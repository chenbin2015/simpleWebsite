<template>
 
    <el-container>
      <!-- 头部 -->
      <el-header class="app-header">
        <div class="header-content">
          <!-- Logo -->
          <div class="logo-section">
            <img 
              src="https://guanwang.makabaka.ltd/uploads/20250910/f803dcb1eedefdac8fcefa641a4d6020.png" 
              alt="Logo" 
              class="logo"
            />
          </div>
          
          <!-- 导航菜单 -->
          <div class="nav-section">
            <el-menu
              :default-active="activeMenu"
              mode="horizontal"
              class="nav-menu"
              @select="handleMenuSelect"
              style="width: 1000px;"
            >
              <el-menu-item 
                v-for="menu in topMenus" 
                :key="menu.name"
                :index="menu.name"
              >
                <template v-if="menu.children && menu.children.length > 0">
                  <el-sub-menu :index="menu.name">
                    <template #title>{{ menu.name }}</template>
                    <el-menu-item 
                      v-for="child in menu.children" 
                      :key="child.key"
                      :index="`${menu.name}-${child.key}`"
                    >
                      {{ child.name }}
                    </el-menu-item>
                  </el-sub-menu>
                </template>
                <template v-else>
                  {{ menu.name }}
                </template>
              </el-menu-item>
            </el-menu>
          </div>
          <div class="nav-space"></div>
        </div>
      </el-header>
      
      <!-- 主要内容区 -->
      <div class="app-main">
        <transition name="fade-slide" mode="out-in">
          <router-view />
        </transition>
      </div>
      
      <!-- 底部 -->
      <Footer />
    </el-container>
 
</template>

<script>
import Footer from './components/Footer.vue'
import { menuGroups as defaultMenuGroups, getDefaultRoutePath, getMenuKeyByPageType } from '@/config/menuConfig'
import { getPageTypeById, getCategoryKeyById } from '@/services/dataService'
import { getAllMenus } from '@/services/publicMenuApi'
import { convertBackendMenusToTopMenus, menuNameToRootType } from '@/utils/menuUtils'
import { ElMessage } from 'element-plus'

export default {
  name: 'App',
  components: {
    Footer
  },
  created() {
    console.log('=== App.vue created ===')
  },
  computed: {
    topMenus() {
      // 如果后端菜单已加载，使用后端菜单，否则使用默认菜单
      if (this.backendMenus && this.backendMenus.length > 0) {
        return convertBackendMenusToTopMenus(this.backendMenus)
      }
      
      // 回退到默认菜单
      const result = []
      this.menus.forEach(menuName => {
        if (menuName.trim() === '') return
        
        const rootType = menuNameToRootType[menuName]
        let children = []
        
        // 如果有对应的 rootType，从 defaultMenuGroups 获取子菜单
        if (rootType && defaultMenuGroups[rootType]) {
          children = defaultMenuGroups[rootType].items.map(item => ({
            key: item.key,
            name: item.name
          }))
        }
        
        result.push({
          name: menuName,
          path: this.menuRouteMap[menuName] || '',
          rootType: rootType,
          children: children
        })
      })
      
      return result
    },
    menuNameToRootType() {
      return menuNameToRootType
    }
  },
  data() {
    return {
      activeMenu: '首页',
      backendMenus: [], // 从后端加载的菜单数据
      menus: [
        '首页',
        '中心概况',
        '实验教学',
        '实验资源',
        '建设成效',
        '安全管理',
        '科普教育'
      ],
      // 菜单名称到路由路径的映射（仅用于一级菜单）
      menuRouteMap: {
        '首页': '/',
        '中心概况': '/center-overview',
        '科普教育': '/popular-science'
      }
    }
  },
  async mounted() {
    console.log('=== App.vue mounted ===')
    
    // 加载菜单数据
    await this.loadMenus()
    
    // 根据当前路由设置激活菜单
    await this.updateActiveMenu()
    
    // 监听路由变化
    this.$router.afterEach(async (to, from) => {
      console.log('=== 路由变化 ===', { to: to.path, from: from.path })
      await this.updateActiveMenu()
    })
    
    // 隐藏"更多"菜单按钮
    this.$nextTick(() => {
      const moreMenu = document.querySelector('.nav-menu .el-menu__more')
      if (moreMenu) {
        moreMenu.style.display = 'none'
      }
      
      // 隐藏所有包含"更多"文本的菜单项
      const menuItems = document.querySelectorAll('.nav-menu .el-sub-menu')
      menuItems.forEach(item => {
        const title = item.querySelector('.el-sub-menu__title')
        if (title && (title.textContent.includes('更多') || title.textContent.includes('...'))) {
          item.style.display = 'none'
        }
      })
      
      // 确保所有菜单项都显示
      const allMenuItems = document.querySelectorAll('.nav-menu .el-menu-item, .nav-menu .el-sub-menu')
      allMenuItems.forEach(item => {
        item.style.display = 'inline-block'
        item.style.visibility = 'visible'
      })
    })
  },
  methods: {
    async loadMenus() {
      try {
        const response = await getAllMenus()
        if (response.data && response.data.success && response.data.data) {
          this.backendMenus = response.data.data
        }
      } catch (error) {
        console.error('加载菜单失败:', error)
        ElMessage.warning('加载菜单失败，使用默认菜单')
        // 静默失败，使用默认菜单
      }
    },
    async updateActiveMenu() {
      console.log('=== updateActiveMenu 被调用 ===')
      console.log('当前路由:', this.$route.path)
      console.log('查询参数:', this.$route.query)
      const currentPath = this.$route.path
      
      // 检查一级菜单
      for (const [menuName, path] of Object.entries(this.menuRouteMap)) {
        if (path === currentPath) {
          this.activeMenu = menuName
          return
        }
      }
      
      // 检查是否是动态路由 /dynamic/:rootType/:type/:id
      const pathParts = currentPath.split('/').filter(p => p)
      console.log('pathParts:', pathParts, 'length:', pathParts.length)
      if (pathParts.length >= 4 && pathParts[0] === 'dynamic') {
        console.log('进入动态路由处理')
        const rootType = pathParts[1]
        const pageType = pathParts[2] // 这是 pageType（如 news-list, product-list 等）
        
          // 根据 rootType 和 pageType 找到对应的 menuKey
          // 需要从当前菜单数据中查找
          const topMenu = this.topMenus.find(m => m.rootType === rootType)
          if (topMenu && topMenu.children) {
            const childMenu = topMenu.children.find(c => c.pageType === pageType)
            if (childMenu) {
              this.activeMenu = `${topMenu.name}-${childMenu.key}`
              return
            }
          }
          
          // 回退到使用默认菜单组查找
          const menuKey = getMenuKeyByPageType(rootType, pageType)
          if (menuKey) {
            // 根据 rootType 找到对应的菜单名称
            for (const [menuName, rt] of Object.entries(menuNameToRootType)) {
              if (rt === rootType) {
                // 使用 menuKey 来设置 activeMenu
                this.activeMenu = `${menuName}-${menuKey}`
                return
              }
            }
          }
      }
      
      // 检查是否是通用列表页路由 /common-list
      if (currentPath === '/common-list') {
        console.log('✓ 进入通用列表页路由处理逻辑')
        const from = this.$route.query.from
        console.log('from 参数:', from)
        if (from) {
          if (from === 'popular-science') {
            console.log('设置菜单为: 科普教育')
            this.activeMenu = '科普教育'
            return
          }
          
          if (from === 'home') {
            console.log('设置菜单为: 首页')
            this.activeMenu = '首页'
            return
          }
          
          // 如果是 rootType-id 格式，解析并设置菜单
          const allRootTypes = Object.values(menuNameToRootType)
          const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
          
          for (const rootType of sortedRootTypes) {
            if (from.startsWith(rootType + '-')) {
              for (const [menuName, rt] of Object.entries(menuNameToRootType)) {
                if (rt === rootType) {
                  // 对于通用列表页，只高亮一级菜单
                  this.activeMenu = menuName
                  console.log('设置菜单为:', menuName)
                  return
                }
              }
            }
          }
        }
        // 如果没有 from 参数或无法匹配，默认设置为首页
        this.activeMenu = '首页'
        return
      }
      
      // 检查是否是详情页路由 /detail/:type/:id
      console.log('检查详情页路由，pathParts.length:', pathParts.length, 'pathParts[0]:', pathParts[0])
      console.log('条件判断:', pathParts.length >= 3, pathParts[0] === 'detail')
      if (pathParts.length >= 3 && pathParts[0] === 'detail') {
        console.log('✓ 进入详情页路由处理逻辑')
        // 从查询参数中获取 from
        const from = this.$route.query.from
        console.log('from 参数:', from, 'type:', typeof from)
        if (from) {
          console.log('from 存在，继续处理')
          // from 格式可能是 "rootType-id" 或 "popular-science" 或 "home"
          if (from === 'popular-science') {
            console.log('设置菜单为: 科普教育')
            this.activeMenu = '科普教育'
            return
          }
          
          if (from === 'home') {
            console.log('设置菜单为: 首页')
            this.activeMenu = '首页'
            return
          }
          
          console.log('from 不是特殊值，开始解析 fromParts')
          // 解析 from 参数：格式为 "rootType-id"
          // 由于 rootType 可能包含 "-"（如 experiment-teaching），需要从所有可能的 rootType 中匹配
          // 从路由参数获取 id（更准确）
          const routeId = pathParts[2] // /detail/:type/:id 中的 id
          console.log('路由中的 id:', routeId)
          
          // 尝试从 from 中匹配 rootType
          // 方法：遍历所有可能的 rootType，找到最长的匹配
          let matchedRootType = null
          let matchedMenuName = null
          const allRootTypes = Object.values(menuNameToRootType)
          
          // 按长度从长到短排序，优先匹配更长的 rootType
          const sortedRootTypes = allRootTypes.sort((a, b) => b.length - a.length)
          
          console.log('所有可能的 rootType:', sortedRootTypes)
          for (const rootType of sortedRootTypes) {
            // 检查 from 是否以 rootType 开头
            if (from.startsWith(rootType + '-')) {
              matchedRootType = rootType
              // 找到对应的菜单名称
              for (const [menuName, rt] of Object.entries(menuNameToRootType)) {
                if (rt === rootType) {
                  matchedMenuName = menuName
                  break
                }
              }
              console.log('✓ 匹配到 rootType:', rootType, '菜单名称:', matchedMenuName)
              break
            }
          }
          
          if (matchedRootType && matchedMenuName) {
            const actualId = routeId || from.substring(matchedRootType.length + 1) // 去掉 rootType- 前缀
            console.log('实际使用的 id:', actualId)
            console.log('调用 findPageTypeAndSetMenu')
            // 异步查找 pageType 并设置菜单，等待完成
            await this.findPageTypeAndSetMenu(actualId, matchedRootType, matchedMenuName)
            console.log('findPageTypeAndSetMenu 完成，activeMenu:', this.activeMenu)
            return
          } else {
            console.warn('未找到匹配的 rootType，from:', from)
          }
        }
      }
      
      // 如果没找到，默认设置为首页
      this.activeMenu = '首页'
    },
    async findPageTypeAndSetMenu(id, rootType, menuName) {
      console.log('=== findPageTypeAndSetMenu 被调用 ===')
      console.log('参数:', { id, rootType, menuName })
      try {
        // 根据 id 查找 pageType
        console.log('开始查找 pageType，id:', id)
        const pageType = await getPageTypeById(id)
        console.log('找到 pageType:', pageType)
        if (pageType) {
          // 根据 id 查找 categoryKey（数据分类的 key，对应菜单项的 defaultId）
          console.log('开始查找 categoryKey，id:', id)
          const categoryKey = await getCategoryKeyById(id)
          console.log('找到 categoryKey:', categoryKey)
          
          // 从当前菜单数据中查找
          const topMenu = this.topMenus.find(m => m.rootType === rootType)
          let menuKey = null
          
          if (topMenu && topMenu.children) {
            // 优先通过ID查找（categoryKey对应菜单ID）
            if (categoryKey) {
              const childMenu = topMenu.children.find(c => String(c.id) === categoryKey)
              if (childMenu) {
                menuKey = childMenu.key
                console.log('通过 categoryKey 找到 menuKey:', menuKey)
              }
            }
            
            // 如果通过ID没找到，使用pageType查找
            if (!menuKey) {
              const childMenu = topMenu.children.find(c => c.pageType === pageType)
              if (childMenu) {
                menuKey = childMenu.key
                console.log('通过 pageType 找到 menuKey:', menuKey)
              }
            }
          }
          
          // 如果还是没找到，回退到使用默认菜单组
          if (!menuKey) {
            console.log('通过后端菜单未找到，使用默认菜单组查找')
            menuKey = getMenuKeyByPageType(rootType, pageType)
            console.log('通过默认菜单组找到 menuKey:', menuKey)
          }
          
          if (menuKey) {
            const activeMenuValue = `${menuName}-${menuKey}`
            console.log('设置 activeMenu 为:', activeMenuValue)
            this.activeMenu = activeMenuValue
            return
          } else {
            console.warn('未找到 menuKey，rootType:', rootType, 'pageType:', pageType, 'categoryKey:', categoryKey)
          }
        } else {
          console.warn('未找到 pageType，id:', id)
        }
        
        // 如果找不到 pageType 或 menuKey，设置为第一个子菜单
        console.log('回退到第一个子菜单')
        const topMenu = this.topMenus.find(m => m.rootType === rootType)
        if (topMenu && topMenu.children && topMenu.children.length > 0) {
          this.activeMenu = `${menuName}-${topMenu.children[0].key}`
        } else {
          // 回退到默认菜单组
          const menuGroup = defaultMenuGroups[rootType]
          if (menuGroup && menuGroup.items && menuGroup.items.length > 0) {
            this.activeMenu = `${menuName}-${menuGroup.items[0].key}`
          } else {
            this.activeMenu = menuName
          }
        }
      } catch (err) {
        console.error('Failed to find pageType and set menu:', err)
        // 出错时设置为第一个子菜单
        const topMenu = this.topMenus.find(m => m.rootType === rootType)
        if (topMenu && topMenu.children && topMenu.children.length > 0) {
          this.activeMenu = `${menuName}-${topMenu.children[0].key}`
        } else {
          const menuGroup = defaultMenuGroups[rootType]
          if (menuGroup && menuGroup.items && menuGroup.items.length > 0) {
            this.activeMenu = `${menuName}-${menuGroup.items[0].key}`
          } else {
            this.activeMenu = menuName
          }
        }
      }
    },
    handleMenuSelect(index) {
      // index 可能是 "菜单名" 或 "父菜单-子菜单key" 格式
      if (index.includes('-')) {
        // 如果是子菜单，格式是 "父菜单-子菜单key"
        const firstDashIndex = index.indexOf('-')
        if (firstDashIndex !== -1) {
          const parentMenu = index.substring(0, firstDashIndex)
          const childKey = index.substring(firstDashIndex + 1) // 这是 menuKey
          
          // 从当前菜单数据中查找
          const menuItem = this.topMenus.find(menu => menu.name === parentMenu)
          if (menuItem && menuItem.children) {
            const childMenu = menuItem.children.find(c => c.key === childKey)
            if (childMenu && menuItem.rootType) {
              // 构建路由路径：/dynamic/:rootType/:pageType/:id
              const routePath = `/dynamic/${menuItem.rootType}/${childMenu.pageType}/${childMenu.id}`
              this.$router.push(routePath)
              this.activeMenu = index
              return
            }
          }
          
          // 回退到使用默认菜单组
          const rootType = menuNameToRootType[parentMenu]
          if (rootType) {
            const routePath = getDefaultRoutePath(rootType, childKey)
            this.$router.push(routePath)
            this.activeMenu = index
            return
          }
        }
      }
      
      // 一级菜单跳转
      // 先检查是否有子菜单
      const menuItem = this.topMenus.find(menu => menu.name === index)
      if (menuItem && menuItem.children && menuItem.children.length > 0) {
        // 如果有子菜单，跳转到第一个子菜单
        const rootType = menuItem.rootType
        const firstChild = menuItem.children[0]
        if (rootType && firstChild) {
          const routePath = `/dynamic/${rootType}/${firstChild.pageType}/${firstChild.id}`
          this.$router.push(routePath)
          this.activeMenu = `${index}-${firstChild.key}`
          return
        }
      }
      
      // 没有子菜单的一级菜单跳转
      const routePath = this.menuRouteMap[index]
      if (routePath) {
        this.$router.push(routePath)
        this.activeMenu = index
      }
    }
  }
}
</script>

<style>
#app {
  width: 100%;
  min-height: 100vh;
}

.app-header {
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  padding: 0;
  padding-bottom: 10px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  height: 80px !important;
  position: relative;

}

.header-content {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo-section {
  display: flex;
  align-items: center;
  margin-right: 40px;
  margin-top: 10px;
  width:200px;
}

.logo {
  height: 60px;
  width: auto;
}

.nav-section {
  display: flex;
  justify-content: flex-start;
 
  overflow: visible;
 
}
.nav-space {
  width: 200px;
}

.nav-section .el-menu {
  flex-wrap: nowrap;
  overflow: visible;
  width: 100%;
}

.nav-menu {
  border: none !important;
  border-bottom: none !important;
  background: transparent;
  overflow: visible !important;
  transform: scale(1);
  /* 或使用 zoom 属性 */
  zoom: 1;
  transform-origin: 0 0;
}

/* 完全隐藏菜单的省略号按钮和"更多"菜单 */
.nav-menu .el-menu__more,
.nav-menu .el-submenu__title[aria-expanded="false"] + .el-menu--popup,
.nav-menu .el-menu--popup {
  display: none !important;
}

/* 强制显示所有菜单项，防止被折叠 */
.nav-menu.el-menu--horizontal {
  overflow: visible !important;
  white-space: nowrap !important;
}

.nav-menu.el-menu--horizontal .el-menu-item,
.nav-menu.el-menu--horizontal .el-sub-menu {
  display: inline-block !important;
  visibility: visible !important;
  opacity: 1 !important;
  white-space: nowrap;
  flex-shrink: 0;
}

/* 隐藏可能的折叠按钮和"更多"菜单 */
.nav-menu .el-menu__collapse,
.nav-menu .el-menu__more-btn,
.nav-menu .el-submenu[role="menuitem"]:last-child .el-submenu__title::after {
  display: none !important;
}

/* 隐藏包含"更多"文本的菜单项 */
.nav-menu .el-sub-menu:has(.el-sub-menu__title:contains("更多")),
.nav-menu .el-sub-menu:has(.el-sub-menu__title:contains("...")) {
  display: none !important;
}

/* 使用属性选择器隐藏可能的"更多"菜单 */
.nav-menu .el-sub-menu[aria-label*="更多"],
.nav-menu .el-sub-menu[aria-label*="more"] {
  display: none !important;
}

/* 确保所有菜单项都显示，包括最后一个 */
.nav-menu.el-menu--horizontal > .el-menu-item:last-child,
.nav-menu.el-menu--horizontal > .el-sub-menu:last-child {
  display: inline-block !important;
  visibility: visible !important;
}

/* 防止菜单项被隐藏 */
.nav-menu.el-menu--horizontal .el-menu-item,
.nav-menu.el-menu--horizontal .el-sub-menu {
  max-width: none !important;
}

.nav-menu .el-menu-item,
.nav-menu .el-sub-menu__title {
  height: 80px;
  line-height: 80px;
  padding: 0 15px !important;
  font-size: 22px;
  color: #fff;
  border-bottom: none !important;
  flex-shrink: 0;
}

.nav-menu .el-menu-item:hover,
.nav-menu .el-sub-menu__title:hover {
  background-color: transparent !important;
  color: #D4AF37;
}

.nav-menu .el-menu-item.is-active {
  color: #D4AF37 !important;
  border-bottom: none !important;
  background-color: transparent !important;
  position: relative;
}

.nav-menu .el-menu-item.is-active::after {
  content: '';
  position: absolute;
  bottom: 10px;
  left: 15px;
  right: 15px;
  height: 3px;
  background: #D4AF37;
}

.nav-menu .el-sub-menu.is-active .el-sub-menu__title {
  color: #D4AF37 !important;
  border-bottom: none !important;
  position: relative;
}

.nav-menu .el-sub-menu.is-active .el-sub-menu__title::after {
  content: '';
  position: absolute;
  bottom: 10px;
  left: 15px;
  right: 15px;
  height: 3px;
  background: #D4AF37;
}

.app-main {
  flex: 1;
  background: #f5f7fa;
  min-height: calc(100vh - 120px);
  position: relative;
  overflow: hidden;
}

/* 路由切换过渡效果：淡入淡出 + 轻微滑动 */
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease-in-out;
}

.fade-slide-enter-from {
  opacity: 0;
  transform: translateX(20px);
}

.fade-slide-enter-to {
  opacity: 1;
  transform: translateX(0);
}

.fade-slide-leave-from {
  opacity: 1;
  transform: translateX(0);
}

.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}

</style>
