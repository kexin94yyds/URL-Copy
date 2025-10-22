// 监听快捷键命令
chrome.commands.onCommand.addListener((command) => {
  if (command === "copy-url") {
    copyCurrentUrl();
  }
});

// 监听插件图标点击
chrome.action.onClicked.addListener(() => {
  copyCurrentUrl();
});

// 复制当前标签页 URL
async function copyCurrentUrl() {
  try {
    // 获取当前活动标签页
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    
    if (tab && tab.url) {
      // 方法1: 尝试使用 scripting API 注入
      try {
        await chrome.scripting.executeScript({
          target: { tabId: tab.id },
          func: copyToClipboard,
          args: [tab.url]
        });
      } catch (scriptError) {
        // 方法2: 如果注入失败（如 Chrome 内部页面），使用 document.execCommand
        console.log('注入失败，使用备用方案:', scriptError);
        const input = document.createElement('textarea');
        input.value = tab.url;
        document.body.appendChild(input);
        input.select();
        document.execCommand('copy');
        document.body.removeChild(input);
        console.log('URL 已复制（备用方案）:', tab.url);
      }
    }
  } catch (error) {
    console.error('复制失败:', error);
  }
}

// 在页面上下文中执行的复制函数
function copyToClipboard(url) {
  // 使用多种方法尝试复制
  
  // 方法1: Clipboard API
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(url).then(() => {
      console.log('URL 已复制:', url);
    }).catch(err => {
      console.error('Clipboard API 失败:', err);
      fallbackCopy(url);
    });
  } else {
    // 方法2: 备用方法
    fallbackCopy(url);
  }
  
  function fallbackCopy(text) {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();
    
    try {
      const successful = document.execCommand('copy');
      if (successful) {
        console.log('URL 已复制（备用方法）:', text);
      } else {
        console.error('复制命令执行失败');
      }
    } catch (err) {
      console.error('备用复制方法失败:', err);
    }
    
    document.body.removeChild(textarea);
  }
}
