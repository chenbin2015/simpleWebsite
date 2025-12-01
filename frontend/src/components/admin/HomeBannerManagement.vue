<template>
  <div class="home-banner-management">
    <div class="section-header">
      <h3>Banner图设置</h3>
      <div class="upload-tip">仅支持上传一张图片</div>
    </div>
    
    <el-upload
      ref="bannerUploadRef"
      :auto-upload="false"
      :on-change="handleBannerChange"
      :on-remove="handleBannerRemove"
      :on-exceed="handleBannerExceed"
      :file-list="bannerFileList"
      list-type="picture-card"
      accept="image/*"
      :limit="1"
    >
      <el-icon><Plus /></el-icon>
    </el-upload>

    <!-- 图片裁剪对话框 -->
    <el-dialog
      v-model="cropDialogVisible"
      title="裁剪图片"
      width="800px"
      :close-on-click-modal="false"
    >
      <div class="crop-container">
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
            aspectRatio: 16 / 9,
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
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import * as homeApi from '@/services/homeApi'
import 'cropperjs/dist/cropper.css'

const bannerUploadRef = ref(null)
const bannerFileList = ref([])

// 裁剪相关
const cropDialogVisible = ref(false)
const cropImageSrc = ref('')
const pendingFile = ref(null)
const pictureCropperRef = ref(null)
const cropperReady = ref(false)

// 构建完整的图片URL
const getImageUrl = (imageUrl) => {
  if (!imageUrl) return ''
  // 如果是完整URL或base64，直接返回
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://') || imageUrl.startsWith('data:')) {
    return imageUrl
  }
  // 如果是相对路径，需要加上后端基础URL
  // 注意：这里假设图片通过后端的静态资源服务访问
  // 根据实际配置可能需要调整
  if (imageUrl.startsWith('/')) {
    return `http://localhost:8080${imageUrl}`
  }
  return `http://localhost:8080/${imageUrl}`
}

// 加载Banner图
const loadBanner = async () => {
  try {
    const response = await homeApi.getBanner()
    if (response.success && response.data && response.data.imageUrl) {
      const imageUrl = response.data.imageUrl
      bannerFileList.value = [{
        uid: response.data.id || Date.now(),
        url: getImageUrl(imageUrl),
        name: 'Banner图'
      }]
    } else {
      bannerFileList.value = []
    }
  } catch (error) {
    console.error('加载Banner图失败:', error)
    ElMessage.error('加载Banner图失败')
    bannerFileList.value = []
  }
}

const handleBannerChange = async (file, fileList) => {
  // 保存待处理的文件
  pendingFile.value = file
  
  // 读取文件为base64，用于裁剪
  const reader = new FileReader()
  reader.onload = (e) => {
    cropImageSrc.value = e.target.result
    cropDialogVisible.value = true
  }
  
  reader.onerror = () => {
    ElMessage.error('读取文件失败')
    if (bannerUploadRef.value) {
      bannerUploadRef.value.clearFiles()
    }
    pendingFile.value = null
  }
  
  reader.readAsDataURL(file.raw)
}

// 裁剪器准备就绪
const onCropReady = () => {
  // 裁剪器已准备好
  cropperReady.value = true
}

// 裁剪事件
const onCrop = () => {
  // 实时裁剪预览（可选）
}

// 取消裁剪
const cancelCrop = () => {
  cropDialogVisible.value = false
  cropImageSrc.value = ''
  pendingFile.value = null
  cropperReady.value = false
  // 清空上传组件的文件列表
  if (bannerUploadRef.value) {
    bannerUploadRef.value.clearFiles()
  }
}

// 确认裁剪并上传
const confirmCrop = async () => {
  if (!cropperReady.value || !cropper || !pendingFile.value) {
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
    
    const croppedImageUrl = croppedCanvas.toDataURL('image/jpeg', 0.9)
    
    // 调用接口上传
    const response = await homeApi.saveBanner(croppedImageUrl)
    
    if (response && response.success) {
      // 上传成功，更新文件列表
      const savedImageUrl = response.data?.imageUrl || croppedImageUrl
      bannerFileList.value = [{
        uid: response.data?.id || Date.now(),
        url: getImageUrl(savedImageUrl),
        name: pendingFile.value.name
      }]
      ElMessage.success('Banner图上传成功')
      
      // 关闭裁剪对话框
      cropDialogVisible.value = false
      cropImageSrc.value = ''
      pendingFile.value = null
      cropperReady.value = false
    } else {
      throw new Error(response?.message || '上传失败')
    }
  } catch (error) {
    console.error('上传Banner图失败:', error)
    ElMessage.error('上传Banner图失败: ' + (error.response?.data?.message || error.message || '未知错误'))
    // 上传失败，恢复之前的文件列表
    await loadBanner()
    if (bannerUploadRef.value) {
      bannerUploadRef.value.clearFiles()
    }
  }
}

const handleBannerExceed = () => {
  ElMessage.warning('Banner图只能上传一张，请先删除现有图片')
}

const handleBannerRemove = async () => {
  try {
    await ElMessageBox.confirm('确定要删除这张Banner图吗？', '提示', {
      type: 'warning'
    })
    
    // 执行后端删除操作
    const response = await homeApi.deleteBanner()
    if (response.success) {
      // 删除成功后，清空文件列表
      bannerFileList.value = []
      if (bannerUploadRef.value) {
        bannerUploadRef.value.clearFiles()
      }
      ElMessage.success('删除成功')
    } else {
      ElMessage.error(response.message || '删除失败')
      // 删除失败，重新加载
      await loadBanner()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除Banner图失败:', error)
      ElMessage.error('删除Banner图失败')
      // 删除失败，重新加载
      await loadBanner()
    }
  }
}

onMounted(() => {
  loadBanner()
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

.upload-tip {
  color: #909399;
  font-size: 12px;
}

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}
</style>
