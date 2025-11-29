<template>
  <div class="page-layout">
    <div class="layout-container">
      <!-- 左侧菜单 -->
      <aside class="sidebar">
        <SidebarMenu />
      </aside>
      <!-- 右侧内容 -->
      <main class="content">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import SidebarMenu from './SidebarMenu.vue'
</script>

<style scoped>
.page-layout {
  width: 100%;
  min-height: calc(100vh - 120px);
  background-color: #f5f7fa;
  padding: 20px 0;
}

.layout-container {
  max-width: 1600px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

.sidebar {
  flex-shrink: 0;
}

.content {
  flex: 1;
  min-width: 0;
  background-color: #fff;
  border-radius: 4px;
  padding: 20px;
}

/* 响应式 */
@media (max-width: 768px) {
  .layout-container {
    flex-direction: column;
    padding: 0 15px;
  }

  .content {
    padding: 15px;
  }
}
</style>

