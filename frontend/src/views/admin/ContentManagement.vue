<template>
  <div class="admin-page">
    <el-card>
      <template #header>
        <h2>通用模块管理 - {{ categoryName }}</h2>
      </template>
      <div class="content">
        <p>通用模块管理功能开发中...</p>
        <p>当前分类：{{ categoryName }}</p>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const categoryNameMap = {
  'experiment-teaching': '实验教学',
  'experiment-resources': '实验资源',
  'construction-results': '建设成效',
  'safety-management': '安全管理'
}

const categoryName = computed(() => {
  const path = route.path.split('/').pop()
  return categoryNameMap[path] || '未知分类'
})
</script>

<style scoped>
.admin-page {
  padding: 0;
}

.content {
  padding: 20px 0;
  color: #606266;
}
</style>


