<template>
  <el-card shadow="hover">
    <template #header>
      <div class="card-header">
        <h3>{{ menu.name }} - 内容管理</h3>
      </div>
    </template>

    <el-form :model="formData" label-width="100px">
      <el-form-item label="标题">
        <el-input :model-value="menu.name" disabled placeholder="标题与菜单名称一致，不可编辑" />
      </el-form-item>
      <el-form-item label="内容">
        <RichTextEditor v-model="formData.html" placeholder="请输入图文内容，支持插入图片和视频" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" size="large" @click="handleSave" :loading="saving">
          <el-icon><Check /></el-icon>
          保存
        </el-button>
        <el-button size="large" @click="handleReset" :disabled="saving">
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
import * as contentApi from '@/services/contentApi'
import * as menuApi from '@/services/menuApi'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const formData = reactive({
  html: '<p>请输入内容...</p>'
})

const saving = ref(false)
const originalHtml = ref('')
const menuIdRef = ref(null) // 存储数据库菜单ID

// 根据菜单名称查找数据库菜单ID
const findMenuIdByName = async (menuName, categoryName) => {
  try {
    const response = await menuApi.getAllMenus()
    if (response.success && response.data) {
      // 分类名称到数据库父菜单名称的映射
      const categoryToParentName = {
        'experiment-teaching': '实验教学',
        'experiment-resources': '实验资源',
        'construction-results': '建设成效',
        'safety-management': '安全管理'
      }
      
      const parentName = categoryToParentName[categoryName]
      if (!parentName) return null
      
      // 查找匹配的菜单
      for (const parentMenu of response.data) {
        if (parentMenu.name === parentName && parentMenu.children) {
          const childMenu = parentMenu.children.find(child => child.name === menuName)
          if (childMenu) {
            return childMenu.id
          }
        }
      }
    }
  } catch (error) {
    console.error('查找菜单ID失败:', error)
  }
  return null
}

// 获取菜单的数据库ID（从props或查找）
const getMenuId = async () => {
  // 先尝试从props获取
  if (props.menu.menuId && typeof props.menu.menuId === 'number') {
    return props.menu.menuId
  }
  
  // 如果menuIdRef已缓存，直接返回
  if (menuIdRef.value) {
    return menuIdRef.value
  }
  
  // 尝试通过菜单名称查找
  const foundId = await findMenuIdByName(props.menu.name, props.menu.category)
  if (foundId) {
    menuIdRef.value = foundId
    return foundId
  }
  
  return null
}

// 加载数据
const loadData = async () => {
  const menuId = await getMenuId()
  
  if (!menuId) {
    console.warn('无法找到菜单的数据库ID，无法加载内容。菜单对象:', props.menu)
    formData.html = '<p>请输入内容...</p>'
    originalHtml.value = '<p>请输入内容...</p>'
    return
  }
  
  try {
    const response = await contentApi.getContentByMenuId(menuId)
    if (response.success && response.content) {
      formData.html = response.content.content || '<p>请输入内容...</p>'
      originalHtml.value = formData.html
    } else {
      formData.html = '<p>请输入内容...</p>'
      originalHtml.value = '<p>请输入内容...</p>'
    }
  } catch (error) {
    console.error('加载内容失败:', error)
    ElMessage.error('加载内容失败')
    formData.html = '<p>请输入内容...</p>'
    originalHtml.value = '<p>请输入内容...</p>'
  }
}

const handleSave = async () => {
  if (!formData.html || formData.html.trim() === '' || formData.html === '<p><br></p>') {
    ElMessage.warning('请输入内容')
    return
  }
  
  // 获取菜单的数据库ID
  const menuId = await getMenuId()
  
  if (!menuId) {
    ElMessage.error('无法找到菜单的数据库ID，无法保存内容')
    console.error('菜单对象:', props.menu)
    return
  }
  
  saving.value = true
  try {
    // 标题固定为菜单名称
    const title = props.menu.name
    const response = await contentApi.saveContent(menuId, title, formData.html)
    
    if (response.success) {
      ElMessage.success('保存成功')
      originalHtml.value = formData.html
      emit('update')
    } else {
      throw new Error(response.message || '保存失败')
    }
  } catch (error) {
    console.error('保存内容失败:', error)
    ElMessage.error(error.message || '保存内容失败')
  } finally {
    saving.value = false
  }
}

const handleReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？重置后将恢复为上次保存的内容。', '提示', { type: 'warning' })
    .then(() => {
      formData.html = originalHtml.value
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

