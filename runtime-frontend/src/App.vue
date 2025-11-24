<template>
  <div id="app">
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
      
      <!-- 主要内容区 -->
      <el-main class="app-main">
        <router-view />
      </el-main>
      
      <!-- 底部 -->
      <el-footer class="app-footer">
        <!-- 顶部区域：Logo和分隔线 -->
        <div class="footer-top">
          <div class="footer-logo">
            <img 
          src="https://guanwang.makabaka.ltd/uploads/20250910/f803dcb1eedefdac8fcefa641a4d6020.png" 
          alt="Logo" 
          class="logo"
        />
          </div>
          <div class="footer-divider"></div>
        </div>
        
        <!-- 中间区域：联系信息和友情链接 -->
        <div class="footer-middle">
          <div class="footer-left">
            <div class="contact-item">
              <span class="label">联系电话：</span>
              <span class="value">025-83792484</span>
            </div>
            <div class="contact-item">
              <span class="label">邮编：</span>
              <span class="value">210096</span>
            </div>
            <div class="contact-item">
              <span class="label">地址：</span>
              <span class="value">江苏省南京市玄武区四牌楼2号</span>
            </div>
          </div>
          
          <div class="footer-divider-vertical"></div>
          
          <div class="footer-right">
            <div class="links-title">友情链接</div>
            <div class="links-columns">
              <div class="links-column">
                <div class="link-item">东南大学</div>
                <div class="link-item">东南大学建筑学院</div>
              </div>
              <div class="links-column">
                <div class="link-item">东南大学实验室与设备管理处</div>
                <div class="link-item">东南大学教务处</div>
              </div>
              <div class="links-column">
                <div class="link-item">东南大学科研院</div>
                <div class="link-item">东南大学保卫处</div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 底部：版权信息 -->
        <div class="footer-bottom">
          <p>Copyright © 2025 东南大学建筑学院实验教学中心All Rights Reserved. 版权所有</p>
        </div>
      </el-footer>
    </el-container>
  </div>
</template>

<script>
export default {
  name: 'App',
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
      ]
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
            currentTopMenu.children.push({ name: childName })
          }
        } else {
          // 一级菜单
          if (currentTopMenu) {
            result.push(currentTopMenu)
          }
          currentTopMenu = { name: menu.trim() }
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
    handleMenuSelect(index) {
      this.activeMenu = index
      // TODO: 处理路由跳转
      console.log('Selected menu:', index)
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
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 120px);
}

.app-footer {
  background: #303133;
  color: #fff;
  padding: 40px 60px 10px;
  min-height: 320px;
}

/* 顶部区域：Logo和分隔线 */
.footer-top {
  display: flex;
  align-items: center;
  margin-bottom: 30px;
  .footer-logo {
  display: flex;
  align-items: center;
}

.footer-logo .logo {
  height: 30px;
  width: auto;
}
}


.footer-divider {
  flex: 1;
  height: 1px;
  background: rgba(255, 255, 255, 0.3);
  margin-left: 20px;
}

/* 中间区域 */
.footer-middle {
  display: flex;
  gap: 40px;
  margin-bottom: 30px;
  padding-bottom: 30px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.footer-left {
  flex: 1;
}

.contact-item {
  margin-bottom: 12px;
  font-size: 14px;
  line-height: 1.8;
}

.contact-item .label {
  color: rgba(255, 255, 255, 0.8);
  margin-right: 8px;
}

.contact-item .value {
  color: #fff;
}

.footer-divider-vertical {
  width: 1px;
  background: rgba(255, 255, 255, 0.2);
  margin: 0 20px;
}

.footer-right {
  flex: 1.5;
}

.links-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 20px;
  color: #fff;
}

.links-columns {
  display: flex;
  gap: 40px;
}

.links-column {
  flex: 1;
}

.link-item {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 10px;
  cursor: pointer;
  transition: color 0.3s;
}

.link-item:hover {
  color: #D4AF37;
}

/* 底部版权信息 */
.footer-bottom {
  text-align: center;
  padding-top: 20px;
}

.footer-bottom p {
  margin: 0;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
}

</style>
