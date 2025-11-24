// 静态路由配置（新增的路由）
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import Admin from '../views/Admin.vue'

export const staticRoutes = [
  { 
    path: '/', 
    name: 'Home',
    component: Home 
  },
  { 
    path: '/login', 
    name: 'Login',
    component: Login 
  },
  { 
    path: '/register', 
    name: 'Register',
    component: Register 
  },
  { 
    path: '/admin', 
    name: 'Admin',
    component: Admin 
  }
]

