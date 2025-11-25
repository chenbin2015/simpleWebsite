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

// 检查是否有菜单数据
const hasMenuData = computed(() => {
  if (!props.showSidebar) return false
  
  // 先尝试从路径获取（适用于 /dynamic/... 路径）
  let group = getMenuGroupByPath(route.path)
  
  // 如果是详情页路径，从查询参数 from 中获取 rootType
  if (!group && route.path.startsWith('/detail/')) {
    const from = route.query.from
    if (from) {
      // from 格式可能是 "rootType-id" 或 "popular-science" 或 "home"
      if (from === 'popular-science' || from === 'home') {
        return false // 这些页面没有 sidebar
      }
      
      // 从 from 中提取 rootType
      // 遍历所有可能的 rootType，找到最长的匹配
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
  
  // 检查菜单组是否有数据
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

