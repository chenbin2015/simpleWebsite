<template>
  <div class="product-list-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>{{ pageTitle }}</h2>
        </div>
      </template>

      <!-- 筛选栏 -->
      <div class="filter-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索产品..."
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
        <el-button type="primary" @click="handleSearch">搜索</el-button>
      </div>

      <!-- 产品列表 -->
      <div class="product-list">
        <el-row :gutter="20">
          <el-col
            v-for="(item, index) in filteredProducts"
            :key="index"
            :xs="24"
            :sm="12"
            :md="8"
            :lg="6"
          >
            <el-card
              shadow="hover"
              class="product-item"
              @click="handleViewDetail(item)"
            >
              <div class="product-image">
                <el-image
                  :src="item.image"
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
              <div class="product-info">
                <div class="product-name">{{ item.name }}</div>
                <div class="product-category">
                  <el-tag size="small">{{ item.category }}</el-tag>
                </div>
                <div class="product-description" v-if="item.description">
                  {{ item.description }}
                </div>
                <div class="product-specs" v-if="item.specs">
                  <div v-for="(value, key) in item.specs" :key="key" class="spec-item">
                    <span class="spec-label">{{ key }}：</span>
                    <span class="spec-value">{{ value }}</span>
                  </div>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[12, 24, 48, 96]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailVisible"
      :title="selectedProduct?.name"
      width="70%"
    >
      <div class="product-detail" v-if="selectedProduct">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-image
              :src="selectedProduct.image"
              fit="cover"
              style="width: 100%;"
            />
          </el-col>
          <el-col :span="16">
            <div class="detail-info">
              <h3>{{ selectedProduct.name }}</h3>
              <el-tag>{{ selectedProduct.category }}</el-tag>
              <el-divider />
              <div class="detail-specs">
                <h4>产品规格</h4>
                <el-descriptions :column="1" border>
                  <el-descriptions-item
                    v-for="(value, key) in selectedProduct.specs"
                    :key="key"
                    :label="key"
                  >
                    {{ value }}
                  </el-descriptions-item>
                </el-descriptions>
              </div>
              <div class="detail-description" v-if="selectedProduct.description">
                <h4>产品描述</h4>
                <p>{{ selectedProduct.description }}</p>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { Search, Picture } from '@element-plus/icons-vue'
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
const pageTitle = ref('产品列表')

// 搜索和筛选
const searchKeyword = ref('')
const selectedCategory = ref('')
const categories = ref(['分析仪器', '测量仪器', '实验设备', '其他'])

// 分页
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)

// 产品数据
const productData = ref([])

// 详情对话框
const detailVisible = ref(false)
const selectedProduct = ref(null)

// 过滤后的产品列表
const filteredProducts = computed(() => {
  let result = productData.value
  
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
  
  total.value = result.length
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return result.slice(start, end)
})

const loadData = async () => {
  try {
    const data = await fetchMockData('product-list.json')
    const pageData = data[props.id]

    if (!pageData) {
      pageTitle.value = '产品列表'
      productData.value = []
      total.value = 0
      return
    }

    pageTitle.value = pageData.title || '产品列表'
    categories.value = pageData.categories || []
    productData.value = pageData.items || []
    total.value = productData.value.length
    currentPage.value = 1
  } catch (error) {
    console.error(error)
    ElMessage.error('加载产品数据失败')
    pageTitle.value = '产品列表'
    productData.value = []
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

// 查看详情
const handleViewDetail = (item) => {
  selectedProduct.value = item
  detailVisible.value = true
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
.product-list-page {
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

.product-list {
  margin-bottom: 20px;
}

.product-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
}

.product-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
}

.product-image {
  margin-bottom: 15px;
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

.product-info {
  padding: 10px 0;
}

.product-name {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 10px;
}

.product-category {
  margin-bottom: 10px;
}

.product-description {
  color: #606266;
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 10px;
}

.product-specs {
  margin-top: 10px;
}

.spec-item {
  font-size: 13px;
  color: #909399;
  margin-bottom: 5px;
}

.spec-label {
  font-weight: 500;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.product-detail h3 {
  margin: 0 0 15px;
  color: #303133;
}

.detail-info {
  padding: 0 10px;
}

.detail-specs {
  margin: 20px 0;
}

.detail-specs h4 {
  margin: 0 0 15px;
  color: #303133;
}

.detail-description {
  margin-top: 20px;
}

.detail-description h4 {
  margin: 0 0 10px;
  color: #303133;
}

.detail-description p {
  color: #606266;
  line-height: 1.8;
  margin: 0;
}
</style>

