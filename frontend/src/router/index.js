import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import CenterOverview from '../views/CenterOverview.vue'
import DynamicPage from '../views/DynamicPage.vue'
import PopularScience from '../views/PopularScience.vue'
import AdminLayout from '../views/admin/AdminLayout.vue'
import AdminHome from '../views/admin/AdminHome.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/center-overview',
    name: 'CenterOverview',
    component: CenterOverview
  },
  // 动态路由：category/pageType/id
  {
    path: '/:category/:pageType/:id',
    name: 'DynamicPage',
    component: DynamicPage,
    props: true
  },
  // 兼容旧路由，重定向到新结构
  {
    path: '/course-system',
    redirect: '/experiment-teaching/image-text/1'
  },
  {
    path: '/experiment-course',
    redirect: '/experiment-teaching/news-list/2'
  },
  {
    path: '/experiment-instruments',
    redirect: '/experiment-resources/product-list/3'
  },
  {
    path: '/experiment-space',
    redirect: '/experiment-resources/image-text/4'
  },
  {
    path: '/open-sharing',
    redirect: '/experiment-resources/download-list/5'
  },
  {
    path: '/teaching-reform',
    redirect: '/construction-results/news-list/6'
  },
  {
    path: '/research-innovation',
    redirect: '/construction-results/news-list/7'
  },
  {
    path: '/environment-capability',
    redirect: '/construction-results/image-text/8'
  },
  {
    path: '/safety-education',
    redirect: '/safety-management/news-list/9'
  },
  {
    path: '/safety-access',
    redirect: '/safety-management/download-list/10'
  },
  {
    path: '/management-system',
    redirect: '/safety-management/download-list/11'
  },
  {
    path: '/popular-science',
    name: 'PopularScience',
    component: PopularScience
  },
  // 管理后台登录页
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('../views/admin/Login.vue')
  },
  // 管理后台路由
  {
    path: '/admin',
    component: AdminLayout,
    redirect: '/admin/home',
    children: [
      {
        path: 'home',
        name: 'AdminHome',
        component: AdminHome
      },
      {
        path: 'center-overview',
        name: 'AdminCenterOverview',
        component: () => import('../views/admin/CenterOverviewManagement.vue')
      },
      {
        path: 'content',
        redirect: '/admin/content/experiment-teaching'
      },
      {
        path: 'content/:category',
        name: 'AdminContent',
        component: () => import('../views/admin/CommonModulesManagement.vue'),
        props: true
      },
      {
        path: 'popular-science',
        name: 'AdminPopularScience',
        component: () => import('../views/admin/PopularScienceManagement.vue')
      },
      {
        path: 'footer',
        name: 'AdminFooter',
        component: () => import('../views/admin/FooterManagement.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫：保护管理后台路由
router.beforeEach((to, from, next) => {
  // 获取token
  const token = localStorage.getItem('token')
  
  // 如果是访问管理后台路由（除了登录页）
  if (to.path.startsWith('/admin') && to.path !== '/admin/login') {
    // 检查是否有token
    if (!token) {
      // 没有token，跳转到登录页
      next('/admin/login')
      return
    }
  }
  
  // 如果已经登录，访问登录页时重定向到管理后台首页
  if (to.path === '/admin/login' && token) {
    next('/admin/home')
    return
  }
  
  // 其他情况正常放行
  next()
})

export default router
