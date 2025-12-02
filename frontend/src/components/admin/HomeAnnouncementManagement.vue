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
        <el-form-item label="描述">
          <el-input 
            v-model="announcementForm.description" 
            type="textarea" 
            :rows="3"
            placeholder="请输入公告描述（最多200字）" 
            maxlength="200" 
            show-word-limit 
          />
        </el-form-item>
        <el-form-item label="附件">
          <div style="width: 100%;">
            <el-upload
              ref="attachmentUploadRef"
              :auto-upload="false"
              :limit="1"
              accept=".pdf"
              :on-change="handleAttachmentChange"
              :on-remove="handleAttachmentRemove"
              :file-list="attachmentFileList"
              :before-upload="beforeAttachmentUpload"
            >
              <template #trigger>
                <el-button type="primary">选择附件（仅支持PDF）</el-button>
              </template>
            </el-upload>
            <div v-if="announcementForm.attachmentName && !attachmentFile && !shouldRemoveAttachment" style="margin-top: 10px; display: flex; align-items: center; gap: 10px;">
              <span style="color: #606266;">当前附件：{{ announcementForm.attachmentName }}</span>
              <el-button type="danger" size="small" @click="handleRemoveAttachment">删除附件</el-button>
            </div>
            <div v-if="attachmentFile" style="margin-top: 10px; color: #606266;">
              已选择附件：{{ attachmentFile.name }}
            </div>
          </div>
        </el-form-item>
        <el-form-item label="内容">
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
import { ElMessage, ElMessageBox, ElLoading } from 'element-plus'
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
  description: '',
  content: '',
  attachmentUrl: '',
  attachmentName: '',
  status: 'draft'
})
const announcementEditId = ref(null)
const attachmentFile = ref(null)
const attachmentUploadRef = ref(null)
const attachmentFileList = ref([])
const shouldRemoveAttachment = ref(false)

const handleAnnouncementAdd = () => {
  announcementDialogTitle.value = '添加公告'
  announcementForm.id = null
  announcementForm.title = ''
  announcementForm.description = ''
  announcementForm.content = ''
  announcementForm.attachmentUrl = ''
  announcementForm.attachmentName = ''
  announcementForm.status = 'draft'
  announcementEditId.value = null
  attachmentFile.value = null
  attachmentFileList.value = []
  shouldRemoveAttachment.value = false
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
      announcementForm.description = data.description || ''
      announcementForm.content = data.content
      announcementForm.attachmentUrl = data.attachmentUrl || ''
      announcementForm.attachmentName = data.attachmentName || ''
      announcementForm.status = data.status
      announcementEditId.value = data.id
      attachmentFile.value = null
      attachmentFileList.value = []
      shouldRemoveAttachment.value = false
      announcementDialogVisible.value = true
    }
  } catch (error) {
    console.error('加载公告详情失败:', error)
    ElMessage.error('加载公告详情失败')
  }
}

// 附件相关处理
const handleAttachmentChange = (file, fileList) => {
  attachmentFile.value = file.raw
  attachmentFileList.value = fileList
  // 如果选择了新文件，清除删除标记
  shouldRemoveAttachment.value = false
}

const handleAttachmentRemove = () => {
  attachmentFile.value = null
  attachmentFileList.value = []
}

const beforeAttachmentUpload = (file) => {
  // 检查文件类型（只允许PDF）
  const fileName = file.name.toLowerCase()
  if (!fileName.endsWith('.pdf')) {
    ElMessage.error('公告附件仅支持PDF格式，请选择PDF文件')
    return false
  }
  
  // 检查文件大小（100MB限制）
  const maxSize = 100 * 1024 * 1024
  if (file.size > maxSize) {
    ElMessage.error('附件大小不能超过100MB')
    return false
  }
  return false // 阻止自动上传，我们手动上传
}

const handleRemoveAttachment = () => {
  announcementForm.attachmentUrl = ''
  announcementForm.attachmentName = ''
  attachmentFile.value = null
  attachmentFileList.value = []
  shouldRemoveAttachment.value = true
  ElMessage.success('附件已标记删除')
}

const handleAnnouncementSubmit = async () => {
  if (!announcementForm.title) {
    ElMessage.warning('请输入标题')
    return
  }
  
  const loading = ElLoading.service({
    lock: true,
    text: '保存中，请稍候...',
    background: 'rgba(0, 0, 0, 0.7)'
  })
  
  try {
    // 构建FormData
    const formData = new FormData()
    formData.append('title', announcementForm.title)
    formData.append('description', announcementForm.description || '')
    formData.append('content', announcementForm.content)
    formData.append('status', announcementForm.status)
    
    // 如果有新上传的附件
    if (attachmentFile.value) {
      // 再次验证文件类型（防止绕过前端验证）
      const fileName = attachmentFile.value.name.toLowerCase()
      if (!fileName.endsWith('.pdf')) {
        ElMessage.error('公告附件仅支持PDF格式')
        loading.close()
        return
      }
      formData.append('attachment', attachmentFile.value)
    }
    
    // 如果编辑时删除了附件
    if (announcementEditId.value && shouldRemoveAttachment.value && !attachmentFile.value) {
      formData.append('removeAttachment', 'true')
    }
    
    if (announcementEditId.value) {
      const response = await homeApi.updateAnnouncement(announcementEditId.value, formData)
      if (response.success) {
        await loadAnnouncement()
        ElMessage.success('编辑成功')
        announcementDialogVisible.value = false
      }
    } else {
      const response = await homeApi.addAnnouncement(formData)
      if (response.success) {
        await loadAnnouncement()
        ElMessage.success('添加成功')
        announcementDialogVisible.value = false
      }
    }
  } catch (error) {
    console.error('保存公告失败:', error)
    ElMessage.error('保存公告失败: ' + (error.response?.data?.message || error.message || '未知错误'))
  } finally {
    loading.close()
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
