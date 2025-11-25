<template>
  <PageLayout :show-sidebar="false">
    <div class="common-list-page">
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
            :placeholder="searchPlaceholder"
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
        <div v-if="listType === 'news'" class="list-container">
          <el-card
            v-for="(item, index) in filteredList"
            :key="index"
            shadow="hover"
            class="list-item"
            @click="handleViewDetail(item)"
          >
            <div class="item-content">
              <div class="item-title">
                <span class="title-text">{{ item.title }}</span>
              </div>
              <div class="item-meta">
                <span class="item-date" v-if="item.date">
                  <el-icon><Calendar /></el-icon>
                  {{ item.date }}
                </span>
                <span class="item-author" v-if="item.author">
                  <el-icon><User /></el-icon>
                  {{ item.author }}
                </span>
              </div>
              <div class="item-summary" v-if="item.summary">
                {{ item.summary }}
              </div>
            </div>
          </el-card>
        </div>

        <!-- 公告列表 -->
        <div v-else-if="listType === 'announcement'" class="list-container">
          <el-card
            v-for="(item, index) in filteredList"
            :key="index"
            shadow="hover"
            class="list-item announcement-item"
            @click="handleViewDetail(item)"
          >
            <div class="item-content">
              <div class="item-title">
                <span class="title-text">{{ item.title }}</span>
                <span class="item-date" v-if="item.date">{{ item.date }}</span>
              </div>
              <div class="item-summary" v-if="item.description">
                {{ item.description }}
              </div>
            </div>
          </el-card>
        </div>

        <!-- 空状态 -->
        <el-empty v-if="filteredList.length === 0" description="暂无数据" />

        <!-- 分页 -->
        <div class="pagination-container" v-if="filteredList.length > 0">
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
    </div>
  </PageLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElCard, ElInput, ElButton, ElIcon, ElEmpty, ElPagination, ElMessage } from 'element-plus'
import { Search, Calendar, User } from '@element-plus/icons-vue'
import PageLayout from '@/components/PageLayout.vue'
import { fetchMockData } from '@/services/mockClient'

const route = useRoute()
const router = useRouter()

// 从查询参数获取类型（news 或 announcement）
const listType = computed(() => {
  const type = route.query.type || 'news'
  return type === 'announcement' ? 'announcement' : 'news'
})

// 从查询参数获取 from
const from = computed(() => route.query.from || 'home')

// 页面标题
const pageTitle = computed(() => {
  return listType.value === 'announcement' ? '通知公告' : '新闻动态'
})

// 搜索占位符
const searchPlaceholder = computed(() => {
  return listType.value === 'announcement' ? '搜索公告...' : '搜索新闻...'
})

// 数据
const listData = ref([])
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

// 过滤后的列表
const filteredList = computed(() => {
  let result = listData.value
  
  // 搜索过滤
  if (searchKeyword.value) {
    const keyword = searchKeyword.value.toLowerCase()
    result = result.filter(item => 
      item.title?.toLowerCase().includes(keyword) ||
      item.summary?.toLowerCase().includes(keyword) ||
      item.description?.toLowerCase().includes(keyword)
    )
  }
  
  total.value = result.length
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return result.slice(start, end)
})

// 加载数据
const loadData = async () => {
  try {
    if (listType.value === 'news') {
      // 加载所有新闻
      const data = await fetchMockData('news-list.json')
      const allNews = []
      
      // 遍历所有分类，收集所有新闻
      for (const key in data) {
        const category = data[key]
        if (category.items && Array.isArray(category.items)) {
          allNews.push(...category.items)
        }
      }
      
      listData.value = allNews
    } else {
      // 加载所有公告
      const data = await fetchMockData('announcement-list.json')
      listData.value = data.items || []
    }
    
    total.value = listData.value.length
    currentPage.value = 1
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败')
    listData.value = []
    total.value = 0
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
  if (!item.id) {
    ElMessage.warning('该项缺少 ID，无法查看详情')
    return
  }
  
  const type = listType.value === 'announcement' ? 'announcement' : 'news'
  router.push({
    path: `/detail/${type}/${item.id}`,
    query: { from: from.value }
  })
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.common-list-page {
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

.list-container {
  margin-bottom: 20px;
}

.list-item {
  margin-bottom: 15px;
  cursor: pointer;
  transition: all 0.3s;
}

.list-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.item-content {
  padding: 10px 0;
}

.item-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.title-text {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  flex: 1;
}

.item-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 10px;
  font-size: 14px;
  color: #909399;
}

.item-meta .el-icon {
  margin-right: 5px;
}

.item-date {
  display: flex;
  align-items: center;
}

.item-author {
  display: flex;
  align-items: center;
}

.item-summary {
  font-size: 14px;
  color: #606266;
  line-height: 1.6;
  margin-top: 8px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 公告列表特殊样式 */
.announcement-item .item-title {
  border-bottom: 1px solid #ffd700;
  padding-bottom: 8px;
}

.announcement-item .item-date {
  font-size: 14px;
  color: #999;
  white-space: nowrap;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}
</style>

