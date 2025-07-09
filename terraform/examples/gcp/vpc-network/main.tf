# GCP VPC Network Example
# This example creates a complete VPC network setup with subnets and firewall rules

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create VPC Network
resource "google_compute_network" "main" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode           = "REGIONAL"

  description = "Hybrid Cloud Demo VPC Network"
}

# Create Public Subnet
resource "google_compute_subnetwork" "public" {
  name          = var.public_subnet_name
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id

  description = "Public subnet for web servers and load balancers"

  # Enable private Google access for instances without external IPs
  private_ip_google_access = true

  # Secondary IP ranges for services like GKE
  secondary_ip_range {
    range_name    = "public-services"
    ip_cidr_range = var.public_services_cidr
  }
}

# Create Private Subnet
resource "google_compute_subnetwork" "private" {
  name          = var.private_subnet_name
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id

  description = "Private subnet for application servers and databases"

  # Enable private Google access
  private_ip_google_access = true

  # Secondary IP ranges for services
  secondary_ip_range {
    range_name    = "private-services"
    ip_cidr_range = var.private_services_cidr
  }
}

# Create Cloud Router for NAT Gateway
resource "google_compute_router" "main" {
  name    = "${var.vpc_name}-router"
  region  = var.region
  network = google_compute_network.main.id

  description = "Router for NAT Gateway"
}

# Create NAT Gateway for private subnet internet access
resource "google_compute_router_nat" "main" {
  name                               = "${var.vpc_name}-nat-gateway"
  router                            = google_compute_router.main.name
  region                            = var.region
  nat_ip_allocate_option            = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall rule: Allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "${var.vpc_name}-allow-http"
  network = google_compute_network.main.name

  description = "Allow HTTP traffic from internet"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]

  priority = 1000
}

# Firewall rule: Allow HTTPS traffic
resource "google_compute_firewall" "allow_https" {
  name    = "${var.vpc_name}-allow-https"
  network = google_compute_network.main.name

  description = "Allow HTTPS traffic from internet"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]

  priority = 1000
}

# Firewall rule: Allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.main.name

  description = "Allow SSH access from authorized networks"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = ["ssh-server"]

  priority = 1000
}

# Firewall rule: Allow internal communication
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.main.name

  description = "Allow internal communication within VPC"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.public_subnet_cidr,
    var.private_subnet_cidr,
    var.public_services_cidr,
    var.private_services_cidr
  ]

  priority = 65534
}

# Firewall rule: Allow health check traffic
resource "google_compute_firewall" "allow_health_check" {
  name    = "${var.vpc_name}-allow-health-check"
  network = google_compute_network.main.name

  description = "Allow health check traffic from Google Cloud"

  allow {
    protocol = "tcp"
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  target_tags = ["http-server", "https-server"]

  priority = 1000
}

# Firewall rule: Deny all other traffic (optional, explicit deny)
resource "google_compute_firewall" "deny_all" {
  name    = "${var.vpc_name}-deny-all"
  network = google_compute_network.main.name

  description = "Deny all other traffic (explicit deny rule)"

  deny {
    protocol = "all"
  }

  source_ranges      = ["0.0.0.0/0"]
  destination_ranges = ["0.0.0.0/0"]

  priority = 65535

  # Only create this rule if explicitly enabled
  count = var.enable_explicit_deny ? 1 : 0
}