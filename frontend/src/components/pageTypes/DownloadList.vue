<template>
  <div class="download-list-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>{{ pageTitle }}</h2>
        </div>
      </template>

      <!-- 搜索和筛选 -->
      <div class="filter-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索文件..."
          clearable
          style="width: 300px; margin-right: 10px;"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        <el-select
          v-model="selectedCategory"
          placeholder="选择分类"
          clearable
          style="width: 200px; margin-right: 10px;"
        >
          <el-option
            v-for="category in categories"
            :key="category"
            :label="category"
            :value="category"
          />
        </el-select>
        <el-select
          v-model="selectedFileType"
          placeholder="文件类型"
          clearable
          style="width: 150px; margin-right: 10px;"
        >
          <el-option label="全部" value="" />
          <el-option label="PDF" value="pdf" />
          <el-option label="Word" value="doc" />
          <el-option label="Excel" value="xls" />
          <el-option label="其他" value="other" />
        </el-select>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
      </div>

      <!-- 下载列表 -->
      <div class="download-list">
        <el-table :data="filteredDownloads" style="width: 100%">
          <el-table-column prop="name" label="文件名" min-width="200">
            <template #default="{ row }">
              <div class="file-name">
                <el-icon class="file-icon" :size="20">
                  <Document v-if="row.type === 'pdf'" />
                  <Document v-else-if="row.type === 'doc'" />
                  <Document v-else />
                </el-icon>
                <span>{{ row.name }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="category" label="分类" width="120">
            <template #default="{ row }">
              <el-tag size="small">{{ row.category }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="size" label="文件大小" width="120" />
          <el-table-column prop="type" label="文件类型" width="100">
            <template #default="{ row }">
              <el-tag :type="getFileTypeTag(row.type)" size="small">
                {{ row.type.toUpperCase() }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="downloadCount" label="下载次数" width="120" align="center" />
          <el-table-column prop="updateTime" label="更新时间" width="180" />
          <el-table-column label="操作" width="120" fixed="right">
            <template #default="{ row }">
              <el-button
                type="primary"
                size="small"
                :icon="Download"
                @click="handleDownload(row)"
              >
                下载
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { Search, Document, Download } from '@element-plus/icons-vue'
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

// 页面标题（从后端获取）
const pageTitle = ref('下载列表')

// 搜索和筛选
const searchKeyword = ref('')
const selectedCategory = ref('')
const selectedFileType = ref('')
const categories = ref(['管理制度', '安全规范', '操作手册', '其他'])

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 下载数据
const downloadData = ref([])

// 过滤后的下载列表
const filteredDownloads = computed(() => {
  let result = downloadData.value
  
  if (searchKeyword.value) {
    const keyword = searchKeyword.value.toLowerCase()
    result = result.filter(item => 
      item.name.toLowerCase().includes(keyword) ||
      item.description?.toLowerCase().includes(keyword)
    )
  }
  
  if (selectedCategory.value) {
    result = result.filter(item => item.category === selectedCategory.value)
  }
  
  if (selectedFileType.value) {
    result = result.filter(item => item.type === selectedFileType.value)
  }
  
  total.value = result.length
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return result.slice(start, end)
})

// 获取文件类型标签
const getFileTypeTag = (type) => {
  const tagMap = {
    'pdf': 'danger',
    'doc': 'primary',
    'xls': 'success',
    'other': 'info'
  }
  return tagMap[type] || 'info'
}

// 加载数据
const loadData = async () => {
  try {
    const data = await fetchMockData('download-list.json')
    const pageData = data[props.id]

    if (!pageData) {
      pageTitle.value = '下载列表'
      downloadData.value = []
      total.value = 0
      return
    }

    pageTitle.value = pageData.title || '下载列表'
    downloadData.value = pageData.items || []
    const computedCategories = Array.from(
      new Set((pageData.items || []).map(item => item.category).filter(Boolean))
    )
    if (computedCategories.length) {
      categories.value = computedCategories
    }
    total.value = downloadData.value.length
    currentPage.value = 1
  } catch (error) {
    console.error(error)
    ElMessage.error('加载下载数据失败')
    pageTitle.value = '下载列表'
    downloadData.value = []
    total.value = 0
    currentPage.value = 1
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  ElMessage.success('搜索完成')
}

// 分页
const handleSizeChange = (val) => {
  pageSize.value = val
  currentPage.value = 1
}

const handleCurrentChange = (val) => {
  currentPage.value = val
}

// 下载
const handleDownload = (item) => {
  if (!item.url) {
    ElMessage.error('暂无可用的下载链接')
    return
  }

  const link = document.createElement('a')
  link.href = item.url
  link.target = '_blank'
  link.rel = 'noopener'
  link.download = item.name || ''
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)

  ElMessage.success(`开始下载：${item.name}`)
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
.download-list-page {
  padding: 0;
}

.card-header h2 {
  margin: 0;
  color: #303133;
}

.filter-bar {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.download-list {
  margin-bottom: 20px;
}

.file-name {
  display: flex;
  align-items: center;
  gap: 8px;
}

.file-icon {
  color: #409eff;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

</style>

