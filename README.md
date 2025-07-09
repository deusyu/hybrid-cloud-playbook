# Hybrid Cloud Playbook

> **Practical patterns for CMP, IaC & multi-cloud architecture**  
> 一份能跑、能学、能拆的混合云手册 🌩️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-blue.svg)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Compatible-orange.svg)](https://aws.amazon.com/)
[![Azure](https://img.shields.io/badge/Azure-Compatible-blue.svg)](https://azure.microsoft.com/)
[![GCP](https://img.shields.io/badge/GCP-Compatible-green.svg)](https://cloud.google.com/)

## 🎯 项目愿景

创建一个全面、实用、可运行的混合云实战手册，帮助开发者和架构师：
- 📚 **快速学习**混合云核心概念和最佳实践
- 🚀 **实际部署**可运行的多云基础设施
- 🔧 **深入理解**真实企业级架构模式
- 💡 **获得灵感**用于自己的项目实践

## 📁 项目结构

| 目录 | 说明 | 状态 |
| ---- | ---- | ---- |
| [`/docs`](docs/) | 📖 深度文章与技术指南 | ✅ 完成 |
| [`/terraform`](terraform/) | 🚀 可运行示例 & 可复用模块 | ✅ 完成 |
| [`/diagrams`](diagrams/) | 📊 架构图表 (draw.io / mermaid) | 🏗️ 初始化 |
| [`/mindmaps`](mindmaps/) | 🧠 学习路径脑图 | ✅ 完成 |
| [`/scripts`](scripts/) | 🤖 自动化脚本工具 | ✅ 完成 |
| [`/examples`](examples/) | 🎪 完整端到端项目示例 | 🏗️ 初始化 |

## 🚀 快速开始

### 1. 环境准备

```bash
# 克隆项目
git clone https://github.com/deusyu/hybrid-cloud-playbook.git
cd hybrid-cloud-playbook

# 一键环境初始化
./scripts/init-environment.sh
```

### 2. 运行第一个示例

#### AWS VPC 示例
```bash
cd terraform/examples/aws/simple-vpc
terraform init
terraform plan
terraform apply
```

#### 多云基础示例
```bash
cd terraform/examples/multi-cloud/basic
terraform init
terraform plan
terraform apply
```

### 3. 开始学习之旅

📚 **推荐学习路径**：
1. [混合云基础架构指南](docs/architecture/hybrid-cloud-fundamentals.md)
2. [快速入门教程](docs/tutorials/getting-started.md)
3. [学习路径脑图](mindmaps/hybrid-cloud-learning-path.md)

## 🌟 主要特性

### ✅ 开箱即用
- **一键环境搭建**：自动安装所需工具和依赖
- **完整示例代码**：涵盖 AWS、Azure、GCP 三大云平台
- **详细操作文档**：从入门到精通的完整指南

### 🏗️ 生产就绪
- **最佳实践**：遵循云厂商官方推荐架构
- **安全优先**：内置安全配置和访问控制
- **成本优化**：提供成本分析和优化建议

### 📖 学习友好
- **循序渐进**：从基础概念到高级架构
- **实战导向**：所有示例都能直接运行
- **中英双语**：适合中文用户学习

### 🔧 易于扩展
- **模块化设计**：可复用的 Terraform 模块
- **标准化结构**：统一的代码组织方式
- **丰富文档**：详细的 API 和配置说明

## 📚 学习资源

### 🎓 教程文档
- [混合云基础概念](docs/architecture/hybrid-cloud-fundamentals.md)
- [AWS 实战指南](terraform/examples/aws/)
- [Azure 实战指南](terraform/examples/azure/)
- [GCP 实战指南](terraform/examples/gcp/)
- [多云架构设计](terrafoAI 时代，如果你需要一个产品的话，你需要什么？rm/examples/multi-cloud/)
- [云计算角色手册](docs/handbook/cloud-roles.md)

### 🧠 脑图指南
- [混合云学习路径](mindmaps/hybrid-cloud-learning-path.md)
- [技术栈全景图](mindmaps/)
- [最佳实践总结](mindmaps/)

### 🛠️ 工具脚本
- [环境初始化](scripts/init-environment.sh)
- [资源清理](scripts/cleanup-resources.sh)
- [成本分析](scripts/)
- [安全检查](scripts/)

## 🎯 支持的云平台

| 云平台 | 状态 | 示例数量 | 覆盖服务 |
|--------|------|----------|----------|
| **AWS** | ✅ 完成 | 5+ | VPC, EC2, S3, RDS, Lambda |
| **Azure** | 🚧 进行中 ➜ 🏗️ 初版 | 1+ | VNet, VM, Storage, SQL |
| **GCP** | 🚧 进行中 ➜ 🏗️ 初版 | 1+ | VPC, Compute, Storage |
| **多云** | ✅ 完成 | 2+ | 跨云网络, 统一管理 |

## 💡 示例概览

### 单云示例
- **AWS Simple VPC**：基础 VPC 网络架构
- **AWS Web Application**：高可用 Web 应用
- **Azure Resource Group**：资源组织和管理
- **GCP Compute Engine**：虚拟机部署

### 多云示例
- **Multi-Cloud Basic**：跨云基础设施部署
- **Hybrid Networking**：混合云网络连接
- **Cross-Cloud Data Sync**：跨云数据同步

### 完整项目
- **E-commerce Platform**：电商平台架构
- **Data Analytics Pipeline**：数据分析管道
- **IoT Solution**：物联网解决方案

## 🤝 参与贡献

我们欢迎所有形式的贡献！

### 贡献方式
- 🐛 **报告问题**：发现 bug 或提出改进建议
- 💡 **功能请求**：提出新功能或示例需求
- 📖 **改进文档**：完善文档或添加翻译
- 🚀 **提交代码**：贡献新的示例或修复

### 快速参与
1. Fork 本项目
2. 创建功能分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 提交 Pull Request

详细指南请参考：[贡献指南](CONTRIBUTING.md)

## 🏆 致谢

感谢所有贡献者的努力！

### 核心贡献者
- [@deusyu](https://github.com/deusyu) - 项目创始人
- 更多贡献者招募中...

### 特别感谢
- 云计算社区的开源精神
- 各大云厂商的技术文档
- 所有用户的反馈和建议

## 📞 联系我们

### 获取帮助
- 📋 **问题反馈**：[GitHub Issues](https://github.com/deusyu/hybrid-cloud-playbook/issues)
- 💬 **社区讨论**：[GitHub Discussions](https://github.com/deusyu/hybrid-cloud-playbook/discussions)
- 📧 **邮件联系**：[rainman.deus@gmail.com](mailto:rainman.deus@gmail.com)

### 社区交流
- 📖 **博客**：[技术博客](https://deusyu.app/)
- 📚 **Terraform 101**：[Terraform 基础教程](https://deusyu.app/posts/about-terraform/)

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。

## ⚠️ 免责声明

- 本项目仅用于学习和测试目的
- 在生产环境使用前请仔细评估
- 使用本项目产生的云服务费用由用户自行承担
- 请定期清理测试资源以避免不必要的费用

## 🗺️ 发展路线图

### 近期计划 (Q1 2025)
- [ ] 完善 Azure 和 GCP 示例
- [ ] 增加 Kubernetes 集成示例
- [ ] 添加监控和日志方案
- [ ] 创建视频教程

### 中期计划 (Q2-Q3 2025)
- [ ] 支持更多云服务
- [ ] 增加企业级安全方案
- [ ] 开发 Web 管理界面
- [ ] 国际化支持

### 长期愿景
- [ ] 成为混合云领域的权威参考
- [ ] 建立活跃的开源社区
- [ ] 提供认证培训课程

---

<div align="center">

**🌟 如果这个项目对你有帮助，请给我们一个 Star！🌟**

Made with ❤️ by the Hybrid Cloud Playbook community

</div>
