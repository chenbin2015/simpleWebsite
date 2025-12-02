<template>
  <div class="admin-page">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h2>中心概况 - 下设实验室</h2>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            添加实验室
          </el-button>
        </div>
      </template>
      
      <div v-if="laboratoryList.length === 0" class="empty-state">
        <el-empty description="暂无实验室数据">
          <el-button type="primary" @click="handleAdd">添加第一个实验室</el-button>
        </el-empty>
      </div>
      
      <el-table v-else :data="laboratoryList" border style="width: 100%">
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column label="图片" width="150">
          <template #default="{ row }">
            <el-image
              :src="row.image"
              style="width: 120px; height: 80px;"
              fit="cover"
              :preview-src-list="[row.image]"
            >
              <template #error>
                <div class="image-slot">
                  <el-icon><Picture /></el-icon>
                </div>
              </template>
            </el-image>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="实验室名称" min-width="200" />
        <el-table-column prop="link" label="链接地址" min-width="200" show-overflow-tooltip />
        <el-table-column prop="sort" label="排序" width="100" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row, $index }">
            <el-button
              type="primary"
              size="small"
              @click="handleEdit(row, $index)"
            >
              编辑
            </el-button>
            <el-button
              type="danger"
              size="small"
              @click="handleDelete($index)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
    >
      <el-form :model="formData" label-width="100px">
        <el-form-item label="实验室名称" required>
          <el-input v-model="formData.name" placeholder="请输入实验室名称" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="图片" required>
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
        <el-form-item label="链接地址">
          <el-input v-model="formData.link" placeholder="请输入链接地址（可选）" maxlength="200" show-word-limit />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="formData.sort" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Picture } from '@element-plus/icons-vue'

// 实验室列表
const laboratoryList = ref([
  {
    id: 1,
    name: '设计基础实训实验室',
    image: 'https://via.placeholder.com/400x200?text=设计基础实训实验室',
    link: '/lab/design-basic',
    sort: 1
  },
  {
    id: 2,
    name: '智能建筑实验室',
    image: 'https://via.placeholder.com/400x200?text=智能建筑实验室',
    link: '/lab/smart-building',
    sort: 2
  },
  {
    id: 3,
    name: '建筑物理实验室',
    image: 'https://via.placeholder.com/400x200?text=建筑物理实验室',
    link: '/lab/building-physics',
    sort: 3
  },
  {
    id: 4,
    name: '城市大数据与虚拟仿真实验室',
    image: 'https://via.placeholder.com/400x200?text=城市大数据与虚拟仿真实验室',
    link: '/lab/urban-bigdata',
    sort: 4
  },
  {
    id: 5,
    name: '遗产保护实验室',
    image: 'https://via.placeholder.com/400x200?text=遗产保护实验室',
    link: '/lab/heritage',
    sort: 5
  },
  {
    id: 6,
    name: '数字景观实验室',
    image: 'https://via.placeholder.com/400x200?text=数字景观实验室',
    link: '/lab/digital-landscape',
    sort: 6
  }
])

const dialogVisible = ref(false)
const dialogTitle = ref('添加实验室')
const formData = reactive({
  id: null,
  name: '',
  image: '',
  link: '',
  sort: 0
})
const imageFileList = ref([])
const editIndex = ref(-1)

// 添加
const handleAdd = () => {
  dialogTitle.value = '添加实验室'
  formData.id = null
  formData.name = ''
  formData.image = ''
  formData.link = ''
  formData.sort = laboratoryList.value.length + 1
  imageFileList.value = []
  editIndex.value = -1
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row, index) => {
  dialogTitle.value = '编辑实验室'
  formData.id = row.id
  formData.name = row.name
  formData.image = row.image
  formData.link = row.link
  formData.sort = row.sort
  imageFileList.value = row.image ? [{ url: row.image }] : []
  editIndex.value = index
  dialogVisible.value = true
}

// 图片上传
const handleImageChange = (file) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    formData.image = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

// 提交
const handleSubmit = () => {
  if (!formData.name || !formData.name.trim()) {
    ElMessage.warning('请输入实验室名称')
    return
  }
  if (!formData.image) {
    ElMessage.warning('请上传图片')
    return
  }

  if (editIndex.value >= 0) {
    // 编辑
    laboratoryList.value[editIndex.value] = {
      ...formData,
      id: formData.id || Date.now()
    }
    ElMessage.success('编辑成功')
  } else {
    // 添加
    laboratoryList.value.push({
      ...formData,
      id: Date.now()
    })
    // 按排序字段排序
    laboratoryList.value.sort((a, b) => a.sort - b.sort)
    ElMessage.success('添加成功')
  }
  dialogVisible.value = false
}

// 删除
const handleDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个实验室吗？', '提示', {
    type: 'warning'
  }).then(() => {
    laboratoryList.value.splice(index, 1)
    ElMessage.success('删除成功')
  }).catch(() => {})
}
</script>

<style scoped>
.admin-page {
  padding: 0;
  min-height: calc(100vh - 200px);
  background-color: #f0f2f5;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.empty-state {
  padding: 60px 0;
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

:deep(.el-card__header) {
  background-color: #fafafa;
  border-bottom: 1px solid #ebeef5;
}

:deep(.el-table) {
  margin-top: 0;
}

:deep(.el-table th) {
  background-color: #fafafa;
}
</style>
