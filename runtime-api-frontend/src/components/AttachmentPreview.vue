<template>
  <div class="attachment-preview">
    <div class="attachment-header">
      <div class="attachment-info">
        <el-icon class="attachment-icon"><Document /></el-icon>
        <span class="attachment-name">{{ attachmentName }}</span>
      </div>
      <div class="attachment-actions">
        <el-button type="primary" size="small" @click="handleDownload">
          <el-icon><Download /></el-icon>
          下载
        </el-button>
        <el-button v-if="showPreview" type="info" size="small" @click="togglePreview">
          {{ previewVisible ? '关闭预览' : '预览' }}
        </el-button>
      </div>
    </div>
    
    <!-- 预览区域 -->
    <div v-if="previewVisible" class="preview-container">
      <div v-if="loading" class="loading">
        <el-icon class="is-loading"><Loading /></el-icon>
        <span>加载中...</span>
      </div>
      
      <!-- PDF 预览 -->
      <div v-else-if="fileType === 'pdf'" class="pdf-preview">
        <iframe 
          :src="getFullUrl(attachmentUrl)" 
          style="width: 100%; height: 800px; border: 1px solid #ddd;"
          frameborder="0"
        ></iframe>
      </div>
      
      <!-- Word 预览 (仅支持 .docx) -->
      <div v-else-if="fileType === 'word-docx'" class="word-preview">
        <div class="word-content" ref="wordContainer"></div>
      </div>
      
      <!-- 不支持预览的格式 -->
      <div v-else class="unsupported-preview">
        <el-icon><WarningFilled /></el-icon>
        <p v-if="fileType === 'word-doc'">
          暂不支持预览旧的 .doc 格式，请下载后使用 Microsoft Word 查看
        </p>
        <p v-else>
          暂不支持预览此文件格式，请下载后查看
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, nextTick } from 'vue'
import { Document, Download, Loading, WarningFilled } from '@element-plus/icons-vue'
import { ElButton, ElIcon, ElMessage } from 'element-plus'
import mammoth from 'mammoth'
import { buildImageUrl } from '@/utils/url'

const props = defineProps({
  attachmentUrl: {
    type: String,
    required: true
  },
  attachmentName: {
    type: String,
    required: true
  }
})

// 默认预览可见（如果支持预览）
const previewVisible = ref(false)
const loading = ref(false)
const wordContainer = ref(null)

// 获取完整的文件URL
const getFullUrl = buildImageUrl

// 根据文件名判断文件类型
const fileType = computed(() => {
  const fileName = props.attachmentName.toLowerCase()
  if (fileName.endsWith('.pdf')) {
    return 'pdf'
  } else if (fileName.endsWith('.docx')) {
    return 'word-docx'
  } else if (fileName.endsWith('.doc')) {
    return 'word-doc'
  }
  return 'unsupported'
})

// 是否支持预览
const showPreview = computed(() => {
  // mammoth 只支持 .docx，不支持旧的 .doc 格式
  return fileType.value === 'pdf' || fileType.value === 'word-docx'
})

// 下载附件
const handleDownload = async () => {
  try {
    console.log('========== 开始下载附件 ==========')
    console.log('原始URL:', props.attachmentUrl)
    console.log('附件名称:', props.attachmentName)
    
    const fileUrl = getFullUrl(props.attachmentUrl)
    console.log('完整URL:', fileUrl)
    
    // 使用 fetch 获取文件，然后创建下载链接
    console.log('开始 fetch 文件...')
    const response = await fetch(fileUrl)
    console.log('响应状态:', response.status, response.statusText)
    console.log('响应头:', Object.fromEntries(response.headers.entries()))
    
    if (!response.ok) {
      throw new Error(`文件加载失败: ${response.status} ${response.statusText}`)
    }
    
    console.log('开始读取 blob...')
    const blob = await response.blob()
    console.log('Blob 类型:', blob.type)
    console.log('Blob 大小:', blob.size, 'bytes')
    
    const url = window.URL.createObjectURL(blob)
    console.log('创建对象URL:', url)
    
    const link = document.createElement('a')
    link.href = url
    link.download = props.attachmentName
    link.style.display = 'none'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    
    // 释放 URL 对象
    window.URL.revokeObjectURL(url)
    
    console.log('========== 下载成功 ==========')
    ElMessage.success('开始下载')
  } catch (error) {
    console.error('========== 下载失败 ==========')
    console.error('错误详情:', error)
    console.error('错误堆栈:', error.stack)
    ElMessage.error('下载失败: ' + (error.message || '未知错误'))
    
    // 如果 fetch 失败，尝试直接打开链接（可能因为跨域）
    try {
      console.log('尝试直接打开链接...')
      window.open(getFullUrl(props.attachmentUrl), '_blank')
    } catch (e) {
      console.error('打开链接失败:', e)
    }
  }
}

// 切换预览
const togglePreview = () => {
  previewVisible.value = !previewVisible.value
}

// 加载 Word 预览（仅支持 .docx）
const loadWordPreview = async () => {
  // 保存容器引用，避免在异步操作过程中引用丢失
  const container = wordContainer.value
  if (!container) {
    console.error('Word容器不存在，无法加载预览')
    ElMessage.error('预览容器未初始化，请重试')
    return
  }
  
  try {
    loading.value = true
    console.log('========== 开始加载 Word 预览 ==========')
    console.log('原始附件URL:', props.attachmentUrl)
    console.log('容器元素:', container)
    
    const fileUrl = getFullUrl(props.attachmentUrl)
    console.log('完整文件URL:', fileUrl)
    console.log('文件类型:', fileType.value)
    console.log('附件名称:', props.attachmentName)
    
    // 获取文件
    console.log('开始 fetch 文件...')
    const response = await fetch(fileUrl)
    console.log('Fetch 响应状态:', response.status, response.statusText)
    console.log('响应头 Content-Type:', response.headers.get('Content-Type'))
    console.log('响应头 Content-Length:', response.headers.get('Content-Length'))
    console.log('响应头 Access-Control-Allow-Origin:', response.headers.get('Access-Control-Allow-Origin'))
    
    if (!response.ok) {
      throw new Error(`文件加载失败: ${response.status} ${response.statusText}`)
    }
    
    console.log('开始读取 arrayBuffer...')
    const arrayBuffer = await response.arrayBuffer()
    console.log('文件大小:', arrayBuffer.byteLength, 'bytes')
    
    if (arrayBuffer.byteLength === 0) {
      throw new Error('文件大小为 0，可能文件损坏或为空')
    }
    
    // 使用 mammoth 转换为 HTML（仅支持 .docx）
    console.log('开始使用 mammoth 转换...')
    const result = await mammoth.convertToHtml(
      { arrayBuffer },
      {
        // 配置选项
        styleMap: [
          "p[style-name='Heading 1'] => h1:fresh",
          "p[style-name='Heading 2'] => h2:fresh",
          "p[style-name='Heading 3'] => h3:fresh"
        ]
      }
    )
    console.log('Mammoth 转换完成')
    console.log('转换后的HTML长度:', result.value.length)
    
    // 再次检查容器是否仍然存在且有效
    const currentContainer = wordContainer.value || container
    if (!currentContainer) {
      throw new Error('Word容器在转换过程中丢失，预览可能已关闭')
    }
    
    // 检查容器是否仍在 DOM 中
    if (!currentContainer.parentElement || !document.contains(currentContainer)) {
      throw new Error('Word容器已从DOM中移除，预览可能已关闭')
    }
    
    // 检查预览是否仍然可见
    if (!previewVisible.value) {
      throw new Error('预览已关闭，取消加载')
    }
    
    // 显示转换后的HTML（使用当前容器引用）
    currentContainer.innerHTML = result.value
    console.log('HTML 已插入到容器')
    
    // 如果有警告，可以打印出来
    if (result.messages.length > 0) {
      console.warn('Word转换警告:', result.messages)
    }
    console.log('========== Word 预览加载完成 ==========')
  } catch (error) {
    console.error('========== Word预览加载失败 ==========')
    console.error('错误详情:', error)
    console.error('错误堆栈:', error.stack)
    const errorMsg = error.message || '未知错误'
    ElMessage.error('预览加载失败: ' + errorMsg)
    
    // 尝试显示错误信息（如果容器还存在）
    const currentContainer = wordContainer.value || container
    if (currentContainer && 
        currentContainer.parentElement && 
        document.contains(currentContainer) &&
        previewVisible.value) {
      currentContainer.innerHTML = `
        <div style="color: #f56c6c; padding: 20px; text-align: center;">
          <p>预览加载失败: ${errorMsg}</p>
          <p style="margin-top: 10px; font-size: 14px; color: #909399;">
            请检查文件是否为 .docx 格式（mammoth.js 不支持旧的 .doc 格式）
          </p>
        </div>
      `
    }
  } finally {
    loading.value = false
  }
}

// 组件挂载时，如果支持预览，默认打开预览
onMounted(() => {
  if (showPreview.value) {
    previewVisible.value = true
  }
})

// 监听预览状态变化
watch([previewVisible, fileType], async ([newVisible, newFileType], [oldVisible, oldFileType]) => {
  console.log('预览状态变化:', {
    newVisible,
    newFileType,
    oldVisible,
    oldFileType,
    wordContainerExists: !!wordContainer.value
  })
  
  // 打开预览且是 Word 文档
  if (newVisible && !oldVisible && newFileType === 'word-docx') {
    console.log('准备加载 Word 预览，等待 DOM 渲染...')
    
    // 等待多个 tick，确保 DOM 完全渲染
    await nextTick()
    await nextTick()
    
    // 使用轮询等待容器创建（最多等待 1 秒）
    let attempts = 0
    const maxAttempts = 20
    const checkContainer = () => {
      attempts++
      console.log(`检查容器 (${attempts}/${maxAttempts}):`, !!wordContainer.value)
      
      if (wordContainer.value) {
        console.log('容器已找到，开始加载预览')
        loadWordPreview()
        return true
      }
      
      if (attempts < maxAttempts) {
        setTimeout(checkContainer, 50)
      } else {
        console.error('Word容器创建超时，无法加载预览')
        ElMessage.error('预览容器初始化失败，请刷新页面重试')
      }
      return false
    }
    
    // 如果容器还不存在，开始轮询
    if (!wordContainer.value) {
      setTimeout(checkContainer, 100)
    } else {
      loadWordPreview()
    }
  } else if (!newVisible && oldVisible && wordContainer.value) {
    // 关闭预览时清空内容
    console.log('关闭预览，清空容器内容')
    wordContainer.value.innerHTML = ''
  }
}, { immediate: false })
</script>

<style scoped>
.attachment-preview {
  background-color: #f5f7fa;
  padding: 15px 20px;
  border-left: 4px solid #ffd700;
  margin: 20px 0;
  border-radius: 4px;
}

.attachment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0;
}

.attachment-info {
  display: flex;
  align-items: center;
  gap: 10px;
  flex: 1;
}

.attachment-icon {
  font-size: 20px;
  color: #606266;
}

.attachment-name {
  font-size: 16px;
  color: #606266;
  font-weight: 500;
}

.attachment-actions {
  display: flex;
  gap: 10px;
}

.preview-container {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #e4e7ed;
}

.loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 40px;
  color: #606266;
}

.pdf-preview {
  background-color: #fff;
  border-radius: 4px;
  overflow: hidden;
}

.word-preview {
  background-color: #fff;
  border-radius: 4px;
  padding: 30px;
  min-height: 400px;
}

.word-content {
  font-size: 16px;
  line-height: 1.8;
  color: #303133;
}

.word-content :deep(p) {
  margin: 0 0 15px 0;
}

.word-content :deep(h1),
.word-content :deep(h2),
.word-content :deep(h3) {
  margin-top: 20px;
  margin-bottom: 10px;
  font-weight: bold;
}

.word-content :deep(ul),
.word-content :deep(ol) {
  margin: 15px 0;
  padding-left: 30px;
}

.word-content :deep(img) {
  max-width: 100%;
  height: auto;
  margin: 15px 0;
}

.unsupported-preview {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #909399;
  gap: 15px;
}

.unsupported-preview .el-icon {
  font-size: 48px;
}

.unsupported-preview p {
  margin: 0;
  font-size: 16px;
}
</style>
