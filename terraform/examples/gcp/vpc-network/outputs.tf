# GCP VPC Network Outputs

output "project_id" {
  description = "Google Cloud Project ID"
  value       = var.project_id
}

output "vpc_network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.main.id
}

output "vpc_network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.main.name
}

output "vpc_network_self_link" {
  description = "Self link of the VPC network"
  value       = google_compute_network.main.self_link
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = google_compute_subnetwork.public.id
}

output "public_subnet_name" {
  description = "Name of the public subnet"
  value       = google_compute_subnetwork.public.name
}

output "public_subnet_cidr" {
  description = "CIDR block of the public subnet"
  value       = google_compute_subnetwork.public.ip_cidr_range
}

output "public_subnet_self_link" {
  description = "Self link of the public subnet"
  value       = google_compute_subnetwork.public.self_link
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private.id
}

output "private_subnet_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private.name
}

output "private_subnet_cidr" {
  description = "CIDR block of the private subnet"
  value       = google_compute_subnetwork.private.ip_cidr_range
}

output "private_subnet_self_link" {
  description = "Self link of the private subnet"
  value       = google_compute_subnetwork.private.self_link
}

output "cloud_router_id" {
  description = "ID of the Cloud Router"
  value       = google_compute_router.main.id
}

output "cloud_router_name" {
  description = "Name of the Cloud Router"
  value       = google_compute_router.main.name
}

output "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  value       = google_compute_router_nat.main.name
}

output "firewall_rules" {
  description = "List of firewall rules created"
  value = {
    allow_http         = google_compute_firewall.allow_http.name
    allow_https        = google_compute_firewall.allow_https.name
    allow_ssh          = google_compute_firewall.allow_ssh.name
    allow_internal     = google_compute_firewall.allow_internal.name
    allow_health_check = google_compute_firewall.allow_health_check.name
  }
}

output "secondary_ranges" {
  description = "Secondary IP ranges for subnets"
  value = {
    public_services  = var.public_services_cidr
    private_services = var.private_services_cidr
  }
}