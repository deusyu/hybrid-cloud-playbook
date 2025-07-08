#!/bin/bash

# Hybrid Cloud Playbook - Environment Initialization Script
# This script helps set up the development environment for the playbook

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ASCII Art Banner
print_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║          🌩️  Hybrid Cloud Playbook  🌩️                 ║
    ║                                                           ║
    ║        Environment Initialization Script                  ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system requirements
check_system_requirements() {
    log_info "Checking system requirements..."
    
    # Check OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
        OS="Windows"
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    log_success "Operating System: $OS"
    
    # Check architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64|amd64) ARCH="amd64" ;;
        aarch64|arm64) ARCH="arm64" ;;
        *) log_error "Unsupported architecture: $ARCH"; exit 1 ;;
    esac
    
    log_success "Architecture: $ARCH"
}

# Install Terraform
install_terraform() {
    if command_exists terraform; then
        TERRAFORM_VERSION=$(terraform --version | head -n1 | cut -d' ' -f2 | cut -d'v' -f2)
        log_success "Terraform already installed (version: $TERRAFORM_VERSION)"
        return 0
    fi
    
    log_info "Installing Terraform..."
    
    case $OS in
        "Linux")
            if command_exists apt-get; then
                # Ubuntu/Debian
                sudo apt-get update
                sudo apt-get install -y gnupg software-properties-common
                
                # Add HashiCorp GPG key
                wget -O- https://apt.releases.hashicorp.com/gpg | \
                    gpg --dearmor | \
                    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
                
                # Add HashiCorp repository
                echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
                    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
                    sudo tee /etc/apt/sources.list.d/hashicorp.list
                
                sudo apt-get update
                sudo apt-get install -y terraform
                
            elif command_exists yum; then
                # RHEL/CentOS
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
                sudo yum -y install terraform
            else
                log_error "Unsupported Linux distribution"
                exit 1
            fi
            ;;
        "macOS")
            if command_exists brew; then
                brew tap hashicorp/tap
                brew install hashicorp/tap/terraform
            else
                log_error "Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            ;;
        "Windows")
            log_error "Please install Terraform manually on Windows"
            exit 1
            ;;
    esac
    
    log_success "Terraform installed successfully"
}

# Install AWS CLI
install_aws_cli() {
    if command_exists aws; then
        AWS_VERSION=$(aws --version 2>&1 | cut -d' ' -f1 | cut -d'/' -f2)
        log_success "AWS CLI already installed (version: $AWS_VERSION)"
        return 0
    fi
    
    log_info "Installing AWS CLI..."
    
    case $OS in
        "Linux")
            case $ARCH in
                "amd64")
                    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                    ;;
                "arm64")
                    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
                    ;;
            esac
            unzip awscliv2.zip
            sudo ./aws/install
            rm -rf awscliv2.zip aws/
            ;;
        "macOS")
            curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
            sudo installer -pkg AWSCLIV2.pkg -target /
            rm AWSCLIV2.pkg
            ;;
        "Windows")
            log_error "Please install AWS CLI manually on Windows"
            exit 1
            ;;
    esac
    
    log_success "AWS CLI installed successfully"
}

# Install Azure CLI
install_azure_cli() {
    if command_exists az; then
        AZ_VERSION=$(az --version | grep "azure-cli" | awk '{print $2}')
        log_success "Azure CLI already installed (version: $AZ_VERSION)"
        return 0
    fi
    
    log_info "Installing Azure CLI..."
    
    case $OS in
        "Linux")
            if command_exists apt-get; then
                # Ubuntu/Debian
                curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
            elif command_exists yum; then
                # RHEL/CentOS
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
                sudo yum install -y azure-cli
            fi
            ;;
        "macOS")
            if command_exists brew; then
                brew update && brew install azure-cli
            else
                log_error "Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            ;;
        "Windows")
            log_error "Please install Azure CLI manually on Windows"
            exit 1
            ;;
    esac
    
    log_success "Azure CLI installed successfully"
}

# Install Google Cloud SDK
install_gcloud() {
    if command_exists gcloud; then
        GCLOUD_VERSION=$(gcloud --version | grep "Google Cloud SDK" | awk '{print $4}')
        log_success "Google Cloud SDK already installed (version: $GCLOUD_VERSION)"
        return 0
    fi
    
    log_info "Installing Google Cloud SDK..."
    
    case $OS in
        "Linux")
            if command_exists apt-get; then
                # Ubuntu/Debian
                echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
                curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
                sudo apt-get update && sudo apt-get install -y google-cloud-sdk
            elif command_exists yum; then
                # RHEL/CentOS
                sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
                sudo yum install -y google-cloud-sdk
            fi
            ;;
        "macOS")
            if command_exists brew; then
                brew install --cask google-cloud-sdk
            else
                log_error "Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            ;;
        "Windows")
            log_error "Please install Google Cloud SDK manually on Windows"
            exit 1
            ;;
    esac
    
    log_success "Google Cloud SDK installed successfully"
}

# Install additional tools
install_additional_tools() {
    log_info "Installing additional tools..."
    
    # Install jq for JSON parsing
    if ! command_exists jq; then
        case $OS in
            "Linux")
                if command_exists apt-get; then
                    sudo apt-get install -y jq
                elif command_exists yum; then
                    sudo yum install -y jq
                fi
                ;;
            "macOS")
                if command_exists brew; then
                    brew install jq
                fi
                ;;
        esac
        log_success "jq installed"
    else
        log_success "jq already installed"
    fi
    
    # Install curl if not present
    if ! command_exists curl; then
        case $OS in
            "Linux")
                if command_exists apt-get; then
                    sudo apt-get install -y curl
                elif command_exists yum; then
                    sudo yum install -y curl
                fi
                ;;
            "macOS")
                log_info "curl is pre-installed on macOS"
                ;;
        esac
        log_success "curl installed"
    else
        log_success "curl already installed"
    fi
    
    # Install git if not present
    if ! command_exists git; then
        case $OS in
            "Linux")
                if command_exists apt-get; then
                    sudo apt-get install -y git
                elif command_exists yum; then
                    sudo yum install -y git
                fi
                ;;
            "macOS")
                if command_exists brew; then
                    brew install git
                fi
                ;;
        esac
        log_success "git installed"
    else
        log_success "git already installed"
    fi
}

# Setup project structure
setup_project() {
    log_info "Setting up project structure..."
    
    # Create necessary directories if they don't exist
    mkdir -p terraform/examples/{aws,azure,gcp,multi-cloud}
    mkdir -p terraform/modules
    mkdir -p terraform/templates
    mkdir -p docs/{architecture,best-practices,tutorials,troubleshooting}
    mkdir -p diagrams/{draw.io,mermaid,exports}
    mkdir -p mindmaps
    mkdir -p scripts
    mkdir -p examples
    
    log_success "Project structure created"
}

# Create configuration templates
create_config_templates() {
    log_info "Creating configuration templates..."
    
    # Create terraform.tfvars.example
    cat > terraform.tfvars.example << EOF
# Terraform Variables Example
# Copy this file to terraform.tfvars and modify as needed

# AWS Configuration
aws_region = "us-west-2"
aws_profile = "default"

# Azure Configuration
azure_subscription_id = "your-subscription-id"
azure_tenant_id = "your-tenant-id"

# GCP Configuration
gcp_project_id = "your-project-id"
gcp_region = "us-central1"

# Common Configuration
project_name = "hybrid-cloud-demo"
environment = "dev"
owner = "your-name"

# Networking
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# Compute
instance_type = "t3.micro"  # AWS
vm_size = "Standard_B1s"    # Azure
machine_type = "e2-micro"   # GCP
EOF
    
    # Create .env.example
    cat > .env.example << EOF
# Environment Variables Example
# Copy this file to .env and modify as needed

# AWS Credentials
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_DEFAULT_REGION=us-west-2

# Azure Credentials
AZURE_CLIENT_ID=your-client-id
AZURE_CLIENT_SECRET=your-client-secret
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_TENANT_ID=your-tenant-id

# GCP Credentials
GOOGLE_APPLICATION_CREDENTIALS=path/to/service-account-key.json
GOOGLE_PROJECT=your-project-id
GOOGLE_REGION=us-central1

# Terraform Backend (optional)
TF_VAR_backend_bucket=your-terraform-state-bucket
TF_VAR_backend_key=terraform.tfstate
EOF
    
    log_success "Configuration templates created"
}

# Display summary
display_summary() {
    echo -e "\n${GREEN}✅ Environment initialization completed successfully!${NC}\n"
    
    echo -e "${BLUE}📋 Installed Tools:${NC}"
    command_exists terraform && echo "  ✅ Terraform: $(terraform --version | head -n1)"
    command_exists aws && echo "  ✅ AWS CLI: $(aws --version 2>&1 | cut -d' ' -f1)"
    command_exists az && echo "  ✅ Azure CLI: $(az --version | grep "azure-cli" | awk '{print $1 " " $2}')"
    command_exists gcloud && echo "  ✅ Google Cloud SDK: $(gcloud --version | grep "Google Cloud SDK" | awk '{print $1 " " $2 " " $3 " " $4}')"
    command_exists jq && echo "  ✅ jq: $(jq --version)"
    command_exists git && echo "  ✅ Git: $(git --version)"
    
    echo -e "\n${BLUE}📁 Project Structure:${NC}"
    echo "  ✅ Terraform examples and modules"
    echo "  ✅ Documentation directories"
    echo "  ✅ Diagrams and mindmaps"
    echo "  ✅ Scripts and examples"
    
    echo -e "\n${BLUE}🔧 Configuration:${NC}"
    echo "  ✅ terraform.tfvars.example created"
    echo "  ✅ .env.example created"
    
    echo -e "\n${YELLOW}📝 Next Steps:${NC}"
    echo "  1. Configure cloud credentials:"
    echo "     - AWS: aws configure"
    echo "     - Azure: az login"
    echo "     - GCP: gcloud auth login"
    echo "  2. Copy and customize configuration files:"
    echo "     - cp terraform.tfvars.example terraform.tfvars"
    echo "     - cp .env.example .env"
    echo "  3. Explore examples:"
    echo "     - cd terraform/examples/aws/simple-vpc"
    echo "     - terraform init && terraform plan"
    echo "  4. Read the documentation:"
    echo "     - docs/tutorials/getting-started.md"
    
    echo -e "\n${GREEN}🎉 Happy cloud engineering!${NC}"
}

# Main execution
main() {
    print_banner
    
    # Check if script is run with --help
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --skip-tools   Skip tool installation"
        echo "  --tools-only   Only install tools, skip project setup"
        echo ""
        echo "This script initializes the Hybrid Cloud Playbook environment by:"
        echo "  1. Checking system requirements"
        echo "  2. Installing required tools (Terraform, AWS CLI, Azure CLI, GCP SDK)"
        echo "  3. Setting up project structure"
        echo "  4. Creating configuration templates"
        exit 0
    fi
    
    check_system_requirements
    
    if [[ "$1" != "--skip-tools" ]]; then
        install_terraform
        install_aws_cli
        install_azure_cli
        install_gcloud
        install_additional_tools
    fi
    
    if [[ "$1" != "--tools-only" ]]; then
        setup_project
        create_config_templates
    fi
    
    display_summary
}

# Run main function
main "$@"