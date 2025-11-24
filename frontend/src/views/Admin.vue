<template>
  <div class="admin-container">
    <el-container class="admin-layout">
      <!-- 顶部导航栏 -->
      <el-header class="admin-header">
        <div class="header-left">
          <h2 class="admin-title">管理后台</h2>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-avatar :size="32" class="user-avatar">
                {{ currentUser?.username?.charAt(0).toUpperCase() || 'A' }}
              </el-avatar>
              <span class="username">{{ currentUser?.username || '管理员' }}</span>
              <el-icon><arrow-down /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item command="settings">系统设置</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-container>
        <!-- 左侧菜单 -->
        <el-aside class="admin-aside" width="200px">
          <el-menu
            :default-active="activeMenu"
            class="admin-menu"
            background-color="#FFFFFF"
            text-color="#606266"
            active-text-color="#409EFF"
            @select="handleMenuSelect"
          >
            <el-menu-item index="dashboard">
              <el-icon><Odometer /></el-icon>
              <span>仪表盘</span>
            </el-menu-item>
            <el-menu-item index="users">
              <el-icon><User /></el-icon>
              <span>用户管理</span>
            </el-menu-item>
            <el-sub-menu index="business">
              <template #title>
                <el-icon><FolderOpened /></el-icon>
                <span>业务管理</span>
              </template>
              <el-menu-item index="business-home">首页</el-menu-item>
              <el-menu-item index="business-overview">中心概况</el-menu-item>
              <el-menu-item index="business-teaching">实验教学</el-menu-item>
              <el-menu-item index="business-resources">实验资源</el-menu-item>
              <el-menu-item index="business-achievements">建设成效</el-menu-item>
              <el-menu-item index="business-safety">安全管理</el-menu-item>
              <el-menu-item index="business-science">科普教育</el-menu-item>
            </el-sub-menu>
            <el-menu-item index="content">
              <el-icon><Document /></el-icon>
              <span>内容管理</span>
            </el-menu-item>
            <el-menu-item index="settings">
              <el-icon><Setting /></el-icon>
              <span>系统设置</span>
            </el-menu-item>
            <el-sub-menu index="more">
              <template #title>
                <el-icon><MoreFilled /></el-icon>
                <span>更多功能</span>
              </template>
              <el-menu-item index="logs">操作日志</el-menu-item>
              <el-menu-item index="reports">数据报表</el-menu-item>
            </el-sub-menu>
          </el-menu>
        </el-aside>

        <!-- 右侧内容区 -->
        <el-main class="admin-main">
          <div class="content-wrapper">
            <div class="content-header">
              <h3>{{ currentPageTitle }}</h3>
              <el-breadcrumb separator="/">
                <el-breadcrumb-item :to="{ path: '/admin' }">首页</el-breadcrumb-item>
                <el-breadcrumb-item>{{ currentPageTitle }}</el-breadcrumb-item>
              </el-breadcrumb>
            </div>
            <div class="content-body">
              <!-- 业务管理页面 -->
              <BusinessManagement v-if="activeMenu.startsWith('business-')" :menu-key="activeMenu" />
              <!-- 其他页面占位内容 -->
              <el-card v-else shadow="never" class="content-card">
                <div class="placeholder-content">
                  <el-icon class="placeholder-icon"><Document /></el-icon>
                  <p class="placeholder-text">这里是 {{ currentPageTitle }} 的内容区域</p>
                  <p class="placeholder-desc">当前选中的菜单：{{ activeMenu }}</p>
                </div>
              </el-card>
            </div>
          </div>
        </el-main>
      </el-container>

      <!-- 底部 -->
      <el-footer class="admin-footer">
        <div class="footer-content">
          <span>© 2025 企业建站平台 管理后台</span>
          <span>当前时间：{{ currentTime }}</span>
        </div>
      </el-footer>
    </el-container>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue'
import { 
  ArrowDown, 
  Odometer, 
  User, 
  Document, 
  Setting, 
  MoreFilled,
  FolderOpened
} from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import BusinessManagement from '../components/BusinessManagement.vue'

export default {
  name: 'Admin',
  components: {
    ArrowDown,
    Odometer,
    User,
    Document,
    Setting,
    MoreFilled,
    FolderOpened,
    BusinessManagement
  },
  setup() {
    const router = useRouter()
    const activeMenu = ref('dashboard')
    const currentUser = ref(null)
    const currentTime = ref('')
    let timeInterval = null

    const menuTitles = {
      dashboard: '仪表盘',
      users: '用户管理',
      business: '业务管理',
      'business-home': '首页',
      'business-overview': '中心概况',
      'business-teaching': '实验教学',
      'business-resources': '实验资源',
      'business-achievements': '建设成效',
      'business-safety': '安全管理',
      'business-science': '科普教育',
      content: '内容管理',
      settings: '系统设置',
      logs: '操作日志',
      reports: '数据报表'
    }

    const currentPageTitle = ref(menuTitles[activeMenu.value])

    // 加载用户信息
    const loadUser = () => {
      const userStr = localStorage.getItem('user')
      if (userStr) {
        try {
          currentUser.value = JSON.parse(userStr)
        } catch (e) {
          currentUser.value = null
        }
      }
    }

    // 更新当前时间
    const updateTime = () => {
      const now = new Date()
      currentTime.value = now.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      })
    }

    // 菜单选择
    const handleMenuSelect = (key) => {
      activeMenu.value = key
      currentPageTitle.value = menuTitles[key] || '管理后台'
    }

    // 用户下拉菜单
    const handleCommand = (command) => {
      if (command === 'logout') {
        localStorage.removeItem('token')
        localStorage.removeItem('user')
        localStorage.removeItem('tokenExpire')
        router.push('/login')
      } else if (command === 'profile') {
        // 跳转到个人中心
      } else if (command === 'settings') {
        // 跳转到系统设置
      }
    }

    onMounted(() => {
      loadUser()
      updateTime()
      timeInterval = setInterval(updateTime, 1000)
    })

    onUnmounted(() => {
      if (timeInterval) {
        clearInterval(timeInterval)
      }
    })

    return {
      activeMenu,
      currentUser,
      currentTime,
      currentPageTitle,
      handleMenuSelect,
      handleCommand
    }
  }
}
</script>

<style scoped>
.admin-container {
  width: 100%;
  height: 100vh;
  overflow: hidden;
}

.admin-layout {
  height: 100%;
}

/* 顶部导航栏 */
.admin-header {
  background: #FFFFFF;
  color: #303133;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  border-bottom: 1px solid #E4E7ED;
}

.header-left {
  display: flex;
  align-items: center;
}

.admin-title {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  color: #303133;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 12px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.user-info:hover {
  background-color: #F5F7FA;
}

.user-avatar {
  background: #409EFF;
  color: #FFFFFF;
  font-weight: bold;
}

.username {
  font-size: 14px;
  color: #303133;
}

/* 左侧菜单 */
.admin-aside {
  background: #FFFFFF;
  border-right: 1px solid #E4E7ED;
  overflow-y: auto;
}

.admin-menu {
  border: none;
  height: 100%;
}

.admin-menu .el-menu-item,
.admin-menu .el-sub-menu__title {
  height: 50px;
  line-height: 50px;
}

.admin-menu .el-menu-item:hover,
.admin-menu .el-sub-menu__title:hover {
  background-color: #F5F7FA !important;
}

.admin-menu .el-menu-item.is-active {
  background-color: #ECF5FF !important;
  color: #409EFF !important;
  border-right: 3px solid #409EFF;
}

/* 右侧内容区 */
.admin-main {
  background: #F8F9FA;
  padding: 20px;
  overflow-y: auto;
}

.content-wrapper {
  max-width: 1400px;
  margin: 0 auto;
}

.content-header {
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.content-header h3 {
  margin: 0;
  font-size: 20px;
  color: #303133;
}

.content-body {
  min-height: 500px;
}

.content-card {
  min-height: 500px;
}

.placeholder-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.placeholder-icon {
  font-size: 64px;
  color: #C0C4CC;
  margin-bottom: 20px;
}

.placeholder-text {
  font-size: 18px;
  color: #606266;
  margin: 10px 0;
}

.placeholder-desc {
  font-size: 14px;
  color: #909399;
  margin: 5px 0;
}

/* 底部 */
.admin-footer {
  background: #FFFFFF;
  border-top: 1px solid #E4E7ED;
  height: 50px;
  line-height: 50px;
  padding: 0 24px;
}

.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #909399;
  font-size: 14px;
}
</style>

