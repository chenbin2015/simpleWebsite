import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import Home from './views/Home.vue'
import CenterOverview from './views/CenterOverview.vue'
import ExperimentalTeaching from './views/ExperimentalTeaching.vue'
import CourseSystem from './views/CourseSystem.vue'
import ExperimentalCourse from './views/ExperimentalCourse.vue'
import ExperimentalResources from './views/ExperimentalResources.vue'
import ExperimentalInstruments from './views/ExperimentalInstruments.vue'
import ExperimentalSpace from './views/ExperimentalSpace.vue'
import OpenSharing from './views/OpenSharing.vue'
import ConstructionResults from './views/ConstructionResults.vue'
import TeachingReform from './views/TeachingReform.vue'
import ResearchInnovation from './views/ResearchInnovation.vue'
import ExperimentalEnvironment from './views/ExperimentalEnvironment.vue'
import SafetyManagement from './views/SafetyManagement.vue'
import SafetyEducation from './views/SafetyEducation.vue'
import SafetyAccess from './views/SafetyAccess.vue'
import ManagementSystem from './views/ManagementSystem.vue'
import ScienceEducation from './views/ScienceEducation.vue'
import MenuPage from './views/MenuPage.vue'

const routes = [
  { path: '/', name: '首页', component: Home },
  { path: '/center-overview', name: '中心概况', component: CenterOverview },
  { path: '/experimental-teaching', name: '实验教学', component: ExperimentalTeaching },
  { path: '/experimental-resources', name: '实验资源', component: ExperimentalResources },
  { path: '/construction-results', name: '建设成效', component: ConstructionResults },
  { path: '/safety-management', name: '安全管理', component: SafetyManagement },
  { path: '/science-education', name: '科普教育', component: ScienceEducation },
  // 动态路由：二级菜单路由，格式为 /menu/:type/:id
  { path: '/menu/:type/:id', name: 'MenuPage', component: MenuPage }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const app = createApp(App)
app.use(router)
app.use(ElementPlus)
app.mount('#app')
