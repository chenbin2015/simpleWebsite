<template>
  <el-container class="admin-container">
    <el-container class="admin-body">
      <!-- 左侧菜单 -->
      <el-aside class="admin-aside" :width="isCollapse ? '64px' : '200px'">
        <div class="aside-header">
          <div class="collapse-btn" @click="toggleCollapse">
            <el-icon><Fold v-if="!isCollapse" /><Expand v-else /></el-icon>
          </div>
          <h1 v-if="!isCollapse" class="admin-title">管理后台</h1>
        </div>
        <el-menu
          :default-active="activeMenu"
          class="admin-menu"
          :collapse="isCollapse"
          :router="true"
        >
          <template v-for="item in adminMenuItems" :key="item.key">
            <!-- 有子菜单 -->
            <el-sub-menu v-if="item.children" :index="item.path">
              <template #title>
                <el-icon v-if="item.icon">
                  <component :is="getIconComponent(item.icon)" />
                </el-icon>
                <span>{{ item.name }}</span>
              </template>
              <el-menu-item
                v-for="child in item.children"
                :key="child.key"
                :index="child.path"
              >
                {{ child.name }}
              </el-menu-item>
            </el-sub-menu>
            <!-- 无子菜单 -->
            <el-menu-item v-else :index="item.path">
              <el-icon v-if="item.icon">
                <component :is="getIconComponent(item.icon)" />
              </el-icon>
              <span>{{ item.name }}</span>
            </el-menu-item>
          </template>
        </el-menu>
        <!-- 用户信息区域 -->
        <div class="user-section" v-if="!isCollapse">
          <el-dropdown trigger="click" placement="top">
            <div class="user-info">
              <el-icon><User /></el-icon>
              <span>管理员</span>
              <el-icon class="el-icon--right"><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
        <div v-else class="user-section-collapsed">
          <el-dropdown trigger="click" placement="right">
            <div class="user-icon">
              <el-icon><User /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-aside>

      <!-- 右侧内容区域 -->
      <el-main class="admin-main">
        <router-view />
      </el-main>
    </el-container>

    <!-- 底部 -->
    <el-footer class="admin-footer">
      <p>© 2025 管理后台 - 东南大学建筑学院实验教学中心</p>
    </el-footer>
  </el-container>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { adminMenuItems } from '@/config/adminMenu'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import { User, Fold, Expand, ArrowDown } from '@element-plus/icons-vue'
import { clearAuthData } from '@/utils/auth'

const route = useRoute()
const router = useRouter()

// 菜单折叠状态
const isCollapse = ref(false)

// 当前激活的菜单
const activeMenu = computed(() => route.path)

// 切换菜单折叠
const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}

// 获取图标组件
const getIconComponent = (iconName) => {
  return ElementPlusIconsVue[iconName] || ElementPlusIconsVue['Document']
}

// 退出登录处理
const handleLogout = () => {
  ElMessageBox.confirm(
    '确定要退出登录吗？',
    '退出登录',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
      center: true
    }
  ).then(() => {
    // 清除所有登录信息（包括 localStorage 和 sessionStorage）
    clearAuthData()
    
    // 显示退出成功消息
    ElMessage.success('已退出登录')
    
    // 跳转到登录页
    router.push('/admin/login')
  }).catch(() => {
    // 用户取消退出，不做任何操作
  })
}
</script>

<style scoped>
.admin-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  height: 100vh;
  width: 100vw;
  display: flex;
  flex-direction: column;
  margin: 0;
  padding: 0;
}

/* 侧边栏头部 */
.aside-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 60px;
  padding: 0 15px;
  background-color: #263445;
  border-bottom: 1px solid #1f2d3d;
}

.admin-title {
  margin: 0;
  font-size: 18px;
  font-weight: bold;
  color: white;
  flex: 1;
  text-align: center;
}

/* 主体区域 */
.admin-body {
  flex: 1;
  overflow: hidden;
}

/* 左侧菜单 */
.admin-aside {
  background-color: #304156;
  transition: width 0.3s;
  position: relative;
  display: flex;
  flex-direction: column;
}

.collapse-btn {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: white;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.collapse-btn:hover {
  background-color: #1f2d3d;
}

.admin-menu {
  border-right: none;
  background-color: #304156;
  height: calc(100vh - 160px);
  overflow-y: auto;
}

/* 用户信息区域 */
.user-section {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 60px;
  padding: 0 15px;
  background-color: #263445;
  border-top: 1px solid #1f2d3d;
  display: flex;
  align-items: center;
}

.user-section-collapsed {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #263445;
  border-top: 1px solid #1f2d3d;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  color: #bfcbd9;
  width: 100%;
  padding: 10px;
  border-radius: 4px;
  transition: all 0.3s;
}

.user-info:hover {
  background-color: #1f2d3d;
  color: white;
}

.user-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #bfcbd9;
  border-radius: 4px;
  transition: all 0.3s;
}

.user-icon:hover {
  background-color: #1f2d3d;
  color: white;
}

.admin-menu :deep(.el-menu-item),
.admin-menu :deep(.el-sub-menu__title) {
  color: #bfcbd9;
}

.admin-menu :deep(.el-menu-item:hover),
.admin-menu :deep(.el-sub-menu__title:hover) {
  background-color: #263445;
  color: white;
}

.admin-menu :deep(.el-menu-item.is-active) {
  background-color: #409eff;
  color: white;
}

.admin-menu :deep(.el-sub-menu.is-active .el-sub-menu__title) {
  color: white;
}

/* 二级菜单样式 */
.admin-menu :deep(.el-sub-menu .el-menu) {
  background-color: #1f2d3d !important;
}

.admin-menu :deep(.el-sub-menu .el-menu-item) {
  background-color: #1f2d3d !important;
  color: #bfcbd9 !important;
}

.admin-menu :deep(.el-sub-menu .el-menu-item:hover) {
  background-color: #263445 !important;
  color: white !important;
}

.admin-menu :deep(.el-sub-menu .el-menu-item.is-active) {
  background-color: #409eff !important;
  color: white !important;
}

/* 弹出层二级菜单样式 */
:deep(.el-menu--popup) {
  background-color: #1f2d3d !important;
  border: none !important;
}

:deep(.el-menu--popup .el-menu-item) {
  background-color: #1f2d3d !important;
  color: #bfcbd9 !important;
}

:deep(.el-menu--popup .el-menu-item:hover) {
  background-color: #263445 !important;
  color: white !important;
}

:deep(.el-menu--popup .el-menu-item.is-active) {
  background-color: #409eff !important;
  color: white !important;
}

/* 右侧内容区域 */
.admin-main {
  background-color: #f0f2f5;
  padding: 20px;
  overflow-y: auto;
}

/* 底部 */
.admin-footer {
  background-color: #fff;
  text-align: center;
  height: 50px;
  line-height: 50px;
  color: #606266;
  border-top: 1px solid #ebeef5;
}

.admin-footer p {
  margin: 0;
  font-size: 14px;
}
</style>

