<template>
  <div class="popular-science-page">
    <div class="banner-container">
      <img 
        src="https://guanwang.makabaka.ltd/uploads/20251114/56a506a92343ceb274924d4e1aa1bc58.png" 
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
                <p class="news-desc">{{ news.description }}</p>
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
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AnnouncementList from '@/components/AnnouncementList.vue'

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
  if (!item.id) {
    console.warn('轮播图项缺少 ID，无法跳转')
    return
  }
  // 科普教育页面的轮播图，from 参数设置为 "popular-science"
  router.push({
    path: `/detail/news/${item.id}`,
    query: { from: 'popular-science' }
  })
}

const carouselItems = ref([
  {
    id: '1',
    image: 'https://guanwang.makabaka.ltd/uploads/20251114/56a506a92343ceb274924d4e1aa1bc58.png',
    title: '科普活动1'
  },
  {
    id: '2',
    image: 'https://guanwang.makabaka.ltd/uploads/20251114/56a506a92343ceb274924d4e1aa1bc58.png',
    title: '科普活动2'
  },
  {
    id: '3',
    image: 'https://guanwang.makabaka.ltd/uploads/20251114/56a506a92343ceb274924d4e1aa1bc58.png',
    title: '科普活动3'
  }
])

const newsList = ref([
  {
    id: '1',
    title: '科普教育活动成功举办',
    description: '本次科普教育活动吸引了众多师生参与，活动内容丰富，取得了良好的效果。'
  },
  {
    id: '2',
    title: '科普知识竞赛圆满结束',
    description: '科普知识竞赛于近日圆满结束，参赛选手表现优异，展现了良好的科学素养。'
  },
  {
    id: '3',
    title: '科普讲座：探索科学奥秘',
    description: '邀请知名专家开展科普讲座，为师生带来精彩的科学知识分享。'
  },
  {
    id: '4',
    title: '科普展览活动启动',
    description: '科普展览活动正式启动，展示多项科技成果和科普知识，欢迎师生参观。'
  }
])

const announcementList = ref([
  {
    id: '4',
    title: '实验教学中心科普基地开放管理制度',
    description: '实验教学中心科普基地开放管理制度基本描述',
    date: '2025-10-15'
  }
])
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
  margin: 0 0 8px 0;
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

.news-desc {
  margin: 0;
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
  
  