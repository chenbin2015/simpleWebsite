<template>
  <div class="news-list-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>{{ pageTitle }}</h2>
        </div>
      </template>
      
      <!-- 搜索栏 -->
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索新闻..."
          clearable
          style="width: 300px; margin-right: 10px;"
          @keyup.enter="handleSearch"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
      </div>

      <!-- 新闻列表 -->
      <div class="news-list">
        <el-card
          v-for="(item, index) in filteredNews"
          :key="index"
          shadow="hover"
          class="news-item"
          @click="handleViewDetail(item)"
        >
          <div class="news-content">
            <div class="news-title">
              <el-tag v-if="item.category" size="small" style="margin-right: 10px;">
                {{ item.category }}
              </el-tag>
              <span class="title-text">{{ item.title }}</span>
            </div>
            <div class="news-meta">
              <span class="news-date">
                <el-icon><Calendar /></el-icon>
                {{ item.date }}
              </span>
              <span class="news-author" v-if="item.author">
                <el-icon><User /></el-icon>
                {{ item.author }}
              </span>
            </div>
            <div class="news-summary" v-if="item.summary">
              {{ item.summary }}
            </div>
          </div>
        </el-card>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailVisible"
      :title="selectedNews?.title"
      width="70%"
    >
      <div class="news-detail">
        <div class="detail-meta">
          <el-tag v-if="selectedNews?.category">{{ selectedNews.category }}</el-tag>
          <span style="margin-left: 10px;">{{ selectedNews?.date }}</span>
          <span style="margin-left: 10px;" v-if="selectedNews?.author">作者：{{ selectedNews.author }}</span>
        </div>
        <el-divider />
        <div class="detail-content" v-html="selectedNews?.content"></div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { Search, Calendar, User } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { fetchMockData } from '@/services/mockClient'

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

// 页面标题（从后端获取）
const pageTitle = ref('新闻列表')

// 搜索关键词
const searchKeyword = ref('')

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 新闻数据（示例数据）
const newsData = ref([])

// 详情对话框
const detailVisible = ref(false)
const selectedNews = ref(null)

// 过滤后的新闻列表
const filteredNews = computed(() => {
  let result = newsData.value
  
  if (searchKeyword.value) {
    const keyword = searchKeyword.value.toLowerCase()
    result = result.filter(item => 
      item.title.toLowerCase().includes(keyword) ||
      item.summary?.toLowerCase().includes(keyword)
    )
  }
  
  total.value = result.length
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return result.slice(start, end)
})

const loadData = async () => {
  try {
    const data = await fetchMockData('news-list.json')
    const pageData = data[props.id]

    if (!pageData) {
      pageTitle.value = '新闻列表'
      newsData.value = []
      total.value = 0
      return
    }

    pageTitle.value = pageData.title || '新闻列表'
    newsData.value = pageData.items || []
    total.value = newsData.value.length
    currentPage.value = 1
  } catch (error) {
    console.error(error)
    ElMessage.error('加载新闻数据失败')
    pageTitle.value = '新闻列表'
    newsData.value = []
    total.value = 0
    currentPage.value = 1
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  ElMessage.success('搜索完成')
}

// 分页
const handleSizeChange = (val) => {
  pageSize.value = val
  currentPage.value = 1
}

const handleCurrentChange = (val) => {
  currentPage.value = val
}

// 查看详情
const handleViewDetail = (item) => {
  selectedNews.value = item
  detailVisible.value = true
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
.news-list-page {
  padding: 0;
}

.card-header h2 {
  margin: 0;
  color: #303133;
}

.search-bar {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.news-list {
  margin-bottom: 20px;
}

.news-item {
  margin-bottom: 15px;
  cursor: pointer;
  transition: all 0.3s;
}

.news-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.news-content {
  padding: 10px 0;
}

.news-title {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.title-text {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
  flex: 1;
}

.news-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 10px;
  font-size: 14px;
  color: #909399;
}

.news-meta span {
  display: flex;
  align-items: center;
  gap: 5px;
}

.news-summary {
  color: #606266;
  line-height: 1.6;
  margin-top: 10px;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.news-detail .detail-meta {
  margin-bottom: 20px;
}

.news-detail .detail-content {
  line-height: 1.8;
  color: #303133;
}
</style>

