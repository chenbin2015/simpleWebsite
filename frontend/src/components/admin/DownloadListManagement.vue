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

    <el-table :data="fileList" border style="width: 100%" v-loading="loading">
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
        <el-form-item label="文件名" required>
          <el-input v-model="formData.name" placeholder="请输入文件名" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="文件" required>
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Upload } from '@element-plus/icons-vue'
import * as moduleDownloadApi from '@/services/moduleDownloadApi'
import * as menuApi from '@/services/menuApi'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const fileList = ref([])
const loading = ref(false)
const menuIdRef = ref(null) // 存储数据库菜单ID

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

// 根据菜单名称查找数据库菜单ID
const findMenuIdByName = async (menuName, categoryName) => {
  try {
    const response = await menuApi.getAllMenus()
    if (response.success && response.data) {
      // 分类名称到数据库父菜单名称的映射
      const categoryToParentName = {
        'experiment-teaching': '实验教学',
        'experiment-resources': '实验资源',
        'construction-results': '建设成效',
        'safety-management': '安全管理'
      }
      
      const parentName = categoryToParentName[categoryName]
      if (!parentName) return null
      
      // 查找匹配的菜单
      for (const parentMenu of response.data) {
        if (parentMenu.name === parentName && parentMenu.children) {
          const childMenu = parentMenu.children.find(child => child.name === menuName)
          if (childMenu) {
            return childMenu.id
          }
        }
      }
    }
  } catch (error) {
    console.error('查找菜单ID失败:', error)
  }
  return null
}

// 获取菜单的数据库ID（从props或查找）
const getMenuId = async () => {
  // 先尝试从props获取
  if (props.menu.menuId && typeof props.menu.menuId === 'number') {
    return props.menu.menuId
  }
  
  // 如果menuIdRef已缓存，直接返回
  if (menuIdRef.value) {
    return menuIdRef.value
  }
  
  // 尝试通过菜单名称查找
  const foundId = await findMenuIdByName(props.menu.name, props.menu.category)
  if (foundId) {
    menuIdRef.value = foundId
    return foundId
  }
  
  return null
}

// 加载下载列表
const loadDownloadList = async () => {
  const menuId = await getMenuId()
  
  if (!menuId) {
    console.warn('无法找到菜单的数据库ID，无法加载下载列表。菜单对象:', props.menu)
    fileList.value = []
    return
  }
  
  loading.value = true
  try {
    const response = await moduleDownloadApi.getDownloadListByMenuId(menuId)
    if (response.success && response.data) {
      fileList.value = response.data.map(item => ({
        ...item,
        url: item.fileUrl // 保持兼容性
      }))
    } else {
      fileList.value = []
    }
  } catch (error) {
    console.error('加载下载列表失败:', error)
    ElMessage.error('加载下载列表失败')
    fileList.value = []
  } finally {
    loading.value = false
  }
}

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

const handleSubmit = async () => {
  if (!formData.name || !formData.name.trim()) {
    ElMessage.warning('请输入文件名')
    return
  }
  
  // 编辑时如果没有上传新文件，可以使用旧文件
  if (editIndex.value < 0 && !formData.file) {
    ElMessage.warning('请上传文件')
    return
  }
  
  const menuId = await getMenuId()
  if (!menuId) {
    ElMessage.error('无法找到菜单的数据库ID，无法保存文件')
    return
  }
  
  try {
    const uploadFormData = new FormData()
    uploadFormData.append('name', formData.name.trim())
    if (formData.category) {
      uploadFormData.append('category', formData.category)
    }
    if (formData.type) {
      uploadFormData.append('fileType', formData.type)
    }
    
    if (editIndex.value >= 0 && formData.id) {
      // 更新
      if (formData.file) {
        uploadFormData.append('file', formData.file)
      }
      const response = await moduleDownloadApi.updateDownload(formData.id, uploadFormData)
      if (response.success) {
        ElMessage.success('编辑成功')
        await loadDownloadList() // 重新加载列表
        dialogVisible.value = false
        emit('update')
      } else {
        throw new Error(response.message || '更新失败')
      }
    } else {
      // 添加 - 必须有文件
      if (!formData.file) {
        ElMessage.warning('请上传文件')
        return
      }
      uploadFormData.append('file', formData.file)
      const response = await moduleDownloadApi.addDownload(menuId, uploadFormData)
      if (response.success) {
        ElMessage.success('添加成功')
        await loadDownloadList() // 重新加载列表
        dialogVisible.value = false
        emit('update')
      } else {
        throw new Error(response.message || '添加失败')
      }
    }
  } catch (error) {
    console.error('保存文件失败:', error)
    ElMessage.error(error.message || '保存文件失败')
  }
}

const handleDelete = async (index) => {
  const file = fileList.value[index]
  if (!file || !file.id) {
    ElMessage.error('文件数据无效')
    return
  }
  
  ElMessageBox.confirm('确定要删除这个文件吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        const response = await moduleDownloadApi.deleteDownload(file.id)
        if (response.success) {
          ElMessage.success('删除成功')
          await loadDownloadList() // 重新加载列表
          emit('update')
        } else {
          throw new Error(response.message || '删除失败')
        }
      } catch (error) {
        console.error('删除文件失败:', error)
        ElMessage.error(error.message || '删除文件失败')
      }
    })
    .catch(() => {})
}

onMounted(() => {
  loadDownloadList()
})
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

