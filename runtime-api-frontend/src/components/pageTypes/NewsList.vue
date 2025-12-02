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
  
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted, watch } from 'vue'
  import { useRouter, useRoute } from 'vue-router'
  import { Search, Calendar, User } from '@element-plus/icons-vue'
  import { ElMessage } from 'element-plus'
  import { getModuleNewsList } from '@/services/publicModuleApi'
  import { getMenuById } from '@/services/publicMenuApi'
  
  const router = useRouter()
  const route = useRoute()
  
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
      const menuId = parseInt(props.id)
      if (isNaN(menuId)) {
        ElMessage.error('无效的菜单ID')
        return
      }
      
      // 先获取菜单信息，使用菜单名称作为标题
      try {
        const menuResponse = await getMenuById(menuId)
        if (menuResponse.data && menuResponse.data.success && menuResponse.data.data) {
          pageTitle.value = menuResponse.data.data.name || '新闻列表'
        }
      } catch (error) {
        console.warn('获取菜单信息失败，使用默认标题:', error)
      }
      
      const response = await getModuleNewsList(menuId)
      
      if (response.data && response.data.success) {
        const data = response.data.data
        
        // 后端返回的data可能是数组，也可能是对象
        // 如果是数组，直接使用；如果是对象，取items字段
        const items = Array.isArray(data) ? data : (data?.items || [])
        newsData.value = items.map(item => {
          // 解析日期
          let date = ''
          if (item.publishTime) {
            date = item.publishTime.split('T')[0]
          } else if (item.createdAt) {
            date = item.createdAt.split('T')[0]
          }
          
          // 提取摘要（始终从content中提取，限制长度，不直接使用summary字段）
          let summary = ''
          if (item.content) {
            const textContent = item.content.replace(/<[^>]*>/g, '').trim()
            if (textContent) {
              // 如果summary字段存在且较短，优先使用summary；否则从content提取
              if (item.summary && item.summary.length <= 150) {
                summary = item.summary
              } else {
                summary = textContent.length > 150 
                  ? textContent.substring(0, 150) + '...'
                  : textContent
              }
            }
          } else if (item.summary) {
            // 如果没有content，才使用summary，但也要限制长度
            summary = item.summary.length > 150 
              ? item.summary.substring(0, 150) + '...'
              : item.summary
          }
          
          return {
            id: item.id,
            title: item.title,
            author: item.author,
            date,
            summary,
            content: item.content,
            category: item.category
          }
        })
        
        total.value = newsData.value.length
        currentPage.value = 1
      } else {
        pageTitle.value = '新闻列表'
        newsData.value = []
        total.value = 0
        ElMessage.error(response.data?.message || '加载新闻数据失败')
      }
    } catch (error) {
      console.error('加载新闻数据失败:', error)
      ElMessage.error('加载新闻数据失败: ' + (error.response?.data?.message || error.message || '未知错误'))
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
  
  // 查看详情 - 跳转到详情页
  const handleViewDetail = (item) => {
    // 必须使用 id 作为路由参数
    if (!item.id) {
      ElMessage.warning('该新闻缺少 ID，无法查看详情')
      return
    }
    
    // 构建 from 参数：rootType-id（根据需求，from 格式为 rootType-id）
    const rootType = props.category
    
    // 构建查询参数
    router.push({
      path: `/detail/news/${item.id}`,
      query: { from: `${rootType}-${item.id}` }
    })
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
  
  