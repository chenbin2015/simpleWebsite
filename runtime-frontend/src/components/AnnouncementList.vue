<template>
  <div class="announcement-section">
    <div class="announcement-header">
      <h2 class="announcement-title">{{ title }}</h2>
      <a 
        :href="moreLink" 
        class="announcement-more-btn"
        @click.prevent="handleMoreClick"
      >查看更多 ></a>
    </div>
    <div class="announcement-list">
      <a 
        :href="getDetailLink(item)" 
        class="announcement-item" 
        v-for="(item, index) in list" 
        :key="index"
        @click.prevent="handleItemClick(item)"
      >
        <div class="announcement-content">
          <div class="announcement-item-title">
            <h3>{{ item.title }}</h3>
            <div class="announcement-date">{{ item.date }}</div>
          </div>
          <p class="announcement-item-desc">{{ item.description }}</p>
          <span class="announcement-item-link">查看更多 ></span>
        </div>
      </a>
    </div>
  </div>
</template>

<script setup>
import { useRouter, useRoute } from 'vue-router'

const props = defineProps({
  title: {
    type: String,
    default: '通知公告'
  },
  list: {
    type: Array,
    required: true,
    default: () => []
  },
  moreLink: {
    type: String,
    default: '#'
  },
  from: {
    type: String,
    default: null
  }
})

const router = useRouter()
const route = useRoute()

// 获取 from 参数
const getFromParam = () => {
  // 优先使用 props.from
  if (props.from) {
    return props.from
  }
  
  // 从当前路由获取
  const currentPath = route.path
  // 如果是科普教育页面
  if (currentPath === '/popular-science') {
    return 'popular-science'
  }
  
  // 如果是动态路由，构建 from 参数
  const pathParts = currentPath.split('/').filter(p => p)
  if (pathParts.length >= 4 && pathParts[0] === 'dynamic') {
    const rootType = pathParts[1]
    const pageType = pathParts[2]
    // 这里需要导入 getMenuKeyByPageType，但为了简化，先返回 rootType
    // 或者可以从路由查询参数中获取
    return rootType
  }
  
  return null
}

// 获取详情页链接
const getDetailLink = (item) => {
  if (item.link) {
    return item.link
  }
  // 必须使用 id 作为路由参数
  if (!item.id) {
    return '#'
  }
  const from = getFromParam()
  return from ? `/detail/announcement/${item.id}?from=${from}` : `/detail/announcement/${item.id}`
}

// 处理点击事件
const handleItemClick = (item) => {
  // 必须使用 id 作为路由参数
  if (!item.id) {
    console.warn('公告项缺少 ID，无法跳转到详情页')
    return
  }
  const from = getFromParam()
  router.push({
    path: `/detail/announcement/${item.id}`,
    query: from ? { from } : {}
  })
}

// 处理"查看更多"点击事件
const handleMoreClick = () => {
  // 如果 moreLink 不是 #，则使用原来的链接（外部链接）
  if (props.moreLink && props.moreLink !== '#') {
    window.open(props.moreLink, '_blank')
    return
  }
  
  // 否则跳转到通用列表页面
  const from = getFromParam()
  router.push({
    path: '/common-list',
    query: {
      type: 'announcement',
      from: from || 'home'
    }
  })
}
</script>

<style scoped>
.announcement-section {
  margin: 0px 0 20px;
  padding: 20px;
  background-color: #fff;
  width: 100%;
  max-width: 1580px;
  box-sizing: border-box;
}

.announcement-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.announcement-title {
  margin: 0;
  font-size: 24px;
  font-weight: bold;
  color: #333;
  padding-bottom: 10px;
  border-bottom: 2px solid #ffd700;
  display: inline-block;
}

.announcement-title h3 {
  display: inline-block;
}

.announcement-more-btn {
  background-color: #ffd700;
  color: #333;
  padding: 8px 20px;
  text-decoration: none;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s;
}

.announcement-more-btn:hover {
  background-color: #ffed4e;
}

.announcement-list {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.announcement-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 20px 0;
  text-decoration: none;
  color: inherit;
  transition: padding-left 0.3s;
  cursor: pointer;
  position: relative;
  border-bottom: 1px solid #eee;
}

.announcement-item:last-child {
  border-bottom: none;
}

.announcement-item:hover {
  padding-left: 5px;
}

.announcement-item:hover .announcement-item-title {
  color: #ffd700;
}

.announcement-content {
  flex: 1;
  padding-right: 20px;
}

.announcement-item-title {
  display: flex;
  margin: 0 0 8px 0;
  font-size: 16px;
  font-weight: bold;
  color: #333;
  padding-bottom: 8px;
  border-bottom: 1px solid #ffd700;
  width: 100%;
  transition: color 0.3s;
  justify-content: space-between;
}

.announcement-item-desc {
  margin: 8px 0;
  font-size: 14px;
  color: #666;
  line-height: 1.6;
}

.announcement-item-link {
  display: inline-block;
  margin-top: 8px;
  font-size: 14px;
  color: #333;
  text-decoration: none;
}

.announcement-date {
  display: inline;
  font-size: 14px;
  color: #999;
  white-space: nowrap;
  flex-shrink: 0;
  padding: 5px 15px;
  border-radius: 4px;
}
</style>

