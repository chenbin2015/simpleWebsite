<template>
  <div class="page-container">
    <h1>{{ pageTitle }}</h1>
    <div class="page-content">
      <p>页面内容加载中...</p>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import request from '../utils/request'

export default {
  name: 'Page',
  setup() {
    const route = useRoute()
    const pageTitle = ref('')
    const pageContent = ref('')
    
    onMounted(async () => {
      const menuId = route.meta.menuId
      if (menuId) {
        try {
          // 加载菜单内容
          const response = await request.get(`/content/menu/${menuId}`)
          if (response.success && response.content) {
            pageTitle.value = response.content.title || route.meta.menuName || '页面'
            pageContent.value = response.content.content || ''
          } else {
            pageTitle.value = route.meta.menuName || '页面'
          }
        } catch (error) {
          pageTitle.value = route.meta.menuName || '页面'
        }
      }
    })
    
    return {
      pageTitle,
      pageContent
    }
  }
}
</script>

<style scoped>
.page-container {
  padding: 20px;
}

.page-content {
  margin-top: 20px;
}
</style>


