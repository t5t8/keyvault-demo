# keyvault-demo
Azure Key Vault demo for November 2021 presentations.
[Slides](secrets2021-11-30.pdf)
Simple demo environment for showing different ways of using Azure Key Vault.

## Usage

Requirements: Azure Subscription, user/application with contributor and user access administrator roles.

Terraform 1.0.10 or later, azurerm provider 2.86.0 or later. Terraform Cloud recommended.

Code is split to 2 workspaces: keyvault-demo will deploy keyvault and virtual machine demo contents. app-service-demo will deploy example web app with system managed identity and uses secrets from the keyvault from earlier workspace. 

### keyvault-demo workspace
- Install terraform and login to azure subscription.
- Run code from `terraform/environments/keyvault-demo/`
- Set .tfvars for prefix, tenant_id and lists of keyvault users. The client id of user running terraform code must be included in `keyvault_admins`list. See `environments/keyvault-demo/variables.tf` for details
- `terraform apply` configuration, will take less than 10min to complete.

### app-service-demo workspace

- Run code from `terraform/environments/app-service-demo/`
- Set .tfvars with same prefix value as in keyvault-demo
- `terraform apply` configuration

## Cleanup

- Run `terraform destroy`on app-service-demo workspace
- Run `terraform destroy`on keyvault-demo workspace
