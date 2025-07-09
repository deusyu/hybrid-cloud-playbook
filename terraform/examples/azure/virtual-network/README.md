# Azure Virtual Network Example

> **完整的Azure虚拟网络基础设施部署示例**  
> 使用Terraform一键创建生产就绪的Azure VNet架构

## 🏗️ 架构概述

这个示例创建了一个完整的Azure虚拟网络环境，包括：

- **Resource Group**：资源组织和管理
- **Virtual Network (VNet)**：核心网络基础设施
- **Public Subnet**：面向互联网的子网
- **Private Subnet**：内部应用子网
- **Network Security Groups (NSG)**：网络安全控制
- **NAT Gateway**：为私有子网提供出站互联网访问

## 📊 资源清单

| 资源类型 | 数量 | 说明 |
|---------|------|------|
| Resource Group | 1 | 主要资源组 |
| Virtual Network | 1 | 主要VNet (10.0.0.0/16) |
| Subnet | 2 | 公有子网 + 私有子网 |
| Network Security Group | 2 | 公有NSG + 私有NSG |
| NAT Gateway | 1 | 私有子网出站访问 |
| Public IP | 1 | NAT Gateway公网IP |

## 🚀 快速开始

### 1. 前置条件

```bash
# 确保已安装 Azure CLI
az --version

# 登录 Azure 账户
az login

# 设置默认订阅（可选）
az account set --subscription "Your-Subscription-ID"

# 确保已安装 Terraform
terraform --version
```

### 2. 部署步骤

```bash
# 克隆项目并进入目录
git clone https://github.com/deusyu/hybrid-cloud-playbook.git
cd hybrid-cloud-playbook/terraform/examples/azure/virtual-network

# 初始化 Terraform
terraform init

# 查看执行计划
terraform plan

# 应用配置（创建资源）
terraform apply
```

### 3. 自定义配置

```bash
# 使用自定义变量文件
cp terraform.tfvars.example terraform.tfvars
terraform apply -var-file="terraform.tfvars"

# 或者直接传递变量
terraform apply \
  -var="resource_group_name=my-rg" \
  -var="location=West US 2" \
  -var="vnet_name=my-vnet"
```

## ⚙️ 配置选项

### 主要变量

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `resource_group_name` | string | `rg-hybrid-cloud-demo` | 资源组名称 |
| `location` | string | `East US` | Azure区域 |
| `vnet_name` | string | `vnet-hybrid-cloud-demo` | 虚拟网络名称 |
| `vnet_address_space` | list(string) | `["10.0.0.0/16"]` | VNet地址空间 |
| `public_subnet_address_prefixes` | list(string) | `["10.0.1.0/24"]` | 公有子网CIDR |
| `private_subnet_address_prefixes` | list(string) | `["10.0.2.0/24"]` | 私有子网CIDR |

### 安全规则配置

#### 公有子网 NSG 规则
- **HTTP (80)**: 允许入站HTTP流量
- **HTTPS (443)**: 允许入站HTTPS流量  
- **SSH (22)**: 允许SSH管理访问

#### 私有子网 NSG 规则
- **VNet 内部**: 允许VNet内部通信
- **出站互联网**: 通过NAT Gateway访问

## 📤 输出值

部署完成后，你将获得以下输出：

```hcl
# 网络信息
vnet_id = "/subscriptions/.../resourceGroups/rg-hybrid-cloud-demo/providers/Microsoft.Network/virtualNetworks/vnet-hybrid-cloud-demo"
vnet_name = "vnet-hybrid-cloud-demo"
vnet_address_space = ["10.0.0.0/16"]

# 子网信息
public_subnet_id = "/subscriptions/.../subnets/subnet-public"
private_subnet_id = "/subscriptions/.../subnets/subnet-private"

# NAT Gateway
nat_gateway_public_ip = "20.xxx.xxx.xxx"
```

## 🛡️ 安全最佳实践

### 网络安全
- ✅ **网络分段**：公有和私有子网隔离
- ✅ **NSG规则**：最小权限原则
- ✅ **NAT Gateway**：私有子网安全出站

### 访问控制
- ✅ **RBAC**：使用Azure AD进行身份验证
- ✅ **网络ACL**：精确的网络访问控制
- ✅ **标签管理**：资源分类和成本跟踪

## 💰 成本估算

### 月度成本预估（美东区域）
- **Virtual Network**: 免费
- **NAT Gateway**: ~$45/月
- **Public IP**: ~$3.65/月
- **总计**: ~$50/月

> 💡 **成本优化提示**：
> - 删除不使用的Public IP
> - 考虑使用Azure Firewall替代多个NSG（大规模场景）

## 🔧 故障排除

### 常见问题

#### 1. 权限不足
```bash
# 检查当前用户权限
az role assignment list --assignee $(az account show --query user.name -o tsv)

# 需要的最小权限
- Network Contributor
- Virtual Machine Contributor
```

#### 2. 区域不支持某些资源
```bash
# 检查区域支持的服务
az provider show --namespace Microsoft.Network --query "resourceTypes[?resourceType=='natGateways'].locations"
```

#### 3. 地址空间冲突
```bash
# 检查现有VNet
az network vnet list --query "[].{Name:name, AddressSpace:addressSpace.addressPrefixes}"
```

### 资源清理

```bash
# 销毁所有资源
terraform destroy

# 确认资源组已删除
az group show --name rg-hybrid-cloud-demo --query "properties.provisioningState"
```

## 🚀 扩展示例

### 1. 添加应用子网
```hcl
# 在 main.tf 中添加
resource "azurerm_subnet" "app" {
  name                 = "subnet-app"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
}
```

### 2. 集成Azure Firewall
```hcl
# Azure Firewall 子网（固定名称）
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.255.0/26"]
}
```

### 3. 配置VNet Peering
```hcl
# 连接到其他VNet
resource "azurerm_virtual_network_peering" "example" {
  name                = "peer-to-hub"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  remote_virtual_network_id = var.hub_vnet_id
}
```

## 📚 相关文档

- [Azure VNet 官方文档](https://docs.microsoft.com/en-us/azure/virtual-network/)
- [Azure NSG 最佳实践](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview)
- [Azure NAT Gateway 配置](https://docs.microsoft.com/en-us/azure/virtual-network/nat-gateway/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## 🤝 贡献指南

欢迎贡献改进建议！

1. **报告问题**：[创建Issue](https://github.com/deusyu/hybrid-cloud-playbook/issues)
2. **功能请求**：提交功能需求
3. **代码贡献**：Fork -> 修改 -> Pull Request

---

<div align="center">
<b>🌟 如果这个示例对你有帮助，请给项目一个Star！🌟</b>
</div>