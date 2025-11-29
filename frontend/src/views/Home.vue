<template>
  <div class="home">
    <el-card class="welcome-card">
      <template #header>
        <div class="card-header">
          <span>欢迎使用 Vue 3 + Element Plus</span>
        </div>
      </template>
      <div class="welcome-content">
        <el-icon :size="60" color="#409eff"><Star /></el-icon>
        <h2>这是一个使用 Vue 3 + Element Plus + Vue Router + Vite 构建的项目</h2>
        <p>项目已成功配置，您可以开始开发了！</p>
        <el-space>
          <el-button type="primary" @click="goToComponents">
            <el-icon><View /></el-icon>
            查看组件示例
          </el-button>
          <el-button @click="goToAbout">
            <el-icon><InfoFilled /></el-icon>
            了解更多
          </el-button>
        </el-space>
      </div>
    </el-card>

    <el-row :gutter="20" class="feature-row">
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover">
          <el-icon :size="40" color="#67c23a"><Check /></el-icon>
          <h3>Vue 3</h3>
          <p>使用最新的 Vue 3 Composition API</p>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover">
          <el-icon :size="40" color="#409eff"><ElementPlus /></el-icon>
          <h3>Element Plus</h3>
          <p>丰富的 UI 组件库</p>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8">
        <el-card shadow="hover">
          <el-icon :size="40" color="#e6a23c"><Lightning /></el-icon>
          <h3>Vite</h3>
          <p>极速的开发体验</p>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { Star, View, InfoFilled, Check, ElementPlus, Lightning } from '@element-plus/icons-vue'

const router = useRouter()

const goToComponents = () => {
  router.push('/components')
}

const goToAbout = () => {
  router.push('/about')
}
</script>

<style scoped>
.home {
  padding: 20px 0;
}

.welcome-card {
  margin-bottom: 30px;
}

.card-header {
  font-size: 18px;
  font-weight: bold;
}

.welcome-content {
  text-align: center;
  padding: 20px;
}

.welcome-content h2 {
  margin: 20px 0;
  color: #303133;
}

.welcome-content p {
  color: #606266;
  margin-bottom: 30px;
  font-size: 16px;
}

.feature-row {
  margin-top: 30px;
}

.feature-row .el-card {
  text-align: center;
  padding: 20px;
  height: 100%;
}

.feature-row h3 {
  margin: 15px 0 10px;
  color: #303133;
}

.feature-row p {
  color: #909399;
  margin: 0;
}
</style>

