<template>
  <div class="admin-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>中心概况管理</h2>
        </div>
      </template>
      
      <el-tabs v-model="activeTab" type="card">
        <!-- Banner管理 -->
        <el-tab-pane label="Banner管理" name="banner">
          <div class="tab-content">
            <BannerManagement
              v-model="bannerForm"
              @save="handleBannerSave"
              @delete="handleBannerDelete"
            />
          </div>
        </el-tab-pane>

        <!-- 详情管理 -->
        <el-tab-pane label="详情管理" name="detail">
          <div class="tab-content">
            <el-form :model="detailForm" label-width="120px" label-position="left">
              <!-- 主标题 -->
              <el-form-item label="主标题">
                <el-input v-model="detailForm.mainTitle" placeholder="请输入主标题" maxlength="100" show-word-limit />
              </el-form-item>

              <!-- 建设背景 -->
              <el-form-item label="建设背景">
                <RichTextEditor v-model="detailForm.background" placeholder="请输入建设背景内容" />
              </el-form-item>

              <!-- 现状概况 -->
              <el-form-item label="现状概况">
                <RichTextEditor v-model="detailForm.overview" placeholder="请输入现状概况内容" />
              </el-form-item>

              <!-- 发展愿景 -->
              <el-form-item label="发展愿景">
                <RichTextEditor v-model="detailForm.vision" placeholder="请输入发展愿景内容" />
              </el-form-item>

              <!-- 操作按钮 -->
              <el-form-item>
                <el-button type="primary" size="large" @click="handleDetailSave">
                  <el-icon><Check /></el-icon>
                  保存
                </el-button>
                <el-button size="large" @click="handleDetailReset">
                  <el-icon><RefreshLeft /></el-icon>
                  重置
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- 组织架构管理 -->
        <el-tab-pane label="组织架构" name="organization">
          <div class="tab-content">
            <div class="organization-management">
              <!-- 角色类型列表 -->
              <div v-for="(roleGroup, index) in organizationRoleGroups" :key="index" class="role-group">
                <div class="role-header">
                  <el-input
                    v-model="roleGroup.roleName"
                    placeholder="请输入角色类型名称"
                    style="width: 200px; margin-right: 10px;"
                    @blur="handleRoleNameChange(index, roleGroup)"
                  />
                  <el-button 
                    type="danger" 
                    :icon="Delete" 
                    circle 
                    @click="removeRoleGroup(index)"
                    :disabled="organizationRoleGroups.length <= 1"
                  />
                </div>
                
                <div class="person-list">
                  <div v-for="(person, personIndex) in roleGroup.members" :key="person.id || personIndex" class="person-item">
                    <el-input
                      v-model="person.name"
                      :placeholder="`请输入${roleGroup.roleName || '角色'}姓名`"
                      style="width: 300px; margin-right: 10px;"
                      @blur="handlePersonNameChange(index, personIndex, person)"
                    />
                    <el-button type="danger" :icon="Delete" circle @click="removePersonFromRole(index, personIndex, person)" />
                  </div>
                  <el-button type="primary" :icon="Plus" @click="addPersonToRole(index)">
                    添加成员
                  </el-button>
                </div>
              </div>

              <!-- 添加角色类型按钮 -->
              <div class="add-role-group">
                <el-button type="primary" :icon="Plus" @click="addRoleGroup">
                  添加角色类型
                </el-button>
              </div>

            </div>
          </div>
        </el-tab-pane>

        <!-- 下设实验室管理 -->
        <el-tab-pane label="下设实验室" name="laboratories">
          <div class="tab-content">
            <div class="section-header">
              <h3>实验室列表</h3>
              <el-button type="primary" @click="handleLabAdd">
                <el-icon><Plus /></el-icon>
                添加实验室
              </el-button>
            </div>

            <div v-if="laboratoryList.length === 0" class="empty-state">
              <el-empty description="暂无实验室数据">
                <el-button type="primary" @click="handleLabAdd">添加第一个实验室</el-button>
              </el-empty>
            </div>

            <el-table v-else :data="laboratoryList" border style="width: 100%" v-loading="loading">
              <el-table-column type="index" label="序号" width="60" />
              <el-table-column label="图片" width="150">
                <template #default="{ row }">
                  <el-image 
                    :src="getImageUrl(row.imageUrl)" 
                    style="width: 120px; height: 80px;" 
                    fit="cover" 
                    :preview-src-list="[getImageUrl(row.imageUrl)]"
                  >
                    <template #error>
                      <div class="image-slot">
                        <el-icon><Picture /></el-icon>
                      </div>
                    </template>
                  </el-image>
                </template>
              </el-table-column>
              <el-table-column prop="name" label="实验室名称" min-width="200" />
              <el-table-column prop="link" label="链接地址" min-width="200" show-overflow-tooltip />
              <el-table-column prop="sortOrder" label="排序" width="100" />
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row }">
                  <el-button type="primary" size="small" @click="handleLabEdit(row)">
                    编辑
                  </el-button>
                  <el-button type="danger" size="small" @click="handleLabDelete(row.id)">
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- 实验室编辑对话框 -->
    <el-dialog v-model="labDialogVisible" :title="labDialogTitle" width="600px">
      <el-form :model="labForm" label-width="100px">
        <el-form-item label="实验室名称">
          <el-input v-model="labForm.name" placeholder="请输入实验室名称" />
        </el-form-item>
        <el-form-item label="图片">
          <el-upload
            ref="labImageUploadRef"
            :auto-upload="false"
            :on-change="handleLabImageChange"
            :on-remove="handleLabImageRemove"
            :file-list="labImageFileList"
            list-type="picture-card"
            :limit="1"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="链接地址">
          <el-input v-model="labForm.link" placeholder="请输入链接地址（可选）" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="labForm.sortOrder" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="labDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleLabSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 图片裁剪对话框 -->
    <el-dialog
      v-model="labCropDialogVisible"
      title="裁剪图片"
      width="800px"
      :close-on-click-modal="false"
      :z-index="3000"
      append-to-body
    >
      <div class="crop-container" v-if="labCropImageSrc">
        <vue-picture-cropper
          ref="labPictureCropperRef"
          :boxStyle="{
            width: '100%',
            height: '400px',
            backgroundColor: '#f8f8f8',
            margin: 'auto'
          }"
          :img="labCropImageSrc"
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
          @ready="onLabCropReady"
          @crop="onLabCrop"
        />
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelLabCrop">取消</el-button>
          <el-button type="primary" @click="confirmLabCrop">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Check, RefreshLeft, Plus, Delete, Picture } from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'
import BannerManagement from '@/components/admin/BannerManagement.vue'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import 'cropperjs/dist/cropper.css'
import * as centerOverviewApi from '@/services/centerOverviewApi'

// Tab切换
const activeTab = ref('banner')
const loading = ref(false)

// ========== Banner管理 ==========
const bannerForm = reactive({
  type: 'image',
  imageUrl: '',
  videoUrl: '',
  videoUrlExternal: ''
})

const handleBannerSave = async (data) => {
  try {
    loading.value = true
    const formData = {
      type: data.type
    }
    
    if (data.type === 'image') {
      // 优先使用 Base64 图片（来自裁剪）
      if (data.imageUrl && data.imageUrl.startsWith('data:image/')) {
        formData.imageUrl = data.imageUrl
      } else if (data.imageFile) {
        formData.image = data.imageFile
      }
    } else if (data.type === 'video') {
      if (data.videoFile) {
        formData.video = data.videoFile
      } else if (data.videoUrlExternal) {
        formData.videoUrlExternal = data.videoUrlExternal
      }
    }
    
    const response = await centerOverviewApi.saveBanner(formData)
    if (response.success) {
      ElMessage.success('保存成功')
      // 更新本地数据
      if (response.data) {
        Object.assign(bannerForm, {
          type: response.data.type,
          imageUrl: response.data.imageUrl ? getImageUrl(response.data.imageUrl) : '',
          videoUrl: response.data.videoUrl ? getImageUrl(response.data.videoUrl) : '',
          videoUrlExternal: response.data.videoUrlExternal || ''
        })
      }
    }
  } catch (error) {
    console.error('保存Banner失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取图片完整URL
const getImageUrl = (imageUrl) => {
  if (!imageUrl) return ''
  // 如果是相对路径，直接返回（由nginx处理）
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://') || imageUrl.startsWith('data:')) {
    return imageUrl
  }
  return imageUrl
}

// 加载Banner数据
const loadBanner = async () => {
  try {
    const response = await centerOverviewApi.getBanner()
    if (response.success && response.data) {
      // 有数据时，更新表单
      bannerForm.type = response.data.type || 'image'
      bannerForm.imageUrl = response.data.imageUrl ? getImageUrl(response.data.imageUrl) : ''
      bannerForm.videoUrl = response.data.videoUrl ? getImageUrl(response.data.videoUrl) : ''
      bannerForm.videoUrlExternal = response.data.videoUrlExternal || ''
    } else {
      // 没有数据时，清空表单
      bannerForm.type = 'image'
      bannerForm.imageUrl = ''
      bannerForm.videoUrl = ''
      bannerForm.videoUrlExternal = ''
    }
  } catch (error) {
    console.error('加载Banner失败:', error)
  }
}

// 删除Banner
const handleBannerDelete = async (data) => {
  try {
    loading.value = true
    const response = await centerOverviewApi.deleteBanner()
    if (response.success) {
      ElMessage.success('删除成功')
      // 重新加载Banner数据以更新状态
      await loadBanner()
    } else {
      ElMessage.error(response.message || '删除失败')
    }
  } catch (error) {
    console.error('删除Banner失败:', error)
    ElMessage.error('删除Banner失败')
  } finally {
    loading.value = false
  }
}

// ========== 详情管理 ==========
const detailForm = reactive({
  mainTitle: '',
  background: '',
  overview: '',
  vision: ''
})

const handleDetailSave = async () => {
  if (!detailForm.mainTitle || !detailForm.mainTitle.trim()) {
    ElMessage.warning('请输入主标题')
    return
  }
  try {
    loading.value = true
    const formData = {
      mainTitle: detailForm.mainTitle,
      background: detailForm.background || '',
      overview: detailForm.overview || '',
      vision: detailForm.vision || ''
    }
    
    const response = await centerOverviewApi.saveDetail(formData)
    if (response.success) {
      ElMessage.success('保存成功')
      if (response.data) {
        Object.assign(detailForm, {
          mainTitle: response.data.mainTitle,
          background: response.data.background || '',
          overview: response.data.overview || '',
          vision: response.data.vision || ''
        })
      }
    }
  } catch (error) {
    console.error('保存详情失败:', error)
  } finally {
    loading.value = false
  }
}

// 加载详情数据
const loadDetail = async () => {
  try {
    const response = await centerOverviewApi.getDetail()
    if (response.success && response.data) {
      Object.assign(detailForm, {
        mainTitle: response.data.mainTitle || '',
        background: response.data.background || '',
        overview: response.data.overview || '',
        vision: response.data.vision || ''
      })
    }
  } catch (error) {
    console.error('加载详情失败:', error)
  }
}

const handleDetailReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', { type: 'warning' })
    .then(async () => {
      await loadDetail()
      ElMessage.success('重置成功')
    })
    .catch(() => {})
}

// ========== 组织架构管理 ==========
// 角色类型列表，每个角色类型包含角色名称和成员列表（成员包含id和name）
const organizationRoleGroups = ref([])

// 添加角色类型
const addRoleGroup = () => {
  organizationRoleGroups.value.push({
    roleName: '',
    members: []
  })
}

// 删除角色类型
const removeRoleGroup = async (index) => {
  if (organizationRoleGroups.value.length <= 1) {
    ElMessage.warning('至少需要保留一个角色类型')
    return
  }
  
  const roleGroup = organizationRoleGroups.value[index]
  if (!roleGroup.roleName || !roleGroup.roleName.trim()) {
    // 如果角色名称为空，直接删除（前端未保存的）
    organizationRoleGroups.value.splice(index, 1)
    return
  }
  
  try {
    await ElMessageBox.confirm('确定要删除这个角色类型吗？', '提示', { type: 'warning' })
    
    loading.value = true
    const response = await centerOverviewApi.deleteOrganizationRole(roleGroup.roleName)
    if (response.success) {
      organizationRoleGroups.value.splice(index, 1)
      ElMessage.success('删除成功')
      // 重新加载数据以确保一致性
      await loadOrganization()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除角色类型失败:', error)
    }
  } finally {
    loading.value = false
  }
}

// 向角色类型添加成员
const addPersonToRole = async (roleIndex) => {
  const roleGroup = organizationRoleGroups.value[roleIndex]
  
  // 如果角色名称为空，先提示输入
  if (!roleGroup.roleName || !roleGroup.roleName.trim()) {
    ElMessage.warning('请先输入角色类型名称')
    return
  }
  
  // 先添加到前端列表
  const newPerson = { id: null, name: '' }
  roleGroup.members.push(newPerson)
}

// 从角色类型删除成员
const removePersonFromRole = async (roleIndex, personIndex, person) => {
  const roleGroup = organizationRoleGroups.value[roleIndex]
  
  // 如果有ID，说明是已保存的成员，需要调用API删除
  if (person.id) {
    try {
      await ElMessageBox.confirm('确定要删除这个成员吗？', '提示', { type: 'warning' })
      
      loading.value = true
      const response = await centerOverviewApi.deleteOrganizationMember(person.id)
      if (response.success) {
        roleGroup.members.splice(personIndex, 1)
        ElMessage.success('删除成功')
      }
    } catch (error) {
      if (error !== 'cancel') {
        console.error('删除成员失败:', error)
      }
    } finally {
      loading.value = false
    }
  } else {
    // 没有ID，说明是前端临时添加的，直接删除
    roleGroup.members.splice(personIndex, 1)
  }
}

// 处理成员姓名变化（保存）
const handlePersonNameChange = async (roleIndex, personIndex, person) => {
  const roleGroup = organizationRoleGroups.value[roleIndex]
  
  if (!roleGroup.roleName || !roleGroup.roleName.trim()) {
    ElMessage.warning('请先输入角色类型名称')
    return
  }
  
  const name = person.name && person.name.trim()
  if (!name) {
    return
  }
  
  // 如果已经有ID，说明是已保存的成员，需要更新（这里暂时只保存新增）
  if (person.id) {
    // 已保存的成员，名称变更暂时不处理（或者可以实现更新API）
    return
  }
  
  // 如果没有ID，说明是新添加的，调用API保存
  try {
    loading.value = true
    const response = await centerOverviewApi.addOrganizationMember(roleGroup.roleName, name)
    if (response.success && response.data) {
      // 更新成员的ID
      person.id = response.data.id
      ElMessage.success('添加成功')
      // 重新加载数据以确保一致性
      await loadOrganization()
    }
  } catch (error) {
    console.error('添加成员失败:', error)
    // 添加失败，移除这个成员
    roleGroup.members.splice(personIndex, 1)
  } finally {
    loading.value = false
  }
}

// 处理角色名称变化
const handleRoleNameChange = async (roleIndex, roleGroup) => {
  const oldRoleName = roleGroup.oldRoleName || ''
  const newRoleName = roleGroup.roleName && roleGroup.roleName.trim()
  
  if (!newRoleName) {
    return
  }
  
  // 如果角色名称没有变化，不需要更新
  if (oldRoleName === newRoleName) {
    return
  }
  
  // 如果是新添加的角色类型（没有oldRoleName），不需要调用API
  if (!oldRoleName || roleGroup.members.length === 0 || !roleGroup.members.some(m => m.id)) {
    roleGroup.oldRoleName = newRoleName
    return
  }
  
  // 如果有旧名称且有已保存的成员，需要更新角色名称
  try {
    loading.value = true
    const response = await centerOverviewApi.updateOrganizationRoleName(oldRoleName, newRoleName)
    if (response.success) {
      roleGroup.oldRoleName = newRoleName
      ElMessage.success('更新成功')
      // 重新加载数据以确保一致性
      await loadOrganization()
    }
  } catch (error) {
    console.error('更新角色名称失败:', error)
    // 恢复原来的名称
    roleGroup.roleName = oldRoleName
  } finally {
    loading.value = false
  }
}

// 加载组织架构数据
const loadOrganization = async () => {
  try {
    const response = await centerOverviewApi.getOrganization()
    if (response.success && response.data) {
      const roleGroups = []
      // 将后端返回的数据转换为前端格式
      for (const [roleName, members] of Object.entries(response.data)) {
        roleGroups.push({
          roleName: roleName,
          oldRoleName: roleName, // 保存原始名称用于更新时比较
          members: members.length > 0 ? members.map(item => ({
            id: item.id,
            name: item.name
          })) : []
        })
      }
      
      // 如果没有数据，保持为空数组
      organizationRoleGroups.value = roleGroups
    }
  } catch (error) {
    console.error('加载组织架构失败:', error)
  }
}

// ========== 下设实验室管理 ==========
const laboratoryList = ref([])

// 加载实验室列表
const loadLaboratoryList = async () => {
  try {
    loading.value = true
    const response = await centerOverviewApi.getLaboratoryList()
    if (response.success && response.data) {
      laboratoryList.value = response.data.map(item => ({
        id: item.id,
        name: item.name,
        imageUrl: item.imageUrl,
        link: item.link || '',
        sortOrder: item.sortOrder || 0
      }))
    }
  } catch (error) {
    console.error('加载实验室列表失败:', error)
  } finally {
    loading.value = false
  }
}

const labDialogVisible = ref(false)
const labDialogTitle = ref('添加实验室')
const labForm = reactive({
  id: null,
  name: '',
  imageUrl: '',
  link: '',
  sortOrder: 0
})
const labImageFileList = ref([])
const labImageFile = ref(null)
const labImageUploadRef = ref(null)

// 裁剪相关
const labCropDialogVisible = ref(false)
const labCropImageSrc = ref('')
const labPendingImageFile = ref(null)
const labPictureCropperRef = ref(null)
const labCropperReady = ref(false)

const handleLabAdd = () => {
  labDialogTitle.value = '添加实验室'
  labForm.id = null
  labForm.name = ''
  labForm.imageUrl = ''
  labForm.link = ''
  labForm.sortOrder = laboratoryList.value.length + 1
  labImageFileList.value = []
  labImageFile.value = null
  labDialogVisible.value = true
}

const handleLabEdit = (row) => {
  labDialogTitle.value = '编辑实验室'
  labForm.id = row.id
  labForm.name = row.name
  labForm.imageUrl = row.imageUrl
  labForm.link = row.link || ''
  labForm.sortOrder = row.sortOrder || 0
  labImageFileList.value = row.imageUrl ? [{ url: getImageUrl(row.imageUrl) }] : []
  labImageFile.value = null
  labDialogVisible.value = true
}

const handleLabImageChange = (file) => {
  // 保存待处理的文件
  labPendingImageFile.value = file
  
  // 读取文件为base64，用于裁剪
  const reader = new FileReader()
  reader.onload = async (e) => {
    labCropImageSrc.value = e.target.result
    // 等待DOM更新后打开裁剪对话框
    await nextTick()
    await nextTick()
    labCropDialogVisible.value = true
  }
  
  reader.onerror = () => {
    ElMessage.error('读取文件失败')
    if (labImageUploadRef.value) {
      labImageUploadRef.value.clearFiles()
    }
    labPendingImageFile.value = null
  }
  
  reader.readAsDataURL(file.raw)
}

const handleLabImageRemove = () => {
  labImageFile.value = null
  labForm.imageUrl = ''
  labImageFileList.value = []
}

// 裁剪器准备就绪
const onLabCropReady = () => {
  labCropperReady.value = true
}

// 裁剪事件
const onLabCrop = () => {
  // 实时裁剪预览（可选）
}

// 取消裁剪
const cancelLabCrop = () => {
  labCropDialogVisible.value = false
  labCropImageSrc.value = ''
  labPendingImageFile.value = null
  labCropperReady.value = false
  // 清空上传组件的文件列表
  if (labImageUploadRef.value) {
    labImageUploadRef.value.clearFiles()
  }
  labImageFileList.value = []
}

// 确认裁剪
const confirmLabCrop = () => {
  if (!labCropperReady.value || !cropper || !labPendingImageFile.value) {
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
    
    // 获取裁剪后的图片URL（Base64格式）
    const croppedImageUrl = croppedCanvas.toDataURL('image/jpeg', 0.9)
    
    // 更新表单数据（保存Base64）
    labForm.imageUrl = croppedImageUrl
    
    // 更新文件列表用于显示
    labImageFileList.value = [{
      uid: Date.now(),
      url: croppedImageUrl,
      name: '裁剪后的图片.jpg'
    }]
    
    // 清空之前的文件对象，确保保存时使用 Base64
    labImageFile.value = null
    
    ElMessage.success('图片裁剪成功')
    
    // 关闭裁剪对话框
    labCropDialogVisible.value = false
    labCropImageSrc.value = ''
    labPendingImageFile.value = null
    labCropperReady.value = false
  } catch (error) {
    console.error('裁剪图片失败:', error)
    ElMessage.error('裁剪图片失败')
  }
}

const handleLabSubmit = async () => {
  console.log('=== 提交实验室数据 ===')
  console.log('labForm:', labForm)
  console.log('labImageFile.value:', labImageFile.value)
  console.log('labForm.imageUrl:', labForm.imageUrl ? (labForm.imageUrl.substring(0, 50) + '...') : 'null')
  console.log('labImageFileList.value:', labImageFileList.value)
  
  if (!labForm.name || !labForm.name.trim()) {
    ElMessage.warning('请输入实验室名称')
    return
  }
  
  // 检查是否有图片：裁剪后的Base64图片 或 上传的文件 或 编辑时已有的图片
  const hasCroppedImage = labForm.imageUrl && labForm.imageUrl.startsWith('data:image/')
  const hasUploadedFile = labImageFile.value !== null
  const hasExistingImage = labForm.id && labForm.imageUrl && !labForm.imageUrl.startsWith('data:image/')
  
  console.log('hasCroppedImage:', hasCroppedImage)
  console.log('hasUploadedFile:', hasUploadedFile)
  console.log('hasExistingImage:', hasExistingImage)
  
  // 新增时必须上传图片
  if (!labForm.id && !hasCroppedImage && !hasUploadedFile) {
    console.log('新增模式：缺少图片')
    ElMessage.warning('请上传图片')
    return
  }
  
  // 编辑时如果没有新图片也没有旧图片，需要提示
  if (labForm.id && !hasCroppedImage && !hasUploadedFile && !hasExistingImage) {
    console.log('编辑模式：缺少图片')
    ElMessage.warning('请上传图片')
    return
  }
  
  try {
    loading.value = true
    const formData = {
      name: labForm.name,
      link: labForm.link || '',
      sortOrder: labForm.sortOrder
    }
    
    // 优先使用 Base64 图片（来自裁剪）
    if (labForm.imageUrl && labForm.imageUrl.startsWith('data:image/')) {
      console.log('使用裁剪后的Base64图片')
      formData.imageUrl = labForm.imageUrl
    } else if (labImageFile.value) {
      console.log('使用上传的文件')
      formData.image = labImageFile.value
    } else {
      console.log('编辑模式：使用现有图片，不传递图片参数')
    }
    
    console.log('提交的formData:', {
      ...formData,
      imageUrl: formData.imageUrl ? (formData.imageUrl.substring(0, 50) + '...') : undefined,
      image: formData.image ? 'File对象' : undefined
    })
    
    let response
    if (labForm.id) {
      // 编辑
      response = await centerOverviewApi.updateLaboratory(labForm.id, formData)
    } else {
      // 新增
      response = await centerOverviewApi.addLaboratory(formData)
    }
    
    if (response.success) {
      ElMessage.success(labForm.id ? '编辑成功' : '添加成功')
      labDialogVisible.value = false
      await loadLaboratoryList()
    }
  } catch (error) {
    console.error('保存实验室失败:', error)
  } finally {
    loading.value = false
  }
}

const handleLabDelete = (id) => {
  ElMessageBox.confirm('确定要删除这个实验室吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        loading.value = true
        const response = await centerOverviewApi.deleteLaboratory(id)
        if (response.success) {
          ElMessage.success('删除成功')
          await loadLaboratoryList()
        }
      } catch (error) {
        console.error('删除实验室失败:', error)
      } finally {
        loading.value = false
      }
    })
    .catch(() => {})
}

// 页面加载时获取数据
onMounted(async () => {
  await loadBanner()
  await loadDetail()
  await loadOrganization()
  await loadLaboratoryList()
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


.organization-management {
  width: 100%;
}

.role-group {
  margin-bottom: 30px;
  padding: 20px;
  background-color: #fafafa;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.role-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 2px solid #e4e7ed;
}

.role-header .el-input {
  font-weight: bold;
  font-size: 16px;
}

.add-role-group {
  margin-top: 20px;
  margin-bottom: 30px;
  text-align: center;
}

.organization-actions {
  margin-top: 30px;
  text-align: center;
}

.person-list {
  width: 100%;
}

.person-item {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  padding: 10px;
  background-color: #ffffff;
  border-radius: 4px;
  border: 1px solid #dcdfe6;
}

.person-item:hover {
  background-color: #ecf5ff;
  border-color: #b3d8ff;
}

.empty-state {
  padding: 60px 0;
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

:deep(.el-form-item__label) {
  font-weight: bold;
}

:deep(.el-card__header) {
  background-color: #fafafa;
  border-bottom: 1px solid #ebeef5;
}
</style>

