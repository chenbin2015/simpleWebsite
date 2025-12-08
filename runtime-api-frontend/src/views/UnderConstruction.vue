<template>
  <div class="under-construction-page">
    <div class="construction-content">
      <el-icon :size="100" color="#909399" class="construction-icon">
        <Tools />
      </el-icon>
      <h1 class="construction-title">系统建设中</h1>
      <p class="construction-text">该功能正在开发中，敬请期待...</p>
    </div>
  </div>
</template>

<script setup>
import { Tools } from '@element-plus/icons-vue'
</script>

<style scoped>
.under-construction-page {
  min-height: 60vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f7fa;
}

.construction-content {
  text-align: center;
  padding: 40px;
}

.construction-icon {
  margin-bottom: 30px;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.6;
  }
}

.construction-title {
  font-size: 32px;
  font-weight: bold;
  color: #303133;
  margin: 0 0 20px 0;
}

.construction-text {
  font-size: 16px;
  color: #909399;
  margin: 0;
}
</style>



