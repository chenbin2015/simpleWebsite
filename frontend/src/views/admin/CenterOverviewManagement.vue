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
            />
          </div>
        </el-tab-pane>

        <!-- 详情管理 -->
        <el-tab-pane label="详情管理" name="detail">
          <div class="tab-content">
            <el-form :model="detailForm" label-width="120px" label-position="left">
              <!-- 视频Banner -->
              <el-form-item label="视频Banner">
                <div class="video-upload-section">
                  <el-upload
                    ref="videoUploadRef"
                    :auto-upload="false"
                    :on-change="handleVideoChange"
                    :file-list="videoFileList"
                    :limit="1"
                    accept="video/*"
                    list-type="text"
                  >
                    <el-button type="primary">
                      <el-icon><Upload /></el-icon>
                      上传视频
                    </el-button>
                    <template #tip>
                      <div class="el-upload__tip">支持mp4、webm等视频格式，建议尺寸1920x1080</div>
                    </template>
                  </el-upload>
                  <div v-if="detailForm.videoUrl" class="video-preview">
                    <video :src="detailForm.videoUrl" controls style="max-width: 100%; max-height: 300px; margin-top: 10px;" />
                    <el-button type="danger" size="small" style="margin-top: 10px;" @click="handleVideoDelete">
                      删除视频
                    </el-button>
                  </div>
                  <div v-else-if="detailForm.videoUrlExternal" class="video-preview">
                    <div class="external-video-info">
                      <p><strong>外部视频URL：</strong>{{ detailForm.videoUrlExternal }}</p>
                      <video :src="detailForm.videoUrlExternal" controls style="max-width: 100%; max-height: 300px; margin-top: 10px;" />
                      <el-button type="danger" size="small" style="margin-top: 10px;" @click="handleVideoExternalDelete">
                        删除视频
                      </el-button>
                    </div>
                  </div>
                  <div v-else class="video-placeholder">
                    <el-alert type="info" :closable="false" style="margin-top: 10px;">
                      <template #default>
                        <div>暂无视频，请上传视频文件或输入外部视频URL</div>
                        <el-input v-model="externalVideoUrl" placeholder="或输入外部视频URL" style="margin-top: 10px;">
                          <template #append>
                            <el-button @click="handleSetExternalVideo">设置</el-button>
                          </template>
                        </el-input>
                      </template>
                    </el-alert>
                  </div>
                </div>
              </el-form-item>

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
            <el-form :model="organizationForm" label-width="120px" label-position="left">
              <!-- 主任 -->
              <el-form-item label="主任">
                <div class="person-list">
                  <div v-for="(person, index) in organizationForm.director" :key="index" class="person-item">
                    <el-input
                      v-model="organizationForm.director[index]"
                      placeholder="请输入主任姓名"
                      style="width: 300px; margin-right: 10px;"
                    />
                    <el-button type="danger" :icon="Delete" circle @click="removePerson('director', index)" />
                  </div>
                  <el-button type="primary" :icon="Plus" @click="addPerson('director')">
                    添加主任
                  </el-button>
                </div>
              </el-form-item>

              <!-- 副主任 -->
              <el-form-item label="副主任">
                <div class="person-list">
                  <div v-for="(person, index) in organizationForm.deputyDirector" :key="index" class="person-item">
                    <el-input
                      v-model="organizationForm.deputyDirector[index]"
                      placeholder="请输入副主任姓名"
                      style="width: 300px; margin-right: 10px;"
                    />
                    <el-button type="danger" :icon="Delete" circle @click="removePerson('deputyDirector', index)" />
                  </div>
                  <el-button type="primary" :icon="Plus" @click="addPerson('deputyDirector')">
                    添加副主任
                  </el-button>
                </div>
              </el-form-item>

              <!-- 成员 -->
              <el-form-item label="成员">
                <div class="person-list">
                  <div v-for="(person, index) in organizationForm.members" :key="index" class="person-item">
                    <el-input
                      v-model="organizationForm.members[index]"
                      placeholder="请输入成员姓名"
                      style="width: 300px; margin-right: 10px;"
                    />
                    <el-button type="danger" :icon="Delete" circle @click="removePerson('members', index)" />
                  </div>
                  <el-button type="primary" :icon="Plus" @click="addPerson('members')">
                    添加成员
                  </el-button>
                </div>
              </el-form-item>

              <!-- 操作按钮 -->
              <el-form-item>
                <el-button type="primary" size="large" @click="handleOrganizationSave">
                  <el-icon><Check /></el-icon>
                  保存
                </el-button>
                <el-button size="large" @click="handleOrganizationReset">
                  <el-icon><RefreshLeft /></el-icon>
                  重置
                </el-button>
              </el-form-item>
            </el-form>
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

            <el-table v-else :data="laboratoryList" border style="width: 100%">
              <el-table-column type="index" label="序号" width="60" />
              <el-table-column label="图片" width="150">
                <template #default="{ row }">
                  <el-image :src="row.image" style="width: 120px; height: 80px;" fit="cover" :preview-src-list="[row.image]">
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
              <el-table-column prop="sort" label="排序" width="100" />
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row, $index }">
                  <el-button type="primary" size="small" @click="handleLabEdit(row, $index)">
                    编辑
                  </el-button>
                  <el-button type="danger" size="small" @click="handleLabDelete($index)">
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
            :auto-upload="false"
            :on-change="handleLabImageChange"
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
          <el-input-number v-model="labForm.sort" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="labDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleLabSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload, Check, RefreshLeft, Plus, Delete, Picture } from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'
import BannerManagement from '@/components/admin/BannerManagement.vue'

// Tab切换
const activeTab = ref('banner')

// ========== Banner管理 ==========
const bannerForm = reactive({
  type: 'image',
  imageUrl: '',
  videoUrl: '',
  videoUrlExternal: ''
})

const handleBannerSave = (data) => {
  console.log('保存Banner数据:', data)
  // 这里可以调用API保存数据
}

// ========== 详情管理 ==========
const videoUploadRef = ref(null)
const videoFileList = ref([])
const externalVideoUrl = ref('')

const detailForm = reactive({
  videoUrl: '',
  videoUrlExternal: '',
  mainTitle: '东南大学建筑学院实验教学中心',
  background: '<p>东南大学建筑学院实验教学中心（以下简称"中心"）是在整合建筑学院原有各专业实验室的基础上，于2025年2月正式成立的综合性实验教学平台。中心致力于为建筑学院各专业的实验教学、科研创新和社会服务提供强有力的支撑。</p>',
  overview: '<p>中心现为省级实验教学示范中心，拥有15个核心实验平台，涵盖6大研究方向/教学领域。中心现有实体实验室31间，总面积超过2200平方米，配备各类仪器设备1200余台（套），设备总值约8000万元，其中大型仪器设备100余台（套），价值约3500万元。</p><p>中心现有专兼职教师30余人，专职技术人员6人。每年承担实验教学课时数超过2000学时，实验项目数超过300项，服务学生人数超过2000人次。</p><p>中心在实验教学、科研创新、社会服务等方面取得了显著成效，为培养高素质建筑人才和推动学科发展做出了重要贡献。</p>',
  vision: '<p>中心将继续秉承"以学生为中心，以能力培养为导向"的理念，不断推进实验教学改革与创新，努力建设成为国内领先、国际知名的实验教学创新示范中心，为培养具有创新精神和实践能力的高素质建筑人才提供更加优质的教学资源和实验环境。</p>'
})

const handleVideoChange = (file) => {
  const maxSize = 200 * 1024 * 1024
  if (file.size > maxSize) {
    ElMessage.warning('视频文件大小不能超过200MB')
    return false
  }
  const reader = new FileReader()
  reader.onload = (e) => {
    detailForm.videoUrl = e.target.result
    detailForm.videoUrlExternal = ''
    ElMessage.success('视频上传成功')
  }
  reader.readAsDataURL(file.raw)
}

const handleVideoDelete = () => {
  ElMessageBox.confirm('确定要删除视频吗？', '提示', { type: 'warning' })
    .then(() => {
      detailForm.videoUrl = ''
      videoFileList.value = []
      if (videoUploadRef.value) {
        videoUploadRef.value.clearFiles()
      }
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleSetExternalVideo = () => {
  if (!externalVideoUrl.value || !externalVideoUrl.value.trim()) {
    ElMessage.warning('请输入视频URL')
    return
  }
  detailForm.videoUrlExternal = externalVideoUrl.value.trim()
  detailForm.videoUrl = ''
  videoFileList.value = []
  if (videoUploadRef.value) {
    videoUploadRef.value.clearFiles()
  }
  externalVideoUrl.value = ''
  ElMessage.success('外部视频URL设置成功')
}

const handleVideoExternalDelete = () => {
  ElMessageBox.confirm('确定要删除外部视频吗？', '提示', { type: 'warning' })
    .then(() => {
      detailForm.videoUrlExternal = ''
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleDetailSave = () => {
  if (!detailForm.mainTitle || !detailForm.mainTitle.trim()) {
    ElMessage.warning('请输入主标题')
    return
  }
  console.log('保存详情数据:', detailForm)
  ElMessage.success('保存成功')
}

const handleDetailReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', { type: 'warning' })
    .then(() => {
      detailForm.videoUrl = ''
      detailForm.videoUrlExternal = ''
      detailForm.mainTitle = '东南大学建筑学院实验教学中心'
      detailForm.background = '<p>建设背景内容...</p>'
      detailForm.overview = '<p>现状概况内容...</p>'
      detailForm.vision = '<p>发展愿景内容...</p>'
      ElMessage.success('重置成功')
    })
    .catch(() => {})
}

// ========== 组织架构管理 ==========
const organizationForm = reactive({
  director: ['王伟'],
  deputyDirector: ['华好', '冯世虎'],
  members: ['是罪', '李超明', '兰祥启', '刘宇衡', '周海飞']
})

const addPerson = (type) => {
  organizationForm[type].push('')
}

const removePerson = (type, index) => {
  if (organizationForm[type].length <= 1 && type === 'director') {
    ElMessage.warning('至少需要保留一位主任')
    return
  }
  ElMessageBox.confirm('确定要删除吗？', '提示', { type: 'warning' })
    .then(() => {
      organizationForm[type].splice(index, 1)
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleOrganizationSave = () => {
  if (organizationForm.director.length === 0 || organizationForm.director.every(name => !name.trim())) {
    ElMessage.warning('至少需要设置一位主任')
    return
  }
  const data = {
    director: organizationForm.director.filter(name => name.trim()),
    deputyDirector: organizationForm.deputyDirector.filter(name => name.trim()),
    members: organizationForm.members.filter(name => name.trim())
  }
  console.log('保存组织架构数据:', data)
  ElMessage.success('保存成功')
}

const handleOrganizationReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', { type: 'warning' })
    .then(() => {
      organizationForm.director = ['王伟']
      organizationForm.deputyDirector = ['华好', '冯世虎']
      organizationForm.members = ['是罪', '李超明', '兰祥启', '刘宇衡', '周海飞']
      ElMessage.success('重置成功')
    })
    .catch(() => {})
}

// ========== 下设实验室管理 ==========
const laboratoryList = ref([
  {
    id: 1,
    name: '设计基础实训实验室',
    image: 'https://via.placeholder.com/400x200?text=设计基础实训实验室',
    link: '/lab/design-basic',
    sort: 1
  },
  {
    id: 2,
    name: '智能建筑实验室',
    image: 'https://via.placeholder.com/400x200?text=智能建筑实验室',
    link: '/lab/smart-building',
    sort: 2
  },
  {
    id: 3,
    name: '建筑物理实验室',
    image: 'https://via.placeholder.com/400x200?text=建筑物理实验室',
    link: '/lab/building-physics',
    sort: 3
  },
  {
    id: 4,
    name: '城市大数据与虚拟仿真实验室',
    image: 'https://via.placeholder.com/400x200?text=城市大数据与虚拟仿真实验室',
    link: '/lab/urban-bigdata',
    sort: 4
  },
  {
    id: 5,
    name: '遗产保护实验室',
    image: 'https://via.placeholder.com/400x200?text=遗产保护实验室',
    link: '/lab/heritage',
    sort: 5
  },
  {
    id: 6,
    name: '数字景观实验室',
    image: 'https://via.placeholder.com/400x200?text=数字景观实验室',
    link: '/lab/digital-landscape',
    sort: 6
  }
])

const labDialogVisible = ref(false)
const labDialogTitle = ref('添加实验室')
const labForm = reactive({
  id: null,
  name: '',
  image: '',
  link: '',
  sort: 0
})
const labImageFileList = ref([])
const labEditIndex = ref(-1)

const handleLabAdd = () => {
  labDialogTitle.value = '添加实验室'
  labForm.id = null
  labForm.name = ''
  labForm.image = ''
  labForm.link = ''
  labForm.sort = laboratoryList.value.length + 1
  labImageFileList.value = []
  labEditIndex.value = -1
  labDialogVisible.value = true
}

const handleLabEdit = (row, index) => {
  labDialogTitle.value = '编辑实验室'
  labForm.id = row.id
  labForm.name = row.name
  labForm.image = row.image
  labForm.link = row.link
  labForm.sort = row.sort
  labImageFileList.value = row.image ? [{ url: row.image }] : []
  labEditIndex.value = index
  labDialogVisible.value = true
}

const handleLabImageChange = (file) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    labForm.image = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

const handleLabSubmit = () => {
  if (!labForm.name || !labForm.name.trim()) {
    ElMessage.warning('请输入实验室名称')
    return
  }
  if (!labForm.image) {
    ElMessage.warning('请上传图片')
    return
  }
  if (labEditIndex.value >= 0) {
    laboratoryList.value[labEditIndex.value] = { ...labForm, id: labForm.id || Date.now() }
    ElMessage.success('编辑成功')
  } else {
    laboratoryList.value.push({ ...labForm, id: Date.now() })
    laboratoryList.value.sort((a, b) => a.sort - b.sort)
    ElMessage.success('添加成功')
  }
  labDialogVisible.value = false
}

const handleLabDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个实验室吗？', '提示', { type: 'warning' })
    .then(() => {
      laboratoryList.value.splice(index, 1)
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}
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


.video-upload-section {
  width: 100%;
}

.video-preview {
  margin-top: 15px;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.external-video-info {
  margin-top: 15px;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.external-video-info p {
  margin-bottom: 10px;
  color: #606266;
}

.video-placeholder {
  margin-top: 15px;
}

.person-list {
  width: 100%;
}

.person-item {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.person-item:hover {
  background-color: #ecf5ff;
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

