<template>
  <el-footer class="app-footer">
    <div class="footer-container">
    <!-- 顶部区域：Logo和分隔线 -->
    <div class="footer-top">
      <div class="footer-logo">
        <img 
          v-if="basicData && basicData.logo"
          :src="getFullImageUrl(basicData.logo)" 
          alt="Logo" 
          class="logo"
        />
        <img 
          v-else
          src="https://guanwang.makabaka.ltd/uploads/20250910/f803dcb1eedefdac8fcefa641a4d6020.png" 
          alt="Logo" 
          class="logo"
        />
      </div>
      <div class="footer-divider"></div>
    </div>
    
    <!-- 中间区域：联系信息和友情链接 -->
    <div class="footer-middle">
      <div class="footer-left">
        <div class="contact-item" v-if="contactData && contactData.phone">
          <span class="label">联系电话：</span>
          <span class="value">{{ contactData.phone }}</span>
        </div>
        <div class="contact-item" v-if="contactData && contactData.postcode">
          <span class="label">邮编：</span>
          <span class="value">{{ contactData.postcode }}</span>
        </div>
        <div class="contact-item" v-if="contactData && contactData.address">
          <span class="label">地址：</span>
          <span class="value">{{ contactData.address }}</span>
        </div>
        <div class="contact-item" v-if="contactData && contactData.email">
          <span class="label">邮箱：</span>
          <span class="value">{{ contactData.email }}</span>
        </div>
        <div class="contact-item" v-if="contactData && contactData.fax">
          <span class="label">传真：</span>
          <span class="value">{{ contactData.fax }}</span>
        </div>
        <div class="contact-item" v-if="contactData && contactData.workTime">
          <span class="label">工作时间：</span>
          <span class="value">{{ contactData.workTime }}</span>
        </div>
      </div>
      
      <div class="footer-divider-vertical"></div>
      
      <div class="footer-right">
        <div class="links-title">友情链接</div>
        <div class="links-columns" v-if="linksData && linksData.length > 0">
          <div 
            class="links-column" 
            v-for="(column, colIndex) in groupedLinks" 
            :key="colIndex"
          >
            <a 
              v-for="link in column" 
              :key="link.id"
              :href="link.url" 
              :target="link.target || '_blank'"
              class="link-item"
            >
              {{ link.name }}
            </a>
          </div>
        </div>
        <div v-else class="no-links">暂无友情链接</div>
      </div>
    </div>
    
    <!-- 底部：版权信息 -->
    <div class="footer-bottom">
      <p v-if="basicData && basicData.copyright">{{ basicData.copyright }}</p>
      <p v-else>Copyright © 2025 东南大学建筑学院实验教学中心All Rights Reserved. 版权所有</p>
      <p v-if="basicData && basicData.icp" class="icp-info">ICP备案号：{{ basicData.icp }}</p>
    </div>
    </div>
  </el-footer>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getContact, getLinkList, getBasic } from '@/services/publicFooterApi'
import { buildImageUrl } from '@/utils/url'

const contactData = ref(null)
const linksData = ref([])
const basicData = ref(null)

// 将友情链接分组显示（每列2个）
const groupedLinks = computed(() => {
  if (!linksData.value || linksData.value.length === 0) {
    return []
  }
  
  const columns = []
  const itemsPerColumn = 2
  const totalColumns = Math.ceil(linksData.value.length / itemsPerColumn)
  
  for (let i = 0; i < totalColumns; i++) {
    const start = i * itemsPerColumn
    const end = start + itemsPerColumn
    columns.push(linksData.value.slice(start, end))
  }
  
  return columns
})

// 获取完整的图片URL
const getFullImageUrl = buildImageUrl

// 加载Footer数据
const loadFooterData = async () => {
  try {
    // 并行加载所有数据
    const [contactResponse, linksResponse, basicResponse] = await Promise.all([
      getContact(),
      getLinkList(),
      getBasic()
    ])
    
    // 处理联系方式
    if (contactResponse.data && contactResponse.data.success && contactResponse.data.data) {
      contactData.value = contactResponse.data.data
    }
    
    // 处理友情链接
    if (linksResponse.data && linksResponse.data.success && linksResponse.data.data) {
      linksData.value = linksResponse.data.data
    }
    
    // 处理基本信息
    if (basicResponse.data && basicResponse.data.success && basicResponse.data.data) {
      basicData.value = basicResponse.data.data
    }
  } catch (error) {
    console.error('加载Footer数据失败:', error)
    // 静默失败，使用默认值
  }
}

onMounted(() => {
  loadFooterData()
})
</script>

<style scoped>
.app-footer {
  background: #303133;
  color: #fff;
  padding: 40px 60px 10px;
  min-height: 320px;
}
.footer-container {
    width:1600px;
    margin:0 auto;
}

/* 顶部区域：Logo和分隔线 */
.footer-top {
  display: flex;
  align-items: center;
  margin-bottom: 30px;
}

.footer-logo {
  display: flex;
  align-items: center;
}

.footer-logo .logo {
  height: 30px;
  width: auto;
}

.footer-divider {
  flex: 1;
  height: 1px;
  background: rgba(255, 255, 255, 0.3);
  margin-left: 20px;
}

/* 中间区域 */
.footer-middle {
  display: flex;
  gap: 40px;
  margin-bottom: 30px;
  padding-bottom: 30px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.footer-left {
  flex: 1;
}

.contact-item {
  margin-bottom: 12px;
  font-size: 18px;
  line-height: 1.8;
}

.contact-item .label {
  color: rgba(255, 255, 255, 0.8);
  margin-right: 8px;
}

.contact-item .value {
  color: #fff;
}

.footer-divider-vertical {
  width: 1px;
  background: rgba(255, 255, 255, 0.2);
  margin: 0 20px;
}

.footer-right {
  flex: 1.5;
}

.links-title {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 20px;
  color: #fff;
}

.links-columns {
  display: flex;
  gap: 40px;
}

.links-column {
  flex: 1;
}

.link-item {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 10px;
  cursor: pointer;
  transition: color 0.3s;
  text-decoration: none;
  display: block;
}

.link-item:hover {
  color: #D4AF37;
}

.no-links {
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
}

/* 底部版权信息 */
.footer-bottom {
  text-align: center;
}

.footer-bottom p {
  margin: 0;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
}

.footer-bottom .icp-info {
  margin-top: 8px;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.5);
}
</style>

