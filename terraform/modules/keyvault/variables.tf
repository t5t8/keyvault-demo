variable "name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "location" {
  type        = string
  description = "Location of the Key Vault, defaults to westeurope"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group of the Key Vault"
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Enable disk encryption (boolean)"
  default     = true
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection (boolean)"
  default     = false
}

variable "tenant_id" {
  type        = string
  description = "tenant_id of the Key Vault"
}

variable "sku_name" {
  type        = string
  description = "tenant_id of the Key Vault"
  default     = "standard"
}

variable "key_vault_readers" {
  type        = list(string)
  description = "UUID list of key vault readers"
  default     = []
}

variable "key_vault_administrators" {
  type        = list(string)
  description = "UUID list of key vault readers"
  default     = []
}
