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

    <el-table :data="newsList" border style="width: 100%" v-loading="loading">
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
        <template #default="{ row }">
          <el-button type="primary" size="small" @click="handleEdit(row)">
            编辑
          </el-button>
          <el-button type="danger" size="small" @click="handleDelete(newsList.findIndex(n => n.id === row.id))">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="800px">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="标题" required>
          <el-input v-model="formData.title" placeholder="请输入标题" maxlength="50" show-word-limit />
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
        <el-form-item label="内容" required>
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'
import * as moduleNewsApi from '@/services/moduleNewsApi'
import * as menuApi from '@/services/menuApi'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const newsList = ref([])
const loading = ref(false)
const menuIdRef = ref(null) // 存储数据库菜单ID

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

// 加载新闻列表
const loadNewsList = async () => {
  const menuId = await getMenuId()
  
  if (!menuId) {
    console.warn('无法找到菜单的数据库ID，无法加载新闻列表。菜单对象:', props.menu)
    newsList.value = []
    return
  }
  
  loading.value = true
  try {
    const response = await moduleNewsApi.getNewsListByMenuId(menuId)
    if (response.success && response.data) {
      newsList.value = response.data
    } else {
      newsList.value = []
    }
  } catch (error) {
    console.error('加载新闻列表失败:', error)
    ElMessage.error('加载新闻列表失败')
    newsList.value = []
  } finally {
    loading.value = false
  }
}

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

const handleEdit = (row) => {
  dialogTitle.value = '编辑新闻'
  formData.id = row.id
  formData.title = row.title
  formData.author = row.author
  // 日期处理：如果有publishTime则使用，否则使用date字段
  if (row.publishTime) {
    formData.date = row.publishTime.split('T')[0] // 提取日期部分
  } else if (row.date) {
    formData.date = row.date
  } else {
    formData.date = new Date().toISOString().split('T')[0]
  }
  formData.tags = [...(row.tags || [])]
  formData.summary = row.summary || ''
  formData.content = row.content || ''
  formData.status = row.status
  editIndex.value = newsList.value.findIndex(n => n.id === row.id)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!formData.title || !formData.title.trim()) {
    ElMessage.warning('请输入标题')
    return
  }
  
  const menuId = await getMenuId()
  if (!menuId) {
    ElMessage.error('无法找到菜单的数据库ID，无法保存新闻')
    return
  }
  
  try {
    const newsData = {
      title: formData.title,
      author: formData.author,
      content: formData.content,
      tags: formData.tags,
      summary: formData.summary,
      status: formData.status,
      date: formData.date // 传递日期字段
    }
    
    if (editIndex.value >= 0 && formData.id) {
      // 更新
      const response = await moduleNewsApi.updateNews(formData.id, newsData)
      if (response.success) {
        ElMessage.success('编辑成功')
        await loadNewsList() // 重新加载列表
        dialogVisible.value = false
        emit('update')
      } else {
        throw new Error(response.message || '更新失败')
      }
    } else {
      // 添加
      const response = await moduleNewsApi.addNews(menuId, newsData)
      if (response.success) {
        ElMessage.success('添加成功')
        await loadNewsList() // 重新加载列表
        dialogVisible.value = false
        emit('update')
      } else {
        throw new Error(response.message || '添加失败')
      }
    }
  } catch (error) {
    console.error('保存新闻失败:', error)
    ElMessage.error(error.message || '保存新闻失败')
  }
}

const handleDelete = async (index) => {
  const news = newsList.value[index]
  if (!news || !news.id) {
    ElMessage.error('新闻数据无效')
    return
  }
  
  ElMessageBox.confirm('确定要删除这条新闻吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        const response = await moduleNewsApi.deleteNews(news.id)
        if (response.success) {
          ElMessage.success('删除成功')
          await loadNewsList() // 重新加载列表
          emit('update')
        } else {
          throw new Error(response.message || '删除失败')
        }
      } catch (error) {
        console.error('删除新闻失败:', error)
        ElMessage.error(error.message || '删除新闻失败')
      }
    })
    .catch(() => {})
}

onMounted(() => {
  loadNewsList()
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

