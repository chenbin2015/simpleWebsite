<template>
  <div class="home-news-management">
    <div class="section-header">
      <h3>新闻列表</h3>
      <el-button type="primary" @click="handleNewsAdd">
        <el-icon><Plus /></el-icon>
        添加新闻
      </el-button>
    </div>
    
    <el-table :data="newsList" border style="width: 100%" v-loading="newsLoading">
      <el-table-column type="index" label="序号" width="60" />
      <el-table-column prop="title" label="标题" min-width="200" />
      <el-table-column prop="author" label="作者" width="120" />
      <el-table-column label="标签" width="200">
        <template #default="{ row }">
          <el-tag
            v-for="tag in (row.tags || [])"
            :key="tag"
            size="small"
            style="margin-right: 5px;"
          >
            {{ tag }}
          </el-tag>
          <span v-if="!row.tags || row.tags.length === 0" style="color: #909399;">无标签</span>
        </template>
      </el-table-column>
      <el-table-column prop="publishTime" label="发布时间" width="180" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 'published' ? 'success' : 'info'">
            {{ row.status === 'published' ? '已发布' : '草稿' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row, $index }">
          <el-button
            type="primary"
            size="small"
            @click="handleNewsEdit(row, $index)"
          >
            编辑
          </el-button>
          <el-button
            type="danger"
            size="small"
            @click="handleNewsDelete($index)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-pagination
      v-model:current-page="newsPage"
      v-model:page-size="newsPageSize"
      :page-sizes="[10, 20, 50, 100]"
      :total="newsTotal"
      layout="total, sizes, prev, pager, next, jumper"
      style="margin-top: 20px; justify-content: flex-end;"
    />

    <!-- 新闻编辑对话框 -->
    <el-dialog
      v-model="newsDialogVisible"
      :title="newsDialogTitle"
      width="1000px"
      :close-on-click-modal="false"
    >
      <el-form :model="newsForm" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="newsForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="newsForm.author" placeholder="请输入作者" />
        </el-form-item>
        <el-form-item label="标签">
          <el-select
            v-model="newsForm.tags"
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
        <el-form-item label="内容">
          <RichTextEditor
            v-model="newsForm.content"
            placeholder="请输入新闻内容，支持插入图片和视频"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="newsForm.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="newsDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleNewsSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'
import * as homeApi from '@/services/homeApi'

const newsList = ref([])
const newsPage = ref(1)
const newsPageSize = ref(10)
const newsTotal = ref(0)
const newsLoading = ref(false)
const newsStatusFilter = ref('')
const newsKeywordFilter = ref('')

const availableTags = ref(['重要', '通知', '公告', '活动', '新闻', '更新'])

const newsDialogVisible = ref(false)
const newsDialogTitle = ref('添加新闻')
const newsForm = reactive({
  id: null,
  title: '',
  author: '',
  content: '',
  tags: [],
  status: 'draft'
})
const newsEditId = ref(null)

// 加载新闻列表
const loadNews = async () => {
  try {
    newsLoading.value = true
    const response = await homeApi.getNewsList({
      page: newsPage.value,
      pageSize: newsPageSize.value,
      status: newsStatusFilter.value || undefined,
      keyword: newsKeywordFilter.value || undefined
    })
    if (response.success && response.data) {
      newsList.value = response.data.map(item => ({
        ...item,
        tags: typeof item.tags === 'string' ? JSON.parse(item.tags || '[]') : (item.tags || [])
      }))
      newsTotal.value = response.total || 0
    } else {
      newsList.value = []
      newsTotal.value = 0
    }
  } catch (error) {
    console.error('加载新闻列表失败:', error)
    ElMessage.error('加载新闻列表失败')
    newsList.value = []
    newsTotal.value = 0
  } finally {
    newsLoading.value = false
  }
}

watch([newsPage, newsPageSize], () => {
  loadNews()
})

const handleNewsAdd = () => {
  newsDialogTitle.value = '添加新闻'
  newsForm.id = null
  newsForm.title = ''
  newsForm.author = ''
  newsForm.content = ''
  newsForm.tags = []
  newsForm.status = 'draft'
  newsEditId.value = null
  newsDialogVisible.value = true
}

const handleNewsEdit = async (row, index) => {
  try {
    const response = await homeApi.getNewsById(row.id)
    if (response.success && response.data) {
      const data = response.data
      newsDialogTitle.value = '编辑新闻'
      newsForm.id = data.id
      newsForm.title = data.title
      newsForm.author = data.author
      newsForm.content = data.content || ''
      newsForm.tags = typeof data.tags === 'string' ? JSON.parse(data.tags || '[]') : (data.tags || [])
      newsForm.status = data.status
      newsEditId.value = data.id
      newsDialogVisible.value = true
    }
  } catch (error) {
    console.error('加载新闻详情失败:', error)
    ElMessage.error('加载新闻详情失败')
  }
}

const handleNewsSubmit = async () => {
  if (!newsForm.title) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!newsForm.content || newsForm.content.trim() === '' || newsForm.content === '<p><br></p>') {
    ElMessage.warning('请输入内容')
    return
  }
  
  newsForm.tags.forEach(tag => {
    if (!availableTags.value.includes(tag)) {
      availableTags.value.push(tag)
    }
  })
  
  try {
    const newsData = {
      title: newsForm.title,
      author: newsForm.author,
      content: newsForm.content,
      tags: newsForm.tags,
      status: newsForm.status
    }
    
    if (newsEditId.value) {
      const response = await homeApi.updateNews(newsEditId.value, newsData)
      if (response.success) {
        await loadNews()
        ElMessage.success('编辑成功')
      }
    } else {
      const response = await homeApi.addNews(newsData)
      if (response.success) {
        await loadNews()
        ElMessage.success('添加成功')
      }
    }
    newsDialogVisible.value = false
  } catch (error) {
    console.error('保存新闻失败:', error)
    ElMessage.error('保存新闻失败')
  }
}

const handleNewsDelete = async (index) => {
  try {
    await ElMessageBox.confirm('确定要删除这条新闻吗？', '提示', {
      type: 'warning'
    })
    
    const newsId = newsList.value[index].id
    const response = await homeApi.deleteNews(newsId)
    if (response.success) {
      await loadNews()
      ElMessage.success('删除成功')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除新闻失败:', error)
      ElMessage.error('删除新闻失败')
    }
  }
}

onMounted(() => {
  loadNews()
})
</script>

<style scoped>
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
}
</style>
