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
            height: 'auto',
            maxHeight: '80vh',
            backgroundColor: '#f8f8f8',
            margin: 'auto'
          }"
          :img="cropImageSrc"
          :options="{
            viewMode: 1,
            dragMode: 'move',
            autoCropArea: 1,
            restore: false,
            guides: true,
            center: true,
            highlight: false,
            cropBoxMovable: true,
            cropBoxResizable: true,
            toggleDragModeOnDblclick: false
          }"
          @ready="onCropReady"
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

// ==================== 修复删除键和换行问题 ====================
// 注册自定义 Video Blot，简化对齐处理
const BlockEmbed = Quill.import('blots/block/embed')

class VideoBlot extends BlockEmbed {
  static create(value) {
    const node = super.create()
    const video = document.createElement('video')
    
    if (typeof value === 'string') {
      video.setAttribute('src', value)
    } else if (value && value.src) {
      video.setAttribute('src', value.src)
    }
    
    video.setAttribute('controls', 'controls')
    video.setAttribute('preload', 'metadata')
    video.className = 'ql-video-embed'
    video.style.cssText = 'max-width: 100%; height: auto; display: block; margin: 10px auto;'
    
    node.appendChild(video)
    // 添加一个占位符用于换行和删除
    const br = document.createElement('br')
    node.appendChild(br)
    
    return node
  }

  static value(node) {
    const video = node.querySelector('video')
    return video ? video.getAttribute('src') : null
  }
}

VideoBlot.blotName = 'video'
VideoBlot.tagName = 'div'
VideoBlot.className = 'ql-video-wrapper'

// 注册 Video Blot
Quill.register(VideoBlot, true)

// 注册自定义 Attachment Blot
const Inline = Quill.import('blots/inline')

class AttachmentBlot extends Inline {
  static create(value) {
    const node = super.create()
    
    let fileUrl = ''
    let fileName = ''
    
    if (typeof value === 'string') {
      fileUrl = value
      const urlParts = value.split('/')
      fileName = urlParts[urlParts.length - 1] || '附件'
    } else if (value && typeof value === 'object') {
      fileUrl = value.url || value.filePath || ''
      fileName = value.fileName || value.name || '附件'
    }
    
    const link = document.createElement('a')
    link.setAttribute('href', fileUrl)
    link.setAttribute('target', '_blank')
    link.setAttribute('download', fileName)
    link.className = 'ql-attachment'
    link.style.cssText = 'display: inline-flex; align-items: center; gap: 6px; color: #409eff; text-decoration: none; padding: 4px 8px; border-radius: 4px; transition: background-color 0.2s;'
    
    const icon = document.createElement('span')
    icon.innerHTML = '📎'
    icon.style.cssText = 'font-size: 14px;'
    
    const text = document.createTextNode(fileName)
    
    link.appendChild(icon)
    link.appendChild(text)
    
    node.appendChild(link)
    node.setAttribute('data-url', fileUrl)
    node.setAttribute('data-filename', fileName)
    
    return node
  }

  static value(node) {
    const link = node.querySelector('.ql-attachment')
    if (!link) return null
    
    const url = node.getAttribute('data-url') || link.getAttribute('href')
    const fileName = node.getAttribute('data-filename') || link.textContent.trim().replace('📎', '').trim()
    
    return {
      url,
      fileName
    }
  }

  static match(node) {
    return node.classList && node.classList.contains('ql-attachment-wrapper') || 
           (node.querySelector && node.querySelector('.ql-attachment'))
  }
}

AttachmentBlot.blotName = 'attachment'
AttachmentBlot.tagName = 'span'
AttachmentBlot.className = 'ql-attachment-wrapper'
Quill.register(AttachmentBlot)

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
let isInternalUpdate = false
let ignoreNextExternalUpdate = false

// 图片裁剪相关
const cropDialogVisible = ref(false)
const cropImageSrc = ref('')
const pendingFile = ref(null)
const pictureCropperRef = ref(null)
const cropperReady = ref(false)
const pendingInsertIndex = ref(null)

// ==================== 修复关键功能 ====================

// 修复删除键问题：确保所有嵌入式内容都可以被删除
const setupDeleteFix = () => {
  if (!quill) return
  
  // 监听键盘事件
  quill.root.addEventListener('keydown', (event) => {
    // 处理删除键和退格键
    if (event.key === 'Delete' || event.key === 'Backspace') {
      const range = quill.getSelection()
      if (!range) return
      
      // 检查是否在嵌入式内容后面
      const [line] = quill.getLine(range.index)
      if (line && line.length === 1) {
        const blot = line.domNode
        // 如果是自定义的嵌入式内容，确保可以删除
        if (blot.classList && (
          blot.classList.contains('ql-video-wrapper') || 
          blot.classList.contains('ql-attachment-wrapper')
        )) {
          // 允许删除操作继续
          return
        }
      }
    }
  })
}

// 修复换行问题
const setupLineBreakFix = () => {
  if (!quill) return
  
  // 确保回车键创建新段落
  quill.keyboard.addBinding({
    key: 'enter',
    handler: function(range, context) {
      // 获取当前格式
      const formats = quill.getFormat(range.index)
      
      // 如果是在列表项中，让Quill正常处理
      if (formats.list) {
        return true
      }
      
      // 正常插入换行
      quill.insertText(range.index, '\n', 'user')
      quill.setSelection(range.index + 1, 'user')
      return false
    }
  })
  
  // Shift+Enter 插入换行符
  quill.keyboard.addBinding({
    key: 'enter',
    shiftKey: true,
    handler: function(range, context) {
      quill.insertText(range.index, '\n', 'user')
      quill.setSelection(range.index + 1, 'user')
      return false
    }
  })
}

// 初始化编辑器
onMounted(() => {
  // 配置工具栏
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

  // 创建Quill实例
  quill = new Quill(editorRef.value, {
    theme: 'snow',
    placeholder: props.placeholder,
    modules: {
      toolbar: toolbarOptions,
      keyboard: {
        bindings: {
          // 覆盖默认的删除绑定，确保可以删除嵌入式内容
          'delete': {
            key: 'delete',
            handler: function(range, context) {
              if (range.length === 0) {
                const [line, offset] = quill.getLine(range.index)
                if (line && line.length === 1 && offset === 0) {
                  const blot = line.domNode
                  if (blot.classList && blot.classList.contains('ql-video-wrapper')) {
                    quill.deleteText(range.index, 1, 'user')
                    return false
                  }
                }
              }
              return true
            }
          }
        }
      }
    }
  })

  // 设置初始内容
  if (props.modelValue && props.modelValue !== '<p><br></p>') {
    quill.root.innerHTML = props.modelValue
  }

  // ==================== 修复内容同步 ====================
  
  // 使用更可靠的内容变化监听
  quill.on('text-change', (delta, oldDelta, source) => {
    // 只有用户操作才触发外部更新
    if (source === 'user') {
      const content = quill.root.innerHTML
      // 标记下一次外部更新忽略
      ignoreNextExternalUpdate = true
      // 立即更新外部数据
      emit('update:modelValue', content)
      
      // 重置标记（使用setTimeout确保在watch之前执行）
      setTimeout(() => {
        ignoreNextExternalUpdate = false
      }, 0)
    }
  })

  // 应用修复
  setupDeleteFix()
  setupLineBreakFix()

  // ==================== 图片上传处理 ====================
  const toolbar = quill.getModule('toolbar')
  
  toolbar.addHandler('image', () => {
    const input = document.createElement('input')
    input.setAttribute('type', 'file')
    input.setAttribute('accept', 'image/*')
    input.click()
    input.onchange = () => {
      const file = input.files[0]
      if (file) {
        const range = quill.getSelection(true)
        pendingInsertIndex.value = range ? range.index : quill.getLength()
        pendingFile.value = file
        
        const reader = new FileReader()
        reader.onload = async (e) => {
          cropImageSrc.value = e.target.result
          cropperReady.value = false
          await nextTick()
          cropDialogVisible.value = true
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

  // ==================== 附件上传按钮 ====================
  const addAttachmentButton = () => {
    const toolbarContainer = editorRef.value?.querySelector('.ql-toolbar')
    if (!toolbarContainer) {
      setTimeout(addAttachmentButton, 100)
      return
    }
    
    if (toolbarContainer.querySelector('.ql-attachment-upload')) {
      return
    }
    
    const attachmentButton = document.createElement('button')
    attachmentButton.type = 'button'
    attachmentButton.className = 'ql-attachment-upload'
    attachmentButton.innerHTML = '📎 附件'
    attachmentButton.title = '上传附件'
    attachmentButton.setAttribute('aria-label', '上传附件')
    attachmentButton.style.cssText = 'height: 24px; margin-left: 8px; padding: 2px 8px; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; border: 1px solid #ccc; border-radius: 3px; background-color: #fff; font-size: 12px; color: #444; white-space: nowrap;'
    
    attachmentButton.addEventListener('click', () => {
      const input = document.createElement('input')
      input.setAttribute('type', 'file')
      input.setAttribute('accept', '*/*')
      input.click()
      
      input.onchange = async () => {
        const file = input.files[0]
        if (!file) return
        
        const maxSize = 100 * 1024 * 1024
        if (file.size > maxSize) {
          ElMessage.error('文件大小不能超过100MB')
          return
        }
        
        const loading = ElLoading.service({
          lock: true,
          text: '附件上传中，请稍候...',
          background: 'rgba(0, 0, 0, 0.7)'
        })

        try {
          const response = await homeApi.uploadFile(file)
          
          if (response && response.success && response.data && response.data.filePath) {
            const filePath = response.data.filePath
            const fileName = file.name
            
            const range = quill.getSelection(true)
            const insertIndex = range ? range.index : quill.getLength()
            
            quill.insertEmbed(insertIndex, 'attachment', {
              url: filePath,
              fileName: fileName
            })
            
            quill.setSelection(insertIndex + 1, 'user')
            
            const content = quill.root.innerHTML
            ignoreNextExternalUpdate = true
            emit('update:modelValue', content)
            setTimeout(() => { ignoreNextExternalUpdate = false }, 0)
            
            ElMessage.success('附件上传成功')
          } else {
            throw new Error(response?.message || '上传失败')
          }
        } catch (error) {
          console.error('附件上传失败:', error)
          ElMessage.error('附件上传失败: ' + (error.response?.data?.message || error.message || '未知错误'))
        } finally {
          loading.close()
        }
      }
    })
    
    const separator = document.createElement('span')
    separator.className = 'ql-formats'
    separator.style.cssText = 'margin-left: 8px; border-left: 1px solid #ccc; padding-left: 8px;'
    separator.appendChild(attachmentButton)
    toolbarContainer.appendChild(separator)
  }
  
  nextTick(() => {
    addAttachmentButton()
  })

  // ==================== 视频上传处理 ====================
  toolbar.addHandler('video', async () => {
    const input = document.createElement('input')
    input.setAttribute('type', 'file')
    input.setAttribute('accept', 'video/*')
    input.click()
    input.onchange = async () => {
      const file = input.files[0]
      if (file) {
        const maxSize = 500 * 1024 * 1024
        if (file.size > maxSize) {
          ElMessage.error('视频文件大小不能超过500MB')
          return
        }
        
        const loading = ElLoading.service({
          lock: true,
          text: '视频上传中，请稍候...',
          background: 'rgba(0, 0, 0, 0.7)'
        })
        
        try {
          const response = await homeApi.uploadFile(file)
          
          if (response && response.success && response.data && response.data.filePath) {
            const videoPath = response.data.filePath
            
            const range = quill.getSelection(true)
            const insertIndex = range ? range.index : quill.getLength()
            
            quill.insertEmbed(insertIndex, 'video', videoPath)
            await nextTick()
            
            quill.setSelection(insertIndex + 1, 'user')
            
            const content = quill.root.innerHTML
            ignoreNextExternalUpdate = true
            emit('update:modelValue', content)
            setTimeout(() => { ignoreNextExternalUpdate = false }, 0)
            
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

// ==================== 修复外部内容同步 ====================
watch(() => props.modelValue, (newValue) => {
  // 如果这是由内部更新触发的，忽略
  if (ignoreNextExternalUpdate || isInternalUpdate) {
    return
  }
  
  if (!quill) return
  
  const currentContent = quill.root.innerHTML
  // 只有当外部传入的内容与当前内容不同时才更新
  if (newValue !== currentContent) {
    // 保存当前光标位置
    const selection = quill.getSelection()
    
    // 设置新内容
    quill.root.innerHTML = newValue || '<p><br></p>'
    
    // 恢复光标位置
    if (selection) {
      quill.setSelection(selection)
    }
  }
}, { flush: 'post' })

// ==================== 裁剪功能 ====================
const onCropReady = () => {
  cropperReady.value = true
  if (cropper) {
    const imageData = cropper.getImageData()
    if (imageData) {
      cropper.setCropBoxData({
        left: imageData.left,
        top: imageData.top,
        width: imageData.width,
        height: imageData.height
      })
    }
  }
}

const cancelCrop = () => {
  cropDialogVisible.value = false
  // 延迟清理状态
  setTimeout(() => {
    cropImageSrc.value = ''
    pendingFile.value = null
    pendingInsertIndex.value = null
    cropperReady.value = false
    if (cropper) {
      cropper.destroy()
    }
  }, 300)
}

const confirmCrop = async () => {
  if (!cropperReady.value || !cropper || !pendingFile.value || pendingInsertIndex.value === null) {
    ElMessage.error('裁剪器未准备好，请稍候重试')
    return
  }
  
  const loading = ElLoading.service({
    lock: true,
    text: '上传图片中，请稍候...',
    background: 'rgba(0, 0, 0, 0.7)'
  })
  
  try {
    const croppedCanvas = cropper.getCroppedCanvas({
      imageSmoothingEnabled: true,
      imageSmoothingQuality: 'high'
    })
    
    if (!croppedCanvas) {
      ElMessage.error('裁剪失败，请重试')
      loading.close()
      return
    }
    
    croppedCanvas.toBlob(async (blob) => {
      if (!blob) {
        ElMessage.error('图片转换失败')
        loading.close()
        return
      }
      
      try {
        const fileName = pendingFile.value.name || 'cropped_image.jpg'
        const file = new File([blob], fileName, { type: 'image/jpeg' })
        
        const response = await homeApi.uploadFile(file)
        
        if (response && response.success && response.data && response.data.filePath) {
          const imagePath = response.data.filePath
          
          if (quill && pendingInsertIndex.value !== null) {
            quill.insertEmbed(pendingInsertIndex.value, 'image', imagePath)
            quill.setSelection(pendingInsertIndex.value + 1)
            
            const content = quill.root.innerHTML
            ignoreNextExternalUpdate = true
            emit('update:modelValue', content)
            setTimeout(() => { ignoreNextExternalUpdate = false }, 0)
            
            ElMessage.success('图片上传成功')
          }
          
          // 关闭对话框
          cropDialogVisible.value = false
          setTimeout(() => {
            cropImageSrc.value = ''
            pendingFile.value = null
            pendingInsertIndex.value = null
            cropperReady.value = false
            if (cropper) {
              cropper.destroy()
            }
          }, 300)
        } else {
          throw new Error(response?.message || '上传失败')
        }
      } catch (error) {
        console.error('上传图片失败:', error)
        ElMessage.error('上传图片失败: ' + (error.response?.data?.message || error.message || '未知错误'))
      } finally {
        loading.close()
      }
    }, 'image/jpeg', 0.9)
  } catch (error) {
    console.error('裁剪图片失败:', error)
    ElMessage.error('裁剪图片失败: ' + (error.message || '未知错误'))
    loading.close()
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

:deep(.ql-editor .ql-video-embed) {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 10px auto !important;
}

/* 修复嵌入式内容的删除和换行 */
:deep(.ql-editor .ql-video-wrapper) {
  position: relative;
  margin: 10px 0;
}

:deep(.ql-editor .ql-video-wrapper::after) {
  content: '';
  display: block;
  height: 1px;
  visibility: hidden;
}

/* 附件样式 */
:deep(.ql-editor .ql-attachment-wrapper) {
  display: inline-block;
  margin: 4px 2px;
  position: relative;
}

:deep(.ql-editor .ql-attachment) {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: #409eff;
  text-decoration: none;
  padding: 6px 12px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  background-color: #f5f7fa;
  transition: all 0.2s;
  font-size: 14px;
}

:deep(.ql-editor .ql-attachment:hover) {
  color: #66b1ff;
  border-color: #409eff;
  background-color: #ecf5ff;
}

:deep(.ql-editor .ql-attachment span) {
  font-size: 14px;
}

/* 附件上传按钮样式 */
:deep(.ql-toolbar .ql-attachment-upload) {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #ccc;
  border-radius: 3px;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.2s;
}

:deep(.ql-toolbar .ql-attachment-upload:hover) {
  background-color: #f0f0f0;
  border-color: #999;
}

/* 确保所有内容都可以被选择和删除 */
:deep(.ql-editor *[contenteditable="true"]) {
  user-select: text;
  -webkit-user-select: text;
}

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}

/* 修复对齐样式 */
:deep(.ql-align-center) {
  text-align: center;
}

:deep(.ql-align-right) {
  text-align: right;
}

:deep(.ql-align-left) {
  text-align: left;
}

:deep(.ql-align-center .ql-video-embed) {
  margin: 10px auto !important;
}

:deep(.ql-align-right .ql-video-embed) {
  margin: 10px 0 10px auto !important;
}

:deep(.ql-align-left .ql-video-embed) {
  margin: 10px auto 10px 0 !important;
}
</style>