<template>
  <div class="home-page">
    <div class="banner-container">
      <img 
        src="https://guanwang.makabaka.ltd/uploads/20251114/4d14316aa3a1c172ff536a089e11f35a.png" 
        alt="Banner" 
        class="banner-image"
      />
    </div>
    <div class="content-module">
     
      <div class="page-container">
        <div class="left-area">
            <div class="section-header">
        <div class="header-left">新闻动态</div>
        <div class="header-center">
          <a href="#" class="more-link">查看更多 ></a>
        </div>
      </div>
          <div class="news-carousel">
            <el-carousel :interval="4000" height="300px" indicator-position="outside" arrow="always">
              <el-carousel-item v-for="(item, index) in carouselItems" :key="index">
                <img :src="item.image" :alt="item.title" class="carousel-image" />
              </el-carousel-item>
            </el-carousel>
          </div>
          <div class="news-list">
            <div class="news-item" v-for="(news, index) in newsList" :key="index">
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
        <div class="right-area">
            <div class="header-right">中心服务</div>
          <div class="service-list">
            <div class="service-item" v-for="(service, index) in serviceList" :key="index">
              <div class="service-icon">
                <el-icon :size="40" :color="'#4caf50'">
                  <component :is="service.iconComponent" />
                </el-icon>
              </div>
              <div class="service-text">{{ service.name }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Calendar, Lock, Tools } from '@element-plus/icons-vue'

export default {
  name: 'Home',
  components: {
    Calendar,
    Lock,
    Tools
  },
  data() {
    return {
      carouselItems: [
        {
          image: 'https://guanwang.makabaka.ltd/uploads/20251114/4d14316aa3a1c172ff536a089e11f35a.png',
          title: '2025年东南大学教育部YES项目艺术与媒介国际暑期学校'
        },
        {
          image: 'https://guanwang.makabaka.ltd/uploads/20251114/4d14316aa3a1c172ff536a089e11f35a.png',
          title: '李迎成教授荣获2023年度中国城市规划学会青年科技奖'
        },
        {
          image: 'https://guanwang.makabaka.ltd/uploads/20251114/4d14316aa3a1c172ff536a089e11f35a.png',
          title: '从伟大抗战精神中汲取前行力量'
        }
      ],
      newsList: [
        {
          day: '13',
          month: '10月',
          title: '2025年东南大学教育部YES项目艺术与媒介国际暑期学校圆满结营',
          description: '2025年东南大学教育部YES项目艺术与媒介国际暑期学校于近日圆满结营，来自多个国家的学员参与了此次学习交流活动。'
        },
        {
          day: '12',
          month: '10月',
          title: '李迎成教授荣获2023年度中国城市规划学会青年科技奖',
          description: '李迎成教授凭借在城乡规划领域的突出贡献，荣获2023年度中国城市规划学会青年科技奖。'
        }
      ],
      serviceList: [
        {
          name: '实验设备共享借用',
          iconComponent: Tools
        },
        {
          name: '实验申请与安全准入',
          iconComponent: Lock
        }
      ]
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

.news-carousel {
  margin-bottom: 30px;
  border-radius: 8px;
  overflow: hidden;
}

.news-carousel :deep(.el-carousel) {
  width: 100%;
  border-radius: 8px;
}

.news-carousel :deep(.el-carousel__item) {
  width: 100%;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.page-container {
  padding: 20px;
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
  height: 660px;
}

.news-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.news-item {
  display: flex;
  gap: 15px;
  padding: 15px 0;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: all 0.3s;
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
}

.news-title {
  margin: 0 0 8px 0;
  font-size: 16px;
  font-weight: bold;
  color: #333;
  line-height: 1.4;
  transition: color 0.3s;
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
  height: 660px;
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
  gap: 15px;
  padding: 25px 20px;
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

.service-text {
  font-size: 16px;
  color: #333;
  font-weight: 500;
  line-height: 1.5;
}
</style>

