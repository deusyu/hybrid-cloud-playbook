# Multi-Cloud Basic Example
# This example demonstrates deploying basic resources across AWS, Azure, and GCP

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Configure providers
provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Data sources for availability zones and regions
data "aws_availability_zones" "aws_available" {
  state = "available"
}

data "azurerm_client_config" "current" {}

data "google_compute_zones" "gcp_available" {
  region = var.gcp_region
}

# ===== AWS Resources =====

# AWS VPC
resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-aws-vpc"
    Environment = var.environment
    Project     = var.project_name
    Provider    = "aws"
  }
}

# AWS Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-aws-igw"
    Environment = var.environment
    Project     = var.project_name
    Provider    = "aws"
  }
}

# AWS Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.aws_subnet_cidr
  availability_zone       = data.aws_availability_zones.aws_available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-aws-subnet"
    Environment = var.environment
    Project     = var.project_name
    Provider    = "aws"
  }
}

# AWS Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-aws-rt"
    Environment = var.environment
    Project     = var.project_name
    Provider    = "aws"
  }
}

# AWS Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# AWS Security Group
resource "aws_security_group" "web" {
  name        = "${var.project_name}-aws-web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-aws-web-sg"
    Environment = var.environment
    Project     = var.project_name
    Provider    = "aws"
  }
}

# AWS EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.aws_key_name

  user_data = base64encode(templatefile("${path.module}/user-data-aws.sh", {
    project_name = var.project_name
    provider     = "AWS"
  }))

  tags = {
    Name        = "${var.project_name}-aws-web"
    Environment = var.environment
    Project     = var.project_name
    Provider    = "aws"
  }
}

# AWS AMI Data Source
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ===== Azure Resources =====

# Azure Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-azure-rg"
  location = var.azure_location

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Provider    = "azure"
  }
}

# Azure Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-azure-vnet"
  address_space       = [var.azure_vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Provider    = "azure"
  }
}

# Azure Subnet
resource "azurerm_subnet" "main" {
  name                 = "${var.project_name}-azure-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.azure_subnet_cidr]
}

# Azure Public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.project_name}-azure-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Provider    = "azure"
  }
}

# Azure Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "${var.project_name}-azure-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Provider    = "azure"
  }
}

# Azure Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.project_name}-azure-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Provider    = "azure"
  }
}

# Azure Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Azure Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.project_name}-azure-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.azure_vm_size
  admin_username      = "azureuser"

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.azure_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/user-data-azure.sh", {
    project_name = var.project_name
    provider     = "Azure"
  }))

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Provider    = "azure"
  }
}

# ===== GCP Resources =====

# GCP VPC Network
resource "google_compute_network" "main" {
  name                    = "${var.project_name}-gcp-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460

  project = var.gcp_project_id
}

# GCP Subnet
resource "google_compute_subnetwork" "main" {
  name          = "${var.project_name}-gcp-subnet"
  ip_cidr_range = var.gcp_subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.main.id

  project = var.gcp_project_id
}

# GCP Firewall Rules
resource "google_compute_firewall" "web" {
  name    = "${var.project_name}-gcp-web-firewall"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]

  project = var.gcp_project_id
}

# GCP Compute Instance
resource "google_compute_instance" "web" {
  name         = "${var.project_name}-gcp-web"
  machine_type = var.gcp_machine_type
  zone         = data.google_compute_zones.gcp_available.names[0]

  project = var.gcp_project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.main.id

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${var.gcp_ssh_public_key}"
  }

  metadata_startup_script = templatefile("${path.module}/user-data-gcp.sh", {
    project_name = var.project_name
    provider     = "GCP"
  })

  tags = ["web-server"]

  labels = {
    environment = var.environment
    project     = var.project_name
    provider    = "gcp"
  }
}

# ===== Load Balancer for Multi-Cloud (using AWS ALB as example) =====

# AWS Application Load Balancer
resource "aws_lb" "multi_cloud" {
  name               = "${var.project_name}-multi-cloud-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project_name}-multi-cloud-alb"
    Environment = var.environment
    Project     = var.project_name
  }
}

# AWS Target Group
resource "aws_lb_target_group" "multi_cloud" {
  name     = "${var.project_name}-multi-cloud-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name        = "${var.project_name}-multi-cloud-tg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# AWS Load Balancer Listener
resource "aws_lb_listener" "multi_cloud" {
  load_balancer_arn = aws_lb.multi_cloud.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.multi_cloud.arn
  }
}

# AWS Target Group Attachment
resource "aws_lb_target_group_attachment" "aws_instance" {
  target_group_arn = aws_lb_target_group.multi_cloud.id
  target_id        = aws_instance.web.id
  port             = 80
}