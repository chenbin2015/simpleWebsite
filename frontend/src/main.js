import { createApp } from 'vue'
import { createI18n } from 'vue-i18n'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import router from './router'
import { isTokenExpired, clearAuth } from './utils/auth'

// i18n配置
const i18n = createI18n({
  locale: 'zh',
  messages: {
    zh: {
      welcome: '欢迎',
      hello: '你好',
      getData: '获取数据',
      dataFromBackend: '后端数据'
    },
    en: {
      welcome: 'Welcome',
      hello: 'Hello',
      getData: 'Get Data',
      dataFromBackend: 'Data from Backend'
    }
  }
})

// 路由守卫：检查token是否过期
router.beforeEach((to, from, next) => {
  // 如果访问登录或注册页面，直接通过
  if (to.path === '/login' || to.path === '/register') {
    next()
    return
  }
  
  // 检查token是否过期
  if (isTokenExpired()) {
    clearAuth()
    if (to.path !== '/login') {
      next('/login')
      return
    }
  }
  
  next()
})

const app = createApp(App)
app.use(router)
app.use(i18n)
app.use(ElementPlus)
app.mount('#app')

