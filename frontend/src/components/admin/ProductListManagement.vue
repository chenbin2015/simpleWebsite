<template>
  <el-card shadow="hover">
    <template #header>
      <div class="card-header">
        <h3>{{ menu.name }} - 内容管理</h3>
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          添加产品
        </el-button>
      </div>
    </template>

    <el-row :gutter="20" v-loading="loading">
      <el-col
        v-for="(item, index) in productList"
        :key="index"
        :xs="24"
        :sm="12"
        :md="8"
        :lg="6"
      >
        <el-card shadow="hover" class="product-card">
          <el-image :src="getImageUrl(item.image)" fit="cover" style="width: 100%; height: 200px;">
            <template #error>
              <div class="image-slot">
                <el-icon><Picture /></el-icon>
              </div>
            </template>
          </el-image>
          <div class="product-info">
            <div class="product-name">{{ item.name }}</div>
            <el-tag size="small" style="margin-top: 8px;">{{ item.category }}</el-tag>
          </div>
          <div class="product-actions">
            <el-button type="primary" size="small" @click="handleEdit(item, index)">
              编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDelete(index)">
              删除
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form :model="formData" label-width="100px">
        <el-form-item label="名称" required>
          <el-input v-model="formData.name" placeholder="请输入产品名称" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="图片" required>
          <el-upload
            :auto-upload="false"
            :on-change="handleImageChange"
            :file-list="imageFileList"
            list-type="picture-card"
            :limit="1"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="分类">
          <el-input v-model="formData.category" placeholder="请输入分类" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="formData.description" type="textarea" :rows="3" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="链接地址">
          <el-input v-model="formData.link" placeholder="请输入链接地址，如：https://example.com" maxlength="200" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 图片裁剪对话框 -->
    <el-dialog
      v-model="cropDialogVisible"
      title="裁剪图片"
      width="800px"
      :close-on-click-modal="false"
      append-to-body
      :z-index="3000"
    >
      <div class="crop-container">
        <vue-picture-cropper
          v-if="cropImageSrc"
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
            aspectRatio: NaN,
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
  </el-card>
</template>

<script setup>
import { ref, reactive, nextTick, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Picture } from '@element-plus/icons-vue'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import 'cropperjs/dist/cropper.css'
import * as moduleProductApi from '@/services/moduleProductApi'
import * as menuApi from '@/services/menuApi'
import { buildImageUrl } from '@/utils/url'

const props = defineProps({
  menu: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['update'])

const productList = ref([])
const loading = ref(false)
const menuIdRef = ref(null) // 存储数据库菜单ID

const dialogVisible = ref(false)
const dialogTitle = ref('添加产品')
const formData = reactive({
  id: null,
  name: '',
  image: '',
  category: '',
  description: '',
  link: ''
})
const imageFileList = ref([])
const editIndex = ref(-1)

// 裁剪相关
const cropDialogVisible = ref(false)
const cropImageSrc = ref('')
const pendingFile = ref(null)
const pictureCropperRef = ref(null)
const cropperReady = ref(false)

// 构建完整的图片URL
const getImageUrl = buildImageUrl

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

// 加载产品列表
const loadProductList = async () => {
  const menuId = await getMenuId()
  
  if (!menuId) {
    console.warn('无法找到菜单的数据库ID，无法加载产品列表。菜单对象:', props.menu)
    productList.value = []
    return
  }
  
  loading.value = true
  try {
    const response = await moduleProductApi.getProductListByMenuId(menuId)
    if (response.success && response.data) {
      productList.value = response.data
    } else {
      productList.value = []
    }
  } catch (error) {
    console.error('加载产品列表失败:', error)
    ElMessage.error('加载产品列表失败')
    productList.value = []
  } finally {
    loading.value = false
  }
}

const handleAdd = () => {
  dialogTitle.value = '添加产品'
  formData.id = null
  formData.name = ''
  formData.image = ''
  formData.category = ''
  formData.description = ''
  formData.link = ''
  imageFileList.value = []
  editIndex.value = -1
  dialogVisible.value = true
}

const handleEdit = (row, index) => {
  dialogTitle.value = '编辑产品'
  formData.id = row.id
  formData.name = row.name
  formData.image = row.image
  formData.category = row.category
  formData.description = row.description || ''
  formData.link = row.link || ''
  imageFileList.value = row.image ? [{ url: getImageUrl(row.image) }] : []
  editIndex.value = index
  dialogVisible.value = true
}

const handleImageChange = (file) => {
  // 保存待处理的文件
  pendingFile.value = file
  
  // 读取文件为base64，用于裁剪
  const reader = new FileReader()
  reader.onload = async (e) => {
    cropImageSrc.value = e.target.result
    await nextTick()
    cropDialogVisible.value = true
    await nextTick()
    cropperReady.value = true
  }
  
  reader.onerror = () => {
    ElMessage.error('读取文件失败')
    if (imageFileList.value && imageFileList.value.length > 0) {
      imageFileList.value = []
    }
    pendingFile.value = null
  }
  
  reader.readAsDataURL(file.raw)
}

// 裁剪器准备就绪
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

// 取消裁剪
const cancelCrop = () => {
  cropDialogVisible.value = false
  cropImageSrc.value = ''
  pendingFile.value = null
  cropperReady.value = false
  // 清空上传组件的文件列表
  imageFileList.value = []
}

// 确认裁剪
const confirmCrop = () => {
  if (!cropperReady.value || !cropper) {
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
    
    const croppedImageUrl = croppedCanvas.toDataURL('image/jpeg', 0.9)
    
    // 保存裁剪后的图片
    formData.image = croppedImageUrl
    imageFileList.value = [{
      uid: Date.now(),
      url: croppedImageUrl,
      name: pendingFile.value?.name || '产品图片'
    }]
    
    // 关闭裁剪对话框
    cropDialogVisible.value = false
    cropImageSrc.value = ''
    pendingFile.value = null
    cropperReady.value = false
  } catch (error) {
    console.error('裁剪图片失败:', error)
    ElMessage.error('裁剪图片失败: ' + (error.message || '未知错误'))
  }
}

const handleSubmit = async () => {
  if (!formData.name || !formData.name.trim()) {
    ElMessage.warning('请输入产品名称')
    return
  }
  if (!formData.image) {
    ElMessage.warning('请上传图片')
    return
  }
  
  const menuId = await getMenuId()
  if (!menuId) {
    ElMessage.error('无法找到菜单的数据库ID，无法保存产品')
    return
  }
  
  try {
    const productData = {
      name: formData.name,
      image: formData.image,
      category: formData.category,
      description: formData.description,
      link: formData.link
    }
    
    if (editIndex.value >= 0 && formData.id) {
      // 更新
      const response = await moduleProductApi.updateProduct(formData.id, productData)
      if (response.success) {
        ElMessage.success('编辑成功')
        await loadProductList() // 重新加载列表
        dialogVisible.value = false
        emit('update')
      } else {
        throw new Error(response.message || '更新失败')
      }
    } else {
      // 添加
      const response = await moduleProductApi.addProduct(menuId, productData)
      if (response.success) {
        ElMessage.success('添加成功')
        await loadProductList() // 重新加载列表
        dialogVisible.value = false
        emit('update')
      } else {
        throw new Error(response.message || '添加失败')
      }
    }
  } catch (error) {
    console.error('保存产品失败:', error)
    ElMessage.error(error.message || '保存产品失败')
  }
}

const handleDelete = async (index) => {
  const product = productList.value[index]
  if (!product || !product.id) {
    ElMessage.error('产品数据无效')
    return
  }
  
  ElMessageBox.confirm('确定要删除这个产品吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        const response = await moduleProductApi.deleteProduct(product.id)
        if (response.success) {
          ElMessage.success('删除成功')
          await loadProductList() // 重新加载列表
          emit('update')
        } else {
          throw new Error(response.message || '删除失败')
        }
      } catch (error) {
        console.error('删除产品失败:', error)
        ElMessage.error(error.message || '删除产品失败')
      }
    })
    .catch(() => {})
}

// 监听menu变化，重新加载数据
watch(() => props.menu, (newMenu, oldMenu) => {
  // 当菜单切换时，清空缓存的menuId，并重新加载数据
  if (newMenu && (!oldMenu || newMenu.id !== oldMenu.id || newMenu.menuId !== oldMenu.menuId)) {
    menuIdRef.value = null // 清空缓存
    loadProductList()
  }
}, { immediate: false })

onMounted(() => {
  loadProductList()
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

.product-card {
  margin-bottom: 20px;
}

.product-info {
  padding: 10px 0;
}

.product-name {
  font-weight: bold;
  margin-bottom: 8px;
}

.product-actions {
  margin-top: 10px;
  display: flex;
  gap: 10px;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
}

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}
</style>

