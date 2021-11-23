resource "azurerm_app_service_plan" "demo" {
  name                = "${var.prefix}-plan"
  location            = data.azurerm_resource_group.demo.location
  resource_group_name = data.azurerm_resource_group.demo.name
  kind                = "linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}
resource "azurerm_app_service" "demo" {
  name                = "${var.prefix}-webapp"
  location            = data.azurerm_resource_group.demo.location
  resource_group_name = data.azurerm_resource_group.demo.name
  app_service_plan_id = azurerm_app_service_plan.demo.id

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|mcr.microsoft.com/appsvc/staticsite:latest"
    scm_type         = "None"
  }

  app_settings = {
    "VMPassword" = "@Microsoft.KeyVault({VaultName=${data.azurerm_key_vault.demo.vault_uri},SecretName=${var.prefix}-vm-ssh-private-key})"

  }

  identity {
    type = "SystemAssigned" ## Use system assigned managed identity.
  }
}

## Grant app service reader access to keyvault
resource "azurerm_role_assignment" "demo" {
  scope                = data.azurerm_key_vault.demo.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_app_service.demo.identity.0.principal_id

}
