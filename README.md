# URL Copy Chrome 插件

一键复制当前网页链接的 Chrome 插件。

## 功能

- 点击插件图标复制当前网页链接
- 使用快捷键复制当前网页链接
  - Mac: `Command+Shift+C`
  - Windows/Linux: `Ctrl+Shift+C`

## 安装步骤

1. 打开 Chrome 浏览器
2. 访问 `chrome://extensions/`
3. 开启右上角的"开发者模式"
4. 点击"加载已解压的扩展程序"
5. 选择此文件夹

## 自定义快捷键

1. 访问 `chrome://extensions/shortcuts`
2. 找到 "URL Copy" 插件
3. 点击快捷键设置按钮
4. 设置你喜欢的快捷键组合

## 使用方法

### 方式一：点击图标
点击浏览器工具栏上的插件图标即可复制当前页面链接。

### 方式二：快捷键
按下快捷键（默认 `Command+Shift+C` 或 `Ctrl+Shift+C`）即可复制。

## 文件说明

- `manifest.json` - 插件配置文件
- `background.js` - 后台脚本，处理复制逻辑
- `icon.svg` - 插件图标（需要转换为 PNG）
- `README.md` - 说明文档

## 生成图标

由于 Chrome 插件需要 PNG 格式图标，你需要将 `icon.svg` 转换为以下尺寸的 PNG 文件：
- `icon16.png` (16x16)
- `icon48.png` (48x48)
- `icon128.png` (128x128)

你可以使用在线工具或命令行工具（如 ImageMagick）来转换。
