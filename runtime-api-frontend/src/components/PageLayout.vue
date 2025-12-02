<template>
  <div class="page-layout">
    <div class="layout-container">
      <!-- 左侧菜单 -->
      <aside v-if="shouldShowSidebar" class="sidebar">
        <SidebarMenu />
      </aside>
      <!-- 右侧内容 -->
      <main class="content" :class="{ 'full-width': !shouldShowSidebar }">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import SidebarMenu from './SidebarMenu.vue'
import { getMenuGroupByPath, menuGroups } from '@/config/menuConfig'

const props = defineProps({
  showSidebar: {
    type: Boolean,
    default: true
  }
})

const route = useRoute()

// 定义通用模块的 key 列表
const commonModuleKeys = [
  'experiment-teaching',    // 实验教学
  'experiment-resources',   // 实验资源
  'construction-results',   // 建设成效
  'safety-management'       // 安全管理
]

// 检查是否是通用模块页面
const isCommonModulePage = computed(() => {
  if (!props.showSidebar) return false
  
  // 检查是否是通用模块的动态路由路径
  const pathParts = route.path.split('/').filter(Boolean)
  if (pathParts.length >= 2 && pathParts[0] === 'dynamic') {
    const rootType = pathParts[1]
    return commonModuleKeys.includes(rootType)
  }
  
  // 检查是否是详情页，且 from 参数指向通用模块
  if (route.path.startsWith('/detail/')) {
    const from = route.query.from
    if (from && from !== 'popular-science' && from !== 'home') {
      const allRootTypes = Object.values(menuGroups).map(g => g.key)
      const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
      
      for (const rootType of sortedRootTypes) {
        if (from.startsWith(rootType + '-') && commonModuleKeys.includes(rootType)) {
          return true
        }
      }
    }
  }
  
  return false
})

// 检查是否有菜单数据（现在始终显示通用模块的所有菜单）
const hasMenuData = computed(() => {
  if (!props.showSidebar) return false
  
  // 如果是通用模块页面，始终显示侧边栏
  if (isCommonModulePage.value) {
    return true
  }
  
  // 对于其他页面，保持原有逻辑（如中心概况等可能有单独的菜单）
  let group = getMenuGroupByPath(route.path)
  
  if (!group && route.path.startsWith('/detail/')) {
    const from = route.query.from
    if (from) {
      if (from === 'popular-science' || from === 'home') {
        return false
      }
      
      const allRootTypes = Object.values(menuGroups).map(g => g.key)
      const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
      
      for (const rootType of sortedRootTypes) {
        if (from.startsWith(rootType + '-')) {
          group = menuGroups[rootType]
          if (group) break
        }
      }
    }
  }
  
  return group && group.items && group.items.length > 0
})

const shouldShowSidebar = computed(() => {
  return props.showSidebar && hasMenuData.value
})
</script>

<style scoped>
.page-layout {
  width: 100%;
  min-height: calc(100vh - 120px);
  background-color: #f5f7fa;
  padding: 20px 0;
}

.layout-container {
  max-width: 1600px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

.sidebar {
  flex-shrink: 0;
}

.content {
  flex: 1;
  min-width: 0;
  background-color: #fff;
  border-radius: 4px;
  padding: 20px;
}

.content.full-width {
  width: 100%;
  max-width: 100%;
}

/* 响应式 */
@media (max-width: 768px) {
  .layout-container {
    flex-direction: column;
    padding: 0 15px;
  }

  .content {
    padding: 15px;
  }
}
</style>

