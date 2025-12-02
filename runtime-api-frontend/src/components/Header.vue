<template>
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
                      :key="child.name"
                      :index="`${menu.name}-${child.name}`"
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
        </div>
      </el-header>
</template>

<script>
export default {
  name: 'Header',
  data() {
    return {
      activeMenu: '首页',
      menus: [
        '首页',
        '中心概况',
        '实验教学',
        '--课程体系',
        '--实验课程',
        '实验资源',
        '--实验仪器',
        '--实验空间',
        '--开放共享',
        '建设成效',
        '--实验教学改革',
        '--科研创新成果',
        '--实验环境与能力',
        '安全管理',
        '--安全教育',
        '--安全准入',
        '--管理制度',
        '科普教育'
      ],
      // 菜单名称到路由路径的映射
      menuRouteMap: {
        '首页': '/',
        '中心概况': '/center-overview',
        '实验教学': '/experimental-teaching',
        '课程体系': '/course-system',
        '实验课程': '/experimental-course',
        '实验资源': '/experimental-resources',
        '实验仪器': '/experimental-instruments',
        '实验空间': '/experimental-space',
        '开放共享': '/open-sharing',
        '建设成效': '/construction-results',
        '实验教学改革': '/teaching-reform',
        '科研创新成果': '/research-innovation',
        '实验环境与能力': '/experimental-environment',
        '安全管理': '/safety-management',
        '安全教育': '/safety-education',
        '安全准入': '/safety-access',
        '管理制度': '/management-system',
        '科普教育': '/science-education'
      }
    }
  },
  computed: {
    topMenus() {
      const result = []
      let currentTopMenu = null
      
      this.menus.forEach(menu => {
        if (menu.trim() === '') return
        
        if (menu.startsWith('--')) {
          // 二级菜单
          const childName = menu.substring(2).trim()
          if (currentTopMenu) {
            if (!currentTopMenu.children) {
              currentTopMenu.children = []
            }
            currentTopMenu.children.push({ 
              name: childName,
              path: this.menuRouteMap[childName] || ''
            })
          }
        } else {
          // 一级菜单
          if (currentTopMenu) {
            result.push(currentTopMenu)
          }
          const menuName = menu.trim()
          currentTopMenu = { 
            name: menuName,
            path: this.menuRouteMap[menuName] || ''
          }
        }
      })
      
      // 添加最后一个菜单
      if (currentTopMenu) {
        result.push(currentTopMenu)
      }
      
      return result
    }
  },
  mounted() {
    // 根据当前路由设置激活菜单
    this.updateActiveMenu()
    
    // 监听路由变化
    this.$router.afterEach(() => {
      this.updateActiveMenu()
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
    updateActiveMenu() {
      const currentPath = this.$route.path
      // 根据路径找到对应的菜单名称
      for (const [menuName, path] of Object.entries(this.menuRouteMap)) {
        if (path === currentPath) {
          this.activeMenu = menuName
          return
        }
      }
      // 如果没找到，默认设置为首页
      this.activeMenu = '首页'
    },
    handleMenuSelect(index) {
      // index 可能是 "菜单名" 或 "父菜单-子菜单" 格式
      let menuName = index
      if (index.includes('-')) {
        // 如果是子菜单，格式是 "父菜单-子菜单"，需要提取子菜单名称
        // 例如: "实验教学-课程体系" -> "课程体系"
        // 从第一个 "-" 之后开始取，因为子菜单名称可能也包含 "-"
        const firstDashIndex = index.indexOf('-')
        if (firstDashIndex !== -1) {
          menuName = index.substring(firstDashIndex + 1)
        }
      }
      
      const routePath = this.menuRouteMap[menuName]
      if (routePath) {
        this.$router.push(routePath)
        this.activeMenu = menuName
      }
    },
    handleMenuClick(routePath, menuName) {
      if (routePath) {
        this.$router.push(routePath)
        this.activeMenu = menuName
      }
    }
  }
}
</script>

<style scoped>

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
  display: flex;
  align-items: center;
  justify-content: flex-start;
  padding: 0 40px;
}

.logo-section {
  display: flex;
  align-items: center;
  margin-right: 40px;
}

.logo {
  height: 50px;
  width: auto;
}

.nav-section {
  display: flex;
  justify-content: flex-start;
  flex: 1;
  overflow: visible;
  min-width: 0;
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
  font-size: 15px;
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

</style>

