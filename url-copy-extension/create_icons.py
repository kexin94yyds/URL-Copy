#!/usr/bin/env python3
# 创建简单的SVG图标

svg_template = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="{size}" height="{size}" viewBox="0 0 {size} {size}" xmlns="http://www.w3.org/2000/svg">
  <rect width="{size}" height="{size}" rx="{radius}" fill="#4A7FFF"/>
  <text x="50%" y="50%" font-family="Arial" font-size="{font_size}" fill="white" text-anchor="middle" dominant-baseline="middle">🔗</text>
</svg>'''

sizes = [16, 48, 128]
for size in sizes:
    font_size = size // 2
    radius = size // 6

    svg_content = svg_template.format(
        size=size,
        radius=radius,
        font_size=font_size
    )

    with open(f'icon{size}.svg', 'w') as f:
        f.write(svg_content)

    print(f'Created icon{size}.svg')