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
              :before-remove="handleBannerImageBeforeRemove"
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

    <!-- 图片裁剪对话框 -->
    <el-dialog
      v-model="cropDialogVisible"
      title="裁剪图片"
      width="800px"
      :close-on-click-modal="false"
      append-to-body
      :z-index="3000"
    >
      <div class="crop-container" v-if="cropImageSrc">
        <vue-picture-cropper
          ref="pictureCropperRef"
          :boxStyle="{
            width: '100%',
            height: '400px',
            backgroundColor: '#f8f8f8',
            margin: 'auto'
          }"
          :img="cropImageSrc"
          :options="{
            viewMode: 1,
            dragMode: 'move',
            aspectRatio: NaN,
            autoCropArea: 0.8,
            restore: false,
            guides: true,
            center: true,
            highlight: false,
            cropBoxMovable: true,
            cropBoxResizable: true,
            toggleDragModeOnDblclick: false
          }"
          @ready="onCropReady"
          @crop="onCrop"
        />
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelCrop">取消</el-button>
          <el-button type="primary" @click="confirmCrop">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, watch, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Check, RefreshLeft, Plus } from '@element-plus/icons-vue'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import 'cropperjs/dist/cropper.css'

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
const emit = defineEmits(['update:modelValue', 'save', 'delete'])

// Refs
const bannerImageUploadRef = ref(null)
const bannerVideoUploadRef = ref(null)
const bannerImageFileList = ref([])
const bannerVideoFileList = ref([])
const bannerExternalVideoUrl = ref('')
const bannerImageFile = ref(null)
const bannerVideoFile = ref(null)

// 裁剪相关
const cropDialogVisible = ref(false)
const cropImageSrc = ref('')
const pendingImageFile = ref(null)
const pictureCropperRef = ref(null)
const cropperReady = ref(false)

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
    
    // 更新文件列表用于显示
    if (newVal.imageUrl && !newVal.imageUrl.startsWith('data:')) {
      bannerImageFileList.value = [{ url: newVal.imageUrl, uid: Date.now() }]
    } else {
      // 如果没有图片，清空文件列表
      bannerImageFileList.value = []
    }
    
    if (newVal.videoUrl && !newVal.videoUrl.startsWith('data:')) {
      bannerVideoFileList.value = [{ url: newVal.videoUrl, uid: Date.now() }]
    } else {
      // 如果没有视频，清空文件列表
      bannerVideoFileList.value = []
    }
  } else {
    // 如果 newVal 为空，清空所有状态
    bannerForm.imageUrl = ''
    bannerForm.videoUrl = ''
    bannerForm.videoUrlExternal = ''
    bannerImageFileList.value = []
    bannerVideoFileList.value = []
  }
}, { deep: true, immediate: true })

// 监听内部数据变化，同步到外部
watch(bannerForm, (newVal) => {
  emit('update:modelValue', { ...newVal })
}, { deep: true })

const handleBannerTypeChange = () => {
  // 切换类型时不清空数据，只切换显示
  // 数据保留在 bannerForm 中，根据 type 显示不同的内容
  // 只有在用户明确删除或保存新数据时，才会清空对应的数据
}

const handleBannerImageChange = (file, fileList) => {
  // 保存待处理的文件
  pendingImageFile.value = file.raw
  
  // 读取文件为base64，用于裁剪
  const reader = new FileReader()
  reader.onload = (e) => {
    cropImageSrc.value = e.target.result
    cropDialogVisible.value = true
  }
  
  reader.onerror = () => {
    ElMessage.error('读取文件失败')
    if (bannerImageUploadRef.value) {
      bannerImageUploadRef.value.clearFiles()
    }
    pendingImageFile.value = null
  }
  
  reader.readAsDataURL(file.raw)
  bannerImageFileList.value = fileList
}

const handleBannerImageBeforeRemove = async (file) => {
  try {
    await ElMessageBox.confirm('确定要删除这张图片吗？', '提示', {
      type: 'warning'
    })
    
    // 判断是否是已保存到服务器的图片（不是Base64）
    const isServerImage = bannerForm.imageUrl && 
                          !bannerForm.imageUrl.startsWith('data:')
    
    if (isServerImage) {
      // 已保存到服务器的图片，通知父组件调用后端删除API并重新加载数据
      emit('delete', { type: 'image' })
      // 删除服务器图片后，返回 true 允许从上传组件中移除
      return true
    }
    
    // 本地图片或Base64图片，只清空本地状态
    bannerForm.imageUrl = ''
    bannerImageFile.value = null
    // 更新表单数据
    emit('update:modelValue', { ...bannerForm })
    // 允许从上传组件中移除
    return true
  } catch (error) {
    // 用户取消删除，返回 false 阻止删除
    return false
  }
}

const handleBannerImageDelete = async () => {
  try {
    await ElMessageBox.confirm('确定要删除图片吗？', '提示', { type: 'warning' })
    
    // 判断是否是已保存到服务器的图片（不是Base64）
    const isServerImage = bannerForm.imageUrl && 
                          !bannerForm.imageUrl.startsWith('data:')
    
    if (isServerImage) {
      // 已保存到服务器的图片，通知父组件调用后端删除API并重新加载数据
      // 父组件会负责重新加载数据并更新状态
      emit('delete', { type: 'image' })
      return
    }
    
    // 本地图片或Base64图片，只清空本地状态
    bannerForm.imageUrl = ''
    bannerImageFile.value = null
    bannerImageFileList.value = []
    if (bannerImageUploadRef.value) {
      bannerImageUploadRef.value.clearFiles()
    }
    
    // 更新表单数据
    emit('update:modelValue', { ...bannerForm })
    
    ElMessage.success('删除成功')
  } catch (error) {
    // 用户取消删除
  }
}

const handleBannerVideoChange = (file) => {
  const maxSize = 200 * 1024 * 1024
  if (file.size > maxSize) {
    ElMessage.warning('视频文件大小不能超过200MB')
    return false
  }
  bannerVideoFile.value = file.raw
  // 预览用base64
  const reader = new FileReader()
  reader.onload = (e) => {
    bannerForm.videoUrl = e.target.result
    bannerForm.videoUrlExternal = ''
    ElMessage.success('视频选择成功')
  }
  reader.readAsDataURL(file.raw)
}

const handleBannerVideoDelete = () => {
  ElMessageBox.confirm('确定要删除视频吗？', '提示', { type: 'warning' })
    .then(() => {
      bannerForm.videoUrl = ''
      bannerVideoFile.value = null
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
  bannerVideoFile.value = null
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
  // 传递文件对象和表单数据（包含所有数据，让后端决定保留哪些）
  const saveData = {
    type: bannerForm.type,
    videoFile: bannerVideoFile.value,
    videoUrlExternal: bannerForm.videoUrlExternal,
    videoUrl: bannerForm.videoUrl
  }
  
  // 图片处理：优先使用 Base64（来自裁剪），否则使用文件，最后使用已有的图片URL
  if (bannerForm.type === 'image') {
    if (bannerForm.imageUrl && bannerForm.imageUrl.startsWith('data:image/')) {
      // Base64 图片（来自裁剪）
      saveData.imageUrl = bannerForm.imageUrl
    } else if (bannerImageFile.value) {
      // 文件上传
      saveData.imageFile = bannerImageFile.value
    } else if (bannerForm.imageUrl && !bannerForm.imageUrl.startsWith('data:')) {
      // 已有的图片URL（不是Base64），保留原有数据
      saveData.imageUrl = bannerForm.imageUrl
    }
  }
  
  // 视频处理：如果有新文件或新外部URL，使用新的；否则保留原有的视频数据
  if (bannerForm.type === 'video') {
    if (!bannerVideoFile.value && !bannerForm.videoUrlExternal) {
      // 如果没有新视频数据，保留原有的视频数据（如果有）
      // videoUrl 和 videoUrlExternal 已经在 saveData 中
    }
  }
  
  console.log('保存Banner数据:', saveData)
  emit('save', saveData)
}

const handleBannerReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', { type: 'warning' })
    .then(() => {
      bannerForm.type = 'image'
      bannerForm.imageUrl = ''
      bannerForm.videoUrl = ''
      bannerForm.videoUrlExternal = ''
      bannerImageFile.value = null
      bannerVideoFile.value = null
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

// 裁剪相关函数
const onCropReady = () => {
  cropperReady.value = true
}

const onCrop = () => {
  // 实时裁剪预览（可选）
}

const cancelCrop = () => {
  cropDialogVisible.value = false
  cropImageSrc.value = ''
  pendingImageFile.value = null
  cropperReady.value = false
  // 清空上传组件的文件列表
  if (bannerImageUploadRef.value) {
    bannerImageUploadRef.value.clearFiles()
  }
}

const confirmCrop = async () => {
  if (!cropperReady.value || !cropper || !pendingImageFile.value) {
    ElMessage.error('裁剪器未准备好，请稍候重试')
    return
  }
  
  try {
    // 获取裁剪后的base64图片
    const croppedCanvas = cropper.getCroppedCanvas({
      width: 1920,  // 推荐宽度
      height: 1080, // 推荐高度（16:9比例）
      imageSmoothingEnabled: true,
      imageSmoothingQuality: 'high'
    })
    
    if (!croppedCanvas) {
      ElMessage.error('裁剪失败，请重试')
      return
    }
    
    // 获取裁剪后的图片URL（Base64格式）
    const croppedImageUrl = croppedCanvas.toDataURL('image/jpeg', 0.9)
    
    // 更新表单数据（保存Base64）
    bannerForm.imageUrl = croppedImageUrl
    
    // 更新文件列表用于显示
    bannerImageFileList.value = [{
      uid: Date.now(),
      url: croppedImageUrl,
      name: '裁剪后的图片.jpg'
    }]
    
    // 清空之前的文件对象，确保保存时使用 Base64
    bannerImageFile.value = null
    
    ElMessage.success('图片裁剪成功')
    
    // 关闭裁剪对话框
    cropDialogVisible.value = false
    cropImageSrc.value = ''
    pendingImageFile.value = null
    cropperReady.value = false
  } catch (error) {
    console.error('裁剪图片失败:', error)
    ElMessage.error('裁剪图片失败: ' + (error.message || '未知错误'))
    // 裁剪失败，清空文件列表
    if (bannerImageUploadRef.value) {
      bannerImageUploadRef.value.clearFiles()
    }
    pendingImageFile.value = null
  }
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

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}
</style>


