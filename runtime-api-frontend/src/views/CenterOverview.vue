<template>
  <div class="center-overview">
    <!-- 视频 Banner -->
    <div class="video-banner">
      <video
        autoplay
        muted
        loop
        playsinline
        class="banner-video"
      >
        <source src="https://guanwang.makabaka.ltd/uploads/20250904/e019f993c966552eb6f9693d7b98eace.mp4" type="video/mp4" />
        您的浏览器不支持视频播放。
      </video>
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
        <!-- 主标题 -->
        <h1 class="main-title">东南大学建筑学院实验教学中心</h1>

        <!-- 建设背景 -->
        <section class="content-section">
          <h2 class="section-title">建设背景</h2>
          <div class="section-content">
            <p>
              东南大学建筑学院实验教学中心（以下简称"中心"）是在整合建筑学院原有各专业实验室的基础上，
              于2025年2月正式成立的综合性实验教学平台。中心致力于为建筑学院各专业的实验教学、科研创新
              和社会服务提供强有力的支撑。
            </p>
          </div>
        </section>

        <!-- 现状概况 -->
        <section class="content-section">
          <h2 class="section-title">现状概况</h2>
          <div class="section-content">
            <p>
              中心现为省级实验教学示范中心，拥有15个核心实验平台，涵盖6大研究方向/教学领域。
              中心现有实体实验室31间，总面积超过2200平方米，配备各类仪器设备1200余台（套），
              设备总值约8000万元，其中大型仪器设备100余台（套），价值约3500万元。
            </p>
            <p>
              中心现有专兼职教师30余人，专职技术人员6人。每年承担实验教学课时数超过2000学时，
              实验项目数超过300项，服务学生人数超过2000人次。
            </p>
            <p>
              中心在实验教学、科研创新、社会服务等方面取得了显著成效，为培养高素质建筑人才
              和推动学科发展做出了重要贡献。
            </p>
          </div>
        </section>

        <!-- 发展愿景 -->
        <section class="content-section">
          <h2 class="section-title">发展愿景</h2>
          <div class="section-content">
            <p>
              中心将继续秉承"以学生为中心，以能力培养为导向"的理念，不断推进实验教学改革与创新，
              努力建设成为国内领先、国际知名的实验教学创新示范中心，为培养具有创新精神和实践能力
              的高素质建筑人才提供更加优质的教学资源和实验环境。
            </p>
          </div>
        </section>

        <!-- 组织架构 -->
        <section class="content-section">
          <h2 class="section-title">组织架构</h2>
          <div class="section-content">
            <div class="organization-structure">
              <div class="org-item">
                <span class="org-label">主任：</span>
                <span class="org-name">王伟</span>
              </div>
              <div class="org-item">
                <span class="org-label">副主任：</span>
                <span class="org-name">华好、冯世虎</span>
              </div>
              <div class="org-item">
                <span class="org-label">成员：</span>
                <span class="org-name">是罪、李超明、兰祥启、刘宇衡、周海飞</span>
              </div>
            </div>
          </div>
        </section>

        <!-- 下设实验室 -->
        <section class="content-section">
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
                      :src="lab.image"
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
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { HomeFilled, Picture } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// 实验室数据
const laboratories = ref([
  {
    id: 1,
    name: '设计基础实训实验室',
    image: 'https://via.placeholder.com/400x200?text=设计基础实训实验室',
    path: '/lab/design-basic'
  },
  {
    id: 2,
    name: '智能建筑实验室',
    image: 'https://via.placeholder.com/400x200?text=智能建筑实验室',
    path: '/lab/smart-building'
  },
  {
    id: 3,
    name: '建筑物理实验室',
    image: 'https://via.placeholder.com/400x200?text=建筑物理实验室',
    path: '/lab/building-physics'
  },
  {
    id: 4,
    name: '城市大数据与虚拟仿真实验室',
    image: 'https://via.placeholder.com/400x200?text=城市大数据与虚拟仿真实验室',
    path: '/lab/urban-bigdata'
  },
  {
    id: 5,
    name: '遗产保护实验室',
    image: 'https://via.placeholder.com/400x200?text=遗产保护实验室',
    path: '/lab/heritage'
  },
  {
    id: 6,
    name: '数字景观实验室',
    image: 'https://via.placeholder.com/400x200?text=数字景观实验室',
    path: '/lab/digital-landscape'
  }
])

// 点击实验室卡片
const handleLabClick = (lab) => {
  // 可以跳转到实验室详情页
  console.log('点击实验室:', lab.name)
  // router.push(lab.path)
}
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

.banner-video {
  width: 100%;
  height: 100%;
  object-fit: cover;
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
</style>
