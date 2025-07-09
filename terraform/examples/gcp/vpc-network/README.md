# GCP VPC Network Example

> **完整的Google Cloud VPC网络基础设施部署示例**  
> 使用Terraform一键创建生产就绪的GCP VPC架构

## 🏗️ 架构概述

这个示例创建了一个完整的Google Cloud VPC网络环境，包括：

- **VPC Network**：自定义VPC网络（关闭自动子网创建）
- **Public Subnet**：面向互联网的子网，支持负载均衡器和Web服务器
- **Private Subnet**：内部应用子网，通过NAT网关访问互联网
- **Cloud Router + NAT Gateway**：为私有子网提供安全的出站互联网访问
- **Firewall Rules**：精细化的网络安全控制
- **Secondary IP Ranges**：为GKE等服务预留IP范围

## 📊 资源清单

| 资源类型 | 数量 | 说明 |
|---------|------|------|
| VPC Network | 1 | 主要VPC网络 |
| Subnet | 2 | 公有子网 + 私有子网 |
| Cloud Router | 1 | NAT网关路由器 |
| NAT Gateway | 1 | 私有子网出站访问 |
| Firewall Rules | 5-6 | HTTP/HTTPS/SSH/内部通信/健康检查 |
| Secondary IP Ranges | 4 | GKE服务IP范围 |

## 🚀 快速开始

### 1. 前置条件

```bash
# 确保已安装 Google Cloud SDK
gcloud --version

# 登录 Google Cloud 账户
gcloud auth login

# 设置默认项目
gcloud config set project YOUR_PROJECT_ID

# 启用必要的API
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

# 确保已安装 Terraform
terraform --version
```

### 2. 部署步骤

```bash
# 克隆项目并进入目录
git clone https://github.com/deusyu/hybrid-cloud-playbook.git
cd hybrid-cloud-playbook/terraform/examples/gcp/vpc-network

# 复制并修改变量文件
cp terraform.tfvars.example terraform.tfvars
# 编辑 terraform.tfvars，设置你的项目ID

# 初始化 Terraform
terraform init

# 查看执行计划
terraform plan

# 应用配置（创建资源）
terraform apply
```

### 3. 自定义配置

```bash
# 使用自定义变量
terraform apply \
  -var="project_id=my-gcp-project" \
  -var="region=us-west1" \
  -var="vpc_name=my-vpc"
```

## ⚙️ 配置选项

### 主要变量

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `project_id` | string | `my-hybrid-cloud-project` | GCP项目ID |
| `region` | string | `us-central1` | 部署区域 |
| `vpc_name` | string | `hybrid-cloud-demo-vpc` | VPC网络名称 |
| `public_subnet_cidr` | string | `10.0.1.0/24` | 公有子网CIDR |
| `private_subnet_cidr` | string | `10.0.2.0/24` | 私有子网CIDR |
| `ssh_source_ranges` | list(string) | `["0.0.0.0/0"]` | SSH访问来源IP |

### 高级配置

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `public_services_cidr` | string | `10.0.11.0/24` | 公有子网二级IP范围 |
| `private_services_cidr` | string | `10.0.12.0/24` | 私有子网二级IP范围 |
| `enable_explicit_deny` | bool | `false` | 是否启用显式拒绝规则 |

### 防火墙规则详情

#### 入站规则
- **HTTP (80)**: 允许来自互联网的HTTP流量，目标标签：`http-server`
- **HTTPS (443)**: 允许来自互联网的HTTPS流量，目标标签：`https-server`
- **SSH (22)**: 允许SSH管理访问，目标标签：`ssh-server`
- **健康检查**: 允许Google Cloud负载均衡器健康检查

#### 内部通信
- **VPC内部**: 允许VPC内所有TCP/UDP/ICMP通信
- **出站**: 通过NAT网关访问互联网

## 📤 输出值

部署完成后，你将获得以下输出：

```hcl
# VPC网络信息
vpc_network_name = "hybrid-cloud-demo-vpc"
vpc_network_id = "projects/my-project/global/networks/hybrid-cloud-demo-vpc"

# 子网信息
public_subnet_name = "public-subnet"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_name = "private-subnet"  
private_subnet_cidr = "10.0.2.0/24"

# NAT网关
nat_gateway_name = "hybrid-cloud-demo-vpc-nat-gateway"

# 防火墙规则
firewall_rules = {
  allow_http = "hybrid-cloud-demo-vpc-allow-http"
  allow_https = "hybrid-cloud-demo-vpc-allow-https"
  allow_ssh = "hybrid-cloud-demo-vpc-allow-ssh"
  allow_internal = "hybrid-cloud-demo-vpc-allow-internal"
  allow_health_check = "hybrid-cloud-demo-vpc-allow-health-check"
}
```

## 🛡️ 安全最佳实践

### 网络安全
- ✅ **网络分段**：公有和私有子网隔离
- ✅ **防火墙规则**：基于标签的精细控制
- ✅ **NAT网关**：私有子网安全出站访问
- ✅ **私有Google访问**：无需外部IP访问Google服务

### 访问控制
- ✅ **IAM集成**：与Google Cloud IAM无缝集成
- ✅ **标签管理**：基于标签的资源管理
- ✅ **日志记录**：NAT网关错误日志记录

### 安全建议
```bash
# 限制SSH访问源
ssh_source_ranges = ["203.0.113.0/24"]  # 替换为你的办公网IP

# 启用显式拒绝规则（可选）
enable_explicit_deny = true
```

## 💰 成本估算

### 月度成本预估（us-central1区域）
- **VPC Network**: 免费
- **Subnet**: 免费
- **Cloud Router**: ~$36/月
- **NAT Gateway**: ~$45/月 + 数据处理费用
- **总计**: ~$80-120/月（取决于流量）

> 💡 **成本优化提示**：
> - NAT网关按使用量计费，优化出站流量
> - 考虑使用Private Google Access减少NAT流量
> - 定期审查防火墙日志，优化规则

## 🔧 故障排除

### 常见问题

#### 1. API未启用
```bash
# 检查并启用必要的API
gcloud services list --enabled | grep compute
gcloud services enable compute.googleapis.com
```

#### 2. 权限不足
```bash
# 检查当前用户权限
gcloud projects get-iam-policy YOUR_PROJECT_ID --format="table(bindings.role,bindings.members)"

# 需要的最小权限
- Compute Network Admin
- Compute Security Admin
```

#### 3. 区域配额限制
```bash
# 检查区域配额
gcloud compute regions describe us-central1
```

#### 4. IP地址冲突
```bash
# 检查现有VPC网络
gcloud compute networks list
gcloud compute networks subnets list --filter="region:us-central1"
```

### 资源清理

```bash
# 销毁所有资源
terraform destroy

# 验证资源已删除
gcloud compute networks list --filter="name:hybrid-cloud-demo-vpc"
```

## 🚀 扩展示例

### 1. 添加GKE集群
```hcl
# 使用现有子网创建GKE集群
resource "google_container_cluster" "main" {
  name     = "gke-cluster"
  location = var.region
  
  network    = google_compute_network.main.name
  subnetwork = google_compute_subnetwork.private.name
  
  # 使用二级IP范围
  ip_allocation_policy {
    cluster_secondary_range_name  = "private-services"
    services_secondary_range_name = "private-services"
  }
}
```

### 2. 配置负载均衡器
```hcl
# HTTP(S) 负载均衡器
resource "google_compute_global_forwarding_rule" "http" {
  name       = "http-lb"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
}
```

### 3. 添加Cloud SQL私有IP
```hcl
# 为Cloud SQL配置私有服务连接
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}
```

## 📚 相关文档

- [GCP VPC Network 官方文档](https://cloud.google.com/vpc/docs)
- [GCP Firewall Rules 最佳实践](https://cloud.google.com/vpc/docs/firewalls)
- [GCP NAT Gateway 配置](https://cloud.google.com/nat/docs/overview)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

## 🤝 贡献指南

欢迎贡献改进建议！

1. **报告问题**：[创建Issue](https://github.com/deusyu/hybrid-cloud-playbook/issues)
2. **功能请求**：提交功能需求
3. **代码贡献**：Fork -> 修改 -> Pull Request

---

<div align="center">
<b>🌟 如果这个示例对你有帮助，请给项目一个Star！🌟</b>
</div>