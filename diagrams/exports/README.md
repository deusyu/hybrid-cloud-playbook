# 导出图片目录

> **高质量架构图片导出文件**  
> 包含PNG、SVG等格式的架构图，可直接用于文档和演示

## 📁 目录结构

```
exports/
├── png/                    # PNG格式图片（适用于文档嵌入）
│   ├── hybrid-cloud-overview.png
│   ├── aws-vpc-architecture.png
│   └── multi-cloud-network.png
├── svg/                    # SVG格式图片（可缩放矢量图）
│   ├── hybrid-cloud-overview.svg
│   ├── aws-vpc-architecture.svg
│   └── multi-cloud-network.svg
└── README.md              # 本文件
```

## 🎯 文件说明

### PNG 格式
- **分辨率**：1920x1080 或更高
- **用途**：文档嵌入、幻灯片展示
- **优势**：兼容性好、加载快速

### SVG 格式
- **特点**：矢量图形、无限缩放
- **用途**：高质量打印、网页显示
- **优势**：文件小、清晰度高

## 🔄 更新流程

### 自动更新
```bash
# 使用 mermaid-cli 批量导出
npm install -g @mermaid-js/mermaid-cli

# 导出所有架构图为PNG
for file in diagrams/architecture/*.mermaid; do
    filename=$(basename "$file" .mermaid)
    mmdc -i "$file" -o "diagrams/exports/png/${filename}.png" -w 1920 -H 1080
done

# 导出所有架构图为SVG
for file in diagrams/architecture/*.mermaid; do
    filename=$(basename "$file" .mermaid)
    mmdc -i "$file" -o "diagrams/exports/svg/${filename}.svg"
done
```

### 手动更新
1. 打开 [mermaid.live](https://mermaid.live/)
2. 粘贴mermaid代码
3. 点击"Download PNG"或"Download SVG"
4. 将文件保存到对应目录

## 📝 使用说明

### 在文档中引用
```markdown
![混合云架构](diagrams/exports/png/hybrid-cloud-overview.png)
```

### 在HTML中使用
```html
<img src="diagrams/exports/svg/aws-vpc-architecture.svg" 
     alt="AWS VPC架构" 
     style="max-width: 100%; height: auto;">
```

## 🔧 维护指南

- **命名规范**：与源文件保持一致
- **版本同步**：源文件更新时及时重新导出
- **质量检查**：确保图片清晰、颜色正确
- **文件大小**：PNG控制在2MB以内，SVG控制在500KB以内

---

💡 **提示**：导出的图片仅供参考使用，建议以源文件为准进行编辑和修改。