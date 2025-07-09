#!/bin/bash

# 简化版Mermaid图表验证脚本
echo "🔍 验证Mermaid图表格式..."

# 检查diagrams目录
if [ ! -d "diagrams" ]; then
    echo "❌ diagrams目录不存在"
    exit 1
fi

# 统计
total=0
errors=0

# 验证每个文件
for file in diagrams/architecture/*.mermaid; do
    if [ -f "$file" ]; then
        echo "检查: $file"
        total=$((total + 1))
        
        # 检查markdown标记
        if grep -q "^```" "$file"; then
            echo "❌ 错误: $file 包含markdown标记"
            errors=$((errors + 1))
        else
            echo "✅ $file 格式正确"
        fi
    fi
done

echo ""
echo "📊 总结: $total 个文件, $errors 个错误"

if [ $errors -eq 0 ]; then
    echo "🎉 所有文件验证通过!"
    exit 0
else
    echo "❌ 请修复错误文件"
    exit 1
fi