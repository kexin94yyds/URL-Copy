from PIL import Image, ImageDraw

def create_icon(size):
    # 创建蓝色背景
    img = Image.new('RGB', (size, size), '#4285f4')
    draw = ImageDraw.Draw(img)
    
    # 计算缩放比例
    scale = size / 128
    
    # 绘制白色矩形（表示文本链接）
    draw.rectangle([32*scale, 45*scale, 96*scale, 53*scale], fill='white')
    draw.rectangle([32*scale, 60*scale, 96*scale, 68*scale], fill='white')
    draw.rectangle([32*scale, 75*scale, 72*scale, 83*scale], fill='white')
    
    # 绘制复制符号
    draw.rectangle([85*scale, 75*scale, 100*scale, 90*scale], fill='white')
    
    return img

# 生成三个尺寸的图标
for size in [16, 48, 128]:
    icon = create_icon(size)
    icon.save(f'icon{size}.png')
    print(f'已生成 icon{size}.png')
