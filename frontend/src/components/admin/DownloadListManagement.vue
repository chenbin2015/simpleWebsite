<template>
  <el-card shadow="hover">
    <template #header>
      <div class="card-header">
        <h3>{{ menu.name }} - 内容管理</h3>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          添加文件
        </el-button>
      </div>
    </template>

    <el-table :data="fileList" border style="width: 100%">
      <el-table-column type="index" label="序号" width="60" />
      <el-table-column prop="name" label="文件名" min-width="200" />
      <el-table-column prop="category" label="分类" width="120">
        <template #default="{ row }">
          <el-tag size="small">{{ row.category }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="size" label="文件大小" width="120" />
      <el-table-column prop="type" label="文件类型" width="100">
        <template #default="{ row }">
          <el-tag size="small">{{ row.type.toUpperCase() }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="downloadCount" label="下载次数" width="120" align="center" />
      <el-table-column prop="updateTime" label="更新时间" width="180" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row, $index }">
          <el-button type="primary" size="small" @click="handleEdit(row, $index)">
            编辑
          </el-button>
          <el-button type="danger" size="small" @click="handleDelete($index)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="文件名">
          <el-input v-model="formData.name" placeholder="请输入文件名" />
        </el-form-item>
        <el-form-item label="文件">
          <el-upload
            :auto-upload="false"
            :on-change="handleFileChange"
            :file-list="fileFileList"
            :limit="1"
          >
            <el-button type="primary">
              <el-icon><Upload /></el-icon>
              选择文件
            </el-button>
          </el-upload>
        </el-form-item>
        <el-form-item label="分类">
          <el-input v-model="formData.category" placeholder="请输入分类" />
        </el-form-item>
        <el-form-item label="文件类型">
          <el-select v-model="formData.type" placeholder="请选择文件类型" style="width: 100%;">
            <el-option label="PDF" value="pdf" />
            <el-option label="Word" value="doc" />
            <el-option label="Excel" value="xls" />
            <el-option label="其他" value="other" />
          </el-select>
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
import { Plus, Upload } from '@element-plus/icons-vue'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const fileList = ref([
  {
    id: 1,
    name: '文件1.pdf',
    category: '文档',
    size: '2.5MB',
    type: 'pdf',
    url: '/uploads/files/file1.pdf',
    downloadCount: 100,
    updateTime: '2025-01-15 10:00:00'
  }
])

const dialogVisible = ref(false)
const dialogTitle = ref('添加文件')
const formData = reactive({
  id: null,
  name: '',
  file: null,
  category: '',
  type: 'pdf',
  url: ''
})
const fileFileList = ref([])
const editIndex = ref(-1)

const formatFileSize = (bytes) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

const handleAdd = () => {
  dialogTitle.value = '添加文件'
  formData.id = null
  formData.name = ''
  formData.file = null
  formData.category = ''
  formData.type = 'pdf'
  formData.url = ''
  fileFileList.value = []
  editIndex.value = -1
  dialogVisible.value = true
}

const handleEdit = (row, index) => {
  dialogTitle.value = '编辑文件'
  formData.id = row.id
  formData.name = row.name
  formData.category = row.category
  formData.type = row.type
  formData.url = row.url
  fileFileList.value = []
  editIndex.value = index
  dialogVisible.value = true
}

const handleFileChange = (file) => {
  formData.file = file.raw
  formData.name = file.name
  // 自动识别文件类型
  const ext = file.name.split('.').pop().toLowerCase()
  if (['pdf'].includes(ext)) {
    formData.type = 'pdf'
  } else if (['doc', 'docx'].includes(ext)) {
    formData.type = 'doc'
  } else if (['xls', 'xlsx'].includes(ext)) {
    formData.type = 'xls'
  } else {
    formData.type = 'other'
  }
}

const handleSubmit = () => {
  if (!formData.name || !formData.name.trim()) {
    ElMessage.warning('请输入文件名')
    return
  }
  if (!formData.file && !formData.url) {
    ElMessage.warning('请上传文件')
    return
  }

  const now = new Date().toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  }).replace(/\//g, '-')

  if (editIndex.value >= 0) {
    const file = fileList.value[editIndex.value]
    fileList.value[editIndex.value] = {
      ...file,
      name: formData.name,
      category: formData.category,
      type: formData.type,
      updateTime: now
    }
    ElMessage.success('编辑成功')
  } else {
    fileList.value.push({
      id: Date.now(),
      name: formData.name,
      category: formData.category,
      size: formData.file ? formatFileSize(formData.file.size) : '0 B',
      type: formData.type,
      url: formData.url || '/uploads/files/' + formData.name,
      downloadCount: 0,
      updateTime: now
    })
    ElMessage.success('添加成功')
  }
  dialogVisible.value = false
  emit('update')
}

const handleDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个文件吗？', '提示', { type: 'warning' })
    .then(() => {
      fileList.value.splice(index, 1)
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
</style>

