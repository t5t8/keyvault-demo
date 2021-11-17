# keyvault-demo
Azure Key Vault demo for November 2021 presentations.

## Usage

- Install terraform and login to azure subscription.
-  Run code from environments/keyvault-demo
- Set .tfvars for prefix, tenant_id and lists of keyvault users. The client id of user running terraform code must be included in `keyvault_admins`list. See `environments/keyvault-demo/variables.tf` for details
- Apply configuration, will take less than 10min to complete.