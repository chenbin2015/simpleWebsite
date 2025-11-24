<template>
  <div id="app">
    <!-- 管理后台页面不显示头部和页脚 -->
    <template v-if="isAdminRoute">
      <router-view />
    </template>
    <!-- 其他页面显示完整的布局 -->
    <template v-else>
      <el-container>
        <el-header class="app-header">
          <div class="header-content">
            <div class="logo-section" @click="goHome">
              <Logo />
            </div>
            <div class="nav-section">
              <el-menu
                mode="horizontal"
                :default-active="activeMenu"
                class="nav-menu"
                background-color="transparent"
                text-color="#ECF0F1"
                active-text-color="#3498DB"
                :collapse="false"
              >
                <el-menu-item index="home" @click="goHome">首页</el-menu-item>
                <el-menu-item index="features" @click="scrollToFeatures">功能特性</el-menu-item>
                <el-menu-item index="about" @click="scrollToAbout">关于我们</el-menu-item>
              </el-menu>
            </div>
            <div class="user-section">
              <template v-if="currentUser">
                <el-dropdown @command="handleCommand">
                  <span class="user-dropdown">
                    <el-avatar :size="32" class="user-avatar">
                      {{ currentUser.username.charAt(0).toUpperCase() }}
                    </el-avatar>
                    <span class="username">{{ currentUser.username }}</span>
                    <el-icon><arrow-down /></el-icon>
                  </span>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                      <el-dropdown-item command="settings">账户设置</el-dropdown-item>
                      <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </template>
              <template v-else>
                <el-button type="primary" plain @click="goToLogin">登录</el-button>
                <el-button type="success" @click="goToRegister">免费注册</el-button>
              </template>
            </div>
          </div>
        </el-header>
        <el-main class="app-main">
          <router-view />
        </el-main>
        <el-footer class="app-footer">
          <div class="footer-content">
            <div class="footer-section">
              <h4>企业建站平台</h4>
              <p>为企业提供专业、高效的网站建设解决方案</p>
            </div>
            <div class="footer-section">
              <h4>联系我们</h4>
              <p>邮箱: support@enterprisebuild.com</p>
              <p>电话: 400-888-8888</p>
            </div>
            <div class="footer-section">
              <h4>关注我们</h4>
              <p>© 2025 企业建站平台 版权所有</p>
            </div>
          </div>
        </el-footer>
      </el-container>
    </template>
  </div>
</template>

<script>
import { ArrowDown } from '@element-plus/icons-vue'
import Logo from './components/Logo.vue'

export default {
  name: 'App',
  components: {
    Logo,
    ArrowDown
  },
  data() {
    return {
      currentUser: null,
      activeMenu: 'home'
    }
  },
  computed: {
    isAdminRoute() {
      return this.$route.path.startsWith('/admin')
    }
  },
  mounted() {
    this.loadUser()
    this.updateActiveMenu()
  },
  watch: {
    $route() {
      this.loadUser()
      this.updateActiveMenu()
    }
  },
  methods: {
    loadUser() {
      const userStr = localStorage.getItem('user')
      if (userStr) {
        try {
          this.currentUser = JSON.parse(userStr)
        } catch (e) {
          localStorage.removeItem('user')
          this.currentUser = null
        }
      } else {
        this.currentUser = null
      }
    },
    updateActiveMenu() {
      const path = this.$route.path
      if (path === '/') {
        this.activeMenu = 'home'
      } else if (path === '/login' || path === '/register') {
        this.activeMenu = ''
      }
    },
    goHome() {
      if (this.$route.path !== '/') {
        this.$router.push('/')
      }
    },
    goToLogin() {
      this.$router.push('/login')
    },
    goToRegister() {
      this.$router.push('/register')
    },
    scrollToFeatures() {
      if (this.$route.path === '/') {
        document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })
      } else {
        this.$router.push('/')
        setTimeout(() => {
          document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })
        }, 100)
      }
    },
    scrollToAbout() {
      if (this.$route.path === '/') {
        document.getElementById('about')?.scrollIntoView({ behavior: 'smooth' })
      } else {
        this.$router.push('/')
        setTimeout(() => {
          document.getElementById('about')?.scrollIntoView({ behavior: 'smooth' })
        }, 100)
      }
    },
    handleCommand(command) {
      if (command === 'logout') {
        this.handleLogout()
      } else if (command === 'profile') {
        // 跳转到个人中心
        this.$router.push('/')
      } else if (command === 'settings') {
        // 跳转到设置页面
        this.$router.push('/')
      }
    },
    handleLogout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      localStorage.removeItem('tokenExpire')
      this.currentUser = null
      this.$router.push('/login')
    }
  }
}
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-header {
  background: #2C3E50;
  color: #ECF0F1;
  padding: 0;
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

.logo-section {
  cursor: pointer;
  transition: opacity 0.3s;
}

.logo-section:hover {
  opacity: 0.8;
}

.nav-section {
  flex: 1;
  display: flex;
  justify-content: center;
  min-width: 300px; /* 确保有足够空间显示三个菜单项 */
}

.nav-menu {
  border: none;
  width: auto;
  min-width: 400px;
}

.nav-menu .el-menu-item {
  border-bottom: 2px solid transparent;
  transition: all 0.3s;
  white-space: nowrap;
  padding: 0 20px !important;
}

.nav-menu .el-menu-item:hover {
  background-color: rgba(52, 152, 219, 0.1);
  border-bottom-color: #3498DB;
}

/* 完全隐藏"更多"菜单（三个点） */
.nav-menu .el-submenu {
  display: none !important;
}

/* 强制显示所有菜单项，防止被折叠 */
.nav-menu.el-menu--horizontal {
  overflow: visible !important;
}

.nav-menu.el-menu--horizontal .el-menu-item {
  display: inline-block !important;
  visibility: visible !important;
}

.user-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-dropdown {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 12px;
  border-radius: 20px;
  transition: background-color 0.3s;
}

.user-dropdown:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.user-avatar {
  background: #3498DB;
  color: #FFFFFF;
  font-weight: bold;
}

.username {
  font-size: 14px;
  color: #ECF0F1;
}

.app-main {
  flex: 1;
  padding: 0;
  background: #f5f7fa;
  min-height: calc(100vh - 140px);
}

.app-footer {
  background: #2c3e50;
  color: #ecf0f1;
  padding: 40px 0;
  margin-top: auto;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 40px;
}

.footer-section h4 {
  margin-bottom: 16px;
  color: #ecf0f1;
  font-size: 16px;
}

.footer-section p {
  margin: 8px 0;
  color: #bdc3c7;
  font-size: 14px;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .header-content {
    flex-wrap: wrap;
    padding: 0 16px;
  }
  
  .nav-section {
    order: 3;
    width: 100%;
    margin-top: 8px;
  }
  
  .user-section {
    order: 2;
  }
}
</style>
