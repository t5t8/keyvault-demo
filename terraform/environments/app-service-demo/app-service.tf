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

  ## Set these values from keyvault to app settings
  app_settings = {
    "VMPassword_from_keyvault"   = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.demo.name};SecretName=${var.prefix}-vm-admin-password)"
    "VMPrivatekey_from_keyvault" = "@Microsoft.KeyVault(VaultName=${data.azurerm_key_vault.demo.name};SecretName=${var.prefix}-vm-ssh-private-key)"
    "DEMOsetting" = "test"
  }

  identity {
    type = "SystemAssigned"
  }
}

## Grant app service access to keyvault secrets
## Use resources own identity
resource "azurerm_role_assignment" "demo" {
  scope                = data.azurerm_key_vault.demo.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_app_service.demo.identity.0.principal_id
}
