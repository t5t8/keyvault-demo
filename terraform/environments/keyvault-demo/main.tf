resource "azurerm_resource_group" "keyvaultdemo" {
  name     = var.prefix
  location = var.location
}

## Key vault for common shared secrets
resource "azurerm_key_vault" "keyvaultdemo" {
  name                        = "${var.prefix}-keyvault"
  location                    = azurerm_resource_group.keyvaultdemo.location
  resource_group_name         = azurerm_resource_group.keyvaultdemo.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}


resource "azurerm_key_vault_access_policy" "keyvaultdemo_admins" {
  key_vault_id = azurerm_key_vault.keyvaultdemo.id
  tenant_id    = azurerm_key_vault.keyvaultdemo.tenant_id

  count     = length(var.keyvault_admins)
  object_id = var.keyvault_admins[count.index]

  key_permissions = [
    "Get", "Create", "Update"
  ]

  secret_permissions = [
    "Get", "Set", 
  ]
}

resource "azurerm_key_vault_access_policy" "keyvaultdemo_readers" {
  key_vault_id = azurerm_key_vault.keyvaultdemo.id
  tenant_id    = azurerm_key_vault.keyvaultdemo.tenant_id

  count     = length(var.keyvault_readers)
  object_id = var.keyvault_readers[count.index]

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}