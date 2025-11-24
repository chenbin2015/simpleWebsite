<template>
  <div class="logo-container">
    <svg class="logo-icon" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
      <!-- 网站图标设计：代表企业建站 -->
      <rect x="8" y="8" width="48" height="48" rx="4" fill="#3498DB" opacity="0.1"/>
      <rect x="12" y="12" width="40" height="40" rx="2" fill="none" stroke="#3498DB" stroke-width="2"/>
      <rect x="18" y="20" width="28" height="4" rx="1" fill="#3498DB"/>
      <rect x="18" y="28" width="20" height="4" rx="1" fill="#3498DB" opacity="0.6"/>
      <rect x="18" y="36" width="24" height="4" rx="1" fill="#3498DB" opacity="0.6"/>
      <circle cx="46" cy="20" r="3" fill="#67C23A"/>
      <circle cx="46" cy="28" r="3" fill="#E6A23C"/>
      <circle cx="46" cy="36" r="3" fill="#F56C6C"/>
    </svg>
    <span class="logo-text">企业建站</span>
  </div>
</template>

<script>
export default {
  name: 'Logo'
}
</script>

<style scoped>
.logo-container {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.logo-icon {
  width: 40px;
  height: 40px;
  flex-shrink: 0;
}

.logo-text {
  font-size: 20px;
  font-weight: 600;
  color: #ECF0F1;
  letter-spacing: 1px;
}
</style>

