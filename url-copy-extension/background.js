// 处理快捷键命令
chrome.commands.onCommand.addListener((command) => {
  if (command === 'copy-url') {
    copyCurrentUrl();
  }
});

// 处理插件图标点击
chrome.action.onClicked.addListener((tab) => {
  copyCurrentUrl();
});

// 复制当前页面URL到剪贴板
async function copyCurrentUrl() {
  try {
    // 获取当前活动标签页
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

    if (tab && tab.url) {
      // 使用新的权限API执行复制操作
      await chrome.scripting.executeScript({
        target: { tabId: tab.id },
        func: (url) => {
          // 创建临时输入框来复制文本
          const tempInput = document.createElement('input');
          tempInput.value = url;
          document.body.appendChild(tempInput);
          tempInput.select();
          document.execCommand('copy');
          document.body.removeChild(tempInput);

          // 显示成功提示
          showNotification('链接已复制到剪贴板');
        },
        args: [tab.url]
      });
    }
  } catch (error) {
    console.error('复制URL失败:', error);

    // 尝试使用备用方法
    try {
      const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
      if (tab && tab.url) {
        await navigator.clipboard.writeText(tab.url);
        showNotification('链接已复制到剪贴板');
      }
    } catch (fallbackError) {
      showNotification('复制失败，请重试');
    }
  }
}

// 显示通知
function showNotification(message) {
  chrome.notifications.create({
    type: 'basic',
    iconUrl: 'icon48.svg',
    title: 'URL Copy',
    message: message
  });
}