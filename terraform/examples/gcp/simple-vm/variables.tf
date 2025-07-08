variable "project" {
  description = "GCP 项目 ID"
  type        = string
}

variable "region" {
  description = "GCP 区域"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP 可用区"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Compute Engine 实例名称"
  type        = string
  default     = "example-vm"
}

variable "machine_type" {
  description = "实例规格"
  type        = string
  default     = "e2-medium"
}