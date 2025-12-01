<template>
  <div class="rich-text-editor">
    <div ref="editorRef" class="editor-container"></div>
    
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
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'
import { ElMessage, ElLoading } from 'element-plus'
import Quill from 'quill'
import 'quill/dist/quill.snow.css'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import 'cropperjs/dist/cropper.css'
import * as homeApi from '@/services/homeApi'

// 注册自定义 Video Blot，让 Quill 支持 video 标签
const BlockEmbed = Quill.import('blots/block/embed')

class VideoBlot extends BlockEmbed {
  static create(value) {
    const node = super.create()
    if (typeof value === 'string') {
      node.setAttribute('src', value)
    } else if (value && value.src) {
      node.setAttribute('src', value.src)
    }
    node.setAttribute('controls', 'controls')
    node.setAttribute('preload', 'metadata')
    node.setAttribute('style', 'max-width: 100%; height: auto; display: block; margin: 10px 0;')
    return node
  }

  static value(node) {
    return node.getAttribute('src')
  }
}

VideoBlot.blotName = 'video'
VideoBlot.tagName = 'video'

// 注册 Video Blot（覆盖默认的 video 处理）
Quill.register(VideoBlot, true)

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  placeholder: {
    type: String,
    default: '请输入内容...'
  }
})

const emit = defineEmits(['update:modelValue'])

const editorRef = ref(null)
let quill = null

// 图片裁剪相关
const cropDialogVisible = ref(false)
const cropImageSrc = ref('')
const pendingFile = ref(null)
const pictureCropperRef = ref(null)
const cropperReady = ref(false)
const pendingInsertIndex = ref(null)

onMounted(() => {
  // 配置工具栏，支持图片和视频
  const toolbarOptions = [
    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
    [{ 'font': [] }],
    [{ 'size': ['small', false, 'large', 'huge'] }],
    ['bold', 'italic', 'underline', 'strike'],
    [{ 'color': [] }, { 'background': [] }],
    [{ 'script': 'sub' }, { 'script': 'super' }],
    [{ 'list': 'ordered' }, { 'list': 'bullet' }],
    [{ 'indent': '-1' }, { 'indent': '+1' }],
    [{ 'direction': 'rtl' }],
    [{ 'align': [] }],
    ['link', 'image', 'video'],
    ['clean']
  ]

  quill = new Quill(editorRef.value, {
    theme: 'snow',
    placeholder: props.placeholder,
    modules: {
      toolbar: toolbarOptions
    }
  })

  // 设置初始内容
  if (props.modelValue) {
    quill.root.innerHTML = props.modelValue
  }

  // 监听内容变化
  quill.on('text-change', () => {
    const content = quill.root.innerHTML
    emit('update:modelValue', content)
  })

  // 处理图片上传
  const toolbar = quill.getModule('toolbar')
  toolbar.addHandler('image', () => {
    const input = document.createElement('input')
    input.setAttribute('type', 'file')
    input.setAttribute('accept', 'image/*')
    input.click()
    input.onchange = () => {
      const file = input.files[0]
      if (file) {
        // 保存待插入的位置
        const range = quill.getSelection(true)
        pendingInsertIndex.value = range ? range.index : quill.getLength()
        
        // 保存待处理的文件
        pendingFile.value = file
        
        // 读取文件为base64，用于裁剪
        const reader = new FileReader()
        reader.onload = async (e) => {
          cropImageSrc.value = e.target.result
          cropperReady.value = false
          // 等待下一个 tick 确保图片已设置，然后打开对话框
          await nextTick()
          cropDialogVisible.value = true
          // 再等待一个 tick 确保对话框已完全打开
          await nextTick()
        }
        reader.onerror = () => {
          ElMessage.error('读取文件失败')
          pendingFile.value = null
          pendingInsertIndex.value = null
        }
        reader.readAsDataURL(file)
      }
    }
  })

  // 处理视频上传
  toolbar.addHandler('video', async () => {
    const input = document.createElement('input')
    input.setAttribute('type', 'file')
    input.setAttribute('accept', 'video/*')
    input.click()
    input.onchange = async () => {
      const file = input.files[0]
      if (file) {
        // 检查文件大小（限制为500MB，视频文件通常较大）
        const maxSize = 500 * 1024 * 1024 // 500MB
        if (file.size > maxSize) {
          ElMessage.error('视频文件大小不能超过500MB')
          return
        }
        
        // 显示上传进度
        const loading = ElLoading.service({
          lock: true,
          text: '视频上传中，请稍候...',
          background: 'rgba(0, 0, 0, 0.7)'
        })
        
        try {
          // 上传视频文件
          const response = await homeApi.uploadFile(file)
          
          if (response && response.success && response.data && response.data.filePath) {
            // 构建视频文件的完整URL（使用后端服务器地址）
            const videoPath = `http://localhost:8080/${response.data.filePath}`
            
            // 获取当前光标位置
            const range = quill.getSelection(true)
            const insertIndex = range ? range.index : quill.getLength()
            
            // 使用 insertEmbed 插入视频（使用自定义的 VideoBlot）
            quill.insertEmbed(insertIndex, 'video', videoPath)
            
            // 移动光标到视频后面
            quill.setSelection(insertIndex + 1, 'user')
            
            // 等待 DOM 更新
            await nextTick()
            
            // 触发内容变化事件
            const content = quill.root.innerHTML
            emit('update:modelValue', content)
            
            console.log('视频已插入，HTML内容:', content)
            console.log('视频路径:', videoPath)
            
            ElMessage.success('视频上传成功')
          } else {
            throw new Error(response?.message || '上传失败')
          }
        } catch (error) {
          console.error('视频上传失败:', error)
          ElMessage.error('视频上传失败: ' + (error.response?.data?.message || error.message || '未知错误'))
        } finally {
          loading.close()
        }
      }
    }
  })
})

onBeforeUnmount(() => {
  if (quill) {
    quill = null
  }
})

// 监听外部值变化
watch(() => props.modelValue, (newVal) => {
  if (quill && quill.root.innerHTML !== newVal) {
    // 只有当新值确实不同时才更新，避免覆盖我们刚插入的视频
    const currentContent = quill.root.innerHTML || ''
    const newContent = newVal || ''
    if (currentContent !== newContent) {
      quill.root.innerHTML = newContent
    }
  }
}, { flush: 'post' })

// 裁剪器准备就绪
const onCropReady = () => {
  cropperReady.value = true
}

// 裁剪事件（可选，用于实时预览）
const onCrop = () => {
  // 实时裁剪预览（可选）
}

// 取消裁剪
const cancelCrop = () => {
  cropDialogVisible.value = false
  cropImageSrc.value = ''
  pendingFile.value = null
  pendingInsertIndex.value = null
  cropperReady.value = false
}

// 确认裁剪并插入
const confirmCrop = () => {
  if (!cropperReady.value || !cropper || !pendingFile.value || pendingInsertIndex.value === null) {
    ElMessage.error('裁剪器未准备好，请稍候重试')
    return
  }
  
  try {
    // 获取裁剪后的base64图片
    const croppedCanvas = cropper.getCroppedCanvas({
      imageSmoothingEnabled: true,
      imageSmoothingQuality: 'high'
    })
    
    if (!croppedCanvas) {
      ElMessage.error('裁剪失败，请重试')
      return
    }
    
    // 获取裁剪后的图片URL（Base64格式）
    const croppedImageUrl = croppedCanvas.toDataURL('image/jpeg', 0.9)
    
    // 插入到编辑器
    if (quill && pendingInsertIndex.value !== null) {
      quill.insertEmbed(pendingInsertIndex.value, 'image', croppedImageUrl)
      // 移动光标到图片后面
      quill.setSelection(pendingInsertIndex.value + 1)
    }
    
    // 关闭裁剪对话框
    cropDialogVisible.value = false
    cropImageSrc.value = ''
    pendingFile.value = null
    pendingInsertIndex.value = null
    cropperReady.value = false
  } catch (error) {
    console.error('裁剪图片失败:', error)
    ElMessage.error('裁剪图片失败: ' + (error.message || '未知错误'))
  }
}
</script>

<style scoped>
.rich-text-editor {
  width: 100%;
}

.editor-container {
  min-height: 300px;
}

:deep(.ql-container) {
  min-height: 300px;
  font-size: 14px;
}

:deep(.ql-editor) {
  min-height: 300px;
  max-height: 600px;
  overflow-y: auto;
}

:deep(.ql-editor img) {
  max-width: 100%;
  height: auto;
}

:deep(.ql-editor iframe) {
  max-width: 100%;
}

:deep(.ql-editor video) {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 10px 0;
}

:deep(.ql-editor .video-container) {
  margin: 10px 0;
  width: 100%;
}

:deep(.ql-editor .video-container video) {
  max-width: 100%;
  height: auto;
  display: block;
}

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}
</style>

