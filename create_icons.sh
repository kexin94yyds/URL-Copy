#!/bin/bash

# 使用 macOS 自带的 sips 工具转换图标
# 首先创建一个临时的 128x128 PNG 图标

# 创建基础 PNG 图标（如果你有其他工具可以用其他方式）
# 这里我们使用简单的方法：下载或手动创建一个图标

echo "请使用以下任意方式创建图标："
echo ""
echo "方式1: 在线工具"
echo "访问 https://www.figma.com 或 https://www.canva.com 创建一个 128x128 的图标"
echo "然后导出为 icon128.png 放到当前目录"
echo ""
echo "方式2: 使用 macOS 预览应用"
echo "1. 双击打开 icon.svg"
echo "2. 文件 -> 导出为 PNG"
echo "3. 设置尺寸为 128x128，保存为 icon128.png"
echo ""
echo "方式3: 使用 ImageMagick (如果已安装)"
echo "brew install imagemagick"
echo "convert -background none icon.svg -resize 128x128 icon128.png"
echo "convert -background none icon.svg -resize 48x48 icon48.png"
echo "convert -background none icon.svg -resize 16x16 icon16.png"
echo ""
echo "创建好 icon128.png 后，运行以下命令生成其他尺寸："
echo "sips -z 48 48 icon128.png --out icon48.png"
echo "sips -z 16 16 icon128.png --out icon16.png"
