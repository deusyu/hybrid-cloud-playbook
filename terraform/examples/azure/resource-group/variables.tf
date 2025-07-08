variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "Azure region where the resource group will be created"
  type        = string
  default     = "East US"
}