<template>
  <div class="sidebar-menu">
    <el-card class="menu-card">
      <template #header>
        <div class="menu-header">
          <h3>{{ menuGroup?.title }}</h3>
        </div>
      </template>
      <el-menu
        :default-active="activePath"
        class="vertical-menu"
        :router="true"
      >
        <el-menu-item
          v-for="item in menuGroup?.items"
          :key="item.key"
          :index="getMenuItemPath(item)"
        >
          <el-icon v-if="item.icon">
            <component :is="getIconComponent(item.icon)" />
          </el-icon>
          <span>{{ item.name }}</span>
        </el-menu-item>
      </el-menu>
    </el-card>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { getMenuGroupByPath, generateRoutePath } from '@/config/menuConfig'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

const route = useRoute()

const activePath = computed(() => route.path)

const menuGroup = computed(() => {
  return getMenuGroupByPath(route.path)
})

// 获取菜单项路径
const getMenuItemPath = (item) => {
  const category = menuGroup.value?.key
  if (!category) return '/'
  return generateRoutePath(category, item.pageType, item.defaultId)
}

// 获取图标组件
const getIconComponent = (iconName) => {
  return ElementPlusIconsVue[iconName] || ElementPlusIconsVue['Document']
}
</script>

<style scoped>
.sidebar-menu {
  width: 250px;
  flex-shrink: 0;
}

.menu-card {
  position: sticky;
  top: 20px;
}

.menu-header {
  padding: 0;
}

.menu-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.vertical-menu {
  border-right: none;
}

.vertical-menu :deep(.el-menu-item) {
  height: 50px;
  line-height: 50px;
  margin-bottom: 5px;
  border-radius: 4px;
}

.vertical-menu :deep(.el-menu-item:hover) {
  background-color: #ecf5ff;
}

.vertical-menu :deep(.el-menu-item.is-active) {
  background-color: #409eff;
  color: white;
}

.vertical-menu :deep(.el-menu-item.is-active .el-icon) {
  color: white;
}

.vertical-menu :deep(.el-icon) {
  margin-right: 8px;
  font-size: 18px;
}

/* 响应式 */
@media (max-width: 768px) {
  .sidebar-menu {
    width: 100%;
    margin-bottom: 20px;
  }

  .menu-card {
    position: static;
  }
}
</style>

