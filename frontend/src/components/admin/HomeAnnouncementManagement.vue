<template>
  <div class="home-announcement-management">
    <div class="section-header">
      <h3>公告列表</h3>
      <el-button type="primary" @click="handleAnnouncementAdd">
        <el-icon><Plus /></el-icon>
        添加公告
      </el-button>
    </div>
    
    <el-table :data="announcementList" border style="width: 100%" v-loading="announcementLoading">
      <el-table-column type="index" label="序号" width="60" />
      <el-table-column prop="title" label="标题" />
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
            @click="handleAnnouncementEdit(row, $index)"
          >
            编辑
          </el-button>
          <el-button
            type="danger"
            size="small"
            @click="handleAnnouncementDelete($index)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-pagination
      v-model:current-page="announcementPage"
      v-model:page-size="announcementPageSize"
      :page-sizes="[10, 20, 50, 100]"
      :total="announcementTotal"
      layout="total, sizes, prev, pager, next, jumper"
      style="margin-top: 20px; justify-content: flex-end;"
    />

    <!-- 公告编辑对话框 -->
    <el-dialog
      v-model="announcementDialogVisible"
      :title="announcementDialogTitle"
      width="1000px"
      :close-on-click-modal="false"
    >
      <el-form :model="announcementForm" label-width="100px">
        <el-form-item label="标题" required>
          <el-input v-model="announcementForm.title" placeholder="请输入标题" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="内容" required>
          <RichTextEditor
            v-model="announcementForm.content"
            placeholder="请输入公告内容，支持插入图片和视频"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="announcementForm.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="announcementDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAnnouncementSubmit">确定</el-button>
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

const announcementList = ref([])
const announcementPage = ref(1)
const announcementPageSize = ref(10)
const announcementTotal = ref(0)
const announcementLoading = ref(false)
const announcementStatusFilter = ref('')
const announcementKeywordFilter = ref('')

const announcementDialogVisible = ref(false)
const announcementDialogTitle = ref('添加公告')
const announcementForm = reactive({
  id: null,
  title: '',
  content: '',
  status: 'draft'
})
const announcementEditId = ref(null)

const handleAnnouncementAdd = () => {
  announcementDialogTitle.value = '添加公告'
  announcementForm.id = null
  announcementForm.title = ''
  announcementForm.content = ''
  announcementForm.status = 'draft'
  announcementEditId.value = null
  announcementDialogVisible.value = true
}

// 加载公告列表
const loadAnnouncement = async () => {
  try {
    announcementLoading.value = true
    const response = await homeApi.getAnnouncementList({
      page: announcementPage.value,
      pageSize: announcementPageSize.value,
      status: announcementStatusFilter.value || undefined,
      keyword: announcementKeywordFilter.value || undefined
    })
    if (response.success && response.data) {
      announcementList.value = response.data
      announcementTotal.value = response.total || 0
    } else {
      announcementList.value = []
      announcementTotal.value = 0
    }
  } catch (error) {
    console.error('加载公告列表失败:', error)
    ElMessage.error('加载公告列表失败')
    announcementList.value = []
    announcementTotal.value = 0
  } finally {
    announcementLoading.value = false
  }
}

watch([announcementPage, announcementPageSize], () => {
  loadAnnouncement()
})

const handleAnnouncementEdit = async (row, index) => {
  try {
    const response = await homeApi.getAnnouncementById(row.id)
    if (response.success && response.data) {
      const data = response.data
      announcementDialogTitle.value = '编辑公告'
      announcementForm.id = data.id
      announcementForm.title = data.title
      announcementForm.content = data.content
      announcementForm.status = data.status
      announcementEditId.value = data.id
      announcementDialogVisible.value = true
    }
  } catch (error) {
    console.error('加载公告详情失败:', error)
    ElMessage.error('加载公告详情失败')
  }
}

const handleAnnouncementSubmit = async () => {
  if (!announcementForm.title) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!announcementForm.content || announcementForm.content.trim() === '' || announcementForm.content === '<p><br></p>') {
    ElMessage.warning('请输入内容')
    return
  }
  
  try {
    const announcementData = {
      title: announcementForm.title,
      content: announcementForm.content,
      status: announcementForm.status
    }
    
    if (announcementEditId.value) {
      const response = await homeApi.updateAnnouncement(announcementEditId.value, announcementData)
      if (response.success) {
        await loadAnnouncement()
        ElMessage.success('编辑成功')
      }
    } else {
      const response = await homeApi.addAnnouncement(announcementData)
      if (response.success) {
        await loadAnnouncement()
        ElMessage.success('添加成功')
      }
    }
    announcementDialogVisible.value = false
  } catch (error) {
    console.error('保存公告失败:', error)
    ElMessage.error('保存公告失败')
  }
}

const handleAnnouncementDelete = async (index) => {
  try {
    await ElMessageBox.confirm('确定要删除这条公告吗？', '提示', {
      type: 'warning'
    })
    
    const announcementId = announcementList.value[index].id
    const response = await homeApi.deleteAnnouncement(announcementId)
    if (response.success) {
      await loadAnnouncement()
      ElMessage.success('删除成功')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除公告失败:', error)
      ElMessage.error('删除公告失败')
    }
  }
}

onMounted(() => {
  loadAnnouncement()
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
