<template>
  <div class="home-carousel-management">
    <div class="section-header">
      <h3>轮播图列表</h3>
      <el-button type="primary" @click="handleCarouselAdd">
        <el-icon><Plus /></el-icon>
        添加轮播图
      </el-button>
    </div>
    
    <el-table :data="carouselList" border style="width: 100%" v-loading="carouselLoading">
      <el-table-column type="index" label="序号" width="60" />
      <el-table-column label="图片" width="150">
        <template #default="{ row }">
          <el-image
            :src="getImageUrl(row.image)"
            :preview-src-list="[getImageUrl(row.image)]"
            style="width: 120px; height: 80px;"
            fit="cover"
          />
        </template>
      </el-table-column>
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="description" label="描述" show-overflow-tooltip />
      <el-table-column prop="link" label="链接地址" />
      <el-table-column prop="sort" label="排序" width="100" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row, $index }">
          <el-button
            type="primary"
            size="small"
            @click="handleCarouselEdit(row, $index)"
          >
            编辑
          </el-button>
          <el-button
            type="danger"
            size="small"
            @click="handleCarouselDelete($index)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 轮播图编辑对话框 -->
    <el-dialog
      v-model="carouselDialogVisible"
      :title="carouselDialogTitle"
      width="800px"
    >
      <el-form :model="carouselForm" label-width="100px">
        <el-form-item label="图片">
          <el-upload
            ref="carouselUploadRef"
            :auto-upload="false"
            :on-change="handleCarouselImageChange"
            :on-remove="handleCarouselImageRemove"
            :file-list="uploadFileList"
            list-type="picture-card"
            accept="image/*"
            multiple
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
          <div class="upload-tip">支持多张图片上传，每张图片可单独配置标题、链接和排序</div>
        </el-form-item>
        <el-divider />
        <div v-if="carouselImageList.length > 0">
          <div
            v-for="(item, index) in carouselImageList"
            :key="item.uid || index"
            class="carousel-item-config"
          >
            <el-card shadow="hover" style="margin-bottom: 15px;">
              <div class="item-header">
                <el-image
                  :src="getImageUrl(item.url)"
                  style="width: 120px; height: 80px; margin-right: 15px;"
                  fit="cover"
                />
                <div class="item-form" style="flex: 1;">
                  <el-form-item label="标题" style="margin-bottom: 15px;" required>
                    <el-input
                      v-model="item.title"
                      placeholder="请输入标题"
                      maxlength="50"
                      show-word-limit
                      @input="updateCarouselItemConfig(index, 'title', $event)"
                    />
                  </el-form-item>
                  <el-form-item label="描述" style="margin-bottom: 15px;">
                    <el-input
                      v-model="item.description"
                      type="textarea"
                      :rows="3"
                      placeholder="请输入轮播图描述（可选）"
                      maxlength="200"
                      show-word-limit
                      @input="updateCarouselItemConfig(index, 'description', $event)"
                    />
                  </el-form-item>
                  <el-form-item label="链接地址" style="margin-bottom: 15px;">
                    <el-input
                      v-model="item.link"
                      placeholder="请输入链接地址（可选）"
                      maxlength="200"
                      show-word-limit
                      @input="updateCarouselItemConfig(index, 'link', $event)"
                    />
                  </el-form-item>
                  <el-form-item label="排序">
                    <el-input-number
                      v-model="item.sort"
                      :min="0"
                      @change="updateCarouselItemConfig(index, 'sort', $event)"
                    />
                  </el-form-item>
                </div>
              </div>
            </el-card>
          </div>
        </div>
      </el-form>
      <template #footer>
        <el-button @click="carouselDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleCarouselSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 图片裁剪对话框 -->
    <el-dialog
      v-model="cropDialogVisible"
      title="裁剪图片"
      width="800px"
      :close-on-click-modal="false"
      :z-index="3000"
      append-to-body
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
import { ref, reactive, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import * as homeApi from '@/services/homeApi'
import { buildImageUrl } from '@/utils/url'
import 'cropperjs/dist/cropper.css'

const carouselList = ref([])
const carouselLoading = ref(false)

// 加载轮播图列表
const loadCarousel = async () => {
  try {
    carouselLoading.value = true
    const response = await homeApi.getCarouselList()
    if (response.success && response.data) {
      carouselList.value = response.data
    } else {
      carouselList.value = []
    }
  } catch (error) {
    console.error('加载轮播图失败:', error)
    ElMessage.error('加载轮播图失败')
    carouselList.value = []
  } finally {
    carouselLoading.value = false
  }
}

const carouselDialogVisible = ref(false)
const carouselDialogTitle = ref('添加轮播图')
const carouselUploadRef = ref(null)
const carouselForm = reactive({
  id: null,
  image: '',
  title: '',
  link: '',
  sort: 0
})
const carouselImageList = ref([])
const uploadFileList = ref([]) // el-upload 组件的文件列表（用于显示上传的文件）
const carouselEditId = ref(null)

// 裁剪相关
const cropDialogVisible = ref(false)
const cropImageSrc = ref('')
const pendingFileQueue = ref([]) // 待裁剪文件队列
const currentPendingFile = ref(null)
const pictureCropperRef = ref(null)
const cropperReady = ref(false)

// 构建完整的图片URL
const getImageUrl = buildImageUrl

const handleCarouselAdd = () => {
  carouselDialogTitle.value = '添加轮播图'
  carouselForm.id = null
  carouselForm.image = ''
  carouselForm.title = ''
  carouselForm.link = ''
  carouselForm.sort = carouselList.value.length + 1
  carouselImageList.value = []
  uploadFileList.value = []
  pendingFileQueue.value = []
  carouselEditId.value = null
  if (carouselUploadRef.value) {
    carouselUploadRef.value.clearFiles()
  }
  carouselDialogVisible.value = true
}

const handleCarouselEdit = (row, index) => {
  carouselDialogTitle.value = '编辑轮播图'
  carouselForm.id = row.id
  carouselForm.image = row.image
  carouselForm.title = row.title
  carouselForm.link = row.link
  carouselForm.sort = row.sort
    carouselImageList.value = row.image ? [{
    url: getImageUrl(row.image),
    name: `image-${row.id}`,
    title: row.title || '',
    description: row.description || '',
    link: row.link || '',
    sort: row.sort || 0
  }] : []
  carouselEditId.value = row.id
  if (carouselUploadRef.value) {
    carouselUploadRef.value.clearFiles()
  }
  carouselDialogVisible.value = true
}

const handleCarouselImageChange = (file, fileList) => {
  // 更新上传组件的文件列表（仅用于显示）
  uploadFileList.value = fileList
  
  // 将文件添加到待裁剪队列
  const reader = new FileReader()
  reader.onload = (e) => {
    // 检查是否是新文件（还没有裁剪过的）
    const existingFile = carouselImageList.value.find(f => f.uid === file.uid)
    if (!existingFile) {
      // 新文件，添加到裁剪队列
      pendingFileQueue.value.push({
        file: file,
        base64: e.target.result,
        uid: file.uid
      })
      // 立即处理队列
      if (pendingFileQueue.value.length === 1) {
        processCropQueue()
      }
    }
  }
  reader.onerror = () => {
    ElMessage.error('读取文件失败')
  }
  reader.readAsDataURL(file.raw)
}

// 处理裁剪队列
const processCropQueue = () => {
  // 如果正在处理其他文件，等待
  if (cropDialogVisible.value || !pendingFileQueue.value.length) {
    return
  }
  
  // 取出队列中的第一个文件
  const fileItem = pendingFileQueue.value.shift()
  if (!fileItem || !fileItem.base64) {
    // 如果文件无效，继续处理下一个
    processCropQueue()
    return
  }
  
  currentPendingFile.value = fileItem
  cropImageSrc.value = fileItem.base64
  cropperReady.value = false
  
  // 先设置图片源，等待DOM更新后再打开对话框
  nextTick(async () => {
    // 等待图片加载完成
    await new Promise(resolve => setTimeout(resolve, 300))
    cropDialogVisible.value = true
  })
}

// 裁剪器准备就绪
const onCropReady = () => {
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
  currentPendingFile.value = null
  cropperReady.value = false
  
  // 继续处理队列中的下一个文件
  processCropQueue()
}

// 确认裁剪
const confirmCrop = () => {
  if (!cropperReady.value || !cropper || !currentPendingFile.value) {
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
    
    // 添加到图片列表（已裁剪完成的）
    const newImageItem = {
      uid: currentPendingFile.value.uid,
      url: croppedImageUrl,
      name: currentPendingFile.value.file.name,
      raw: currentPendingFile.value.file.raw,
      title: '',
      description: '',
      link: '',
      sort: carouselImageList.value.length
    }
    
    carouselImageList.value.push(newImageItem)
    
    // 从上传文件列表中移除（因为已经裁剪完成并添加到列表）
    uploadFileList.value = uploadFileList.value.filter(f => f.uid !== currentPendingFile.value.uid)
    
    // 关闭裁剪对话框
    cropDialogVisible.value = false
    cropImageSrc.value = ''
    currentPendingFile.value = null
    cropperReady.value = false
    
    // 继续处理队列中的下一个文件
    processCropQueue()
  } catch (error) {
    console.error('裁剪图片失败:', error)
    ElMessage.error('裁剪图片失败: ' + (error.message || '未知错误'))
  }
}

const handleCarouselImageRemove = (file, fileList) => {
  // 更新上传组件文件列表
  uploadFileList.value = fileList
  
  // 从已裁剪列表中移除
  carouselImageList.value = carouselImageList.value.filter(f => f.uid !== file.uid)
}

const updateCarouselItemConfig = (index, field, value) => {
  if (carouselImageList.value[index]) {
    carouselImageList.value[index][field] = value
  }
}

const handleCarouselSubmit = async () => {
  if (carouselImageList.value.length === 0) {
    ElMessage.warning('请至少上传一张图片')
    return
  }
  
  const hasEmptyTitle = carouselImageList.value.some(item => !item.title || item.title.trim() === '')
  if (hasEmptyTitle) {
    ElMessage.warning('请为所有图片填写标题')
    return
  }
  
  try {
    if (carouselEditId.value) {
      const firstImage = carouselImageList.value[0]
      const carouselId = carouselEditId.value
      // 如果图片是base64，需要上传
      let imageUrl = firstImage.url
      // 如果是base64，直接发送（后端会自动转换）
      // 如果是路径，也直接发送
      const response = await homeApi.updateCarousel(carouselId, {
        image: imageUrl,
        title: firstImage.title,
        description: firstImage.description || '',
        link: firstImage.link || '',
        sort: firstImage.sort || 0
      })
      if (response.success) {
        await loadCarousel()
        ElMessage.success('编辑成功')
      }
    } else {
      const carouselListData = carouselImageList.value.map((item, index) => ({
        image: item.url,
        title: item.title,
        description: item.description || '',
        link: item.link || '',
        sort: item.sort !== undefined ? item.sort : (carouselList.value.length + index + 1)
      }))
      const response = await homeApi.addCarousel(carouselListData)
      if (response.success) {
        await loadCarousel()
        ElMessage.success(`成功添加 ${carouselListData.length} 张轮播图`)
      }
    }
    carouselDialogVisible.value = false
  } catch (error) {
    console.error('保存轮播图失败:', error)
    ElMessage.error('保存轮播图失败')
  }
}

const handleCarouselDelete = async (index) => {
  try {
    await ElMessageBox.confirm('确定要删除这条轮播图吗？', '提示', {
      type: 'warning'
    })
    
    const carouselId = carouselList.value[index].id
    const response = await homeApi.deleteCarousel(carouselId)
    if (response.success) {
      await loadCarousel()
      ElMessage.success('删除成功')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除轮播图失败:', error)
      ElMessage.error('删除轮播图失败')
    }
  }
}

onMounted(() => {
  loadCarousel()
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

.carousel-item-config {
  margin-bottom: 15px;
}

.item-header {
  display: flex;
  align-items: flex-start;
}

.item-form {
  flex: 1;
}

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}
</style>
