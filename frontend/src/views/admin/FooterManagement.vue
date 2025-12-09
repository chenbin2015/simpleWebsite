<template>
  <div class="admin-page">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h2>Footer管理</h2>
        </div>
      </template>
      
      <el-tabs v-model="activeTab" type="card">
        <!-- 基本信息 -->
        <el-tab-pane label="基本信息" name="basic">
          <div class="tab-content">
            <el-form :model="basicForm" label-width="120px" style="max-width: 800px;">
              <el-form-item label="版权信息">
                <el-input v-model="basicForm.copyright" placeholder="请输入版权信息，例如：© 2025 东南大学建筑学院实验教学中心" maxlength="200" show-word-limit />
              </el-form-item>
              <el-form-item label="ICP备案号">
                <el-input v-model="basicForm.icp" placeholder="请输入ICP备案号" maxlength="200" show-word-limit />
              </el-form-item>
              <el-form-item label="Logo">
                <el-upload
                  ref="logoUploadRef"
                  :auto-upload="false"
                  :on-change="handleLogoChange"
                  :before-remove="handleLogoBeforeRemove"
                  :file-list="logoFileList"
                  list-type="picture-card"
                  :limit="1"
                  accept="image/*"
                >
                  <el-icon><Plus /></el-icon>
                </el-upload>
                <div class="form-tip">支持上传Logo图片</div>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="handleBasicSave">保存</el-button>
                <el-button @click="handleBasicReset">重置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- 联系方式 -->
        <el-tab-pane label="联系方式" name="contact">
          <div class="tab-content">
            <el-form :model="contactForm" label-width="120px" style="max-width: 800px;">
              <el-form-item label="地址">
                <el-input v-model="contactForm.address" placeholder="请输入详细地址" maxlength="200" show-word-limit />
              </el-form-item>
              <el-form-item label="邮编">
                <el-input v-model="contactForm.postcode" placeholder="请输入邮编" maxlength="20" show-word-limit />
              </el-form-item>
              <el-form-item label="电话">
                <el-input v-model="contactForm.phone" placeholder="请输入联系电话" maxlength="50" show-word-limit />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="handleContactSave">保存</el-button>
                <el-button @click="handleContactReset">重置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- 友情链接 -->
        <el-tab-pane label="友情链接" name="links">
          <div class="tab-content">
            <div class="section-header">
              <h3>链接列表</h3>
              <el-button type="primary" @click="handleLinkAdd">
                <el-icon><Plus /></el-icon>
                添加链接
              </el-button>
            </div>
            
            <el-table :data="linkList" border style="width: 100%">
              <el-table-column type="index" label="序号" width="60" />
              <el-table-column prop="name" label="链接名称" min-width="150" />
              <el-table-column prop="url" label="链接地址" min-width="300" show-overflow-tooltip />
              <el-table-column label="是否新窗口" width="120">
                <template #default="{ row }">
                  <el-tag :type="row.target === '_blank' ? 'success' : 'info'">
                    {{ row.target === '_blank' ? '是' : '否' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="sort" label="排序" width="100" />
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row, $index }">
                  <el-button type="primary" size="small" @click="handleLinkEdit(row, $index)">
                    编辑
                  </el-button>
                  <el-button type="danger" size="small" @click="handleLinkDelete($index)">
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>

        
      </el-tabs>
    </el-card>

    <!-- Logo裁剪对话框 -->
    <el-dialog
      v-model="logoCropDialogVisible"
      title="裁剪Logo"
      width="800px"
      :close-on-click-modal="false"
      append-to-body
      :z-index="3000"
    >
      <div class="crop-container">
        <vue-picture-cropper
          ref="logoPictureCropperRef"
          :boxStyle="{
            width: '100%',
            height: 'auto',
            maxHeight: '80vh',
            backgroundColor: '#f8f8f8',
            margin: 'auto'
          }"
          :img="logoCropImageSrc"
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
          @ready="onLogoCropReady"
          @crop="onLogoCrop"
        />
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelLogoCrop">取消</el-button>
          <el-button type="primary" @click="confirmLogoCrop">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 友情链接编辑对话框 -->
    <el-dialog v-model="linkDialogVisible" :title="linkDialogTitle" width="600px">
      <el-form :model="linkForm" label-width="100px">
        <el-form-item label="链接名称" required>
          <el-input v-model="linkForm.name" placeholder="请输入链接名称" maxlength="50" show-word-limit />
        </el-form-item>
        <el-form-item label="链接地址" required>
          <el-input v-model="linkForm.url" placeholder="请输入链接地址，例如：https://www.example.com" maxlength="200" show-word-limit />
        </el-form-item>
        <el-form-item label="是否新窗口">
          <el-radio-group v-model="linkForm.target">
            <el-radio label="_self">否</el-radio>
            <el-radio label="_blank">是</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="linkForm.sort" :min="0" :max="999" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="linkDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleLinkSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import * as footerApi from '@/services/footerApi'
import { buildImageUrl } from '@/utils/url'
import 'cropperjs/dist/cropper.css'

// Tab切换
const activeTab = ref('contact')

// ========== 基本信息 ==========
const basicForm = reactive({
  copyright: '© 2025 东南大学建筑学院实验教学中心',
  icp: '',
  logo: ''
})

const logoFileList = ref([])
const logoUploadRef = ref(null)

// Logo裁剪相关
const logoCropDialogVisible = ref(false)
const logoCropImageSrc = ref('')
const logoPendingFile = ref(null)
const logoPictureCropperRef = ref(null)
const logoCropperReady = ref(false)

// 构建完整的图片URL
const getImageUrl = buildImageUrl

const handleLogoChange = (file) => {
  // 保存待处理的文件
  logoPendingFile.value = file
  
  // 读取文件为base64，用于裁剪
  const reader = new FileReader()
  reader.onload = async (e) => {
    logoCropImageSrc.value = e.target.result
    await nextTick()
    logoCropDialogVisible.value = true
  }
  
  reader.onerror = () => {
    ElMessage.error('读取Logo文件失败')
    if (logoUploadRef.value) {
      logoUploadRef.value.clearFiles()
    }
    logoPendingFile.value = null
  }
  
  reader.readAsDataURL(file.raw)
}

// Logo裁剪器准备就绪
const onLogoCropReady = () => {
  logoCropperReady.value = true
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

// Logo裁剪事件
const onLogoCrop = () => {
  // 实时裁剪预览（可选）
}

// 取消Logo裁剪
const cancelLogoCrop = () => {
  logoCropDialogVisible.value = false
  logoCropImageSrc.value = ''
  logoPendingFile.value = null
  logoCropperReady.value = false
  // 清空上传组件的文件列表
  if (logoUploadRef.value) {
    logoUploadRef.value.clearFiles()
  }
}

// 确认Logo裁剪
const confirmLogoCrop = () => {
  if (!logoCropperReady.value || !cropper || !logoPendingFile.value) {
    ElMessage.error('裁剪器未准备好，请稍候重试')
    return
  }
  
  try {
    // 获取裁剪后的base64图片（不固定尺寸，保持原始裁剪比例）
    const croppedCanvas = cropper.getCroppedCanvas({
      imageSmoothingEnabled: true,
      imageSmoothingQuality: 'high'
    })
    
    if (!croppedCanvas) {
      ElMessage.error('裁剪失败，请重试')
      return
    }
    
    const croppedImageUrl = croppedCanvas.toDataURL('image/png', 0.9)
    
    // 将裁剪后的图片保存到表单
    basicForm.logo = croppedImageUrl
    
    // 更新文件列表显示
    logoFileList.value = [{
      uid: Date.now(),
      url: croppedImageUrl,
      name: logoPendingFile.value.name
    }]
    
    // 关闭裁剪对话框
    logoCropDialogVisible.value = false
    logoCropImageSrc.value = ''
    logoPendingFile.value = null
    logoCropperReady.value = false
  } catch (error) {
    console.error('Logo裁剪失败:', error)
    ElMessage.error('Logo裁剪失败')
  }
}

// Logo删除前确认
const handleLogoBeforeRemove = async (file) => {
  try {
    await ElMessageBox.confirm('确定要删除Logo吗？', '提示', {
      type: 'warning'
    })
    
    // 清空Logo
    basicForm.logo = ''
    
    // 允许从上传组件中移除
    return true
  } catch (error) {
    // 用户取消删除，返回 false 阻止删除
    if (error === 'cancel') {
      return false
    }
    return false
  }
}

const handleBasicSave = async () => {
  try {
    const result = await footerApi.saveBasic(basicForm)
    if (result.success) {
      ElMessage.success(result.message || '保存成功')
      await loadBasic()
    } else {
      ElMessage.error(result.message || '保存失败')
    }
  } catch (error) {
    console.error('保存基本信息失败:', error)
    ElMessage.error(error.message || '保存基本信息失败')
  }
}

const loadBasic = async () => {
  try {
    const result = await footerApi.getBasic()
    if (result.success) {
      if (result.data) {
        Object.assign(basicForm, {
          copyright: result.data.copyright || '',
          icp: result.data.icp || '',
          logo: result.data.logo || ''
        })
        if (result.data.logo) {
          logoFileList.value = [{ url: getImageUrl(result.data.logo) }]
        } else {
          logoFileList.value = []
        }
      } else {
        // 没有数据，重置为默认值
        basicForm.copyright = '© 2025 东南大学建筑学院实验教学中心'
        basicForm.icp = ''
        basicForm.logo = ''
        logoFileList.value = []
      }
    }
  } catch (error) {
    console.error('加载基本信息失败:', error)
    ElMessage.error('加载基本信息失败')
  }
}

const handleBasicReset = () => {
        basicForm.copyright = '© 2025 东南大学建筑学院实验教学中心'
        basicForm.icp = ''
        basicForm.logo = ''
        logoFileList.value = []
  ElMessage.info('已重置')
}

// ========== 联系方式 ==========
const contactForm = reactive({
  address: '',
  postcode: '',
  phone: ''
})

const handleContactSave = async () => {
  try {
    const result = await footerApi.saveContact(contactForm)
    if (result.success) {
      ElMessage.success(result.message || '保存成功')
      await loadContact()
    } else {
      ElMessage.error(result.message || '保存失败')
    }
  } catch (error) {
    console.error('保存联系方式失败:', error)
    ElMessage.error(error.message || '保存联系方式失败')
  }
}

const loadContact = async () => {
  try {
    const result = await footerApi.getContact()
    if (result.success) {
      if (result.data) {
        Object.assign(contactForm, {
          address: result.data.address || '',
          postcode: result.data.postcode || '',
          phone: result.data.phone || ''
        })
      } else {
        // 没有数据，重置为空
        contactForm.address = ''
        contactForm.postcode = ''
        contactForm.phone = ''
      }
    }
  } catch (error) {
    console.error('加载联系方式失败:', error)
    ElMessage.error('加载联系方式失败')
  }
}

const handleContactReset = () => {
  contactForm.address = ''
  contactForm.postcode = ''
  contactForm.phone = ''
  ElMessage.info('已重置')
}

// ========== 友情链接 ==========
const linkList = ref([])

const linkDialogVisible = ref(false)
const linkDialogTitle = ref('添加链接')
const linkForm = reactive({
  id: null,
  name: '',
  url: '',
  target: '_blank',
  sort: 0
})
const linkEditIndex = ref(-1)

const handleLinkAdd = () => {
  linkDialogTitle.value = '添加链接'
  linkForm.id = null
  linkForm.name = ''
  linkForm.url = ''
  linkForm.target = '_blank'
  linkForm.sort = linkList.value.length > 0 ? Math.max(...linkList.value.map(l => l.sort)) + 1 : 1
  linkEditIndex.value = -1
  linkDialogVisible.value = true
}

const handleLinkEdit = (row, index) => {
  linkDialogTitle.value = '编辑链接'
  linkForm.id = row.id
  linkForm.name = row.name
  linkForm.url = row.url
  linkForm.target = row.target || '_blank'
  linkForm.sort = row.sort || 0
  linkEditIndex.value = index
  linkDialogVisible.value = true
}

const handleLinkSubmit = async () => {
  if (!linkForm.name || !linkForm.name.trim()) {
    ElMessage.warning('请输入链接名称')
    return
  }
  if (!linkForm.url || !linkForm.url.trim()) {
    ElMessage.warning('请输入链接地址')
    return
  }
  // 简单的URL验证
  if (!linkForm.url.startsWith('http://') && !linkForm.url.startsWith('https://')) {
    ElMessage.warning('链接地址必须以 http:// 或 https:// 开头')
    return
  }
  
  try {
    let result
    if (linkEditIndex.value >= 0) {
      // 编辑
      const linkId = linkList.value[linkEditIndex.value].id
      result = await footerApi.updateLink(linkId, linkForm)
    } else {
      // 添加
      result = await footerApi.addLink(linkForm)
    }
    
    if (result.success) {
      ElMessage.success(result.message || '保存成功')
      linkDialogVisible.value = false
      await loadLinkList()
    } else {
      ElMessage.error(result.message || '保存失败')
    }
  } catch (error) {
    console.error('保存链接失败:', error)
    ElMessage.error(error.message || '保存链接失败')
  }
}

const handleLinkDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个链接吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        const linkId = linkList.value[index].id
        const result = await footerApi.deleteLink(linkId)
        if (result.success) {
          ElMessage.success(result.message || '删除成功')
          await loadLinkList()
        } else {
          ElMessage.error(result.message || '删除失败')
        }
      } catch (error) {
        console.error('删除链接失败:', error)
        ElMessage.error(error.message || '删除链接失败')
      }
    })
    .catch(() => {})
}

const loadLinkList = async () => {
  try {
    const result = await footerApi.getLinkList()
    if (result.success) {
      linkList.value = result.data || []
    } else {
      linkList.value = []
      ElMessage.error(result.message || '加载链接列表失败')
    }
  } catch (error) {
    console.error('加载链接列表失败:', error)
    ElMessage.error('加载链接列表失败')
    linkList.value = []
  }
}

// 页面加载时获取数据
onMounted(() => {
  loadBasic()
  loadContact()
  loadLinkList()
})
</script>

<style scoped>
.admin-page {
  padding: 0;
  min-height: calc(100vh - 200px);
  background-color: #f0f2f5;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.tab-content {
  padding: 20px 0;
}

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

.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.logo-preview {
  margin-top: 10px;
}

:deep(.el-card__header) {
  background-color: #fafafa;
  border-bottom: 1px solid #ebeef5;
}

.crop-container {
  width: 100%;
  margin: 20px 0;
}

:deep(.cropper-container) {
  max-width: 100%;
}
</style>
