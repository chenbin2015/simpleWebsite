<template>
  <div class="image-text-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>{{ pageTitle }}</h2>
        </div>
      </template>

      <div class="rich-content" v-html="contentHtml"></div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { fetchMockData } from '@/services/mockClient'

const props = defineProps({
  id: {
    type: String,
    required: true
  },
  category: {
    type: String,
    required: true
  }
})

const pageTitle = ref('图文内容')
const contentHtml = ref('<p>暂无内容</p>')

const loadData = async () => {
  try {
    const data = await fetchMockData('image-text.json')
    const pageData = data[props.id]

    if (!pageData) {
      pageTitle.value = '图文内容'
      contentHtml.value = '<p>暂无内容</p>'
      return
    }

    pageTitle.value = pageData.title
    contentHtml.value = pageData.html
  } catch (error) {
    console.error(error)
    ElMessage.error('加载图文内容失败')
    pageTitle.value = '图文内容'
    contentHtml.value = '<p>暂无内容</p>'
  }
}

onMounted(loadData)

watch(
  () => props.id,
  () => {
    loadData()
  }
)
</script>

<style scoped>
.image-text-page {
  padding: 0;
}

.card-header h2 {
  margin: 0;
  color: #303133;
}

.rich-content {
  padding: 10px 0;
}
</style>

