<template>
    <div class="sidebar-menu">
      <el-card class="menu-card" v-if="currentGroup">
        <template #header>
          <div class="menu-header">
            <h3>{{ currentGroup.title }}</h3>
          </div>
        </template>
        <el-menu
          :default-active="activePath"
          class="vertical-menu"
          :router="true"
        >
          <!-- 只显示当前根节点下的菜单项 -->
          <el-menu-item
            v-for="item in currentGroup.items"
            :key="item.key"
            :index="getMenuItemPath(currentGroup.key, item)"
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
  import { computed, ref, watch, onMounted } from 'vue'
  import { useRoute } from 'vue-router'
  import { getMenuGroupByPath, generateRoutePath, menuGroups as defaultMenuGroups, getMenuKeyByPageType } from '@/config/menuConfig'
  import { getPageTypeById, getCategoryKeyById } from '@/services/dataService'
  import { getAllMenus } from '@/services/publicMenuApi'
  import { convertBackendMenusToMenuGroups } from '@/utils/menuUtils'
  import { ElMessage } from 'element-plus'
  import * as ElementPlusIconsVue from '@element-plus/icons-vue'
  
  const route = useRoute()
  const activeMenuPath = ref(route.path)
  const openedKeys = ref([])
  
  // 动态菜单组（从后端加载）
  const dynamicMenuGroups = ref({})
  const menuGroups = computed(() => {
    // 如果后端菜单已加载，使用后端菜单，否则使用默认菜单
    return Object.keys(dynamicMenuGroups.value).length > 0 
      ? dynamicMenuGroups.value 
      : defaultMenuGroups
  })
  
  // 定义通用模块的 key 列表（用于判断是否是通用模块）
  const commonModuleKeys = [
    'experiment-teaching',    // 实验教学
    'experiment-resources',   // 实验资源
    'construction-results',   // 建设成效
    'safety-management'       // 安全管理
  ]
  
  // 获取当前根节点对应的菜单组
  const currentGroup = computed(() => {
    // 从路由路径获取当前根节点
    let group = null
    
    // 先从动态菜单中查找
    if (route.path.startsWith('/dynamic/')) {
      const pathParts = route.path.split('/').filter(Boolean)
      if (pathParts.length >= 2 && pathParts[0] === 'dynamic') {
        const rootType = pathParts[1]
        group = menuGroups.value[rootType] || null
      }
    } else if (route.path.startsWith('/detail/')) {
      group = getCurrentGroupFromDetail()
    }
    
    // 只返回通用模块的菜单组
    if (group && commonModuleKeys.includes(group.key)) {
      return group
    }
    
    return null
  })
  
  // 加载菜单数据
  const loadMenus = async () => {
    try {
      const response = await getAllMenus()
      if (response.data && response.data.success && response.data.data) {
        const converted = convertBackendMenusToMenuGroups(response.data.data)
        dynamicMenuGroups.value = converted
      }
    } catch (error) {
      console.error('加载菜单失败:', error)
      // 静默失败，使用默认菜单
      ElMessage.warning('加载菜单失败，使用默认菜单')
    }
  }
  
  onMounted(() => {
    loadMenus()
  })
  
  
  // 从详情页获取当前菜单组
  function getCurrentGroupFromDetail() {
    const from = route.query.from
    if (!from || from === 'popular-science' || from === 'home') {
      return null
    }
    
    const allRootTypes = Object.values(menuGroups.value).map(g => g.key)
    const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
    
    for (const rootType of sortedRootTypes) {
      if (from.startsWith(rootType + '-')) {
        return menuGroups.value[rootType] || null
      }
    }
    
    return null
  }
  
  // 计算 activePath：如果是详情页，需要转换为对应的动态路由路径
  const activePath = computed(() => {
    // 如果是详情页，需要根据 from 参数和 id 生成对应的动态路由路径
    if (route.path.startsWith('/detail/')) {
      return activeMenuPath.value
    }
    return route.path
  })
  
  // 监听路由变化，更新 activeMenuPath
  watch(() => [route.path, route.query], async ([path, query]) => {
    if (path.startsWith('/detail/')) {
      const from = query.from
      if (from && from !== 'popular-science' && from !== 'home') {
        // 从 from 中提取 rootType
        const allRootTypes = Object.values(menuGroups.value).map(g => g.key)
        const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
        
        let matchedRootType = null
        for (const rootType of sortedRootTypes) {
          if (from.startsWith(rootType + '-')) {
            matchedRootType = rootType
            break
          }
        }
        
        if (matchedRootType) {
          // 从路径中获取 id
          const pathParts = path.split('/').filter(p => p)
          const id = pathParts[2] // /detail/:type/:id 中的 id
          
          // 根据 id 查找 pageType
          const pageType = await getPageTypeById(id)
          if (pageType) {
            // 根据 id 查找 categoryKey（数据分类的 key，对应菜单项的 defaultId）
            const categoryKey = await getCategoryKeyById(id)
            
            // 找到对应的菜单项
            const group = menuGroups.value[matchedRootType]
            if (group) {
              let menuItem = null
              
              // 优先通过 categoryKey（对应 defaultId）查找菜单项
              if (categoryKey) {
                menuItem = group.items.find(item => item.defaultId === categoryKey)
              }
              
              // 如果没找到，回退到使用 pageType 查找（取第一个匹配的）
              if (!menuItem) {
                menuItem = group.items.find(item => item.pageType === pageType)
              }
              
              if (menuItem) {
                // 使用菜单项的 defaultId 来生成路径，这样才能匹配到菜单项
                const dynamicPath = generateRoutePath(matchedRootType, pageType, menuItem.defaultId)
                activeMenuPath.value = dynamicPath
              }
            }
          }
        }
      }
    } else {
      activeMenuPath.value = path
    }
  }, { immediate: true })
  
  // 获取菜单项路径
  const getMenuItemPath = (rootType, item) => {
    if (!rootType) {
      return '/'
    }
    return generateRoutePath(rootType, item.pageType, item.defaultId)
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
  
  /* 菜单项样式 */
  .vertical-menu :deep(.el-menu-item) {
    height: 45px;
    line-height: 45px;
    padding-left: 20px !important;
    border-radius: 4px;
    margin: 2px 0;
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
  
  