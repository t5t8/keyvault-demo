resource "azurerm_key_vault" "kv" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption ## true
  tenant_id                   = var.tenant_id

  purge_protection_enabled = var.purge_protection_enabled ##false

  sku_name                  = var.sku_name ## "standard"
  enable_rbac_authorization = true         ## Using RBAC for all kvs

}

resource "azurerm_role_assignment" "kv_dev_reader" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Reader"

  count        = length(var.key_vault_readers)
  principal_id = var.key_vault_readers[count.index]

}

resource "azurerm_role_assignment" "kv_dev_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"

  count        = length(var.key_vault_administrators)
  principal_id = var.key_vault_administrators[count.index]

}
