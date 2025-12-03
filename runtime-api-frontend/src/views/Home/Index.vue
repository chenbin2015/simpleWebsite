<template>
  <div class="home-page">
    <div class="banner-container">
      <img 
        v-if="bannerImage"
        :src="bannerImage" 
        alt="Banner" 
        class="banner-image"
      />
      <div v-else class="banner-placeholder">
        <span>暂无Banner图</span>
      </div>
    </div>
    <div class="content-module">
     
      <div class="page-container">
        <div class="left-area">
            <div class="section-header">
        <div class="header-left">新闻动态</div>
        <div class="header-center">
          <a href="#" class="more-link" @click.prevent="handleViewMoreNews">查看更多 ></a>
        </div>
      </div>
          <div class="news-content-wrapper">
            <div class="news-carousel">
              <el-carousel :interval="4000" height="400px" indicator-position="outside" arrow="always">
                <el-carousel-item v-for="(item, index) in carouselItems" :key="index">
                  <div class="carousel-wrapper">
                    <img 
                      :src="item.image" 
                      :alt="item.title" 
                      class="carousel-image"
                      @click="handleCarouselClick(item)"
                    />
                    <div class="carousel-overlay" v-if="item.title || item.description">
                      <h3 class="carousel-title" v-if="item.title">{{ item.title }}</h3>
                      <p class="carousel-description" v-if="item.description">{{ item.description }}</p>
                    </div>
                  </div>
                </el-carousel-item>
              </el-carousel>
            </div>
            <div class="news-list">
              <div 
                class="news-item" 
                v-for="(news, index) in newsList" 
                :key="index"
                @click="handleNewsClick(news)"
              >
                <div class="news-date">
                  <div class="date-day">{{ news.day }}</div>
                  <div class="date-month">{{ news.month }}</div>
                </div>
                <div class="news-content">
                  <h3 class="news-title">{{ news.title }}</h3>
                  <p class="news-desc">{{ news.description }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="right-area">
            <div class="header-right">中心服务</div>
          <div class="service-list">
            <div 
              class="service-item" 
              v-for="(service, index) in serviceList" 
              :key="index"
              @click="handleServiceClick(service)"
            >
              <div class="service-icon">
                <el-icon :size="50" :color="'#4caf50'">
                  <component :is="service.iconComponent" />
                </el-icon>
              </div>
              <div class="service-text">{{ service.name }}</div>
            </div>
          </div>
        </div>
      </div>
      <!-- 通知公告区域 -->
      <AnnouncementList 
        title="通知公告"
        :list="announcementList"
        more-link="#"
        from="home"
      />
    </div>
  </div>
</template>

<script>
import { Calendar, Lock, Tools } from '@element-plus/icons-vue'
import AnnouncementList from '@/components/AnnouncementList.vue'
import { 
  getBanner, 
  getCarouselList, 
  getNewsList, 
  getAnnouncementList 
} from '@/services/publicHomeApi'
import { ElMessage } from 'element-plus'

export default {
  name: 'Home',
  components: {
    Calendar,
    Lock,
    Tools,
    AnnouncementList
  },
  data() {
    return {
      bannerImage: null,
      carouselItems: [],
      newsList: [],
      serviceList: [
        {
          name: '实验设备共享借用',
          iconComponent: Tools,
          url: 'https://jzxy.seu.edu.cn/wpjy/'
        },
        {
          name: '实验申请与安全准入',
          iconComponent: Lock,
          url: 'https://10.201.0.173:8443/lspcp-web/board'
        }
      ],
      announcementList: [],
      loading: false
    }
  },
  async mounted() {
    await this.loadHomeData()
  },
  methods: {
    async loadHomeData() {
      this.loading = true
      try {
        // 并行加载所有数据
        await Promise.all([
          this.loadBanner(),
          this.loadCarousel(),
          this.loadNews(),
          this.loadAnnouncements()
        ])
      } catch (error) {
        console.error('加载首页数据失败:', error)
        ElMessage.error('加载首页数据失败，请稍后重试')
      } finally {
        this.loading = false
      }
    },
    async loadBanner() {
      try {
        const response = await getBanner()
        if (response.data.success && response.data.data) {
          this.bannerImage = response.data.data.imageUrl
        }
      } catch (error) {
        console.error('加载Banner失败:', error)
      }
    },
    async loadCarousel() {
      try {
        const response = await getCarouselList()
        if (response.data.success && response.data.data) {
          this.carouselItems = response.data.data.map(item => ({
            id: item.id,
            image: item.image,
            title: item.title,
            description: item.description,
            link: item.link
          }))
        }
      } catch (error) {
        console.error('加载轮播图失败:', error)
      }
    },
    async loadNews() {
      try {
        const response = await getNewsList({ page: 1, pageSize: 4 })
        if (response.data.success && response.data.data) {
          this.newsList = response.data.data.map(news => {
            // 解析日期
            let day = ''
            let month = ''
            if (news.publishTime) {
              const date = new Date(news.publishTime)
              day = date.getDate().toString()
              month = `${date.getMonth() + 1}月`
            } else if (news.createdAt) {
              const date = new Date(news.createdAt)
              day = date.getDate().toString()
              month = `${date.getMonth() + 1}月`
            }
            
            // 直接使用描述字段
            let description = news.description || ''
            
            return {
              id: news.id,
              day,
              month,
              title: news.title,
              description
            }
          })
        }
      } catch (error) {
        console.error('加载新闻失败:', error)
      }
    },
    async loadAnnouncements() {
      try {
        const response = await getAnnouncementList({ page: 1, pageSize: 4 })
        if (response.data.success && response.data.data) {
          this.announcementList = response.data.data.map(announcement => {
            // 优先使用后端的描述字段，如果没有则从内容中提取
            let description = announcement.description || ''
            if (!description && announcement.content) {
              const textContent = announcement.content.replace(/<[^>]*>/g, '').trim()
              if (textContent) {
                description = textContent.length > 50 
                  ? textContent.substring(0, 50) + '...'
                  : textContent
              }
            }
            // 如果还是没有描述，使用标题作为后备
            if (!description) {
              description = announcement.title
            }
            
            // 解析日期
            let date = ''
            if (announcement.publishTime) {
              date = announcement.publishTime.split('T')[0]
            } else if (announcement.createdAt) {
              date = announcement.createdAt.split('T')[0]
            }
            
            return {
              id: announcement.id,
              title: announcement.title,
              description,
              date
            }
          })
        }
      } catch (error) {
        console.error('加载公告失败:', error)
      }
    },
    handleNewsClick(news) {
      if (!news.id) {
        console.warn('新闻项缺少 ID，无法跳转')
        return
      }
      // 首页的新闻，from 参数设置为 "home"
      this.$router.push({
        path: `/detail/news/${news.id}`,
        query: { from: 'home' }
      })
    },
    handleServiceClick(service) {
      if (service.url) {
        window.open(service.url, '_blank')
      }
    },
    handleCarouselClick(item) {
      // 如果有链接地址，直接跳转
      if (item.link) {
        if (item.link.startsWith('http://') || item.link.startsWith('https://')) {
          window.open(item.link, '_blank')
        } else {
          this.$router.push(item.link)
        }
        return
      }
      
      // 如果没有链接，但有ID，跳转到新闻详情
      if (item.id) {
        this.$router.push({
          path: `/detail/news/${item.id}`,
          query: { from: 'home' }
        })
      }
    },
    handleViewMoreNews() {
      // 跳转到通用列表页面，显示所有新闻
      this.$router.push({
        path: '/common-list',
        query: { type: 'news', from: 'home' }
      })
    },
    handleViewMoreAnnouncement() {
      // 跳转到通用列表页面，显示所有公告
      this.$router.push({
        path: '/common-list',
        query: { type: 'announcement', from: 'home' }
      })
    }
  }
}
</script>

<style scoped>
.home-page {
  width: 100%;
}

.content-module {
  max-width: 1600px;
  margin: 0 auto;
  width: 100%;
}

.section-header {
  padding: 0 20px 20px 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  border-bottom: 2px solid #ffd700;
  padding-bottom: 20px;
  margin-bottom: 20px;
}

.header-left {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.header-center {
  text-align: center;
}

.more-link {
  color: #4caf50;
  text-decoration: none;
  font-size: 16px;
}

.more-link:hover {
  text-decoration: underline;
}

.header-right {
  font-size: 24px;
  font-weight: bold;
  color: #333;
  border-bottom: 2px solid #ffd700;
  padding-bottom: 20px;
  margin-bottom: 20px;
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

.banner-placeholder {
  width: 100%;
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #999;
  font-size: 16px;
}

.news-content-wrapper {
  display: flex;
  gap: 20px;
  height: 100%;
}

.news-carousel {
  width: 50%;
  flex: 0 0 50%;
  overflow: hidden;
}

.news-carousel :deep(.el-carousel) {
  width: 100%;
  height: 100%;
}

.news-carousel :deep(.el-carousel__item) {
  width: 100%;
}

.carousel-wrapper {
  position: relative;
  width: 100%;
  height: 100%;
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

.carousel-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0));
  color: #fff;
  padding: 30px 20px 20px;
  box-sizing: border-box;
}

.carousel-title {
  margin: 0 0 10px 0;
  font-size: 18px;
  font-weight: bold;
  color: #fff;
  line-height: 1.4;
}

.carousel-description {
  margin: 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.page-container {
  padding: 20px 0;
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

.left-area {
  width: 70%;
  flex: 0 0 70%;
  background-color: #fff;
  padding: 20px;
  box-sizing: border-box;
  height: 520px;
  display: flex;
  flex-direction: column;
}

.news-list {
  width: 50%;
  flex: 0 0 50%;
  display: flex;
  flex-direction: column;
  gap: 15px;
  overflow: hidden;
}

.news-item {
  display: flex;
  gap: 15px;
  padding: 0px 0 26px;
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

.news-date {
  flex-shrink: 0;
  width: 60px;
  height: 60px;
  background-color: #90ee90;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #333;
}

.date-day {
  font-size: 20px;
  font-weight: bold;
  line-height: 1;
}

.date-month {
  font-size: 12px;
  margin-top: 4px;
}

.news-content {

  flex: 1;
  margin-right: 20px;
  height: 65px;
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
  width:450px
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

.right-area {
  width: 30%;
  flex: 0 0 30%;
  background-color: #fff;
  padding: 20px;
  box-sizing: border-box;
  height: 520px;
  display: flex;
  flex-direction: column;
}

.service-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
  flex: 1;
}

.service-item {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  padding: 30px 20px;
  background-color: #f5f5f5;
  border-radius: 8px;
  transition: all 0.3s;
  cursor: pointer;
  flex: 1;
  min-height: 0;
}

.service-item:hover {
  background-color: #e8f5e9;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.service-icon {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.service-icon :deep(.el-icon) {
  font-size: 50px !important;
  width: 50px;
  height: 50px;
}

.service-text {
  font-size: 20px;
  color: #333;
  font-weight: 500;
  line-height: 1.5;
}

</style>

