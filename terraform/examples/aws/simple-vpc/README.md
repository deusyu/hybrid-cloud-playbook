# AWS Simple VPC Example

> **生产就绪的AWS VPC基础设施模板**  
> 使用Terraform一键创建高可用、安全、可扩展的AWS网络架构

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-blue.svg)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Compatible-orange.svg)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](../../../../LICENSE)

## 🏗️ 架构概述

这个示例创建了一个完整的企业级AWS VPC环境，包含以下核心组件：

### 网络基础设施
- **VPC**: 一个带有 DNS 支持的虚拟私有云
- **子网**: 
  - 2个公有子网（跨多个可用区）
  - 2个私有子网（跨多个可用区）
- **Internet Gateway**: 用于公有子网的互联网访问
- **NAT Gateway**: 用于私有子网的出站互联网访问
- **路由表**: 分别用于公有和私有子网的路由配置

### 安全配置
- **Security Groups**: 
  - Web 服务器安全组（HTTP/HTTPS/SSH）
  - 数据库安全组（MySQL）

### 计算资源
- **Launch Template**: EC2 实例启动模板
- **Auto Scaling Group**: 自动扩展组（1-4个实例）
- **Application Load Balancer**: 应用负载均衡器
- **Target Group**: 负载均衡器目标组

## 📋 前置要求

1. **AWS CLI 配置**
   ```bash
   aws configure
   ```

2. **Terraform 安装** (>= 1.0)
   ```bash
   terraform --version
   ```

3. **AWS 权限**
   确保你的 AWS 账户具有以下权限：
   - EC2 完全访问权限
   - VPC 完全访问权限
   - Auto Scaling 权限
   - Load Balancer 权限

## 🚀 使用方法

### 1. 克隆项目
```bash
git clone https://github.com/deusyu/hybrid-cloud-playbook.git
cd hybrid-cloud-playbook/terraform/examples/aws/simple-vpc
```

### 2. 初始化 Terraform
```bash
terraform init
```

### 3. 查看执行计划
```bash
terraform plan
```

### 4. 应用配置
```bash
terraform apply
```

### 5. 访问应用
部署完成后，你将看到输出的负载均衡器 URL：
```
web_url = "http://your-load-balancer-dns-name.region.elb.amazonaws.com"
```

## ⚙️ 配置选项

### 主要变量

| 变量名 | 描述 | 默认值 |
|--------|------|--------|
| `aws_region` | AWS 区域 | `us-west-2` |
| `project_name` | 项目名称 | `hybrid-cloud-demo` |
| `environment` | 环境名称 | `dev` |
| `vpc_cidr` | VPC CIDR 块 | `10.0.0.0/16` |
| `public_subnet_cidrs` | 公有子网 CIDR | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `private_subnet_cidrs` | 私有子网 CIDR | `["10.0.11.0/24", "10.0.12.0/24"]` |
| `instance_type` | EC2 实例类型 | `t3.micro` |
| `min_size` | ASG 最小实例数 | `1` |
| `max_size` | ASG 最大实例数 | `4` |
| `desired_capacity` | ASG 期望实例数 | `2` |

### 自定义配置

创建 `terraform.tfvars` 文件来覆盖默认值：

```hcl
# terraform.tfvars
aws_region = "us-east-1"
project_name = "my-web-app"
environment = "production"
instance_type = "t3.small"
desired_capacity = 3
key_name = "my-key-pair"
```

## 🌟 架构特点

### 高可用性
- 多可用区部署
- 自动扩展组
- 负载均衡器健康检查

### 安全性
- 私有子网用于数据库
- 安全组限制访问
- NAT Gateway 用于私有子网出站访问

### 可扩展性
- 自动扩展组支持按需扩展
- 模块化设计便于修改

### 成本优化
- 使用 t3.micro 实例（符合免费层）
- 按需扩展减少资源浪费

## 📊 监控和日志

### 访问日志
- Apache 访问日志：`/var/log/httpd/access_log`
- Apache 错误日志：`/var/log/httpd/error_log`
- 用户数据脚本日志：`/var/log/user-data.log`

### 健康检查
- 负载均衡器健康检查：`/health`
- API 端点：`/api.php`
- 内建监控脚本：每5分钟检查一次

### CloudWatch 集成
```bash
# 查看实例指标
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
  --statistics Average \
  --start-time 2023-01-01T00:00:00Z \
  --end-time 2023-01-02T00:00:00Z \
  --period 3600
```

## 🧪 测试

### 负载测试
```bash
# 使用 Apache Bench 进行简单负载测试
ab -n 1000 -c 10 http://your-load-balancer-dns-name/
```

### 自动扩展测试
```bash
# 人工触发扩展
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name your-asg-name \
  --desired-capacity 4
```

## 🔧 故障排除

### 常见问题

1. **Terraform apply 失败**
   - 检查 AWS 凭证配置
   - 确认 IAM 权限
   - 检查区域配额限制

2. **实例无法启动**
   - 检查 AMI 在指定区域是否可用
   - 验证安全组配置
   - 查看实例日志

3. **负载均衡器健康检查失败**
   - 检查安全组端口配置
   - 验证 Apache 服务状态
   - 查看目标组健康状态

### 调试命令

```bash
# 查看 Terraform 状态
terraform show

# 查看特定资源
terraform show aws_instance.web

# 刷新状态
terraform refresh

# 查看实例日志
aws ec2 get-console-output --instance-id i-1234567890abcdef0
```

## 🧹 清理资源

```bash
# 销毁所有资源
terraform destroy

# 确认销毁
# 输入 'yes' 确认
```

⚠️ **注意**: 这将删除所有创建的资源，包括数据。请确保已备份重要数据。

## 📈 扩展建议

### 生产环境增强
1. **添加 RDS 数据库**
2. **配置 HTTPS/SSL 证书**
3. **集成 CloudWatch 监控**
4. **设置备份策略**
5. **配置 WAF（Web Application Firewall）**

### 安全增强
1. **启用 VPC Flow Logs**
2. **配置 AWS Config**
3. **集成 AWS Systems Manager**
4. **使用 AWS Secrets Manager**

### 监控增强
1. **添加自定义 CloudWatch 指标**
2. **配置 SNS 告警**
3. **集成 AWS X-Ray**
4. **使用 AWS CloudTrail**

## 📚 相关资源

### 架构图表
- [AWS VPC 详细架构图](../../../../diagrams/architecture/aws-vpc-architecture.mermaid)
- [混合云整体架构](../../../../diagrams/architecture/hybrid-cloud-overview.mermaid)
- [多云网络连接图](../../../../diagrams/architecture/multi-cloud-network.mermaid)

### 文档参考
- [AWS VPC 最佳实践](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [混合云基础架构指南](../../../../docs/architecture/hybrid-cloud-fundamentals.md)

### 相关示例
- [Azure Virtual Network 示例](../../azure/virtual-network/)
- [GCP VPC Network 示例](../../gcp/vpc-network/)
- [多云基础示例](../../multi-cloud/basic/)

## 🔗 快速导航

| 链接 | 说明 |
|------|------|
| [⬆️ 返回 Terraform 示例](../../) | 查看所有云平台示例 |
| [📖 项目文档](../../../../docs/) | 深入学习混合云概念 |
| [� 学习路径](../../../../mindmaps/) | 混合云学习脑图 |
| [🛠️ 工具脚本](../../../../scripts/) | 自动化部署脚本 |

## �🤝 贡献指南

我们欢迎各种形式的贡献！

### 如何贡献
1. **Fork** 本项目
2. **创建分支**：`git checkout -b feature/aws-enhancement`
3. **提交更改**：`git commit -m 'Add some AWS feature'`
4. **推送分支**：`git push origin feature/aws-enhancement`
5. **创建 Pull Request**

### 改进建议
- 🚀 性能优化方案
- 🛡️ 安全加固措施
- 💰 成本优化策略
- 📊 监控告警配置
- 🔧 故障排除指南

## 📞 获取帮助

### 问题反馈
- 📋 [创建 Issue](https://github.com/deusyu/hybrid-cloud-playbook/issues)
- 💬 [社区讨论](https://github.com/deusyu/hybrid-cloud-playbook/discussions)

### 技术支持
- 📧 邮件：[rainman.deus@gmail.com](mailto:rainman.deus@gmail.com)
- 📖 博客：[deusyu.app](https://deusyu.app/)

## 📄 许可证

本项目使用 MIT 许可证。详情请参阅 [LICENSE](../../../../LICENSE) 文件。

---

<div align="center">

**🌟 如果这个示例对你有帮助，请给项目一个 Star！🌟**

[⭐ Star 项目](https://github.com/deusyu/hybrid-cloud-playbook) | [🍴 Fork 项目](https://github.com/deusyu/hybrid-cloud-playbook/fork) | [📖 查看文档](../../../../README.md)

Made with ❤️ by the Hybrid Cloud Playbook community

</div>