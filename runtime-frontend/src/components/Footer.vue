<template>
  <el-footer class="app-footer">
    <!-- 顶部区域：Logo和分隔线 -->
    <div class="footer-top">
      <div class="footer-logo">
        <img 
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
        <div class="contact-item">
          <span class="label">联系电话：</span>
          <span class="value">025-83792484</span>
        </div>
        <div class="contact-item">
          <span class="label">邮编：</span>
          <span class="value">210096</span>
        </div>
        <div class="contact-item">
          <span class="label">地址：</span>
          <span class="value">江苏省南京市玄武区四牌楼2号</span>
        </div>
      </div>
      
      <div class="footer-divider-vertical"></div>
      
      <div class="footer-right">
        <div class="links-title">友情链接</div>
        <div class="links-columns">
          <div class="links-column">
            <div class="link-item">东南大学</div>
            <div class="link-item">东南大学建筑学院</div>
          </div>
          <div class="links-column">
            <div class="link-item">东南大学实验室与设备管理处</div>
            <div class="link-item">东南大学教务处</div>
          </div>
          <div class="links-column">
            <div class="link-item">东南大学科研院</div>
            <div class="link-item">东南大学保卫处</div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 底部：版权信息 -->
    <div class="footer-bottom">
      <p>Copyright © 2025 东南大学建筑学院实验教学中心All Rights Reserved. 版权所有</p>
    </div>
  </el-footer>
</template>

<script>
export default {
  name: 'Footer'
}
</script>

<style scoped>
.app-footer {
  background: #303133;
  color: #fff;
  padding: 40px 60px 10px;
  min-height: 300px;
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
  height: 50px;
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
  font-size: 14px;
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
  font-size: 16px;
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
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 10px;
  cursor: pointer;
  transition: color 0.3s;
}

.link-item:hover {
  color: #D4AF37;
}

/* 底部版权信息 */
.footer-bottom {
  text-align: center;
  padding-top: 20px;
}

.footer-bottom p {
  margin: 0;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
}
</style>

