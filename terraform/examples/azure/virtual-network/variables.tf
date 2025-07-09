# Azure Virtual Network Variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-hybrid-cloud-demo"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-hybrid-cloud-demo"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
  default     = "subnet-public"
}

variable "public_subnet_address_prefixes" {
  description = "Address prefixes for the public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
  default     = "subnet-private"
}

variable "private_subnet_address_prefixes" {
  description = "Address prefixes for the private subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "demo"
    Project     = "hybrid-cloud-playbook"
    Owner       = "DevOps Team"
    ManagedBy   = "Terraform"
  }
}