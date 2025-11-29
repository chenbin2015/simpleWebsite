<template>
  <div style="padding: 20px; background: #fff;">
    <h1>中心概况 - 详情管理</h1>
    <p>如果你能看到这个，说明路由正常工作了！</p>
    
    <el-card>
      <template #header>
        <h2>中心概况 - 详情管理</h2>
      </template>
      
      <el-form :model="formData" label-width="120px">
        <!-- 视频Banner -->
        <el-form-item label="视频Banner">
          <el-upload
            ref="videoUploadRef"
            :auto-upload="false"
            :on-change="handleVideoChange"
            :file-list="videoFileList"
            :limit="1"
            accept="video/*"
            list-type="text"
          >
            <el-button type="primary">
              <el-icon><Upload /></el-icon>
              上传视频
            </el-button>
          </el-upload>
          <div v-if="formData.videoUrl" style="margin-top: 15px;">
            <video :src="formData.videoUrl" controls style="max-width: 100%; max-height: 300px;" />
            <el-button type="danger" size="small" style="margin-top: 10px;" @click="handleVideoDelete">
              删除视频
            </el-button>
          </div>
          <div v-else-if="formData.videoUrlExternal" style="margin-top: 15px;">
            <p><strong>外部视频URL：</strong>{{ formData.videoUrlExternal }}</p>
            <video :src="formData.videoUrlExternal" controls style="max-width: 100%; max-height: 300px;" />
            <el-button type="danger" size="small" style="margin-top: 10px;" @click="handleVideoExternalDelete">
              删除视频
            </el-button>
          </div>
          <div v-else style="margin-top: 15px;">
            <el-alert type="info" :closable="false">
              <template #default>
                <div>暂无视频，请上传视频文件或输入外部视频URL</div>
                <el-input
                  v-model="externalVideoUrl"
                  placeholder="或输入外部视频URL"
                  style="margin-top: 10px;"
                >
                  <template #append>
                    <el-button @click="handleSetExternalVideo">设置</el-button>
                  </template>
                </el-input>
              </template>
            </el-alert>
          </div>
        </el-form-item>

        <!-- 主标题 -->
        <el-form-item label="主标题">
          <el-input v-model="formData.mainTitle" placeholder="请输入主标题" maxlength="100" show-word-limit />
        </el-form-item>

        <!-- 建设背景 -->
        <el-form-item label="建设背景">
          <RichTextEditor v-model="formData.background" placeholder="请输入建设背景内容" />
        </el-form-item>

        <!-- 现状概况 -->
        <el-form-item label="现状概况">
          <RichTextEditor v-model="formData.overview" placeholder="请输入现状概况内容" />
        </el-form-item>

        <!-- 发展愿景 -->
        <el-form-item label="发展愿景">
          <RichTextEditor v-model="formData.vision" placeholder="请输入发展愿景内容" />
        </el-form-item>

        <!-- 操作按钮 -->
        <el-form-item>
          <el-button type="primary" size="large" @click="handleSave">
            <el-icon><Check /></el-icon>
            保存
          </el-button>
          <el-button size="large" @click="handleReset">
            <el-icon><RefreshLeft /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Check, RefreshLeft } from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'

const videoUploadRef = ref(null)
const videoFileList = ref([])
const externalVideoUrl = ref('')

const formData = reactive({
  videoUrl: '',
  videoUrlExternal: '',
  mainTitle: '东南大学建筑学院实验教学中心',
  background: '<p>建设背景内容...</p>',
  overview: '<p>现状概况内容...</p>',
  vision: '<p>发展愿景内容...</p>'
})

const handleVideoChange = (file) => {
  const maxSize = 200 * 1024 * 1024
  if (file.size > maxSize) {
    ElMessage.warning('视频文件大小不能超过200MB')
    return false
  }
  const reader = new FileReader()
  reader.onload = (e) => {
    formData.videoUrl = e.target.result
    formData.videoUrlExternal = ''
    ElMessage.success('视频上传成功')
  }
  reader.readAsDataURL(file.raw)
}

const handleVideoDelete = () => {
  ElMessageBox.confirm('确定要删除视频吗？', '提示', { type: 'warning' })
    .then(() => {
      formData.videoUrl = ''
      videoFileList.value = []
      if (videoUploadRef.value) {
        videoUploadRef.value.clearFiles()
      }
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleSetExternalVideo = () => {
  if (!externalVideoUrl.value || !externalVideoUrl.value.trim()) {
    ElMessage.warning('请输入视频URL')
    return
  }
  formData.videoUrlExternal = externalVideoUrl.value.trim()
  formData.videoUrl = ''
  videoFileList.value = []
  if (videoUploadRef.value) {
    videoUploadRef.value.clearFiles()
  }
  externalVideoUrl.value = ''
  ElMessage.success('外部视频URL设置成功')
}

const handleVideoExternalDelete = () => {
  ElMessageBox.confirm('确定要删除外部视频吗？', '提示', { type: 'warning' })
    .then(() => {
      formData.videoUrlExternal = ''
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleSave = () => {
  if (!formData.mainTitle || !formData.mainTitle.trim()) {
    ElMessage.warning('请输入主标题')
    return
  }
  console.log('保存数据:', formData)
  ElMessage.success('保存成功')
}

const handleReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', { type: 'warning' })
    .then(() => {
      formData.videoUrl = ''
      formData.videoUrlExternal = ''
      formData.mainTitle = '东南大学建筑学院实验教学中心'
      formData.background = '<p>建设背景内容...</p>'
      formData.overview = '<p>现状概况内容...</p>'
      formData.vision = '<p>发展愿景内容...</p>'
      ElMessage.success('重置成功')
    })
    .catch(() => {})
}
</script>

<style scoped>
</style>
