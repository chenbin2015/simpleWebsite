import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import './style.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

const app = createApp(App)

// 注册所有 Element Plus 图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(router)
app.use(ElementPlus)
app.mount('#app')

// 配置 tooltip 单例模式，确保一次只显示一个 tooltip
let currentTooltipElement = null

// 监听 tooltip 的显示和隐藏
function manageTooltips() {
  const tooltips = Array.from(document.querySelectorAll('.el-tooltip__popper, .el-popper.is-tooltip'))
    .filter(t => {
      const style = window.getComputedStyle(t)
      return style.display !== 'none' && style.visibility !== 'hidden' && parseFloat(style.opacity) > 0
    })
  
  if (tooltips.length > 1) {
    // 只保留最后一个可见的 tooltip
    const latestTooltip = tooltips[tooltips.length - 1]
    
    tooltips.forEach((tooltip) => {
      if (tooltip !== latestTooltip) {
        // 隐藏其他 tooltip
        tooltip.style.display = 'none'
        tooltip.setAttribute('aria-hidden', 'true')
      }
    })
    
    currentTooltipElement = latestTooltip
  } else if (tooltips.length === 1) {
    currentTooltipElement = tooltips[0]
  } else {
    currentTooltipElement = null
  }
}

// 使用 MutationObserver 监听 DOM 变化
const observer = new MutationObserver(() => {
  manageTooltips()
})

// 延迟启动观察，确保 DOM 已加载
setTimeout(() => {
  observer.observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['class', 'style', 'aria-hidden']
  })
  
  // 定期检查 tooltip 状态
  setInterval(manageTooltips, 100)
  
  // 监听鼠标移动，实时管理 tooltip
  document.addEventListener('mouseover', () => {
    setTimeout(manageTooltips, 50)
  }, true)
}, 300)

