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
        name: 'AdminContent',
        component: () => import('../views/admin/CommonModulesManagement.vue')
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

export default router
