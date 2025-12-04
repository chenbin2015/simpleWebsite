import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home/Index.vue'
import CenterOverview from '../views/CenterOverview.vue'
import DynamicPage from '../views/DynamicPage.vue'
import PopularScience from '../views/PopularScience.vue'
import DetailPage from '../views/DetailPage.vue'
import CommonList from '../views/CommonList.vue'
import UnderConstruction from '../views/UnderConstruction.vue'

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
  // 动态路由：/dynamic/rootType/type/id
  {
    path: '/dynamic/:rootType/:type/:id',
    name: 'DynamicPage',
    component: DynamicPage,
    props: true
  },
  {
    path: '/popular-science',
    name: 'PopularScience',
    component: PopularScience
  },
  // 详情页路由：/detail/:type/:id (type: news 或 announcement)
  {
    path: '/detail/:type/:id',
    name: 'DetailPage',
    component: DetailPage,
    props: true
  },
  // 通用列表页：/common-list?type=news|announcement&from=home
  {
    path: '/common-list',
    name: 'CommonList',
    component: CommonList
  },
  // 系统建设中页面
  {
    path: '/under-construction',
    name: 'UnderConstruction',
    component: UnderConstruction
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    // 如果有保存的位置（比如浏览器前进/后退），则恢复到该位置
    if (savedPosition) {
      return savedPosition
    }
    // 否则滚动到顶部
    return { top: 0, behavior: 'smooth' }
  }
})

export default router
