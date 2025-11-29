<template>
  <!-- 管理后台路由：全屏布局 -->
  <router-view v-if="isAdminRoute" />
  
  <!-- 前台路由：正常布局 -->
  <el-container v-else class="app-container">
    <el-header class="app-header">
      <div class="header-content">
        <h1 class="logo">Vue 3 项目</h1>
        <el-menu
          :default-active="activeIndex"
          class="header-menu"
          mode="horizontal"
          :router="true"
        >
          <el-menu-item index="/">首页</el-menu-item>
          <el-menu-item index="/center-overview">中心概况</el-menu-item>
          <el-sub-menu index="experiment-teaching">
            <template #title>实验教学</template>
            <el-menu-item :index="getMenuPath('experiment-teaching', 'course-system')">课程体系</el-menu-item>
            <el-menu-item :index="getMenuPath('experiment-teaching', 'experiment-course')">实验课程</el-menu-item>
          </el-sub-menu>
          <el-sub-menu index="experiment-resources">
            <template #title>实验资源</template>
            <el-menu-item :index="getMenuPath('experiment-resources', 'experiment-instruments')">实验仪器</el-menu-item>
            <el-menu-item :index="getMenuPath('experiment-resources', 'experiment-space')">实验空间</el-menu-item>
            <el-menu-item :index="getMenuPath('experiment-resources', 'open-sharing')">开放共享</el-menu-item>
          </el-sub-menu>
          <el-sub-menu index="construction-results">
            <template #title>建设成效</template>
            <el-menu-item :index="getMenuPath('construction-results', 'teaching-reform')">实验教学改革</el-menu-item>
            <el-menu-item :index="getMenuPath('construction-results', 'research-innovation')">科研创新成果</el-menu-item>
            <el-menu-item :index="getMenuPath('construction-results', 'environment-capability')">实验环境与能力</el-menu-item>
          </el-sub-menu>
          <el-sub-menu index="safety-management">
            <template #title>安全管理</template>
            <el-menu-item :index="getMenuPath('safety-management', 'safety-education')">安全教育</el-menu-item>
            <el-menu-item :index="getMenuPath('safety-management', 'safety-access')">安全准入</el-menu-item>
            <el-menu-item :index="getMenuPath('safety-management', 'management-system')">管理制度</el-menu-item>
          </el-sub-menu>
          <el-menu-item index="/popular-science">科普教育</el-menu-item>
        </el-menu>
      </div>
    </el-header>
    <el-main class="app-main" :class="{ 'full-width': isCenterOverview, 'has-sidebar': hasSubMenu }">
      <router-view />
    </el-main>
    <el-footer class="app-footer">
      <p>© 2025 Vue 3 + Element Plus + Vite</p>
    </el-footer>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { hasSubMenu as checkHasSubMenu, getDefaultRoutePath } from '@/config/menuConfig'

const route = useRoute()
const activeIndex = computed(() => route.path)
const isCenterOverview = computed(() => route.path === '/center-overview')
const hasSubMenu = computed(() => checkHasSubMenu(route.path))
const isAdminRoute = computed(() => route.path.startsWith('/admin'))

// 获取菜单路径
const getMenuPath = (category, menuKey) => {
  return getDefaultRoutePath(category, menuKey)
}
</script>

<style scoped>
.app-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-header {
  background-color: #409eff;
  color: white;
  padding: 0;
  height: 60px;
  line-height: 60px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.logo {
  margin: 0;
  font-size: 24px;
  font-weight: bold;
}

.header-menu {
  background-color: transparent;
  border-bottom: none;
}

.header-menu :deep(.el-menu-item) {
  color: white;
  border-bottom: 2px solid transparent;
}

.header-menu :deep(.el-menu-item:hover),
.header-menu :deep(.el-menu-item.is-active) {
  background-color: rgba(255, 255, 255, 0.1);
  border-bottom-color: white;
}

.header-menu :deep(.el-sub-menu__title) {
  color: white;
  border-bottom: 2px solid transparent;
}

.header-menu :deep(.el-sub-menu__title:hover) {
  background-color: rgba(255, 255, 255, 0.1);
}

.header-menu :deep(.el-sub-menu.is-active .el-sub-menu__title) {
  border-bottom-color: white;
}

.app-main {
  flex: 1;
  padding: 20px;
  max-width: 1200px;
  width: 100%;
  margin: 0 auto;
}

.app-main.full-width {
  max-width: 100%;
  padding: 0;
}

.app-main.has-sidebar {
  max-width: 100%;
  padding: 0;
}

.app-footer {
  background-color: #f5f7fa;
  text-align: center;
  height: 60px;
  line-height: 60px;
  color: #606266;
}
</style>

