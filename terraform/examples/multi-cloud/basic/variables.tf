# Multi-Cloud Basic Example - Variables

# Global Variables
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "hybrid-cloud-multi"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# AWS Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "aws_vpc_cidr" {
  description = "CIDR block for AWS VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "aws_subnet_cidr" {
  description = "CIDR block for AWS subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "aws_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "aws_key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = ""
}

# Azure Variables
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = ""
}

variable "azure_location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

variable "azure_vnet_cidr" {
  description = "CIDR block for Azure VNet"
  type        = string
  default     = "10.2.0.0/16"
}

variable "azure_subnet_cidr" {
  description = "CIDR block for Azure subnet"
  type        = string
  default     = "10.2.1.0/24"
}

variable "azure_vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "azure_ssh_public_key" {
  description = "SSH public key for Azure VM"
  type        = string
  default     = ""
}

# GCP Variables
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = ""
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_subnet_cidr" {
  description = "CIDR block for GCP subnet"
  type        = string
  default     = "10.3.1.0/24"
}

variable "gcp_machine_type" {
  description = "GCP machine type"
  type        = string
  default     = "e2-micro"
}

variable "gcp_ssh_user" {
  description = "SSH username for GCP instance"
  type        = string
  default     = "gcpuser"
}

variable "gcp_ssh_public_key" {
  description = "SSH public key for GCP instance"
  type        = string
  default     = ""
}