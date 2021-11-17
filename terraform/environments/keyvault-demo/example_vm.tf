## Create random password
resource "random_password" "vm" {
  length           = 16
  special          = true
  override_special = "_%@"
}

## Create tls private key
resource "tls_private_key" "vm" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

## Needed to let RBAC updates complete in keyvault
resource "time_sleep" "vm" {
  create_duration = "300s"
  destroy_duration = "300s"
  depends_on = [module.keyvault_1]
}

## Set secret using random password
resource "azurerm_key_vault_secret" "vm_password" {
  name         = "${var.prefix}-vm-admin-password"
  value        = random_password.vm.result
  key_vault_id = module.keyvault_1.id
  content_type = "Vm admin password"
  depends_on = [time_sleep.vm]
}

## Set secret using private key
resource "azurerm_key_vault_secret" "vm_private_key" {
  name         = "${var.prefix}-vm-ssh-private-key"
  value        = tls_private_key.vm.private_key_pem
  key_vault_id = module.keyvault_1.id
  content_type = "VM ssh private key"
  depends_on = [time_sleep.vm]
}

## Set SSH public key
resource "azurerm_ssh_public_key" "vm" {
  name                = "${var.prefix}-vm-ssh-key"
  resource_group_name = azurerm_resource_group.keyvaultdemo.name
  location            = azurerm_resource_group.keyvaultdemo.location
  public_key          = tls_private_key.vm.public_key_openssh
}

resource "azurerm_virtual_network" "vm" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.keyvaultdemo.location
  resource_group_name = azurerm_resource_group.keyvaultdemo.name
}

resource "azurerm_subnet" "vm" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.keyvaultdemo.name
  virtual_network_name = azurerm_virtual_network.vm.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vm" {
  name                = "${var.prefix}-vm-nic"
  location            = azurerm_resource_group.keyvaultdemo.location
  resource_group_name = azurerm_resource_group.keyvaultdemo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}-vm-machine"
  resource_group_name = azurerm_resource_group.keyvaultdemo.name
  location            = azurerm_resource_group.keyvaultdemo.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]

  ## Read public key from SSH KEYS
  admin_ssh_key {
    username   = "adminuser"
    public_key = azurerm_ssh_public_key.vm.public_key
  }
  ## Read Password from key vault secrets
  admin_password = azurerm_key_vault_secret.vm_password.value

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}