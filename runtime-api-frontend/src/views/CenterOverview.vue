<template>
  <div class="center-overview">
    <!-- Banner -->
    <div class="video-banner">
      <!-- 视频 Banner -->
      <video
        v-if="bannerData && bannerData.type === 'video' && (bannerData.videoUrl || bannerData.videoUrlExternal)"
        autoplay
        muted
        loop
        playsinline
        class="banner-video"
      >
        <source :src="getVideoUrl(bannerData)" type="video/mp4" />
        您的浏览器不支持视频播放。
      </video>
      <!-- 图片 Banner -->
      <img
        v-else-if="bannerData && bannerData.type === 'image' && bannerData.imageUrl"
        :src="getImageUrl(bannerData.imageUrl)"
        alt="Banner"
        class="banner-image"
      />
      <div v-else class="banner-placeholder">
        <span>暂无Banner</span>
      </div>
      <div class="video-overlay">
        <div class="breadcrumb">
          <el-icon><HomeFilled /></el-icon>
          <span>首页 / 中心概况</span>
        </div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="content-wrapper">
      <div class="content-container">
        <!-- 加载状态 -->
        <div v-if="loading" class="loading">
          <p>加载中...</p>
        </div>
        
        <!-- 内容 -->
        <template v-else>
          <!-- 主标题 -->
          <h1 class="main-title">{{ detailData?.mainTitle || '东南大学建筑学院实验教学中心' }}</h1>

          <!-- 建设背景 -->
          <section v-if="detailData?.background" class="content-section">
            <h2 class="section-title">建设背景</h2>
            <div class="section-content" v-html="detailData.background"></div>
          </section>

          <!-- 现状概况 -->
          <section v-if="detailData?.overview" class="content-section">
            <h2 class="section-title">现状概况</h2>
            <div class="section-content" v-html="detailData.overview"></div>
          </section>

          <!-- 发展愿景 -->
          <section v-if="detailData?.vision" class="content-section">
            <h2 class="section-title">发展愿景</h2>
            <div class="section-content" v-html="detailData.vision"></div>
          </section>

          <!-- 组织架构 -->
          <section v-if="organizationData && Object.keys(organizationData).length > 0" class="content-section">
            <h2 class="section-title">组织架构</h2>
            <div class="section-content">
              <div class="organization-structure">
                <div
                  v-for="(members, role) in organizationData"
                  :key="role"
                  class="org-item"
                >
                  <span class="org-label">{{ role }}：</span>
                  <span class="org-name">{{ members.map(m => m.name).join('、') }}</span>
                </div>
              </div>
            </div>
          </section>
        </template>

        <!-- 下设实验室 -->
        <section v-if="laboratories.length > 0" class="content-section">
          <h2 class="section-title">下设实验室</h2>
          <div class="section-content">
            <el-row :gutter="20" class="lab-grid">
              <el-col
                v-for="lab in laboratories"
                :key="lab.id"
                :xs="24"
                :sm="12"
                :md="8"
              >
                <el-card
                  shadow="hover"
                  class="lab-card"
                  @click="handleLabClick(lab)"
                >
                  <div class="lab-image">
                    <el-image
                      :src="getLabImageUrl(lab.imageUrl)"
                      fit="cover"
                      style="width: 100%; height: 200px;"
                    >
                      <template #error>
                        <div class="image-slot">
                          <el-icon><Picture /></el-icon>
                        </div>
                      </template>
                    </el-image>
                  </div>
                  <div class="lab-title">{{ lab.name }}</div>
                </el-card>
              </el-col>
            </el-row>
          </div>
        </section>
      </div>
    </div>
    
    <!-- 实验室详情对话框 -->
    <el-dialog
      v-model="labDetailVisible"
      :title="selectedLab?.name || '实验室详情'"
      width="80%"
      :close-on-click-modal="false"
    >
      <div v-if="selectedLab" class="lab-detail-content">
        <div v-if="selectedLab.imageUrl" class="lab-detail-image">
          <el-image
            :src="getLabImageUrl(selectedLab.imageUrl)"
            fit="cover"
            style="width: 100%; max-height: 400px;"
          />
        </div>
        <div v-if="selectedLab.detail" class="lab-detail-text" v-html="selectedLab.detail"></div>
        <div v-else class="lab-detail-empty">
          <p>暂无详情信息</p>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { HomeFilled, Picture } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  getBanner,
  getDetail,
  getOrganization,
  getLaboratoryList
} from '@/services/publicCenterOverviewApi'
import { buildImageUrl } from '@/utils/url'

const router = useRouter()

// 数据状态
const loading = ref(true)
const bannerData = ref(null)
const detailData = ref(null)
const organizationData = ref({})
const laboratories = ref([])

// 实验室详情对话框
const labDetailVisible = ref(false)
const selectedLab = ref(null)

// 加载所有数据
const loadData = async () => {
  loading.value = true
  try {
    await Promise.all([
      loadBanner(),
      loadDetail(),
      loadOrganization(),
      loadLaboratories()
    ])
  } catch (error) {
    console.error('加载中心概况数据失败:', error)
    ElMessage.error('加载数据失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 加载Banner
const loadBanner = async () => {
  try {
    const response = await getBanner()
    if (response.data.success && response.data.data) {
      bannerData.value = response.data.data
    }
  } catch (error) {
    console.error('加载Banner失败:', error)
  }
}

// 加载详情
const loadDetail = async () => {
  try {
    const response = await getDetail()
    if (response.data.success && response.data.data) {
      detailData.value = response.data.data
    }
  } catch (error) {
    console.error('加载详情失败:', error)
  }
}

// 加载组织架构
const loadOrganization = async () => {
  try {
    const response = await getOrganization()
    if (response.data.success && response.data.data) {
      organizationData.value = response.data.data
    }
  } catch (error) {
    console.error('加载组织架构失败:', error)
  }
}

// 加载实验室列表
const loadLaboratories = async () => {
  try {
    const response = await getLaboratoryList()
    if (response.data.success && response.data.data) {
      laboratories.value = response.data.data
    }
  } catch (error) {
    console.error('加载实验室列表失败:', error)
  }
}

// 获取图片URL
const getImageUrl = (imageUrl) => {
  return buildImageUrl(imageUrl)
}

// 获取视频URL
const getVideoUrl = (banner) => {
  if (banner.videoUrlExternal) {
    return banner.videoUrlExternal
  }
  if (banner.videoUrl) {
    return getImageUrl(banner.videoUrl)
  }
  return ''
}

// 获取实验室图片URL
const getLabImageUrl = (imageUrl) => {
  return getImageUrl(imageUrl)
}

// 点击实验室卡片
const handleLabClick = (lab) => {
  // 优先显示详情（如果有富文本详情）
  if (lab.detail && lab.detail.trim()) {
    selectedLab.value = lab
    labDetailVisible.value = true
    return
  }
  
  // 如果有链接，则跳转
  if (lab.link) {
    if (lab.link.startsWith('http://') || lab.link.startsWith('https://')) {
      window.open(lab.link, '_blank')
    } else {
      router.push(lab.link)
    }
    return
  }
  
  // 既没有详情也没有链接，显示提示
  ElMessage.info('该实验室暂无详情信息')
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.center-overview {
  width: 100%;
}

/* 视频 Banner */
.video-banner {
  position: relative;
  width: 100%;
  height: 500px;
  overflow: hidden;
  background-color: #000;
}

.banner-video,
.banner-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.banner-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f5f5;
  color: #999;
  font-size: 16px;
}

.video-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.1));
  display: flex;
  align-items: flex-start;
  padding: 20px 40px;
}

.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  color: white;
  font-size: 16px;
  background-color: rgba(0, 0, 0, 0.5);
  padding: 8px 16px;
  border-radius: 4px;
}

.breadcrumb .el-icon {
  font-size: 18px;
}

/* 内容区域 */
.loading {
  text-align: center;
  padding: 40px;
  color: #666;
}

.content-wrapper {
  background-color: #fff;
  padding: 40px 0;
}

.content-container {
  max-width: 1600px;
  margin: 0 auto;
  padding: 0 20px;
}

.main-title {
  font-size: 32px;
  font-weight: bold;
  color: #303133;
  text-align: center;
  margin: 0 0 40px;
  padding-bottom: 20px;
  border-bottom: 2px solid #ebeef5;
}

.content-section {
  margin-bottom: 50px;
}

.section-title {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  margin: 0 0 20px;
  padding-left: 15px;
  border-left: 4px solid #409eff;
}

.section-content {
  color: #606266;
  line-height: 1.8;
  font-size: 16px;
}

/* Quill 样式支持 */
.section-content :deep(.ql-align-center) {
  text-align: center !important;
}

.section-content :deep(.ql-align-right) {
  text-align: right !important;
}

.section-content :deep(.ql-align-left) {
  text-align: left !important;
}

.section-content :deep(.ql-align-justify) {
  text-align: justify !important;
}

.section-content p {
  margin: 15px 0;
  text-align: justify;
}

/* 组织架构 */
.organization-structure {
  padding: 20px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.org-item {
  margin: 15px 0;
  font-size: 16px;
  line-height: 1.8;
}

.org-label {
  font-weight: bold;
  color: #303133;
  margin-right: 10px;
}

.org-name {
  color: #606266;
}

/* 实验室卡片 */
.lab-grid {
  margin-top: 20px;
}

.lab-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
  border-radius: 8px;
  overflow: hidden;
}

.lab-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.lab-image {
  margin-bottom: 15px;
  border-radius: 4px;
  overflow: hidden;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 200px;
  background: #f5f7fa;
  color: #909399;
}

.lab-title {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  text-align: center;
  padding: 10px 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .video-banner {
    height: 300px;
  }

  .video-overlay {
    padding: 15px 20px;
  }

  .breadcrumb {
    font-size: 14px;
    padding: 6px 12px;
  }

  .main-title {
    font-size: 24px;
    margin-bottom: 30px;
  }

  .section-title {
    font-size: 20px;
  }

  .section-content {
    font-size: 14px;
  }

  .content-container {
    padding: 0 15px;
  }
}

/* 实验室详情对话框 */
.lab-detail-content {
  padding: 10px 0;
}

.lab-detail-image {
  margin-bottom: 20px;
  text-align: center;
}

.lab-detail-text {
  line-height: 1.8;
  font-size: 16px;
  color: #606266;
}

.lab-detail-text :deep(img) {
  max-width: 100%;
  height: auto;
  margin: 10px 0;
}

.lab-detail-text :deep(video) {
  max-width: 100%;
  height: auto;
  margin: 10px 0;
}

.lab-detail-empty {
  text-align: center;
  padding: 40px;
  color: #909399;
}
</style>
