<template>
    <div class="image-text-page">
      <el-card>
        <template #header>
          <div class="card-header">
            <h2>{{ pageTitle }}</h2>
          </div>
        </template>
  
        <div class="rich-content" v-html="contentHtml"></div>
      </el-card>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, watch } from 'vue'
  import { ElMessage } from 'element-plus'
  import { getModuleContent } from '@/services/publicModuleApi'
  import { getMenuById } from '@/services/publicMenuApi'
  
  const props = defineProps({
    id: {
      type: String,
      required: true
    },
    category: {
      type: String,
      required: true
    }
  })
  
  const pageTitle = ref('图文内容')
  const contentHtml = ref('<p>暂无内容</p>')
  
  const loadData = async () => {
    try {
      const menuId = parseInt(props.id)
      if (isNaN(menuId)) {
        ElMessage.error('无效的菜单ID')
        return
      }
      
      // 先获取菜单信息，使用菜单名称作为标题
      try {
        const menuResponse = await getMenuById(menuId)
        if (menuResponse.data && menuResponse.data.success && menuResponse.data.data) {
          pageTitle.value = menuResponse.data.data.name || '图文内容'
        }
      } catch (error) {
        console.warn('获取菜单信息失败，使用默认标题:', error)
      }
      
      const response = await getModuleContent(menuId)
      
      if (response.data && response.data.success) {
        // 后端返回的格式是 {success: true, content: {...}}
        const contentData = response.data.content || response.data.data || {}
        // 如果菜单名称已设置，不再使用contentData.title覆盖
        if (!pageTitle.value || pageTitle.value === '图文内容') {
          pageTitle.value = contentData.title || '图文内容'
        }
        contentHtml.value = contentData.content || '<p>暂无内容</p>'
      } else {
        if (!pageTitle.value || pageTitle.value === '图文内容') {
          pageTitle.value = '图文内容'
        }
        contentHtml.value = '<p>暂无内容</p>'
        ElMessage.error(response.data?.message || '加载图文内容失败')
      }
    } catch (error) {
      console.error('加载图文内容失败:', error)
      ElMessage.error('加载图文内容失败: ' + (error.response?.data?.message || error.message || '未知错误'))
      pageTitle.value = '图文内容'
      contentHtml.value = '<p>暂无内容</p>'
    }
  }
  
  onMounted(loadData)
  
  watch(
    () => props.id,
    () => {
      loadData()
    }
  )
  </script>
  
  <style scoped>
  .image-text-page {
    padding: 0;
  }
  
  .card-header h2 {
    margin: 0;
    color: #303133;
  }
  
  .rich-content {
    padding: 10px 0;
    font-size: 16px;
    line-height: 1.8;
    color: #606266;
  }
  
  /* Quill 样式支持 */
  .rich-content :deep(.ql-align-center) {
    text-align: center !important;
  }
  
  .rich-content :deep(.ql-align-right) {
    text-align: right !important;
  }
  
  .rich-content :deep(.ql-align-left) {
    text-align: left !important;
  }
  
  .rich-content :deep(.ql-align-justify) {
    text-align: justify !important;
  }
  
  .rich-content :deep(p) {
    margin: 0 0 15px 0;
  }
  
  .rich-content :deep(img) {
    max-width: 100%;
    height: auto;
    border-radius: 4px;
    margin: 20px 0;
  }
  </style>
  
  