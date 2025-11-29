<template>
  <div class="banner-management">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <h3>Banner管理</h3>
        </div>
      </template>
      <el-form :model="bannerForm" label-width="120px" label-position="left">
        <el-form-item label="Banner类型">
          <el-radio-group v-model="bannerForm.type" @change="handleBannerTypeChange">
            <el-radio label="image">图片</el-radio>
            <el-radio label="video">视频</el-radio>
          </el-radio-group>
        </el-form-item>

        <!-- 图片上传 -->
        <el-form-item v-if="bannerForm.type === 'image'" label="Banner图片">
          <div class="banner-upload-section">
            <el-upload
              ref="bannerImageUploadRef"
              :auto-upload="false"
              :on-change="handleBannerImageChange"
              :on-remove="handleBannerImageRemove"
              :file-list="bannerImageFileList"
              list-type="picture-card"
              accept="image/*"
              :limit="1"
            >
              <el-icon><Plus /></el-icon>
              <template #tip>
                <div class="el-upload__tip">支持jpg、png等图片格式，建议尺寸1920x1080</div>
              </template>
            </el-upload>
            <div v-if="bannerForm.imageUrl" class="banner-preview">
              <el-image
                :src="bannerForm.imageUrl"
                style="max-width: 100%; max-height: 400px; margin-top: 10px;"
                fit="contain"
                :preview-src-list="[bannerForm.imageUrl]"
              />
              <el-button type="danger" size="small" style="margin-top: 10px;" @click="handleBannerImageDelete">
                删除图片
              </el-button>
            </div>
          </div>
        </el-form-item>

        <!-- 视频上传 -->
        <el-form-item v-if="bannerForm.type === 'video'" label="Banner视频">
          <div class="banner-upload-section">
            <el-upload
              ref="bannerVideoUploadRef"
              :auto-upload="false"
              :on-change="handleBannerVideoChange"
              :file-list="bannerVideoFileList"
              :limit="1"
              accept="video/*"
              list-type="text"
            >
              <el-button type="primary">
                <el-icon><Upload /></el-icon>
                上传视频
              </el-button>
              <template #tip>
                <div class="el-upload__tip">支持mp4、webm等视频格式，建议尺寸1920x1080</div>
              </template>
            </el-upload>
            <div v-if="bannerForm.videoUrl" class="banner-preview">
              <video :src="bannerForm.videoUrl" controls style="max-width: 100%; max-height: 400px; margin-top: 10px;" />
              <el-button type="danger" size="small" style="margin-top: 10px;" @click="handleBannerVideoDelete">
                删除视频
              </el-button>
            </div>
            <div v-else-if="bannerForm.videoUrlExternal" class="banner-preview">
              <div class="external-video-info">
                <p><strong>外部视频URL：</strong>{{ bannerForm.videoUrlExternal }}</p>
                <video :src="bannerForm.videoUrlExternal" controls style="max-width: 100%; max-height: 400px; margin-top: 10px;" />
                <el-button type="danger" size="small" style="margin-top: 10px;" @click="handleBannerVideoExternalDelete">
                  删除视频
                </el-button>
              </div>
            </div>
            <div v-else class="video-placeholder">
              <el-alert type="info" :closable="false" style="margin-top: 10px;">
                <template #default>
                  <div>暂无视频，请上传视频文件或输入外部视频URL</div>
                  <el-input v-model="bannerExternalVideoUrl" placeholder="或输入外部视频URL" style="margin-top: 10px;">
                    <template #append>
                      <el-button @click="handleSetBannerExternalVideo">设置</el-button>
                    </template>
                  </el-input>
                </template>
              </el-alert>
            </div>
          </div>
        </el-form-item>

        <!-- 操作按钮 -->
        <el-form-item>
          <el-button type="primary" size="large" @click="handleBannerSave">
            <el-icon><Check /></el-icon>
            保存
          </el-button>
          <el-button size="large" @click="handleBannerReset">
            <el-icon><RefreshLeft /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Check, RefreshLeft, Plus } from '@element-plus/icons-vue'

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      type: 'image',
      imageUrl: '',
      videoUrl: '',
      videoUrlExternal: ''
    })
  }
})

// Emits
const emit = defineEmits(['update:modelValue', 'save'])

// Refs
const bannerImageUploadRef = ref(null)
const bannerVideoUploadRef = ref(null)
const bannerImageFileList = ref([])
const bannerVideoFileList = ref([])
const bannerExternalVideoUrl = ref('')

// Banner表单数据
const bannerForm = reactive({
  type: props.modelValue?.type || 'image',
  imageUrl: props.modelValue?.imageUrl || '',
  videoUrl: props.modelValue?.videoUrl || '',
  videoUrlExternal: props.modelValue?.videoUrlExternal || ''
})

// 监听外部数据变化
watch(() => props.modelValue, (newVal) => {
  if (newVal) {
    bannerForm.type = newVal.type || 'image'
    bannerForm.imageUrl = newVal.imageUrl || ''
    bannerForm.videoUrl = newVal.videoUrl || ''
    bannerForm.videoUrlExternal = newVal.videoUrlExternal || ''
  }
}, { deep: true })

// 监听内部数据变化，同步到外部
watch(bannerForm, (newVal) => {
  emit('update:modelValue', { ...newVal })
}, { deep: true })

const handleBannerTypeChange = () => {
  // 切换类型时清空之前的内容
  if (bannerForm.type === 'image') {
    bannerForm.videoUrl = ''
    bannerForm.videoUrlExternal = ''
    bannerVideoFileList.value = []
    bannerExternalVideoUrl.value = ''
    if (bannerVideoUploadRef.value) {
      bannerVideoUploadRef.value.clearFiles()
    }
  } else {
    bannerForm.imageUrl = ''
    bannerImageFileList.value = []
    if (bannerImageUploadRef.value) {
      bannerImageUploadRef.value.clearFiles()
    }
  }
}

const handleBannerImageChange = (file, fileList) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    bannerForm.imageUrl = e.target.result
    ElMessage.success('图片上传成功')
  }
  reader.readAsDataURL(file.raw)
  bannerImageFileList.value = fileList
}

const handleBannerImageRemove = () => {
  bannerForm.imageUrl = ''
  bannerImageFileList.value = []
}

const handleBannerImageDelete = () => {
  ElMessageBox.confirm('确定要删除图片吗？', '提示', { type: 'warning' })
    .then(() => {
      bannerForm.imageUrl = ''
      bannerImageFileList.value = []
      if (bannerImageUploadRef.value) {
        bannerImageUploadRef.value.clearFiles()
      }
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleBannerVideoChange = (file) => {
  const maxSize = 200 * 1024 * 1024
  if (file.size > maxSize) {
    ElMessage.warning('视频文件大小不能超过200MB')
    return false
  }
  const reader = new FileReader()
  reader.onload = (e) => {
    bannerForm.videoUrl = e.target.result
    bannerForm.videoUrlExternal = ''
    ElMessage.success('视频上传成功')
  }
  reader.readAsDataURL(file.raw)
}

const handleBannerVideoDelete = () => {
  ElMessageBox.confirm('确定要删除视频吗？', '提示', { type: 'warning' })
    .then(() => {
      bannerForm.videoUrl = ''
      bannerVideoFileList.value = []
      if (bannerVideoUploadRef.value) {
        bannerVideoUploadRef.value.clearFiles()
      }
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleSetBannerExternalVideo = () => {
  if (!bannerExternalVideoUrl.value || !bannerExternalVideoUrl.value.trim()) {
    ElMessage.warning('请输入视频URL')
    return
  }
  bannerForm.videoUrlExternal = bannerExternalVideoUrl.value.trim()
  bannerForm.videoUrl = ''
  bannerVideoFileList.value = []
  if (bannerVideoUploadRef.value) {
    bannerVideoUploadRef.value.clearFiles()
  }
  bannerExternalVideoUrl.value = ''
  ElMessage.success('外部视频URL设置成功')
}

const handleBannerVideoExternalDelete = () => {
  ElMessageBox.confirm('确定要删除外部视频吗？', '提示', { type: 'warning' })
    .then(() => {
      bannerForm.videoUrlExternal = ''
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleBannerSave = () => {
  if (bannerForm.type === 'image' && !bannerForm.imageUrl) {
    ElMessage.warning('请上传Banner图片')
    return
  }
  if (bannerForm.type === 'video' && !bannerForm.videoUrl && !bannerForm.videoUrlExternal) {
    ElMessage.warning('请上传Banner视频或输入外部视频URL')
    return
  }
  emit('save', { ...bannerForm })
  ElMessage.success('保存成功')
}

const handleBannerReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', { type: 'warning' })
    .then(() => {
      bannerForm.type = 'image'
      bannerForm.imageUrl = ''
      bannerForm.videoUrl = ''
      bannerForm.videoUrlExternal = ''
      bannerImageFileList.value = []
      bannerVideoFileList.value = []
      bannerExternalVideoUrl.value = ''
      if (bannerImageUploadRef.value) {
        bannerImageUploadRef.value.clearFiles()
      }
      if (bannerVideoUploadRef.value) {
        bannerVideoUploadRef.value.clearFiles()
      }
      ElMessage.success('重置成功')
    })
    .catch(() => {})
}
</script>

<style scoped>
.banner-management {
  margin-bottom: 20px;
}

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

.banner-upload-section {
  width: 100%;
}

.banner-preview {
  margin-top: 15px;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
  text-align: center;
}

.external-video-info {
  margin-top: 15px;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.external-video-info p {
  margin-bottom: 10px;
  color: #606266;
}

.video-placeholder {
  margin-top: 15px;
}

:deep(.el-card__header) {
  background-color: #fafafa;
  border-bottom: 1px solid #ebeef5;
}
</style>


