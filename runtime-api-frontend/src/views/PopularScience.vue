<template>
  <div class="popular-science-page">
    <div class="banner-container">
      <img 
        :src="bannerImage" 
        alt="Banner" 
        class="banner-image"
      />
    </div>
    <div class="page-container">
      <div class="content-wrapper">
        <div class="left-area">
          <div class="news-carousel">
            <el-carousel :interval="4000" height="400px" indicator-position="outside" arrow="always">
              <el-carousel-item v-for="(item, index) in carouselItems" :key="index">
                <img 
                  :src="item.image" 
                  :alt="item.title" 
                  class="carousel-image"
                  @click="handleCarouselClick(item)"
                />
              </el-carousel-item>
            </el-carousel>
          </div>
        </div>
        <div class="right-area">
          <div class="news-header">
            <h2 class="module-title">新闻动态</h2>
            <a href="#" class="more-link" @click.prevent="handleViewMoreNews">查看更多 ></a>
          </div>
          <div class="news-list">
            <div 
              class="news-item" 
              v-for="(news, index) in newsList" 
              :key="index"
              @click="handleNewsClick(news)"
            >
              <div class="news-content">
                <h3 class="news-title">{{ news.title }}</h3>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- 通知公告区域 -->
      <AnnouncementList 
        title="参会公告"
        :list="announcementList"
        more-link="#"
        from="popular-science"
      />
    </div>
  </div>
</template>
  
<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import AnnouncementList from '@/components/AnnouncementList.vue'
import { getBanner, getCarouselList, getArticleList, getAnnouncementList } from '@/services/publicPopularScienceApi'
import { buildImageUrl } from '@/utils/url'

const router = useRouter()

const handleNewsClick = (news) => {
  if (!news.id) {
    return
  }
  router.push({
    path: `/detail/news/${news.id}`,
    query: { from: 'popular-science' }
  })
}

const handleViewMoreNews = () => {
  // 跳转到通用列表页面，显示所有新闻
  router.push({
    path: '/common-list',
    query: { type: 'news', from: 'popular-science' }
  })
}

const handleCarouselClick = (item) => {
  // 如果轮播图有link，优先使用link
  if (item.link) {
    if (item.link.startsWith('http://') || item.link.startsWith('https://')) {
      window.open(item.link, '_blank')
    } else {
      router.push(item.link)
    }
    return
  }
  
  // 如果没有link但有id，跳转到详情页
  if (item.id) {
    router.push({
      path: `/detail/news/${item.id}`,
      query: { from: 'popular-science' }
    })
    return
  }
  
  console.warn('轮播图项缺少 ID 和 link，无法跳转')
}

// Banner数据
const bannerImage = ref('https://guanwang.makabaka.ltd/uploads/20251114/56a506a92343ceb274924d4e1aa1bc58.png')

// 轮播图数据
const carouselItems = ref([])

// 新闻列表
const newsList = ref([])

// 公告列表
const announcementList = ref([])

// 加载Banner
const loadBanner = async () => {
  try {
    const response = await getBanner()
    if (response.data && response.data.success && response.data.data) {
      const imageUrl = response.data.data.imageUrl
      if (imageUrl) {
        // 构建完整URL
        bannerImage.value = buildImageUrl(imageUrl)
      }
    }
  } catch (error) {
    console.error('加载Banner失败:', error)
    // 静默失败，使用默认Banner
  }
}

// 加载轮播图
const loadCarousel = async () => {
  try {
    const response = await getCarouselList()
    if (response.data && response.data.success && response.data.data) {
      const items = response.data.data || []
      carouselItems.value = items.map(item => {
        // 构建完整图片URL
        let imageUrl = buildImageUrl(item.image)
        
        return {
          id: String(item.id),
          image: imageUrl || '',
          title: item.title || '',
          link: item.link || ''
        }
      })
    }
  } catch (error) {
    console.error('加载轮播图失败:', error)
    ElMessage.warning('加载轮播图失败')
  }
}

// 加载新闻列表
const loadNews = async () => {
  try {
    const response = await getArticleList({ page: 1, pageSize: 4 })
    if (response.data && response.data.success && response.data.data) {
      const items = response.data.data || []
      newsList.value = items.map(item => {
        // 提取摘要
        let description = ''
        if (item.content) {
          const textContent = item.content.replace(/<[^>]*>/g, '').trim()
          if (textContent) {
            description = textContent.length > 100 
              ? textContent.substring(0, 100) + '...'
              : textContent
          }
        }
        
        return {
          id: String(item.id),
          title: item.title || '',
          description: description
        }
      })
    }
  } catch (error) {
    console.error('加载新闻列表失败:', error)
    ElMessage.warning('加载新闻列表失败')
  }
}

// 加载公告列表
const loadAnnouncements = async () => {
  try {
    const response = await getAnnouncementList({ page: 1, pageSize: 5 })
    if (response.data && response.data.success && response.data.data) {
      const items = response.data.data || []
      announcementList.value = items.map(item => {
        // 提取摘要
        let description = ''
        if (item.content) {
          const textContent = item.content.replace(/<[^>]*>/g, '').trim()
          if (textContent) {
            description = textContent.length > 100 
              ? textContent.substring(0, 100) + '...'
              : textContent
          }
        }
        
        // 解析日期
        let date = ''
        if (item.publishTime) {
          date = item.publishTime.split('T')[0]
        } else if (item.createdAt) {
          date = item.createdAt.split('T')[0]
        }
        
        return {
          id: String(item.id),
          title: item.title || '',
          description: description,
          date: date
        }
      })
    }
  } catch (error) {
    console.error('加载公告列表失败:', error)
    ElMessage.warning('加载公告列表失败')
  }
}

// 初始化加载数据
onMounted(async () => {
  await Promise.all([
    loadBanner(),
    loadCarousel(),
    loadNews(),
    loadAnnouncements()
  ])
})
</script>
  
<style scoped>
.popular-science-page {
  width: 100%;
}

.banner-container {
  width: 100%;
  overflow: hidden;
}

.banner-image {
  width: 100%;
  height: auto;
  display: block;
}

.page-container {
  max-width: 1600px;
  margin: 0 auto;
  padding: 20px;
}

.content-wrapper {
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

.left-area {
  width: 50%;
  flex: 0 0 50%;
}

.news-carousel {
  border-radius: 8px;
  overflow: hidden;
}

.news-carousel :deep(.el-carousel) {
  width: 100%;
  border-radius: 8px;
  height: 100%;
}

.news-carousel :deep(.el-carousel__item) {
  width: 100%;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  cursor: pointer;
  transition: opacity 0.3s;
}

.carousel-image:hover {
  opacity: 0.9;
}

.right-area {
  width: 50%;
  flex: 0 0 50%;
  display: flex;
  flex-direction: column;
}

.news-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 2px solid #4caf50;
}

.module-title {
  margin: 0;
  font-size: 20px;
  font-weight: bold;
  color: #333;
}

.more-link {
  font-size: 14px;
  color: #666;
  text-decoration: none;
  transition: color 0.3s;
}

.more-link:hover {
  color: #4caf50;
}

.news-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
  flex: 1;
}

.news-item {
  padding: 12px 0;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: all 0.3s;
  flex-shrink: 0;
}

.news-item:last-child {
  border-bottom: none;
}

.news-item:hover {
  padding-left: 5px;
}

.news-item:hover .news-title {
  color: #4caf50;
}

.news-content {
  width: 100%;
}

.news-title {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
  color: #333;
  line-height: 1.4;
  transition: color 0.3s;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 100%;
}
</style>
  
  