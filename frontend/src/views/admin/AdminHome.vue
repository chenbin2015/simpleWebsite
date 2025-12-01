<template>
  <div class="admin-home">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>首页管理</h2>
        </div>
      </template>
      
      <el-tabs v-model="activeTab" type="card">
        <!-- Banner图管理 -->
        <el-tab-pane label="Banner图管理" name="banner">
          <div class="tab-content">
            <HomeBannerManagement />
          </div>
        </el-tab-pane>
        
        <!-- 轮播图管理 -->
        <el-tab-pane label="轮播图管理" name="carousel">
          <div class="tab-content">
            <HomeCarouselManagement />
          </div>
        </el-tab-pane>
        
        <!-- 新闻列表管理 -->
        <el-tab-pane label="新闻列表管理" name="news">
          <div class="tab-content">
            <HomeNewsManagement />
          </div>
        </el-tab-pane>
        
        <!-- 公告管理 -->
        <el-tab-pane label="公告管理" name="announcement">
          <div class="tab-content">
            <HomeAnnouncementManagement />
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import HomeBannerManagement from '@/components/admin/HomeBannerManagement.vue'
import HomeCarouselManagement from '@/components/admin/HomeCarouselManagement.vue'
import HomeNewsManagement from '@/components/admin/HomeNewsManagement.vue'
import HomeAnnouncementManagement from '@/components/admin/HomeAnnouncementManagement.vue'

// Tab切换
const activeTab = ref('banner')
</script>

<style scoped>
.admin-home {
  padding: 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  font-size: 20px;
  font-weight: bold;
}

.tab-content {
  padding: 20px 0;
}
</style>