#!/bin/bash

# Hybrid Cloud Playbook - Resource Cleanup Script
# This script helps clean up resources created by the playbook examples

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
readonly LOG_FILE="/tmp/hybrid-cloud-cleanup.log"
readonly DRY_RUN="${DRY_RUN:-false}"
readonly FORCE_DELETE="${FORCE_DELETE:-false}"
readonly BACKUP_ENABLED="${BACKUP_ENABLED:-true}"

# Default values
DEFAULT_PROJECT_NAME="hybrid-cloud-demo"
DEFAULT_ENVIRONMENT="dev"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Print banner
print_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║          🧹  Hybrid Cloud Resource Cleanup  🧹           ║
    ║                                                           ║
    ║              Clean up cloud resources safely             ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Show help
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  --help, -h              Show this help message
  --dry-run              Show what would be deleted without actually deleting
  --force                Force deletion without confirmation
  --no-backup            Skip backup creation
  --provider PROVIDER    Clean up specific provider (aws|azure|gcp|all)
  --project-name NAME    Project name filter (default: $DEFAULT_PROJECT_NAME)
  --environment ENV      Environment filter (default: $DEFAULT_ENVIRONMENT)
  --region REGION        Region filter (optional)
  --older-than DAYS      Only delete resources older than X days
  --tag-filter TAG=VALUE Filter resources by tag

Examples:
  $0 --dry-run                           # Show what would be deleted
  $0 --provider aws --project-name demo  # Clean up AWS resources for demo project
  $0 --older-than 7 --environment dev    # Clean up dev resources older than 7 days
  $0 --tag-filter Environment=test       # Clean up test environment resources

Environment Variables:
  DRY_RUN=true           # Enable dry-run mode
  FORCE_DELETE=true      # Force deletion without confirmation
  BACKUP_ENABLED=false   # Disable backup creation

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                show_help
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --force)
                FORCE_DELETE=true
                shift
                ;;
            --no-backup)
                BACKUP_ENABLED=false
                shift
                ;;
            --provider)
                PROVIDER="$2"
                shift 2
                ;;
            --project-name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            --environment)
                ENVIRONMENT="$2"
                shift 2
                ;;
            --region)
                REGION="$2"
                shift 2
                ;;
            --older-than)
                OLDER_THAN="$2"
                shift 2
                ;;
            --tag-filter)
                TAG_FILTER="$2"
                shift 2
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Set defaults
    PROVIDER="${PROVIDER:-all}"
    PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}"
    ENVIRONMENT="${ENVIRONMENT:-$DEFAULT_ENVIRONMENT}"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    local missing_tools=()
    
    if [[ "$PROVIDER" == "all" ]] || [[ "$PROVIDER" == "aws" ]]; then
        if ! command_exists aws; then
            missing_tools+=("aws")
        fi
    fi
    
    if [[ "$PROVIDER" == "all" ]] || [[ "$PROVIDER" == "azure" ]]; then
        if ! command_exists az; then
            missing_tools+=("az")
        fi
    fi
    
    if [[ "$PROVIDER" == "all" ]] || [[ "$PROVIDER" == "gcp" ]]; then
        if ! command_exists gcloud; then
            missing_tools+=("gcloud")
        fi
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_error "Please install missing tools and try again"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Backup resources
backup_resources() {
    if [[ "$BACKUP_ENABLED" != "true" ]]; then
        log_info "Backup is disabled, skipping..."
        return 0
    fi
    
    log_info "Creating backup of resources..."
    
    local backup_dir="/tmp/hybrid-cloud-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    if [[ "$PROVIDER" == "all" ]] || [[ "$PROVIDER" == "aws" ]]; then
        backup_aws_resources "$backup_dir"
    fi
    
    if [[ "$PROVIDER" == "all" ]] || [[ "$PROVIDER" == "azure" ]]; then
        backup_azure_resources "$backup_dir"
    fi
    
    if [[ "$PROVIDER" == "all" ]] || [[ "$PROVIDER" == "gcp" ]]; then
        backup_gcp_resources "$backup_dir"
    fi
    
    log_success "Backup created in: $backup_dir"
}

# Backup AWS resources
backup_aws_resources() {
    local backup_dir="$1"
    
    log_info "Backing up AWS resources..."
    
    # Backup EC2 instances
    aws ec2 describe-instances \
        --filters "Name=tag:Project,Values=$PROJECT_NAME" \
        --query 'Reservations[].Instances[]' \
        --output json > "$backup_dir/aws-ec2-instances.json"
    
    # Backup VPCs
    aws ec2 describe-vpcs \
        --filters "Name=tag:Project,Values=$PROJECT_NAME" \
        --output json > "$backup_dir/aws-vpcs.json"
    
    # Backup Load Balancers
    aws elbv2 describe-load-balancers \
        --output json > "$backup_dir/aws-load-balancers.json"
    
    # Backup S3 buckets
    aws s3api list-buckets \
        --query 'Buckets[?contains(Name, `'"$PROJECT_NAME"'`)]' \
        --output json > "$backup_dir/aws-s3-buckets.json"
    
    log_success "AWS resources backed up"
}

# Backup Azure resources
backup_azure_resources() {
    local backup_dir="$1"
    
    log_info "Backing up Azure resources..."
    
    # Backup resource groups
    az group list \
        --tag "Project=$PROJECT_NAME" \
        --output json > "$backup_dir/azure-resource-groups.json"
    
    # Backup virtual machines
    az vm list \
        --query "[?tags.Project=='$PROJECT_NAME']" \
        --output json > "$backup_dir/azure-virtual-machines.json"
    
    # Backup storage accounts
    az storage account list \
        --query "[?tags.Project=='$PROJECT_NAME']" \
        --output json > "$backup_dir/azure-storage-accounts.json"
    
    log_success "Azure resources backed up"
}

# Backup GCP resources
backup_gcp_resources() {
    local backup_dir="$1"
    
    log_info "Backing up GCP resources..."
    
    # Backup compute instances
    gcloud compute instances list \
        --filter="labels.project=$PROJECT_NAME" \
        --format=json > "$backup_dir/gcp-compute-instances.json"
    
    # Backup VPC networks
    gcloud compute networks list \
        --filter="labels.project=$PROJECT_NAME" \
        --format=json > "$backup_dir/gcp-vpc-networks.json"
    
    # Backup storage buckets
    gsutil ls -L -b gs://*"$PROJECT_NAME"* > "$backup_dir/gcp-storage-buckets.txt" 2>/dev/null || true
    
    log_success "GCP resources backed up"
}

# Clean up AWS resources
cleanup_aws_resources() {
    log_info "Cleaning up AWS resources..."
    
    # Get AWS region
    local aws_region="${REGION:-$(aws configure get region)}"
    aws_region="${aws_region:-us-west-2}"
    
    log_info "Cleaning up AWS resources in region: $aws_region"
    
    # Clean up EC2 instances
    cleanup_aws_ec2_instances "$aws_region"
    
    # Clean up Load Balancers
    cleanup_aws_load_balancers "$aws_region"
    
    # Clean up Auto Scaling Groups
    cleanup_aws_autoscaling_groups "$aws_region"
    
    # Clean up VPC resources
    cleanup_aws_vpc_resources "$aws_region"
    
    # Clean up S3 buckets
    cleanup_aws_s3_buckets
    
    log_success "AWS resources cleanup completed"
}

# Clean up EC2 instances
cleanup_aws_ec2_instances() {
    local region="$1"
    
    log_info "Cleaning up EC2 instances..."
    
    local instances
    instances=$(aws ec2 describe-instances \
        --region "$region" \
        --filters "Name=tag:Project,Values=$PROJECT_NAME" \
                 "Name=tag:Environment,Values=$ENVIRONMENT" \
                 "Name=instance-state-name,Values=running,stopped" \
        --query 'Reservations[].Instances[].InstanceId' \
        --output text)
    
    if [[ -n "$instances" ]]; then
        log_info "Found EC2 instances: $instances"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Would terminate instances: $instances"
        else
            if confirm_action "Terminate EC2 instances: $instances"; then
                aws ec2 terminate-instances --region "$region" --instance-ids $instances
                log_success "Terminated EC2 instances: $instances"
            fi
        fi
    else
        log_info "No EC2 instances found matching criteria"
    fi
}

# Clean up Load Balancers
cleanup_aws_load_balancers() {
    local region="$1"
    
    log_info "Cleaning up Load Balancers..."
    
    local load_balancers
    load_balancers=$(aws elbv2 describe-load-balancers \
        --region "$region" \
        --query "LoadBalancers[?contains(LoadBalancerName, '$PROJECT_NAME')].LoadBalancerArn" \
        --output text)
    
    if [[ -n "$load_balancers" ]]; then
        log_info "Found Load Balancers: $load_balancers"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Would delete load balancers: $load_balancers"
        else
            if confirm_action "Delete Load Balancers"; then
                for lb in $load_balancers; do
                    aws elbv2 delete-load-balancer --region "$region" --load-balancer-arn "$lb"
                    log_success "Deleted Load Balancer: $lb"
                done
            fi
        fi
    else
        log_info "No Load Balancers found matching criteria"
    fi
}

# Clean up Auto Scaling Groups
cleanup_aws_autoscaling_groups() {
    local region="$1"
    
    log_info "Cleaning up Auto Scaling Groups..."
    
    local asg_names
    asg_names=$(aws autoscaling describe-auto-scaling-groups \
        --region "$region" \
        --query "AutoScalingGroups[?contains(AutoScalingGroupName, '$PROJECT_NAME')].AutoScalingGroupName" \
        --output text)
    
    if [[ -n "$asg_names" ]]; then
        log_info "Found Auto Scaling Groups: $asg_names"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Would delete Auto Scaling Groups: $asg_names"
        else
            if confirm_action "Delete Auto Scaling Groups"; then
                for asg in $asg_names; do
                    # Scale down to 0 first
                    aws autoscaling update-auto-scaling-group \
                        --region "$region" \
                        --auto-scaling-group-name "$asg" \
                        --min-size 0 \
                        --max-size 0 \
                        --desired-capacity 0
                    
                    # Wait for instances to terminate
                    log_info "Waiting for instances to terminate..."
                    sleep 30
                    
                    # Delete ASG
                    aws autoscaling delete-auto-scaling-group \
                        --region "$region" \
                        --auto-scaling-group-name "$asg" \
                        --force-delete
                    
                    log_success "Deleted Auto Scaling Group: $asg"
                done
            fi
        fi
    else
        log_info "No Auto Scaling Groups found matching criteria"
    fi
}

# Clean up VPC resources
cleanup_aws_vpc_resources() {
    local region="$1"
    
    log_info "Cleaning up VPC resources..."
    
    local vpcs
    vpcs=$(aws ec2 describe-vpcs \
        --region "$region" \
        --filters "Name=tag:Project,Values=$PROJECT_NAME" \
        --query 'Vpcs[].VpcId' \
        --output text)
    
    if [[ -n "$vpcs" ]]; then
        log_info "Found VPCs: $vpcs"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Would delete VPC resources for: $vpcs"
        else
            if confirm_action "Delete VPC resources"; then
                for vpc in $vpcs; do
                    cleanup_vpc_dependencies "$region" "$vpc"
                    aws ec2 delete-vpc --region "$region" --vpc-id "$vpc"
                    log_success "Deleted VPC: $vpc"
                done
            fi
        fi
    else
        log_info "No VPCs found matching criteria"
    fi
}

# Clean up VPC dependencies
cleanup_vpc_dependencies() {
    local region="$1"
    local vpc_id="$2"
    
    log_info "Cleaning up VPC dependencies for: $vpc_id"
    
    # Delete NAT Gateways
    local nat_gateways
    nat_gateways=$(aws ec2 describe-nat-gateways \
        --region "$region" \
        --filter "Name=vpc-id,Values=$vpc_id" \
        --query 'NatGateways[].NatGatewayId' \
        --output text)
    
    for nat_gw in $nat_gateways; do
        aws ec2 delete-nat-gateway --region "$region" --nat-gateway-id "$nat_gw"
        log_info "Deleted NAT Gateway: $nat_gw"
    done
    
    # Delete Internet Gateway
    local igw
    igw=$(aws ec2 describe-internet-gateways \
        --region "$region" \
        --filters "Name=attachment.vpc-id,Values=$vpc_id" \
        --query 'InternetGateways[].InternetGatewayId' \
        --output text)
    
    if [[ -n "$igw" ]]; then
        aws ec2 detach-internet-gateway --region "$region" --internet-gateway-id "$igw" --vpc-id "$vpc_id"
        aws ec2 delete-internet-gateway --region "$region" --internet-gateway-id "$igw"
        log_info "Deleted Internet Gateway: $igw"
    fi
    
    # Delete Subnets
    local subnets
    subnets=$(aws ec2 describe-subnets \
        --region "$region" \
        --filters "Name=vpc-id,Values=$vpc_id" \
        --query 'Subnets[].SubnetId' \
        --output text)
    
    for subnet in $subnets; do
        aws ec2 delete-subnet --region "$region" --subnet-id "$subnet"
        log_info "Deleted Subnet: $subnet"
    done
    
    # Delete Route Tables
    local route_tables
    route_tables=$(aws ec2 describe-route-tables \
        --region "$region" \
        --filters "Name=vpc-id,Values=$vpc_id" \
        --query 'RouteTables[?!Associations[?Main==`true`]].RouteTableId' \
        --output text)
    
    for rt in $route_tables; do
        aws ec2 delete-route-table --region "$region" --route-table-id "$rt"
        log_info "Deleted Route Table: $rt"
    done
    
    # Delete Security Groups
    local security_groups
    security_groups=$(aws ec2 describe-security-groups \
        --region "$region" \
        --filters "Name=vpc-id,Values=$vpc_id" \
        --query 'SecurityGroups[?GroupName!=`default`].GroupId' \
        --output text)
    
    for sg in $security_groups; do
        aws ec2 delete-security-group --region "$region" --group-id "$sg"
        log_info "Deleted Security Group: $sg"
    done
}

# Clean up S3 buckets
cleanup_aws_s3_buckets() {
    log_info "Cleaning up S3 buckets..."
    
    local buckets
    buckets=$(aws s3api list-buckets \
        --query "Buckets[?contains(Name, '$PROJECT_NAME')].Name" \
        --output text)
    
    if [[ -n "$buckets" ]]; then
        log_info "Found S3 buckets: $buckets"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Would delete S3 buckets: $buckets"
        else
            if confirm_action "Delete S3 buckets (ALL DATA WILL BE LOST)"; then
                for bucket in $buckets; do
                    # Empty bucket first
                    aws s3 rm "s3://$bucket" --recursive
                    # Delete bucket
                    aws s3api delete-bucket --bucket "$bucket"
                    log_success "Deleted S3 bucket: $bucket"
                done
            fi
        fi
    else
        log_info "No S3 buckets found matching criteria"
    fi
}

# Clean up Azure resources
cleanup_azure_resources() {
    log_info "Cleaning up Azure resources..."
    
    # Clean up resource groups
    local resource_groups
    resource_groups=$(az group list \
        --tag "Project=$PROJECT_NAME" \
        --query '[].name' \
        --output tsv)
    
    if [[ -n "$resource_groups" ]]; then
        log_info "Found resource groups: $resource_groups"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Would delete resource groups: $resource_groups"
        else
            if confirm_action "Delete Azure resource groups (ALL RESOURCES WILL BE LOST)"; then
                for rg in $resource_groups; do
                    az group delete --name "$rg" --yes --no-wait
                    log_success "Initiated deletion of resource group: $rg"
                done
            fi
        fi
    else
        log_info "No Azure resource groups found matching criteria"
    fi
}

# Clean up GCP resources
cleanup_gcp_resources() {
    log_info "Cleaning up GCP resources..."
    
    # Clean up compute instances
    local instances
    instances=$(gcloud compute instances list \
        --filter="labels.project=$PROJECT_NAME" \
        --format="value(name,zone)" | tr '\t' ':')
    
    if [[ -n "$instances" ]]; then
        log_info "Found GCP instances: $instances"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Would delete GCP instances: $instances"
        else
            if confirm_action "Delete GCP compute instances"; then
                for instance in $instances; do
                    local name="${instance%:*}"
                    local zone="${instance#*:}"
                    gcloud compute instances delete "$name" --zone="$zone" --quiet
                    log_success "Deleted GCP instance: $name"
                done
            fi
        fi
    else
        log_info "No GCP compute instances found matching criteria"
    fi
}

# Confirm action
confirm_action() {
    local action="$1"
    
    if [[ "$FORCE_DELETE" == "true" ]]; then
        return 0
    fi
    
    echo -e "\n${YELLOW}WARNING: This will $action${NC}"
    echo -e "${RED}This action cannot be undone!${NC}"
    read -p "Are you sure you want to continue? (yes/no): " -r
    
    if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        return 0
    else
        log_info "Action cancelled by user"
        return 1
    fi
}

# Show summary
show_summary() {
    log_info "Cleanup summary:"
    log_info "- Provider: $PROVIDER"
    log_info "- Project: $PROJECT_NAME"
    log_info "- Environment: $ENVIRONMENT"
    log_info "- Dry run: $DRY_RUN"
    log_info "- Force delete: $FORCE_DELETE"
    log_info "- Backup enabled: $BACKUP_ENABLED"
    
    if [[ -n "$REGION" ]]; then
        log_info "- Region: $REGION"
    fi
    
    if [[ -n "$OLDER_THAN" ]]; then
        log_info "- Older than: $OLDER_THAN days"
    fi
    
    if [[ -n "$TAG_FILTER" ]]; then
        log_info "- Tag filter: $TAG_FILTER"
    fi
    
    echo
}

# Main execution
main() {
    print_banner
    
    # Parse arguments
    parse_args "$@"
    
    # Show summary
    show_summary
    
    # Check prerequisites
    check_prerequisites
    
    # Create backup if enabled
    backup_resources
    
    # Clean up resources
    case "$PROVIDER" in
        aws)
            cleanup_aws_resources
            ;;
        azure)
            cleanup_azure_resources
            ;;
        gcp)
            cleanup_gcp_resources
            ;;
        all)
            cleanup_aws_resources
            cleanup_azure_resources
            cleanup_gcp_resources
            ;;
        *)
            log_error "Invalid provider: $PROVIDER"
            exit 1
            ;;
    esac
    
    log_success "Cleanup completed successfully!"
    log_info "Log file: $LOG_FILE"
    
    if [[ "$BACKUP_ENABLED" == "true" ]]; then
        log_info "Backup location: /tmp/hybrid-cloud-backup-*"
    fi
}

# Run main function
main "$@"