variable "prefix" {
  type        = string
  description = "Prefix your resource groups and resources"
}

variable "location" {
  type        = string
  description = "Location for all resources"
  default     = "westeurope"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant for users and groups"
}

variable "keyvault_admins" {
  type        = list(string)
  description = "UUID list of keyvault admin users and groups"
}

variable "keyvault_readers" {
  type        = list(string)
  description = "UUID list of keyvault reader users and groups"
}