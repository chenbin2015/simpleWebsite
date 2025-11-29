<template>
  <div class="rich-text-editor">
    <div ref="editorRef" class="editor-container"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import Quill from 'quill'
import 'quill/dist/quill.snow.css'

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
        const reader = new FileReader()
        reader.onload = (e) => {
          const range = quill.getSelection(true)
          quill.insertEmbed(range.index, 'image', e.target.result)
        }
        reader.readAsDataURL(file)
      }
    }
  })

  // 处理视频上传
  toolbar.addHandler('video', () => {
    const input = document.createElement('input')
    input.setAttribute('type', 'file')
    input.setAttribute('accept', 'video/*')
    input.click()
    input.onchange = () => {
      const file = input.files[0]
      if (file) {
        // 检查文件大小（限制为100MB）
        const maxSize = 100 * 1024 * 1024 // 100MB
        if (file.size > maxSize) {
          alert('视频文件大小不能超过100MB')
          return
        }
        
        const reader = new FileReader()
        reader.onload = (e) => {
          const range = quill.getSelection(true)
          // 使用video标签插入视频，支持controls属性以便播放
          const videoUrl = e.target.result
          const videoHtml = `<video controls style="max-width: 100%; height: auto;">
            <source src="${videoUrl}" type="${file.type}">
            您的浏览器不支持视频播放。
          </video>`
          quill.clipboard.dangerouslyPasteHTML(range.index, videoHtml)
        }
        reader.readAsDataURL(file)
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
    quill.root.innerHTML = newVal || ''
  }
})
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
</style>

