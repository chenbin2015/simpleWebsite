<template>
    <!-- 全屏 Banner -->
    <div class="banner-container">
      <img 
        src="https://guanwang.makabaka.ltd/uploads/20251114/c6030f82aa4475c108496dd426f19ac6.png" 
        alt="Banner" 
        class="banner-image"
      />
    </div>
    <PageLayout>
      <div class="dynamic-page">
        <!-- 调试信息 -->
        <div v-if="!pageType" style="padding: 20px; color: red;">
          <p>调试信息：</p>
          <p>rootType: {{ rootType }}</p>
          <p>type: {{ type }}</p>
          <p>pageType: {{ pageType }}</p>
          <p>id: {{ id }}</p>
          <p>route.params: {{ JSON.stringify(route.params) }}</p>
        </div>
        
        <!-- 根据页面类型动态渲染不同的组件 -->
        <!-- 所有组件都接收 id，用于从后端获取数据 -->
        <NewsList 
          v-if="pageType === 'news-list'" 
          :id="id" 
          :category="rootType"
        />
        <ProductList 
          v-else-if="pageType === 'product-list'" 
          :id="id"
          :category="rootType"
        />
        <ImageText 
          v-else-if="pageType === 'image-text'" 
          :id="id"
          :category="rootType"
        />
        <DownloadList 
          v-else-if="pageType === 'download-list'" 
          :id="id"
          :category="rootType"
        />
        
        <!-- 如果没有匹配的组件，显示提示 -->
        <div v-if="pageType && pageType !== 'news-list' && pageType !== 'product-list' && pageType !== 'image-text' && pageType !== 'download-list'" style="padding: 20px;">
          <p>未找到对应的组件类型: {{ pageType }}</p>
          <p>支持的页面类型: news-list, product-list, image-text, download-list</p>
        </div>
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
  const rootType = computed(() => route.params.rootType)
  const type = computed(() => route.params.type) // type 就是 pageType
  const id = computed(() => route.params.id)
  
  // type 参数就是 pageType，直接使用
  const pageType = computed(() => type.value)
  
  // 页面类型文本映射
  const pageTypeTextMap = {
    'news-list': '新闻列表',
    'product-list': '产品列表',
    'image-text': '图文',
    'download-list': '下载列表'
  }
  
  // 在控制台打印页面类型信息
  watch([rootType, type, id, pageType], ([root, menuType, pageId, pageTypeValue]) => {
    const typeText = pageTypeTextMap[pageTypeValue] || pageTypeValue || '未知'
    console.log('=== 当前页面信息 ===')
    console.log('RootType:', root)
    console.log('Type (MenuKey):', menuType)
    console.log('PageType:', pageTypeValue, `(${typeText})`)
    console.log('ID:', pageId)
    console.log('==================')
  }, { immediate: true })
  </script>
  
<style scoped>
.banner-container {
  width: 100%;
  overflow: hidden;
  margin-bottom: 0;
}

.banner-image {
  width: 100%;
  height: auto;
  display: block;
}

.dynamic-page {
  padding: 0;
}
</style>
  
  