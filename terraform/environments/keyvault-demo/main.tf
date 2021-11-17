resource "azurerm_resource_group" "keyvaultdemo" {
  name     = var.prefix
  location = var.location
}

module "keyvault_1" {
  source = "./../../modules/keyvault"
  name                        = "${var.prefix}-keyvault"
  location                    = azurerm_resource_group.keyvaultdemo.location
  resource_group_name         = azurerm_resource_group.keyvaultdemo.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  key_vault_readers = []
  key_vault_administrators = []

}
