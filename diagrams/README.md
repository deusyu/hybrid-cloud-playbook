# 架构图表集合

> **可视化的混合云架构设计图库**  
> 包含Mermaid图表、Draw.io文件和导出的高质量图片

## 📊 图表概览

### 🏗️ 架构设计图

| 图表名称 | 文件 | 类型 | 说明 |
|---------|------|------|------|
| **混合云整体架构** | `architecture/hybrid-cloud-overview.mermaid` | Mermaid | 完整的混合云生态系统架构 |
| **AWS VPC详细架构** | `architecture/aws-vpc-architecture.mermaid` | Mermaid | AWS VPC网络详细设计 |
| **多云网络连接** | `architecture/multi-cloud-network.mermaid` | Mermaid | 跨云网络连接和数据流 |

### 🔄 工作流程图

| 图表名称 | 文件 | 类型 | 说明 |
|---------|------|------|------|
| **CI/CD流水线** | `workflows/cicd-pipeline.mermaid` | Mermaid | 多云CI/CD部署流程 |
| **数据同步流程** | `workflows/data-sync-flow.mermaid` | Mermaid | 跨云数据同步机制 |

## 🎨 图表类型说明

### Mermaid 图表 (.mermaid)
- **优势**：代码化、版本控制友好、自动渲染
- **用途**：架构图、流程图、时序图
- **渲染**：GitHub、GitLab、Notion等平台原生支持

### Draw.io 文件 (.drawio)
- **优势**：可视化编辑、丰富的图标库
- **用途**：复杂的架构图、详细的网络拓扑
- **编辑**：使用 [draw.io](https://app.diagrams.net/) 在线编辑

### 导出图片 (.png/.svg)
- **优势**：通用性强、高质量显示
- **用途**：文档嵌入、演示文稿
- **位置**：`exports/` 目录

## 🚀 快速使用

### 查看Mermaid图表

#### 在线预览
```bash
# 复制mermaid文件内容
cat diagrams/architecture/hybrid-cloud-overview.mermaid

# 在以下网站粘贴预览：
# https://mermaid.live/
# https://mermaid-js.github.io/mermaid-live-editor/
```

#### 本地渲染
```bash
# 安装mermaid-cli
npm install -g @mermaid-js/mermaid-cli

# 渲染为PNG
mmdc -i diagrams/architecture/hybrid-cloud-overview.mermaid -o hybrid-cloud.png

# 渲染为SVG
mmdc -i diagrams/architecture/hybrid-cloud-overview.mermaid -o hybrid-cloud.svg
```

#### 在Markdown中使用
```markdown
\`\`\`mermaid
graph TB
    A[开始] --> B[处理]
    B --> C[结束]
\`\`\`
```

### 编辑Draw.io图表

1. 访问 [draw.io](https://app.diagrams.net/)
2. 打开现有 `.drawio` 文件
3. 编辑保存
4. 导出为PNG/SVG到 `exports/` 目录

## 📋 图表说明

### 1. 混合云整体架构 (hybrid-cloud-overview.mermaid)

**描述**：展示完整的混合云生态系统，包括：
- 🏢 本地数据中心
- ☁️ AWS、Azure、GCP三大云平台
- 🔄 多云管理工具
- 🔗 网络连接关系

**适用场景**：
- 项目概览展示
- 架构规划讨论
- 技术方案介绍

### 2. AWS VPC详细架构 (aws-vpc-architecture.mermaid)

**描述**：AWS VPC的详细网络设计，包括：
- 📍 多可用区部署
- 🌐 公有/私有子网
- 🛡️ 安全组配置
- 🛣️ 路由表设置
- ☁️ AWS服务集成

**适用场景**：
- AWS网络规划
- 安全架构设计
- 运维文档参考

### 3. 多云网络连接 (multi-cloud-network.mermaid)

**描述**：跨云网络连接的详细实现，包括：
- 🔒 Site-to-Site VPN
- 🚀 专线连接(ExpressRoute/DirectConnect)
- 🌉 云间对等连接
- 📊 数据流向
- 🛡️ 安全控制

**适用场景**：
- 多云网络设计
- 数据迁移规划
- 安全合规审查

## 🎯 图表设计原则

### 颜色规范
- **AWS**: `#FF9900` (橙色)
- **Azure**: `#0078D4` (蓝色)
- **GCP**: `#4285F4` (蓝色)
- **本地**: `#8B4513` (棕色)
- **安全**: `#F44336` (红色)
- **管理**: `#9C27B0` (紫色)

### 图标使用
- 🌐 网络/互联网
- 🔒 私有/安全
- ☁️ 云服务
- 🏢 本地数据中心
- 🔄 流程/循环
- 🛡️ 安全
- 📊 数据/存储

### 命名规范
- 文件名：`kebab-case`
- 节点ID：`UPPER_CASE`
- 描述文字：简洁明了

## 🔧 维护指南

### 更新图表
1. **修改源文件**：编辑 `.mermaid` 或 `.drawio` 文件
2. **更新导出**：重新生成PNG/SVG文件
3. **更新文档**：同步更新相关README和文档
4. **版本控制**：提交到Git仓库

### 添加新图表
1. **确定类型**：选择Mermaid或Draw.io
2. **创建文件**：在相应目录创建文件
3. **更新索引**：在本README中添加条目
4. **生成导出**：创建对应的PNG/SVG文件

### 质量检查
- ✅ 图表渲染正常
- ✅ 颜色符合规范
- ✅ 文字清晰可读
- ✅ 逻辑关系正确
- ✅ 导出图片质量良好

## 📚 参考资源

### 工具文档
- [Mermaid 官方文档](https://mermaid-js.github.io/mermaid/)
- [Draw.io 用户指南](https://desk.draw.io/support/home)
- [AWS架构图标](https://aws.amazon.com/architecture/icons/)
- [Azure架构图标](https://docs.microsoft.com/en-us/azure/architecture/icons/)
- [GCP架构图标](https://cloud.google.com/icons)

### 最佳实践
- [AWS架构最佳实践](https://aws.amazon.com/architecture/)
- [Azure架构中心](https://docs.microsoft.com/en-us/azure/architecture/)
- [GCP架构框架](https://cloud.google.com/architecture/framework)

## 🤝 贡献指南

欢迎贡献新的架构图表！

### 贡献流程
1. **Fork项目**
2. **创建分支**：`git checkout -b feature/new-diagram`
3. **添加图表**：按照命名规范创建文件
4. **更新文档**：在README中添加说明
5. **提交PR**：详细描述图表用途和特点

### 图表要求
- 🎨 **美观**：遵循颜色和样式规范
- 📝 **清晰**：逻辑关系明确，标注清楚
- 🔧 **实用**：具有实际参考价值
- 📖 **文档**：提供详细的说明文档

---

<div align="center">
<b>🎨 让架构可视化，让复杂简单化！</b>
</div>