# GCP VPC Network Variables

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = "my-hybrid-cloud-project"
}

variable "region" {
  description = "Google Cloud region where resources will be created"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "hybrid-cloud-demo-vpc"
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
  default     = "public-subnet"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_services_cidr" {
  description = "CIDR block for public subnet secondary services range"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
  default     = "private-subnet"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_services_cidr" {
  description = "CIDR block for private subnet secondary services range"
  type        = string
  default     = "10.0.12.0/24"
}

variable "ssh_source_ranges" {
  description = "List of CIDR blocks that can access SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this to your specific IP ranges for security
}

variable "enable_explicit_deny" {
  description = "Whether to create an explicit deny-all firewall rule"
  type        = bool
  default     = false
}

variable "labels" {
  description = "A map of labels to add to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    project     = "hybrid-cloud-playbook"
    owner       = "devops-team"
    managed-by  = "terraform"
  }
}