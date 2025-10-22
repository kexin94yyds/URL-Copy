# URL Copy Chrome 插件

一个简单快捷的Chrome插件，通过快捷键一键复制当前网页链接到剪贴板。

## 功能
- 按 `Ctrl+Shift+C` (Windows/Linux) 或 `Command+Shift+C` (Mac) 复制当前页面URL
- 点击插件图标也可复制URL
- 复制成功后显示通知提示

## 安装方法

1. 打开Chrome浏览器
2. 在地址栏输入 `chrome://extensions/`
3. 开启右上角的"开发者模式"
4. 点击"加载已解压的扩展程序"
5. 选择本插件文件夹 (`url-copy-extension`)
6. 插件安装完成！

## 使用方法

- **快捷键**: `Ctrl+Shift+C` (Windows/Linux) 或 `Command+Shift+C` (Mac)
- **鼠标**: 点击工具栏中的插件图标

## 自定义快捷键

1. 打开 `chrome://extensions/`
2. 找到URL Copy插件
3. 点击"详细信息"
4. 在"扩展程序选项"中找到快捷键设置
5. 修改为你想要的快捷键组合

## 文件说明

- `manifest.json`: 插件配置文件
- `background.js`: 后台脚本，处理快捷键和复制功能
- `icon*.svg`: 插件图标文件
- `create_icons.py`: 图标生成脚本

## 技术特点

- 使用 Manifest V3 标准
- 支持Chrome最新版本
- 无需网络权限，完全本地运行
- 内存占用极小