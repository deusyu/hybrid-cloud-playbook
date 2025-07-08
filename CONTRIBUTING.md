# 贡献指南

欢迎为 Hybrid Cloud Playbook 项目贡献！本指南将帮助你了解如何参与项目开发和改进。

## 🎯 项目愿景

创建一个全面、实用、可运行的混合云实战手册，帮助开发者和架构师快速掌握混合云技术，并提供可直接使用的代码示例和最佳实践。

## 🤝 贡献方式

### 1. 问题报告
- 🐛 **Bug 报告**：发现代码或文档中的错误
- 💡 **功能建议**：提出新的功能或改进建议
- 📚 **文档改进**：改进现有文档或补充缺失文档
- 🔧 **工具建议**：推荐有用的工具或脚本

### 2. 代码贡献
- 🚀 **新功能开发**：实现新的云服务示例
- 🔧 **Bug 修复**：修复已知问题
- 📈 **性能优化**：改进现有代码性能
- 🧪 **测试补充**：添加测试用例

### 3. 文档贡献
- 📖 **教程编写**：创建新的教程或指南
- 🎯 **最佳实践**：分享实际项目经验
- 🌐 **多语言支持**：翻译文档到其他语言
- 📊 **图表制作**：创建架构图或流程图

## 📋 贡献流程

### 1. 准备工作

#### Fork 项目
```bash
# 1. Fork 项目到你的账号
# 2. 克隆你的 fork
git clone https://github.com/your-username/hybrid-cloud-playbook.git
cd hybrid-cloud-playbook

# 3. 添加上游仓库
git remote add upstream https://github.com/deusyu/hybrid-cloud-playbook.git
```

#### 环境设置
```bash
# 运行环境初始化脚本
./scripts/init-environment.sh

# 安装开发依赖
./scripts/install-dev-tools.sh
```

### 2. 开发流程

#### 创建功能分支
```bash
# 同步上游更改
git fetch upstream
git checkout main
git merge upstream/main

# 创建功能分支
git checkout -b feature/your-feature-name
```

#### 开发规范
```bash
# 提交前检查
./scripts/pre-commit-check.sh

# 运行测试
./scripts/run-tests.sh

# 格式化代码
./scripts/format-code.sh
```

#### 提交变更
```bash
git add .
git commit -m "feat: add new AWS Lambda example"
git push origin feature/your-feature-name
```

### 3. 提交 Pull Request

#### PR 模板
```markdown
## 变更描述
简要描述你的更改内容

## 变更类型
- [ ] 新功能
- [ ] Bug 修复
- [ ] 文档更新
- [ ] 性能优化
- [ ] 重构
- [ ] 测试

## 测试
- [ ] 已添加测试用例
- [ ] 已运行现有测试
- [ ] 已在以下环境测试：
  - [ ] AWS
  - [ ] Azure
  - [ ] GCP

## 检查清单
- [ ] 代码符合风格指南
- [ ] 已更新相关文档
- [ ] 已添加必要的注释
- [ ] 变更向后兼容
```

## 📐 开发标准

### 1. 代码风格

#### Terraform 规范
```hcl
# 使用有意义的资源名称
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

# 使用一致的变量命名
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "hybrid-cloud-demo"
}
```

#### Shell 脚本规范
```bash
#!/bin/bash
# 始终使用 bash shebang
# 使用 set -e 确保错误时退出
set -e

# 使用函数组织代码
log_info() {
    echo "[INFO] $1"
}

# 使用有意义的变量名
readonly PROJECT_NAME="hybrid-cloud-playbook"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

#### 文档规范
```markdown
# 使用清晰的标题层级
## 主要章节
### 子章节
#### 详细说明

# 使用代码块标明语言
```bash
# Shell 命令示例
terraform init
```

# 使用表格组织信息
| 参数 | 说明 | 默认值 |
|------|------|--------|
| region | AWS 区域 | us-west-2 |
```

### 2. 目录结构

```
hybrid-cloud-playbook/
├── terraform/
│   ├── examples/
│   │   ├── aws/
│   │   │   └── service-name/
│   │   │       ├── main.tf
│   │   │       ├── variables.tf
│   │   │       ├── outputs.tf
│   │   │       ├── README.md
│   │   │       └── terraform.tfvars.example
│   │   ├── azure/
│   │   └── gcp/
│   └── modules/
│       └── module-name/
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           └── README.md
├── docs/
│   ├── architecture/
│   ├── best-practices/
│   ├── tutorials/
│   └── troubleshooting/
├── scripts/
│   ├── init-environment.sh
│   ├── cleanup-resources.sh
│   └── run-tests.sh
└── examples/
    └── project-name/
        ├── README.md
        ├── docker-compose.yml
        └── terraform/
```

### 3. 命名约定

#### 文件命名
```
# Terraform 文件
main.tf          # 主要资源定义
variables.tf     # 变量定义
outputs.tf       # 输出定义
locals.tf        # 本地值定义
data.tf          # 数据源定义

# 文档文件
README.md        # 项目说明
CHANGELOG.md     # 变更日志
CONTRIBUTING.md  # 贡献指南

# 脚本文件
init-environment.sh    # 环境初始化
cleanup-resources.sh   # 资源清理
run-tests.sh          # 测试运行
```

#### 资源命名
```hcl
# AWS 资源
aws_vpc.main
aws_subnet.public
aws_subnet.private
aws_security_group.web
aws_instance.web

# Azure 资源
azurerm_resource_group.main
azurerm_virtual_network.main
azurerm_subnet.public
azurerm_network_security_group.web

# GCP 资源
google_compute_network.main
google_compute_subnetwork.public
google_compute_firewall.web
google_compute_instance.web
```

## 🧪 测试要求

### 1. Terraform 测试
```bash
# 语法检查
terraform fmt -check
terraform validate

# 安全扫描
tfsec .
checkov -f main.tf

# 计划验证
terraform plan -var-file=test.tfvars
```

### 2. 脚本测试
```bash
# Shell 脚本检查
shellcheck scripts/*.sh

# 功能测试
bats tests/

# 集成测试
./scripts/integration-test.sh
```

### 3. 文档测试
```bash
# Markdown 格式检查
markdownlint docs/

# 链接检查
markdown-link-check docs/**/*.md

# 拼写检查
aspell check docs/**/*.md
```

## 📝 文档标准

### 1. README 结构
```markdown
# 项目名称

简要描述项目用途

## 🏗️ 架构概述
## 📋 前置要求
## 🚀 使用方法
## ⚙️ 配置选项
## 🧪 测试
## 🔧 故障排除
## 📈 扩展建议
## 🤝 贡献
## 📄 许可证
```

### 2. 代码注释
```hcl
# Terraform 注释示例
# Create VPC for the hybrid cloud demo
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}
```

### 3. 变更日志
```markdown
# 变更日志

## [1.2.0] - 2024-01-15
### 新增
- 添加 AWS Lambda 示例
- 增加多云监控脚本

### 修复
- 修复 Azure 资源组命名问题
- 修复文档中的链接错误

### 变更
- 更新 Terraform 版本要求
- 改进错误处理逻辑
```

## 🏷️ 发布流程

### 1. 版本号规则
遵循 [语义化版本](https://semver.org/) 规则：
- **主版本号**：不兼容的 API 修改
- **次版本号**：向后兼容的功能性新增
- **修订号**：向后兼容的问题修正

### 2. 发布检查清单
- [ ] 所有测试通过
- [ ] 文档已更新
- [ ] 变更日志已更新
- [ ] 版本号已更新
- [ ] 标签已创建

### 3. 发布命令
```bash
# 创建发布标签
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0

# 创建发布说明
gh release create v1.2.0 --generate-notes
```

## 🎨 设计原则

### 1. 可运行性
- 所有示例都应该能够直接运行
- 提供完整的配置文件
- 包含必要的依赖安装

### 2. 可学习性
- 提供详细的注释和文档
- 包含学习路径和教程
- 提供故障排除指南

### 3. 可扩展性
- 模块化设计
- 支持自定义配置
- 提供扩展示例

### 4. 最佳实践
- 遵循云服务最佳实践
- 考虑安全性和性能
- 提供成本优化建议

## 🏆 贡献者认可

### 1. 贡献者类型
- **代码贡献者**：提交代码改进
- **文档贡献者**：改进文档质量
- **测试贡献者**：添加测试用例
- **社区贡献者**：帮助其他用户

### 2. 认可方式
- 在 README 中列出贡献者
- 在发布说明中感谢贡献者
- 颁发贡献者徽章
- 社区活动邀请

## 📞 联系方式

### 获取帮助
- 📋 **问题报告**：[GitHub Issues](https://github.com/deusyu/hybrid-cloud-playbook/issues)
- 💬 **讨论交流**：[GitHub Discussions](https://github.com/deusyu/hybrid-cloud-playbook/discussions)
- 📧 **邮件联系**：[rainman.deus@gmail.com](mailto:rainman.deus@gmail.com)

### 社区参与
- 💬 **Slack 频道**：[#hybrid-cloud-playbook](https://slack.com/channels/hybrid-cloud-playbook)

## 🎉 致谢

感谢所有为 Hybrid Cloud Playbook 项目做出贡献的朋友！你们的贡献让这个项目变得更好。

特别感谢：
- 所有提交 PR 的贡献者
- 所有报告问题的用户
- 所有参与讨论的社区成员
- 所有分享使用经验的用户

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。通过贡献代码，你同意你的贡献将在相同许可证下发布。