<template>
  <div class="home-page">
    <!-- 欢迎横幅 -->
    <section class="hero-section">
      <div class="hero-content">
        <h1 class="hero-title">快速构建专业企业网站</h1>
        <p class="hero-subtitle">简单、高效、专业的网站建设平台，让您的企业快速拥有专业网站</p>
        <div class="hero-actions">
          <el-button type="primary" size="large" @click="goToRegister" v-if="!currentUser">
            免费开始
          </el-button>
          <el-button type="success" size="large" plain @click="scrollToFeatures">
            了解更多
          </el-button>
        </div>
      </div>
    </section>

    <!-- 用户信息卡片 -->
    <section class="user-section" v-if="currentUser">
      <div class="container">
        <el-card class="user-card">
          <template #header>
            <div class="card-header">
              <h3>欢迎回来, {{ currentUser.username }}!</h3>
            </div>
          </template>
          <el-descriptions :column="2" border>
            <el-descriptions-item label="用户名">{{ currentUser.username }}</el-descriptions-item>
            <el-descriptions-item label="邮箱">{{ currentUser.email }}</el-descriptions-item>
            <el-descriptions-item label="邮箱验证" :span="2">
              <el-tag :type="currentUser.emailVerified ? 'success' : 'warning'">
                {{ currentUser.emailVerified ? '已验证' : '未验证' }}
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
        </el-card>
      </div>
    </section>

    <!-- 功能特性 -->
    <section id="features" class="features-section">
      <div class="container">
        <h2 class="section-title">核心功能特性</h2>
        <p class="section-subtitle">为企业提供全方位的网站建设解决方案</p>
        <div class="features-grid">
          <el-card class="feature-card" shadow="hover">
            <div class="feature-icon">🚀</div>
            <h3>快速部署</h3>
            <p>几分钟内完成网站搭建，无需技术背景，轻松上手</p>
          </el-card>
          <el-card class="feature-card" shadow="hover">
            <div class="feature-icon">🎨</div>
            <h3>精美模板</h3>
            <p>丰富的专业模板库，满足不同行业和风格需求</p>
          </el-card>
          <el-card class="feature-card" shadow="hover">
            <div class="feature-icon">📱</div>
            <h3>响应式设计</h3>
            <p>完美适配PC、平板、手机等各类设备，提升用户体验</p>
          </el-card>
          <el-card class="feature-card" shadow="hover">
            <div class="feature-icon">🔒</div>
            <h3>安全可靠</h3>
            <p>企业级安全保障，数据加密存储，让您放心使用</p>
          </el-card>
          <el-card class="feature-card" shadow="hover">
            <div class="feature-icon">⚡</div>
            <h3>高性能</h3>
            <p>优化的服务器架构，确保网站快速加载和稳定运行</p>
          </el-card>
          <el-card class="feature-card" shadow="hover">
            <div class="feature-icon">🛠️</div>
            <h3>易于管理</h3>
            <p>直观的后台管理系统，轻松管理网站内容和设置</p>
          </el-card>
        </div>
      </div>
    </section>

    <!-- 关于我们 -->
    <section id="about" class="about-section">
      <div class="container">
        <h2 class="section-title">关于企业建站平台</h2>
        <div class="about-content">
          <div class="about-text">
            <p>企业建站平台致力于为企业提供简单、高效、专业的网站建设服务。我们相信，每个企业都应该拥有一个专业、美观的网站来展示自己的品牌和业务。</p>
            <p>无论您是初创企业还是成熟公司，我们都能为您提供最适合的网站建设解决方案。让您的企业在互联网时代脱颖而出。</p>
          </div>
          <div class="about-stats">
            <div class="stat-item">
              <div class="stat-number">1000+</div>
              <div class="stat-label">企业用户</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">5000+</div>
              <div class="stat-label">网站案例</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">99.9%</div>
              <div class="stat-label">服务可用性</div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: 'Home',
  data() {
    return {
      currentUser: null
    }
  },
  mounted() {
    this.loadUser()
  },
  methods: {
    loadUser() {
      const userStr = localStorage.getItem('user')
      if (userStr) {
        try {
          this.currentUser = JSON.parse(userStr)
        } catch (e) {
          localStorage.removeItem('user')
          this.currentUser = null
        }
      } else {
        this.currentUser = null
      }
    },
    goToRegister() {
      this.$router.push('/register')
    },
    scrollToFeatures() {
      document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })
    }
  }
}
</script>

<style scoped>
.home-page {
  width: 100%;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

/* 欢迎横幅 */
.hero-section {
  background: linear-gradient(135deg, #34495E 0%, #2C3E50 100%);
  color: #ECF0F1;
  padding: 80px 24px;
  text-align: center;
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.hero-title {
  font-size: 48px;
  font-weight: 700;
  margin-bottom: 24px;
  line-height: 1.2;
}

.hero-subtitle {
  font-size: 20px;
  margin-bottom: 40px;
  opacity: 0.9;
  line-height: 1.6;
}

.hero-actions {
  display: flex;
  gap: 16px;
  justify-content: center;
  flex-wrap: wrap;
}

/* 用户信息卡片 */
.user-section {
  padding: 40px 0;
  background: white;
}

.user-card {
  max-width: 800px;
  margin: 0 auto;
}

.card-header h3 {
  margin: 0;
  color: #303133;
}

/* 功能特性 */
.features-section {
  padding: 80px 0;
  background: white;
}

.section-title {
  font-size: 36px;
  font-weight: 700;
  text-align: center;
  margin-bottom: 16px;
  color: #303133;
}

.section-subtitle {
  text-align: center;
  font-size: 18px;
  color: #909399;
  margin-bottom: 60px;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  margin-top: 40px;
}

.feature-card {
  text-align: center;
  padding: 32px 24px;
  transition: transform 0.3s;
}

.feature-card:hover {
  transform: translateY(-8px);
}

.feature-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.feature-card h3 {
  font-size: 20px;
  margin-bottom: 12px;
  color: #303133;
}

.feature-card p {
  color: #606266;
  line-height: 1.6;
  font-size: 14px;
}

/* 关于我们 */
.about-section {
  padding: 80px 0;
  background: #F8F9FA;
}

.about-content {
  max-width: 900px;
  margin: 0 auto;
}

.about-text {
  margin-bottom: 60px;
}

.about-text p {
  font-size: 16px;
  line-height: 1.8;
  color: #606266;
  margin-bottom: 20px;
}

.about-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 40px;
  text-align: center;
}

.stat-item {
  padding: 24px;
}

.stat-number {
  font-size: 48px;
  font-weight: 700;
  color: #3498DB;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 16px;
  color: #909399;
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 32px;
  }
  
  .hero-subtitle {
    font-size: 16px;
  }
  
  .section-title {
    font-size: 28px;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
}
</style>
