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
const Block = Quill.import('blots/block')

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
    return node
  }

  static value(node) {
    const video = node.querySelector('video')
    return video ? video.getAttribute('src') : null
  }

  // 重写 format 方法，让视频块能够响应对齐格式
  format(name, value) {
    if (name === 'align' && this.domNode) {
      // 应用对齐格式到视频块
      if (value) {
        this.domNode.style.textAlign = value
        // 同时添加 Quill 的对齐类名，确保 CSS 生效
        this.domNode.classList.remove('ql-align-left', 'ql-align-center', 'ql-align-right')
        if (value) {
          this.domNode.classList.add(`ql-align-${value}`)
        }
        this.updateVideoMargin(value)
      } else {
        this.domNode.style.textAlign = ''
        this.domNode.classList.remove('ql-align-left', 'ql-align-center', 'ql-align-right')
        this.updateVideoMargin(null)
      }
    } else {
      super.format(name, value)
    }
  }

  // 重写 formats 方法，返回当前的对齐格式
  formats() {
    if (this.domNode) {
      const align = this.domNode.style.textAlign || 
                   (this.domNode.className.includes('ql-align-center') ? 'center' : null) ||
                   (this.domNode.className.includes('ql-align-left') ? 'left' : null) ||
                   (this.domNode.className.includes('ql-align-right') ? 'right' : null)
      if (align) {
        return { align }
      }
    }
    return {}
  }

  // 更新视频的 margin 以匹配对齐
  updateVideoMargin(align) {
    const video = this.domNode?.querySelector('.ql-video-embed')
    if (!video) return
    
    switch (align) {
      case 'center':
        video.style.margin = '10px auto'
        break
      case 'right':
        video.style.margin = '10px 0 10px auto'
        break
      case 'left':
        video.style.margin = '10px auto 10px 0'
        break
      default:
        video.style.margin = '10px auto'
    }
  }
}

VideoBlot.blotName = 'video'
VideoBlot.tagName = 'p' // 使用 p 标签，这样可以更好地响应对齐格式

// 注册 Video Blot（覆盖默认的 video 处理）
Quill.register(VideoBlot, true)

// 注册自定义 Attachment Blot，用于显示附件
const Inline = Quill.import('blots/inline')

class AttachmentBlot extends Inline {
  static create(value) {
    const node = super.create()
    
    // value 可以是字符串（文件路径）或对象 {url, fileName}
    let fileUrl = ''
    let fileName = ''
    
    if (typeof value === 'string') {
      fileUrl = value
      // 从URL中提取文件名
      const urlParts = value.split('/')
      fileName = urlParts[urlParts.length - 1] || '附件'
    } else if (value && typeof value === 'object') {
      fileUrl = value.url || value.filePath || ''
      fileName = value.fileName || value.name || '附件'
    }
    
    // 创建附件链接元素
    const link = document.createElement('a')
    link.setAttribute('href', fileUrl)
    link.setAttribute('target', '_blank')
    link.setAttribute('download', fileName)
    link.className = 'ql-attachment'
    link.style.cssText = 'display: inline-flex; align-items: center; gap: 6px; color: #409eff; text-decoration: none; padding: 4px 8px; border-radius: 4px; transition: background-color 0.2s;'
    
    // 添加文件图标（使用简单的图标字符，或可以替换为SVG）
    const icon = document.createElement('span')
    icon.innerHTML = '📎'
    icon.style.cssText = 'font-size: 14px;'
    
    // 添加文件名
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

  // 添加 match 方法，用于从HTML中识别附件
  static match(node) {
    // 匹配带有 ql-attachment-wrapper 类的元素或包含 ql-attachment 链接的元素
    return node.classList && node.classList.contains('ql-attachment-wrapper') || 
           (node.querySelector && node.querySelector('.ql-attachment'))
  }
}

AttachmentBlot.blotName = 'attachment'
AttachmentBlot.tagName = 'span'
AttachmentBlot.className = 'ql-attachment-wrapper'

// 注册 Attachment Blot
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

  // 更新视频对齐样式
  const updateVideoAlignmentStyles = (quillInstance) => {
    if (!quillInstance || !quillInstance.root) return
    
    const videoElements = quillInstance.root.querySelectorAll('.ql-video-embed')
    videoElements.forEach((video) => {
      // 找到包含视频的直接父元素（应该是 VideoBlot 创建的块元素）
      const parent = video.parentElement
      if (!parent) return
      
      // 检查父元素的样式和类名
      const computedStyle = window.getComputedStyle(parent)
      const align = parent.style.textAlign || computedStyle.textAlign
      const className = parent.className || ''
      
      // 检查是否有 Quill 的对齐类
      let alignment = null
      if (className.includes('ql-align-center') || align === 'center') {
        alignment = 'center'
      } else if (className.includes('ql-align-left') || align === 'left') {
        alignment = 'left'
      } else if (className.includes('ql-align-right') || align === 'right') {
        alignment = 'right'
      }
      
      // 应用对齐样式到视频
      if (alignment === 'center') {
        video.style.margin = '10px auto'
        video.style.display = 'block'
      } else if (alignment === 'right') {
        video.style.margin = '10px 0 10px auto'
        video.style.display = 'block'
      } else if (alignment === 'left') {
        video.style.margin = '10px auto 10px 0'
        video.style.display = 'block'
      } else {
        // 默认居中
        video.style.margin = '10px auto'
        video.style.display = 'block'
      }
    })
  }

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


  // 监听内容变化（使用防抖，避免频繁触发）
  let updateTimer = null
  quill.on('text-change', (delta, oldDelta, source) => {
    // 立即设置标志，防止watch在更新过程中触发
    isInternalUpdate = true
    
    // 清除之前的定时器
    if (updateTimer) {
      clearTimeout(updateTimer)
    }
    
    // 立即更新，不延迟
    const content = quill.root.innerHTML
    emit('update:modelValue', content)
    
    // 延迟重置标志，确保watch不会在内部更新时触发
    setTimeout(() => {
      isInternalUpdate = false
    }, 300) // 足够长的延迟，确保watch不会干扰
    
    // 检查并更新视频对齐
    nextTick(() => {
      updateVideoAlignmentStyles(quill)
    })
  })

  // 监听选择变化，确保对齐格式能够正确应用
  quill.on('selection-change', (range) => {
    if (range) {
      nextTick(() => {
        updateVideoAlignmentStyles(quill)
      })
    }
  })

  // 监听格式变化（包括对齐格式）
  quill.on('editor-change', (eventName, ...args) => {
    if (eventName === 'text-change') {
      nextTick(() => {
        updateVideoAlignmentStyles(quill)
      })
    }
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

  // 添加附件上传按钮到工具栏
  const addAttachmentButton = () => {
    const toolbarContainer = editorRef.value?.querySelector('.ql-toolbar')
    if (!toolbarContainer) {
      // 如果工具栏还没准备好，等待一下再试
      setTimeout(addAttachmentButton, 100)
      return
    }
    
    // 检查是否已经添加过按钮
    if (toolbarContainer.querySelector('.ql-attachment-upload')) {
      return
    }
    
    // 创建附件上传按钮
    const attachmentButton = document.createElement('button')
    attachmentButton.type = 'button'
    attachmentButton.className = 'ql-attachment-upload'
    // 使用更明显的回形针图标和文本
    attachmentButton.innerHTML = '📎 附件'
    attachmentButton.title = '上传附件'
    attachmentButton.setAttribute('aria-label', '上传附件')
    attachmentButton.style.cssText = 'height: 24px; margin-left: 8px; padding: 2px 8px; display: inline-flex; align-items: center; justify-content: center; cursor: pointer; border: 1px solid #ccc; border-radius: 3px; background-color: #fff; font-size: 12px; color: #444; white-space: nowrap;'
    
    attachmentButton.addEventListener('click', () => {
      const input = document.createElement('input')
      input.setAttribute('type', 'file')
      input.setAttribute('accept', '*/*') // 接受所有文件类型
      input.click()
      
      input.onchange = async () => {
        const file = input.files[0]
        if (!file) return
        
        // 检查文件大小（限制为100MB）
        const maxSize = 100 * 1024 * 1024 // 100MB
        if (file.size > maxSize) {
          ElMessage.error('文件大小不能超过100MB')
          return
        }
        
        // 显示上传进度
        const loading = ElLoading.service({
          lock: true,
          text: '附件上传中，请稍候...',
          background: 'rgba(0, 0, 0, 0.7)'
        })

        try {
          // 上传附件文件
          const response = await homeApi.uploadFile(file)
          
          if (response && response.success && response.data && response.data.filePath) {
            const filePath = response.data.filePath
            const fileName = file.name
            
            // 获取当前光标位置
            const range = quill.getSelection(true)
            const insertIndex = range ? range.index : quill.getLength()
            
            // 插入附件链接
            quill.insertEmbed(insertIndex, 'attachment', {
              url: filePath,
              fileName: fileName
            })
            
            // 移动光标到附件后面
            quill.setSelection(insertIndex + 1, 'user')
            
            // 触发内容变化事件
            const content = quill.root.innerHTML
            emit('update:modelValue', content)
            
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
    
    // 创建一个分隔线容器，将按钮添加到工具栏的最后
    const separator = document.createElement('span')
    separator.className = 'ql-formats'
    separator.style.cssText = 'margin-left: 8px; border-left: 1px solid #ccc; padding-left: 8px;'
    separator.appendChild(attachmentButton)
    toolbarContainer.appendChild(separator)
  }
  
  // 在编辑器初始化完成后添加附件按钮
  nextTick(() => {
    addAttachmentButton()
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
            // 后端已返回完整URL，直接使用
            const videoPath = response.data.filePath
            
            // 获取当前光标位置
            const range = quill.getSelection(true)
            const insertIndex = range ? range.index : quill.getLength()
            
            // 使用 insertEmbed 插入视频（使用自定义的 VideoBlot）
            quill.insertEmbed(insertIndex, 'video', videoPath)
            
            // 等待 DOM 更新
            await nextTick()
            
            // 更新视频对齐样式
            updateVideoAlignmentStyles(quill)
            
            // 移动光标到视频后面
            quill.setSelection(insertIndex + 1, 'user')
            
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

// 添加 watch 来同步外部 modelValue 变化，但避免循环更新
// 只在编辑器初始化时或外部明确重置时更新，不干扰用户编辑
watch(() => props.modelValue, (newValue, oldValue) => {
  // 如果是内部更新触发的，不处理
  if (isInternalUpdate) {
    return
  }
  
  // 如果编辑器不存在，不处理
  if (!quill) {
    return
  }
  
  // 如果内容相同，不处理
  const currentContent = quill.root.innerHTML
  // 改进判断逻辑：如果新值是空字符串或null，且当前内容是空标签，也认为是相同的
  const normalizedNewValue = newValue || '<p><br></p>'
  const normalizedCurrentContent = currentContent || '<p><br></p>'
  
  if (normalizedCurrentContent === normalizedNewValue) {
    return
  }
  
  // 如果新值是空字符串或null，且当前内容也是空标签，不处理
  if ((!newValue || newValue === '') && (currentContent === '<p><br></p>' || currentContent === '<p></p>' || currentContent === '')) {
    return
  }
  
  // 只有在外部明确改变时才更新（比如父组件重置了内容）
  // 但需要确保不是用户正在编辑时的更新
  const selection = quill.getSelection()
  quill.root.innerHTML = newValue || '<p><br></p>'
  // 恢复选择位置
  if (selection) {
    quill.setSelection(selection)
  }
}, { flush: 'post' }) // 使用post flush，确保在DOM更新后执行

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
    // 获取裁剪后的base64图片
    const croppedCanvas = cropper.getCroppedCanvas({
      imageSmoothingEnabled: true,
      imageSmoothingQuality: 'high'
    })
    
    if (!croppedCanvas) {
      ElMessage.error('裁剪失败，请重试')
      loading.close()
      return
    }
    
    // 将canvas转换为Blob
    croppedCanvas.toBlob(async (blob) => {
      if (!blob) {
        ElMessage.error('图片转换失败')
        loading.close()
        return
      }
      
      try {
        // 将Blob转换为File对象
        const fileName = pendingFile.value.name || 'cropped_image.jpg'
        const file = new File([blob], fileName, { type: 'image/jpeg' })
        
        // 上传图片文件到服务器
        const response = await homeApi.uploadFile(file)
        
        if (response && response.success && response.data && response.data.filePath) {
          const imagePath = response.data.filePath
          
          // 插入到编辑器
          if (quill && pendingInsertIndex.value !== null) {
            quill.insertEmbed(pendingInsertIndex.value, 'image', imagePath)
            // 移动光标到图片后面
            quill.setSelection(pendingInsertIndex.value + 1)
            
            // 触发内容变化事件
            const content = quill.root.innerHTML
            emit('update:modelValue', content)
            
            ElMessage.success('图片上传成功')
          }
          
          // 关闭裁剪对话框
          cropDialogVisible.value = false
          cropImageSrc.value = ''
          pendingFile.value = null
          pendingInsertIndex.value = null
          cropperReady.value = false
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
}

/* 支持对齐的样式 - 确保视频块能够响应对齐格式 */
/* 当父容器有对齐类名时 */
:deep(.ql-editor p.ql-align-center .ql-video-embed),
:deep(.ql-editor div.ql-align-center .ql-video-embed) {
  margin: 10px auto !important;
}

:deep(.ql-editor p.ql-align-left .ql-video-embed),
:deep(.ql-editor div.ql-align-left .ql-video-embed) {
  margin: 10px auto 10px 0 !important;
}

:deep(.ql-editor p.ql-align-right .ql-video-embed),
:deep(.ql-editor div.ql-align-right .ql-video-embed) {
  margin: 10px 0 10px auto !important;
}

/* 当父容器有内联对齐样式时 */
:deep(.ql-editor p[style*="text-align: center"] .ql-video-embed),
:deep(.ql-editor p[style*="text-align:center"] .ql-video-embed),
:deep(.ql-editor div[style*="text-align: center"] .ql-video-embed),
:deep(.ql-editor div[style*="text-align:center"] .ql-video-embed) {
  margin: 10px auto !important;
}

:deep(.ql-editor p[style*="text-align: left"] .ql-video-embed),
:deep(.ql-editor p[style*="text-align:left"] .ql-video-embed),
:deep(.ql-editor div[style*="text-align: left"] .ql-video-embed),
:deep(.ql-editor div[style*="text-align:left"] .ql-video-embed) {
  margin: 10px auto 10px 0 !important;
}

:deep(.ql-editor p[style*="text-align: right"] .ql-video-embed),
:deep(.ql-editor p[style*="text-align:right"] .ql-video-embed),
:deep(.ql-editor div[style*="text-align: right"] .ql-video-embed),
:deep(.ql-editor div[style*="text-align:right"] .ql-video-embed) {
  margin: 10px 0 10px auto !important;
}

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}

/* 附件样式 */
:deep(.ql-editor .ql-attachment-wrapper) {
  display: inline-block;
  margin: 4px 2px;
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

:deep(.ql-toolbar .ql-attachment-upload svg) {
  width: 16px;
  height: 16px;
  fill: #444;
}
</style>

