<template>
  <div class="page-container">
    <h1>{{ menuName || '菜单页面' }}</h1>
    <div v-if="menuId && menuType" class="menu-info">
      <p>菜单ID: {{ menuId }}</p>
      <p>菜单类型: {{ menuType }}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MenuPage',
  data() {
    return {
      menuName: '',
      menuId: null,
      menuType: null
    }
  },
  mounted() {
    // 从路由参数获取菜单信息
    this.menuId = this.$route.params.id
    this.menuType = this.$route.params.type
    
    // TODO: 根据id和type从接口获取菜单详细信息
    // 这里暂时使用id作为名称
    if (this.menuId) {
      this.menuName = `菜单 ${this.menuId}`
    }
  }
}
</script>

<style scoped>
.page-container {
  padding: 20px;
}

h1 {
  margin: 0;
  font-size: 24px;
  color: #333;
}

.menu-info {
  margin-top: 20px;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 4px;
}

.menu-info p {
  margin: 8px 0;
  font-size: 14px;
  color: #666;
}
</style>

