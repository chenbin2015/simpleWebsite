<template>
  <PageLayout :show-sidebar="true">
    <div class="detail-page">
      <div class="detail-container">
        <!-- 加载状态 -->
        <div v-if="loading" class="loading">
          <p>加载中...</p>
        </div>
        
        <!-- 错误状态 -->
        <div v-else-if="error" class="error">
          <p>{{ error }}</p>
        </div>
        
        <!-- 详情内容 -->
        <div v-else-if="detailData" class="detail-content">
          <!-- 新闻详情布局 -->
          <div v-if="type === 'news'" class="news-detail">
            <div class="detail-header">
              <h1 class="detail-title">{{ detailData.title }}</h1>
              <div class="detail-meta">
                <span class="meta-item">
                  <el-icon><Calendar /></el-icon>
                  <span>发布时间：{{ detailData.date }}</span>
                </span>
                <span v-if="detailData.author" class="meta-item">
                  <el-icon><User /></el-icon>
                  <span>作者：{{ detailData.author }}</span>
                </span>
                <span v-if="detailData.category" class="meta-item">
                  <el-icon><Folder /></el-icon>
                  <span>分类：{{ detailData.category }}</span>
                </span>
              </div>
            </div>
            <div class="detail-body">
              <div class="detail-summary" v-if="detailData.description">
                <p>{{ detailData.description }}</p>
              </div>
              <div class="detail-html-content" v-html="detailData.content"></div>
            </div>
          </div>
          
          <!-- 公告详情布局 -->
          <div v-else-if="type === 'announcement'" class="announcement-detail">
            <div class="detail-header">
              <h1 class="detail-title">{{ detailData.title }}</h1>
              <div class="detail-meta">
                <span class="meta-item">
                  <el-icon><Calendar /></el-icon>
                  <span>发布时间：{{ detailData.date }}</span>
                </span>
              </div>
            </div>
            <div class="detail-body">
              <div class="detail-description" v-if="detailData.description">
                <p>{{ detailData.description }}</p>
              </div>
              <AttachmentPreview 
                v-if="detailData.attachmentName && detailData.attachmentUrl"
                :attachment-url="detailData.attachmentUrl"
                :attachment-name="detailData.attachmentName"
              />
              <div class="detail-html-content" v-if="detailData.content" v-html="detailData.content"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </PageLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { Calendar, User, Folder } from '@element-plus/icons-vue'
import PageLayout from '@/components/PageLayout.vue'
import AttachmentPreview from '@/components/AttachmentPreview.vue'
import { fetchMockData } from '@/services/mockClient'
import { getNewsById as getHomeNewsById, getAnnouncementById as getHomeAnnouncementById } from '@/services/publicHomeApi'
import { getArticleById as getPopularScienceArticleById, getAnnouncementById as getPopularScienceAnnouncementById } from '@/services/publicPopularScienceApi'
import { getModuleNewsById } from '@/services/publicModuleApi'
import { ElMessage } from 'element-plus'

const route = useRoute()
const loading = ref(true)
const error = ref(null)
const detailData = ref(null)

const type = computed(() => route.params.type) // 'news' 或 'announcement'
const id = computed(() => route.params.id)
const from = computed(() => route.query.from || '') // 来源参数

onMounted(async () => {
  try {
    loading.value = true
    error.value = null
    
    console.log('详情页加载:', { type: type.value, id: id.value, from: from.value })
    
    // 直接用 id 从 API 加载数据
    await loadFromApi()
  } catch (err) {
    error.value = err.message || '加载详情失败'
    console.error('加载详情失败:', err)
    ElMessage.error('加载详情失败: ' + (err.message || '未知错误'))
  } finally {
    loading.value = false
  }
})

// 从后端 API 加载数据
const loadFromApi = async () => {
  try {
    let response
    
    // 根据 from 参数选择不同的 API
    // 模块新闻的 from 格式：experiment-teaching-{id}、experiment-resources-{id} 等
    // 科普教育的 from：popular-science 或 popular-science-{id}
    // 首页的 from：home 或其他
    
    // 判断是否是模块新闻（from 包含模块类型前缀）
    const moduleTypes = ['experiment-teaching', 'experiment-resources', 'construction-results', 'safety-management']
    const isModuleNews = moduleTypes.some(moduleType => from.value?.startsWith(moduleType))
    
    if (from.value === 'popular-science' || from.value?.startsWith('popular-science')) {
      // 科普教育的 API
      console.log('使用科普教育 API，id:', id.value)
      if (type.value === 'news') {
        response = await getPopularScienceArticleById(id.value)
      } else if (type.value === 'announcement') {
        response = await getPopularScienceAnnouncementById(id.value)
      } else {
        throw new Error('不支持的类型，只支持 news 或 announcement')
      }
    } else if (isModuleNews && type.value === 'news') {
      // 模块新闻的 API（只支持 news 类型）
      console.log('使用模块新闻 API，id:', id.value, 'from:', from.value)
      response = await getModuleNewsById(id.value)
    } else {
      // 首页的 API（默认，包括 home 等）
      console.log('使用首页 API，id:', id.value, 'type:', type.value)
      if (type.value === 'news') {
        response = await getHomeNewsById(id.value)
      } else if (type.value === 'announcement') {
        response = await getHomeAnnouncementById(id.value)
      } else {
        throw new Error('不支持的类型，只支持 news 或 announcement')
      }
    }
    
    console.log('API 响应:', response.data)
    
    if (response.data.success && response.data.data) {
      const data = response.data.data
      
      // 转换数据格式为前端需要的格式
      if (type.value === 'news') {
        // 解析日期
        let date = ''
        if (data.date) {
          // 模块新闻可能直接返回 date 字段
          date = data.date
        } else if (data.publishTime) {
          date = data.publishTime.split('T')[0]
        } else if (data.createdAt) {
          date = data.createdAt.split('T')[0]
        }
        
        detailData.value = {
          id: data.id,
          title: data.title,
          author: data.author || '',
          // 模块新闻使用 summary，首页新闻使用 description
          description: data.description || data.summary || '',
          content: data.content || '',
          date: date,
          publishTime: data.publishTime,
          tags: data.tags || [],
          category: '' // 新闻没有分类字段
        }
      } else if (type.value === 'announcement') {
        // 解析日期
        let date = ''
        if (data.publishTime) {
          date = data.publishTime.split('T')[0]
        } else if (data.createdAt) {
          date = data.createdAt.split('T')[0]
        }
        
        detailData.value = {
          id: data.id,
          title: data.title,
          description: data.description || '',
          content: data.content || '',
          date: date,
          publishTime: data.publishTime,
          attachmentUrl: data.attachmentUrl || '',
          attachmentName: data.attachmentName || ''
        }
      }
    } else {
      error.value = response.data.message || '未找到对应的详情数据'
    }
  } catch (err) {
    console.error('从API加载详情失败:', err)
    throw err
  }
}

// 从 Mock 数据加载（兼容其他来源）
const loadFromMock = async () => {
  // 根据类型获取不同的 mock 数据
  let fileName = ''
  if (type.value === 'news') {
    fileName = 'news-list.json'
  } else if (type.value === 'announcement') {
    fileName = 'announcement-list.json'
  } else {
    throw new Error('不支持的类型，只支持 news 或 announcement')
  }
  
  // 获取 mock 数据
  const data = await fetchMockData(fileName)
  
  let foundItem = null
  
  if (type.value === 'news') {
    // 新闻数据结构：{ "2": { "title": "...", "items": [...] } }
    for (const key in data) {
      const category = data[key]
      if (category.items && Array.isArray(category.items)) {
        foundItem = category.items.find(item => item.id === id.value)
        if (foundItem) break
      }
    }
  } else if (type.value === 'announcement') {
    // 公告数据结构：{ "items": [...] }
    if (data.items && Array.isArray(data.items)) {
      foundItem = data.items.find(item => item.id === id.value)
    }
  }
  
  if (!foundItem) {
    error.value = '未找到对应的详情数据'
    console.warn('未找到详情数据，id:', id.value, 'type:', type.value)
  } else {
    detailData.value = foundItem
  }
}
</script>

<style scoped>
.detail-page {
  padding: 0;
}

.detail-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

.loading,
.error {
  text-align: center;
  padding: 40px;
  color: #666;
}

.error {
  color: #f56c6c;
}

.detail-content {
  background-color: #fff;
  border-radius: 8px;
  padding: 40px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.detail-header {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #eee;
}

.detail-title {
  font-size: 28px;
  font-weight: bold;
  color: #333;
  margin: 0 0 20px 0;
  line-height: 1.4;
}

.detail-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  color: #666;
  font-size: 14px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 5px;
}

.meta-item .el-icon {
  font-size: 16px;
}

.detail-body {
  margin-top: 30px;
}

.detail-summary,
.detail-description {
  background-color: #f5f7fa;
  padding: 20px;
  border-left: 4px solid #4caf50;
  margin-bottom: 30px;
  border-radius: 4px;
}

.detail-summary p,
.detail-description p {
  margin: 0;
  font-size: 16px;
  line-height: 1.8;
  color: #606266;
}

.detail-html-content {
  font-size: 16px;
  line-height: 1.8;
  color: #606266;
}

/* Quill 样式支持 */
.detail-html-content :deep(.ql-align-center) {
  text-align: center !important;
}

.detail-html-content :deep(.ql-align-right) {
  text-align: right !important;
}

.detail-html-content :deep(.ql-align-left) {
  text-align: left !important;
}

.detail-html-content :deep(.ql-align-justify) {
  text-align: justify !important;
}

.detail-html-content :deep(p) {
  margin: 0 0 15px 0;
}

.detail-html-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 4px;
  margin: 20px 0;
}

.detail-html-content :deep(h1),
.detail-html-content :deep(h2),
.detail-html-content :deep(h3) {
  margin-top: 30px;
  margin-bottom: 15px;
  color: #303133;
}

.detail-html-content :deep(ul),
.detail-html-content :deep(ol) {
  margin: 15px 0;
  padding-left: 30px;
}

.detail-html-content :deep(li) {
  margin: 8px 0;
}

/* 新闻详情特定样式 */
.news-detail .detail-meta {
  color: #4caf50;
}

/* 公告详情特定样式 */
.announcement-detail .detail-meta {
  color: #ffd700;
}

.announcement-detail .detail-description {
  border-left-color: #ffd700;
}

</style>

