<template>
    <div class="sidebar-menu">
      <el-card class="menu-card">
        <template #header>
          <div class="menu-header">
            <h3>通用模块</h3>
          </div>
        </template>
        <el-menu
          :default-active="activePath"
          class="vertical-menu"
          :router="true"
          :default-openeds="defaultOpenedKeys"
          @open="handleSubMenuOpen"
          @close="handleSubMenuClose"
        >
          <!-- 显示所有四个通用模块作为二级菜单 -->
          <el-sub-menu
            v-for="group in commonModuleGroups"
            :key="group.key"
            :index="group.key"
          >
            <template #title>
              <span>{{ group.title }}</span>
            </template>
            <el-menu-item
              v-for="item in group.items"
              :key="item.key"
              :index="getMenuItemPath(group.key, item)"
            >
              <el-icon v-if="item.icon">
                <component :is="getIconComponent(item.icon)" />
              </el-icon>
              <span>{{ item.name }}</span>
            </el-menu-item>
          </el-sub-menu>
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
  
  // 定义通用模块的 key 列表（按照显示顺序）
  const commonModuleKeys = [
    'experiment-teaching',    // 实验教学
    'experiment-resources',   // 实验资源
    'construction-results',   // 建设成效
    'safety-management'       // 安全管理
  ]
  
  // 获取所有通用模块组
  const commonModuleGroups = computed(() => {
    return commonModuleKeys
      .map(key => menuGroups.value[key])
      .filter(group => group !== undefined)
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
  
  // 默认展开当前激活的菜单组
  const defaultOpenedKeys = computed(() => {
    return openedKeys.value
  })
  
  // 处理子菜单展开
  const handleSubMenuOpen = (key) => {
    if (!openedKeys.value.includes(key)) {
      openedKeys.value.push(key)
    }
  }
  
  // 处理子菜单关闭
  const handleSubMenuClose = (key) => {
    const index = openedKeys.value.indexOf(key)
    if (index > -1) {
      openedKeys.value.splice(index, 1)
    }
  }
  
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
  
  // 更新展开的菜单组
  const updateOpenedKeys = () => {
    const currentGroup = getMenuGroupByPath(route.path) || 
      (route.path.startsWith('/detail/') ? getCurrentGroupFromDetail() : null)
    
    if (currentGroup && commonModuleKeys.includes(currentGroup.key)) {
      if (!openedKeys.value.includes(currentGroup.key)) {
        openedKeys.value = [currentGroup.key]
      }
      return
    }
    
    // 如果是详情页，尝试从查询参数中获取
    if (route.path.startsWith('/detail/')) {
      const from = route.query.from
      if (from && from !== 'popular-science' && from !== 'home') {
        const allRootTypes = Object.values(menuGroups.value).map(g => g.key)
        const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
        
        for (const rootType of sortedRootTypes) {
          if (from.startsWith(rootType + '-') && commonModuleKeys.includes(rootType)) {
            if (!openedKeys.value.includes(rootType)) {
              openedKeys.value = [rootType]
            }
            return
          }
        }
      }
    }
  }
  
  // 监听路由变化，更新 activeMenuPath 和展开的菜单组
  watch(() => [route.path, route.query], async ([path, query]) => {
    // 更新展开的菜单组
    updateOpenedKeys()
    
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
  
  // 初始化时更新展开的菜单组
  updateOpenedKeys()
  
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
  
  /* 父菜单（二级菜单标题）样式 */
  .vertical-menu :deep(.el-sub-menu) {
    margin-bottom: 5px;
  }
  
  .vertical-menu :deep(.el-sub-menu__title) {
    height: 50px;
    line-height: 50px;
    border-radius: 4px;
    font-size: 15px;
    font-weight: 500;
    color: #303133;
  }
  
  .vertical-menu :deep(.el-sub-menu__title:hover) {
    background-color: #ecf5ff;
    color: #409eff;
  }
  
  /* 父菜单展开时的样式 */
  .vertical-menu :deep(.el-sub-menu.is-opened > .el-sub-menu__title) {
    color: #409eff;
  }
  
  /* 子菜单项样式 */
  .vertical-menu :deep(.el-menu-item) {
    height: 45px;
    line-height: 45px;
    padding-left: 50px !important;
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
  
  