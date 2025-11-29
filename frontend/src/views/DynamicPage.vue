<template>
  <PageLayout>
    <div class="dynamic-page">
      <!-- 根据页面类型动态渲染不同的组件 -->
      <!-- 所有组件都接收 id，用于从后端获取数据 -->
      <NewsList 
        v-if="pageType === 'news-list'" 
        :id="id" 
        :category="category"
      />
      <ProductList 
        v-else-if="pageType === 'product-list'" 
        :id="id"
        :category="category"
      />
      <ImageText 
        v-else-if="pageType === 'image-text'" 
        :id="id"
        :category="category"
      />
      <DownloadList 
        v-else-if="pageType === 'download-list'" 
        :id="id"
        :category="category"
      />
    </div>
  </PageLayout>
</template>

<script setup>
import { computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import PageLayout from '@/components/PageLayout.vue'
import NewsList from '@/components/pageTypes/NewsList.vue'
import ProductList from '@/components/pageTypes/ProductList.vue'
import ImageText from '@/components/pageTypes/ImageText.vue'
import DownloadList from '@/components/pageTypes/DownloadList.vue'

const route = useRoute()

// 从路由参数获取信息
const category = computed(() => route.params.category)
const pageType = computed(() => route.params.pageType)
const id = computed(() => route.params.id)

// 页面类型文本映射
const pageTypeTextMap = {
  'news-list': '新闻列表',
  'product-list': '产品列表',
  'image-text': '图文',
  'download-list': '下载列表'
}

// 在控制台打印页面类型信息
watch([category, pageType, id], ([cat, type, pageId]) => {
  const typeText = pageTypeTextMap[type] || type || '未知'
  console.log('=== 当前页面信息 ===')
  console.log('Category:', cat)
  console.log('PageType:', type, `(${typeText})`)
  console.log('ID:', pageId)
  console.log('==================')
}, { immediate: true })
</script>

<style scoped>
.dynamic-page {
  padding: 0;
}
</style>

