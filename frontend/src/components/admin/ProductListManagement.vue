<template>
  <el-card shadow="hover">
    <template #header>
      <div class="card-header">
        <h3>{{ menu.name }} - 内容管理</h3>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          添加产品
        </el-button>
      </div>
    </template>

    <el-row :gutter="20">
      <el-col
        v-for="(item, index) in productList"
        :key="index"
        :xs="24"
        :sm="12"
        :md="8"
        :lg="6"
      >
        <el-card shadow="hover" class="product-card">
          <el-image :src="item.image" fit="cover" style="width: 100%; height: 200px;">
            <template #error>
              <div class="image-slot">
                <el-icon><Picture /></el-icon>
              </div>
            </template>
          </el-image>
          <div class="product-info">
            <div class="product-name">{{ item.name }}</div>
            <el-tag size="small" style="margin-top: 8px;">{{ item.category }}</el-tag>
          </div>
          <div class="product-actions">
            <el-button type="primary" size="small" @click="handleEdit(item, index)">
              编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDelete(index)">
              删除
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="名称">
          <el-input v-model="formData.name" placeholder="请输入产品名称" />
        </el-form-item>
        <el-form-item label="图片">
          <el-upload
            :auto-upload="false"
            :on-change="handleImageChange"
            :file-list="imageFileList"
            list-type="picture-card"
            :limit="1"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="分类">
          <el-input v-model="formData.category" placeholder="请输入分类" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="formData.description" type="textarea" :rows="3" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="规格参数">
          <div v-for="(value, key) in formData.specs" :key="key" class="spec-item">
            <el-input v-model="specKeys[key]" placeholder="参数名" style="width: 150px; margin-right: 10px;" disabled />
            <el-input v-model="formData.specs[key]" placeholder="参数值" style="width: 200px; margin-right: 10px;" />
            <el-button type="danger" size="small" @click="removeSpec(key)">删除</el-button>
          </div>
          <div class="spec-add">
            <el-input v-model="newSpecKey" placeholder="参数名" style="width: 150px; margin-right: 10px;" />
            <el-button type="primary" size="small" @click="addSpec">添加参数</el-button>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Picture } from '@element-plus/icons-vue'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const productList = ref([
  {
    id: 1,
    name: '产品1',
    image: 'https://via.placeholder.com/400x200?text=产品1',
    category: '实验设备',
    description: '产品描述',
    specs: { '型号': 'ABC-123', '规格': '100x50cm' }
  }
])

const dialogVisible = ref(false)
const dialogTitle = ref('添加产品')
const formData = reactive({
  id: null,
  name: '',
  image: '',
  category: '',
  description: '',
  specs: {}
})
const imageFileList = ref([])
const editIndex = ref(-1)
const newSpecKey = ref('')
const specKeys = ref({})

const handleAdd = () => {
  dialogTitle.value = '添加产品'
  formData.id = null
  formData.name = ''
  formData.image = ''
  formData.category = ''
  formData.description = ''
  formData.specs = {}
  specKeys.value = {}
  imageFileList.value = []
  editIndex.value = -1
  dialogVisible.value = true
}

const handleEdit = (row, index) => {
  dialogTitle.value = '编辑产品'
  formData.id = row.id
  formData.name = row.name
  formData.image = row.image
  formData.category = row.category
  formData.description = row.description || ''
  formData.specs = { ...(row.specs || {}) }
  specKeys.value = {}
  Object.keys(formData.specs).forEach(key => {
    specKeys.value[key] = key
  })
  imageFileList.value = row.image ? [{ url: row.image }] : []
  editIndex.value = index
  dialogVisible.value = true
}

const handleImageChange = (file) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    formData.image = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

const addSpec = () => {
  if (!newSpecKey.value || !newSpecKey.value.trim()) {
    ElMessage.warning('请输入参数名称')
    return
  }
  const key = newSpecKey.value.trim()
  if (formData.specs[key]) {
    ElMessage.warning('该参数已存在')
    return
  }
  formData.specs[key] = ''
  specKeys.value[key] = key
  newSpecKey.value = ''
}

const removeSpec = (key) => {
  delete formData.specs[key]
  delete specKeys.value[key]
}

const handleSubmit = () => {
  if (!formData.name || !formData.name.trim()) {
    ElMessage.warning('请输入产品名称')
    return
  }
  if (!formData.image) {
    ElMessage.warning('请上传图片')
    return
  }
  if (editIndex.value >= 0) {
    productList.value[editIndex.value] = { ...formData, id: formData.id || Date.now() }
    ElMessage.success('编辑成功')
  } else {
    productList.value.push({ ...formData, id: Date.now() })
    ElMessage.success('添加成功')
  }
  dialogVisible.value = false
  emit('update')
}

const handleDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个产品吗？', '提示', { type: 'warning' })
    .then(() => {
      productList.value.splice(index, 1)
      ElMessage.success('删除成功')
      emit('update')
    })
    .catch(() => {})
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
}

.product-card {
  margin-bottom: 20px;
}

.product-info {
  padding: 10px 0;
}

.product-name {
  font-weight: bold;
  margin-bottom: 8px;
}

.product-actions {
  margin-top: 10px;
  display: flex;
  gap: 10px;
}

.spec-item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.spec-add {
  display: flex;
  align-items: center;
  margin-top: 10px;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
}
</style>

