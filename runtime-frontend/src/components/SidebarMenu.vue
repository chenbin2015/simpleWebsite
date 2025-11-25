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
          <!-- 调试信息 -->
          <div v-if="false" style="padding: 10px; font-size: 12px; color: #666;">
            <p>activePath: {{ activePath }}</p>
            <p>activeMenuPath: {{ activeMenuPath }}</p>
            <p>route.path: {{ route.path }}</p>
            <p>menuGroup: {{ menuGroup?.title }}</p>
          </div>
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
  import { computed, ref, watch } from 'vue'
  import { useRoute } from 'vue-router'
import { getMenuGroupByPath, generateRoutePath, menuGroups, getMenuKeyByPageType } from '@/config/menuConfig'
import { getPageTypeById, getCategoryKeyById } from '@/services/dataService'
  import * as ElementPlusIconsVue from '@element-plus/icons-vue'
  
  const route = useRoute()
  const activeMenuPath = ref(route.path)
  
  console.log('SidebarMenu - 初始 activeMenuPath:', activeMenuPath.value)
  console.log('SidebarMenu - 当前路由:', route.path, '查询参数:', route.query)
  
  // 计算 activePath：如果是详情页，需要转换为对应的动态路由路径
  const activePath = computed(() => {
    // 如果是详情页，需要根据 from 参数和 id 生成对应的动态路由路径
    if (route.path.startsWith('/detail/')) {
      console.log('SidebarMenu - 详情页，使用 activeMenuPath:', activeMenuPath.value)
      return activeMenuPath.value
    }
    console.log('SidebarMenu - 非详情页，使用 route.path:', route.path)
    return route.path
  })
  
  // 监听路由变化，更新 activeMenuPath
  watch(() => [route.path, route.query], async ([path, query]) => {
    console.log('SidebarMenu - 路由变化:', { path, query })
    if (path.startsWith('/detail/')) {
      const from = query.from
      console.log('SidebarMenu - 详情页，from:', from)
      if (from && from !== 'popular-science' && from !== 'home') {
        // 从 from 中提取 rootType
        const allRootTypes = Object.values(menuGroups).map(g => g.key)
        const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
        console.log('SidebarMenu - 所有 rootType:', sortedRootTypes)
        
        let matchedRootType = null
        for (const rootType of sortedRootTypes) {
          if (from.startsWith(rootType + '-')) {
            matchedRootType = rootType
            console.log('SidebarMenu - 匹配到 rootType:', rootType)
            break
          }
        }
        
        if (matchedRootType) {
          // 从路径中获取 id
          const pathParts = path.split('/').filter(p => p)
          const id = pathParts[2] // /detail/:type/:id 中的 id
          console.log('SidebarMenu - 提取的 id:', id)
          
          // 根据 id 查找 pageType
          console.log('SidebarMenu - 开始查找 pageType')
          const pageType = await getPageTypeById(id)
          console.log('SidebarMenu - 找到 pageType:', pageType)
          if (pageType) {
            // 根据 id 查找 categoryKey（数据分类的 key，对应菜单项的 defaultId）
            console.log('SidebarMenu - 开始查找 categoryKey')
            const categoryKey = await getCategoryKeyById(id)
            console.log('SidebarMenu - 找到 categoryKey:', categoryKey)
            
            // 找到对应的菜单项
            const group = menuGroups[matchedRootType]
            if (group) {
              let menuItem = null
              
              // 优先通过 categoryKey（对应 defaultId）查找菜单项
              if (categoryKey) {
                menuItem = group.items.find(item => item.defaultId === categoryKey)
                console.log('SidebarMenu - 通过 categoryKey 查找菜单项:', menuItem ? menuItem.name : '未找到')
              }
              
              // 如果没找到，回退到使用 pageType 查找（取第一个匹配的）
              if (!menuItem) {
                menuItem = group.items.find(item => item.pageType === pageType)
                console.log('SidebarMenu - 通过 pageType 查找菜单项:', menuItem ? menuItem.name : '未找到')
              }
              
              if (menuItem) {
                // 使用菜单项的 defaultId 来生成路径，这样才能匹配到菜单项
                const dynamicPath = generateRoutePath(matchedRootType, pageType, menuItem.defaultId)
                console.log('SidebarMenu - 生成的动态路径（使用 defaultId）:', dynamicPath, 'defaultId:', menuItem.defaultId, 'menuItem:', menuItem.name)
                activeMenuPath.value = dynamicPath
                console.log('SidebarMenu - 更新 activeMenuPath 为:', activeMenuPath.value)
              } else {
                console.warn('SidebarMenu - 未找到对应的菜单项')
              }
            } else {
              console.warn('SidebarMenu - 未找到菜单组')
            }
          } else {
            console.warn('SidebarMenu - 未找到 pageType')
          }
        } else {
          console.warn('SidebarMenu - 未匹配到 rootType')
        }
      }
    } else {
      console.log('SidebarMenu - 非详情页，直接使用 path')
      activeMenuPath.value = path
    }
  }, { immediate: true })
  
  const menuGroup = computed(() => {
    // 先尝试从路径获取（适用于 /dynamic/... 路径）
    let group = getMenuGroupByPath(route.path)
    
    // 如果是详情页路径，从查询参数 from 中获取 rootType
    if (!group && route.path.startsWith('/detail/')) {
      const from = route.query.from
      if (from) {
        // from 格式可能是 "rootType-id" 或 "popular-science" 或 "home"
        if (from === 'popular-science' || from === 'home') {
          return null // 这些页面没有 sidebar
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
    
    return group
  })
  
  // 获取菜单项路径
  const getMenuItemPath = (item) => {
    const category = menuGroup.value?.key
    if (!category) {
      console.log('SidebarMenu - getMenuItemPath: 没有 category')
      return '/'
    }
    const path = generateRoutePath(category, item.pageType, item.defaultId)
    console.log('SidebarMenu - getMenuItemPath:', { item: item.name, category, pageType: item.pageType, defaultId: item.defaultId, path })
    return path
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
  
  