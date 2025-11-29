<template>
  <el-card shadow="hover">
    <template #header>
      <div class="card-header">
        <h3>{{ menu.name }} - 内容管理</h3>
      </div>
    </template>

    <el-form :model="formData" label-width="100px">
      <el-form-item label="标题">
        <el-input v-model="formData.title" placeholder="请输入标题" />
      </el-form-item>
      <el-form-item label="内容">
        <RichTextEditor v-model="formData.html" placeholder="请输入图文内容，支持插入图片和视频" />
      </el-form-item>
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
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Check, RefreshLeft } from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const formData = reactive({
  title: '',
  html: '<p>请输入内容...</p>'
})

// 加载数据
const loadData = () => {
  // 这里应该从后端加载数据
  // 暂时使用默认值
  formData.title = props.menu.name
  formData.html = '<p>请输入内容...</p>'
}

const handleSave = () => {
  if (!formData.title || !formData.title.trim()) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!formData.html || formData.html.trim() === '' || formData.html === '<p><br></p>') {
    ElMessage.warning('请输入内容')
    return
  }
  console.log('保存数据:', formData)
  ElMessage.success('保存成功')
  emit('update')
}

const handleReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', { type: 'warning' })
    .then(() => {
      loadData()
      ElMessage.success('重置成功')
    })
    .catch(() => {})
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
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
</style>

