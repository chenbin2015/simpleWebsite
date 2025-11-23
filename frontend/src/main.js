import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import { createI18n } from 'vue-i18n'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import Home from './views/Home.vue'

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

// 路由配置
const routes = [
  { path: '/', component: Home }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const app = createApp(App)
app.use(router)
app.use(i18n)
app.use(ElementPlus)
app.mount('#app')

