<template>
  <el-card shadow="hover">
    <template #header>
      <div class="card-header">
        <h3>{{ menu.name }} - 内容管理</h3>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          添加新闻
        </el-button>
      </div>
    </template>

    <el-table :data="newsList" border style="width: 100%">
      <el-table-column type="index" label="序号" width="60" />
      <el-table-column prop="title" label="标题" min-width="200" />
      <el-table-column prop="author" label="作者" width="120" />
      <el-table-column prop="date" label="日期" width="120" />
      <el-table-column label="标签" width="150">
        <template #default="{ row }">
          <el-tag
            v-for="tag in (row.tags || [])"
            :key="tag"
            size="small"
            style="margin-right: 5px;"
          >
            {{ tag }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 'published' ? 'success' : 'info'">
            {{ row.status === 'published' ? '已发布' : '草稿' }}
          </el-tag>
        </template>
      </el-table-column>
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
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="800px">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="formData.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="formData.author" placeholder="请输入作者" />
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker v-model="formData.date" type="date" placeholder="选择日期" style="width: 100%;" />
        </el-form-item>
        <el-form-item label="标签">
          <el-select
            v-model="formData.tags"
            multiple
            filterable
            allow-create
            default-first-option
            placeholder="请选择或输入标签"
            style="width: 100%;"
          >
            <el-option
              v-for="tag in availableTags"
              :key="tag"
              :label="tag"
              :value="tag"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="摘要">
          <el-input v-model="formData.summary" type="textarea" :rows="3" placeholder="请输入摘要" />
        </el-form-item>
        <el-form-item label="内容">
          <RichTextEditor v-model="formData.content" placeholder="请输入新闻内容" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="formData.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
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
import { Plus } from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const newsList = ref([
  {
    id: 1,
    title: '新闻标题1',
    author: '管理员',
    date: '2025-01-15',
    tags: ['重要', '通知'],
    summary: '这是新闻摘要',
    content: '<p>这是新闻内容...</p>',
    status: 'published'
  }
])

const availableTags = ref(['重要', '通知', '公告', '活动'])

const dialogVisible = ref(false)
const dialogTitle = ref('添加新闻')
const formData = reactive({
  id: null,
  title: '',
  author: '',
  date: '',
  tags: [],
  summary: '',
  content: '',
  status: 'draft'
})
const editIndex = ref(-1)

const handleAdd = () => {
  dialogTitle.value = '添加新闻'
  formData.id = null
  formData.title = ''
  formData.author = ''
  formData.date = new Date().toISOString().split('T')[0]
  formData.tags = []
  formData.summary = ''
  formData.content = ''
  formData.status = 'draft'
  editIndex.value = -1
  dialogVisible.value = true
}

const handleEdit = (row, index) => {
  dialogTitle.value = '编辑新闻'
  formData.id = row.id
  formData.title = row.title
  formData.author = row.author
  formData.date = row.date
  formData.tags = [...(row.tags || [])]
  formData.summary = row.summary || ''
  formData.content = row.content || ''
  formData.status = row.status
  editIndex.value = index
  dialogVisible.value = true
}

const handleSubmit = () => {
  if (!formData.title || !formData.title.trim()) {
    ElMessage.warning('请输入标题')
    return
  }
  if (editIndex.value >= 0) {
    newsList.value[editIndex.value] = { ...formData }
    ElMessage.success('编辑成功')
  } else {
    newsList.value.push({ ...formData, id: Date.now() })
    ElMessage.success('添加成功')
  }
  dialogVisible.value = false
  emit('update')
}

const handleDelete = (index) => {
  ElMessageBox.confirm('确定要删除这条新闻吗？', '提示', { type: 'warning' })
    .then(() => {
      newsList.value.splice(index, 1)
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

