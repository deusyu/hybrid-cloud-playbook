# 混合云 Playbook 快速入门指南

## 🎯 概述

本指南将帮助你快速上手混合云 Playbook，从环境准备到运行第一个混合云示例。

## 📋 前置要求

### 必需工具
- **Terraform** >= 1.0
- **Git** >= 2.0
- **云服务 CLI 工具**:
  - AWS CLI v2
  - Azure CLI
  - Google Cloud SDK

### 账户准备
- AWS 账户 + IAM 用户/角色
- Azure 订阅 + 服务主体
- GCP 项目 + 服务账户

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/deusyu/hybrid-cloud-playbook.git
cd hybrid-cloud-playbook
```

### 2. 环境初始化

运行自动化初始化脚本：
```bash
./scripts/init-environment.sh
```

### 3. 配置云服务凭证

#### AWS 配置
```bash
aws configure
# 或使用环境变量
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-west-2"
```

#### Azure 配置
```bash
az login
# 选择订阅
az account set --subscription "your-subscription-id"
```

#### GCP 配置
```bash
gcloud auth login
gcloud config set project your-project-id
```

### 4. 运行第一个示例

#### 单云示例 - AWS
```bash
cd terraform/examples/aws/simple-vpc
terraform init
terraform plan
terraform apply
```

#### 多云示例
```bash
cd terraform/examples/multi-cloud/basic
terraform init
terraform plan
terraform apply
```

## 📚 学习路径

### 新手路径 (1-2 周)
1. **基础概念学习** → [docs/architecture/hybrid-cloud-fundamentals.md](../architecture/hybrid-cloud-fundamentals.md)
2. **单云实践** → [terraform/examples/aws/](../../terraform/examples/aws/)
3. **网络基础** → [docs/architecture/network-design.md](../architecture/network-design.md)

### 进阶路径 (3-4 周)
1. **多云架构** → [terraform/examples/multi-cloud/](../../terraform/examples/multi-cloud/)
2. **安全最佳实践** → [docs/best-practices/security.md](../best-practices/security.md)
3. **监控与运维** → [docs/best-practices/monitoring.md](../best-practices/monitoring.md)

### 专家路径 (持续学习)
1. **复杂场景实战** → [examples/](../../examples/)
2. **成本优化** → [docs/best-practices/cost-optimization.md](../best-practices/cost-optimization.md)
3. **灾备与高可用** → [docs/best-practices/disaster-recovery.md](../best-practices/disaster-recovery.md)

## 🛠️ 项目结构说明

```
hybrid-cloud-playbook/
├── docs/                          # 📖 文档和教程
│   ├── architecture/              # 🏗️ 架构设计
│   ├── best-practices/            # ⭐ 最佳实践
│   ├── tutorials/                 # 📚 教程指南
│   └── troubleshooting/           # 🔧 故障排除
├── terraform/                     # 🚀 基础设施即代码
│   ├── examples/                  # 💡 可运行示例
│   ├── modules/                   # 🧩 可复用模块
│   └── templates/                 # 📋 模板文件
├── diagrams/                      # 📊 架构图表
├── mindmaps/                      # 🧠 学习脑图
├── scripts/                       # 🤖 自动化脚本
└── examples/                      # 🎪 完整项目示例
```

## 💡 使用技巧

### Terraform 最佳实践
1. **总是使用远程状态**: 配置 S3/Azure Storage 后端
2. **模块化设计**: 使用 `terraform/modules/` 中的可复用模块
3. **环境隔离**: 为 dev/staging/prod 使用不同的 workspace
4. **安全第一**: 永远不要在代码中硬编码敏感信息

### 成本控制
1. **使用标签**: 为所有资源添加成本分析标签
2. **定期清理**: 运行 `./scripts/cleanup-resources.sh`
3. **监控预算**: 设置云服务预算告警
4. **选择合适的实例**: 根据负载选择实例类型

## 🆘 常见问题

### Q: Terraform apply 失败怎么办？
A: 
1. 检查云服务凭证是否正确配置
2. 确认账户权限是否足够
3. 查看具体错误信息，参考 [故障排除指南](../troubleshooting/)

### Q: 如何清理测试资源？
A:
```bash
# 单个项目清理
terraform destroy

# 批量清理（谨慎使用）
./scripts/cleanup-resources.sh --dry-run
```

### Q: 如何贡献代码？
A: 请参考 [CONTRIBUTING.md](../../CONTRIBUTING.md) 了解贡献指南

## 📞 获取帮助

- 📋 **问题反馈**: [GitHub Issues](https://github.com/deusyu/hybrid-cloud-playbook/issues)
- 💬 **社区讨论**: [GitHub Discussions](https://github.com/deusyu/hybrid-cloud-playbook/discussions)
- 📧 **联系作者**: [rainman.deus@gmail.com](mailto:rainman.deus@gmail.com)

## 🎉 下一步

恭喜！你已经完成了入门设置。现在可以：

1. 🔍 **探索示例**: 浏览 [terraform/examples/](../../terraform/examples/) 中的各种场景
2. 📖 **深入学习**: 阅读 [架构设计文档](../architecture/)
3. 🛠️ **动手实践**: 尝试修改示例以适应你的需求
4. 🌟 **分享经验**: 为项目贡献你的实践经验

祝你的混合云之旅愉快！🚀