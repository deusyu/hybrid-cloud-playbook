#!/bin/bash

# Mermaid图表验证脚本
# 用于检查.mermaid文件的语法和格式是否正确

set -e

echo "🔍 开始验证Mermaid图表..."

# 检查diagrams目录是否存在
if [ ! -d "diagrams" ]; then
    echo "❌ 错误: diagrams目录不存在"
    exit 1
fi

# 查找所有.mermaid文件
mermaid_files=$(find diagrams -name "*.mermaid" -type f)

if [ -z "$mermaid_files" ]; then
    echo "⚠️  警告: 未找到任何.mermaid文件"
    exit 0
fi

echo "📁 找到以下Mermaid文件:"
echo "$mermaid_files"
echo ""

# 验证计数器
total_files=0
valid_files=0
error_files=0

# 逐个验证文件
for file in $mermaid_files; do
    echo "🔎 检查: $file"
    total_files=$((total_files + 1))
    
    # 检查文件是否存在且不为空
    if [ ! -s "$file" ]; then
        echo "❌ 错误: $file 文件为空或不存在"
        error_files=$((error_files + 1))
        continue
    fi
    
    # 检查是否包含markdown代码块标记
    if grep -q "^```" "$file"; then
        echo "❌ 错误: $file 包含不应该有的markdown代码块标记 (```)"
        echo "   .mermaid文件应该直接包含图表代码，不需要markdown包装"
        error_files=$((error_files + 1))
        continue
    fi
    
    # 检查是否以graph开头（基本语法检查）
    if ! grep -q "^graph" "$file"; then
        echo "⚠️  警告: $file 可能不是标准的graph图表（未以'graph'开头）"
    fi
    
    # 检查是否包含基本的节点定义
    if ! grep -q "\\[.*\\]" "$file"; then
        echo "⚠️  警告: $file 可能缺少节点定义"
    fi
    
    # 检查样式类定义语法
    if grep -q "class.*Color" "$file"; then
        echo "✅ $file 包含样式类定义"
    fi
    
    echo "✅ $file 基本格式检查通过"
    valid_files=$((valid_files + 1))
    echo ""
done

# 输出总结
echo "📊 验证总结:"
echo "   总文件数: $total_files"
echo "   通过验证: $valid_files"
echo "   发现错误: $error_files"

if [ $error_files -eq 0 ]; then
    echo ""
    echo "🎉 所有Mermaid文件验证通过！"
    echo ""
    echo "💡 建议下一步操作:"
    echo "1. 在线验证: 访问 https://mermaid.live/ 粘贴文件内容"
    echo "2. 本地渲染: npm install -g @mermaid-js/mermaid-cli"
    echo "3. 生成图片: mmdc -i diagrams/architecture/文件名.mermaid -o 输出.png"
    exit 0
else
    echo ""
    echo "❌ 发现 $error_files 个文件有问题，请修复后重新验证"
    exit 1
fi