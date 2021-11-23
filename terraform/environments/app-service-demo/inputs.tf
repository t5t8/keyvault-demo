data "azurerm_resource_group" "demo" {
  name = var.prefix
}

data "azurerm_key_vault" "demo" {
  name                = "${var.prefix}-keyvault"
  resource_group_name = data.azurerm_resource_group.demo.name
}

