<template>
  <div class="admin-page">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h2>科普教育管理</h2>
        </div>
      </template>
      
      <el-tabs v-model="activeTab" type="card">
        <!-- Banner图管理 -->
        <el-tab-pane label="Banner图管理" name="banner">
          <div class="tab-content">
            <div class="section-header">
              <h3>Banner图设置</h3>
              <div class="upload-tip">仅支持上传一张图片</div>
            </div>
            
            <el-upload
              ref="bannerUploadRef"
              :auto-upload="false"
              :on-change="handleBannerChange"
              :on-remove="handleBannerRemove"
              :on-exceed="handleBannerExceed"
              :file-list="bannerFileList"
              list-type="picture-card"
              accept="image/*"
              :limit="1"
            >
              <el-icon><Plus /></el-icon>
            </el-upload>
            
            <el-empty v-if="bannerFileList.length === 0" description="暂无Banner图，请上传" />

            <!-- 图片裁剪对话框 -->
            <el-dialog
              v-model="bannerCropDialogVisible"
              title="裁剪图片"
              width="800px"
              :close-on-click-modal="false"
              append-to-body
              z-index="3000"
            >
              <div class="crop-container">
                <vue-picture-cropper
                  v-if="bannerCropImageSrc"
                  ref="bannerPictureCropperRef"
                  :boxStyle="{
                    width: '100%',
                    height: '400px',
                    backgroundColor: '#f8f8f8',
                    margin: 'auto'
                  }"
                  :img="bannerCropImageSrc"
                  :options="{
                    viewMode: 1,
                    dragMode: 'move',
                    aspectRatio: 16 / 9,
                    autoCropArea: 0.8,
                    restore: false,
                    guides: true,
                    center: true,
                    highlight: false,
                    cropBoxMovable: true,
                    cropBoxResizable: true,
                    toggleDragModeOnDblclick: false
                  }"
                  @ready="onBannerCropReady"
                  @crop="onBannerCrop"
                />
              </div>
              <template #footer>
                <span class="dialog-footer">
                  <el-button @click="cancelBannerCrop">取消</el-button>
                  <el-button type="primary" @click="confirmBannerCrop">确定</el-button>
                </span>
              </template>
            </el-dialog>
          </div>
        </el-tab-pane>
        
        <!-- 轮播图管理 -->
        <el-tab-pane label="轮播图管理" name="carousel">
          <div class="tab-content">
            <div class="section-header">
              <h3>轮播图列表</h3>
              <el-button type="primary" @click="handleCarouselAdd">
                <el-icon><Plus /></el-icon>
                添加轮播图
              </el-button>
            </div>
            
            <el-table :data="carouselList" border style="width: 100%">
              <el-table-column type="index" label="序号" width="60" />
              <el-table-column label="图片" width="150">
                <template #default="{ row }">
                  <el-image
                    :src="row.image"
                    :preview-src-list="[row.image]"
                    style="width: 120px; height: 80px;"
                    fit="cover"
                  />
                </template>
              </el-table-column>
              <el-table-column prop="title" label="标题" />
              <el-table-column prop="link" label="链接地址" />
              <el-table-column prop="sort" label="排序" width="100" />
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row, $index }">
                  <el-button
                    type="primary"
                    size="small"
                    @click="handleCarouselEdit(row, $index)"
                  >
                    编辑
                  </el-button>
                  <el-button
                    type="danger"
                    size="small"
                    @click="handleCarouselDelete($index)"
                  >
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>
        
        <!-- 新闻动态 -->
        <el-tab-pane label="新闻动态" name="news">
          <div class="tab-content">
            <div class="section-header">
              <h3>新闻列表</h3>
              <el-button type="primary" @click="handleArticleAdd">
                <el-icon><Plus /></el-icon>
                添加新闻
              </el-button>
            </div>
            
            <el-table :data="articleList" border style="width: 100%">
              <el-table-column type="index" label="序号" width="60" />
              <el-table-column prop="title" label="标题" min-width="200" />
              <el-table-column prop="author" label="作者" width="120" />
              <el-table-column label="标签" width="200">
                <template #default="{ row }">
                  <el-tag
                    v-for="tag in (row.tags || [])"
                    :key="tag"
                    size="small"
                    style="margin-right: 5px;"
                  >
                    {{ tag }}
                  </el-tag>
                  <span v-if="!row.tags || row.tags.length === 0" style="color: #909399;">无标签</span>
                </template>
              </el-table-column>
              <el-table-column prop="publishTime" label="发布时间" width="180" />
              <el-table-column label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="row.status === 'published' ? 'success' : 'info'">
                    {{ row.status === 'published' ? '已发布' : '草稿' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row, $index }">
                  <el-button type="primary" size="small" @click="handleArticleEdit(row, $index)">
                    编辑
                  </el-button>
                  <el-button type="danger" size="small" @click="handleArticleDelete($index)">
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
            
            <el-pagination
              v-model:current-page="articlePage"
              v-model:page-size="articlePageSize"
              :page-sizes="[10, 20, 50, 100]"
              :total="articleTotal"
              layout="total, sizes, prev, pager, next, jumper"
              style="margin-top: 20px; justify-content: flex-end;"
            />
          </div>
        </el-tab-pane>

   

        <!-- 参会公告 -->
        <el-tab-pane label="参会公告" name="announcement">
          <div class="tab-content">
            <div class="section-header">
              <h3>公告列表</h3>
              <el-button type="primary" @click="handleAnnouncementAdd">
                <el-icon><Plus /></el-icon>
                添加公告
              </el-button>
            </div>
            
            <el-table :data="announcementList" border style="width: 100%">
              <el-table-column type="index" label="序号" width="60" />
              <el-table-column prop="title" label="标题" />
              <el-table-column prop="content" label="内容" show-overflow-tooltip />
              <el-table-column prop="publishTime" label="发布时间" width="180" />
              <el-table-column label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="row.status === 'published' ? 'success' : 'info'">
                    {{ row.status === 'published' ? '已发布' : '草稿' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="200" fixed="right">
                <template #default="{ row, $index }">
                  <el-button
                    type="primary"
                    size="small"
                    @click="handleAnnouncementEdit(row, $index)"
                  >
                    编辑
                  </el-button>
                  <el-button
                    type="danger"
                    size="small"
                    @click="handleAnnouncementDelete($index)"
                  >
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
            
            <el-pagination
              v-model:current-page="announcementPage"
              v-model:page-size="announcementPageSize"
              :page-sizes="[10, 20, 50, 100]"
              :total="announcementTotal"
              layout="total, sizes, prev, pager, next, jumper"
              style="margin-top: 20px; justify-content: flex-end;"
            />
          </div>
        </el-tab-pane>

      
      </el-tabs>
    </el-card>

    <!-- 新闻编辑对话框 -->
    <el-dialog v-model="articleDialogVisible" :title="articleDialogTitle" width="1000px" :close-on-click-modal="false">
      <el-form :model="articleForm" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="articleForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="articleForm.author" placeholder="请输入作者" />
        </el-form-item>
        <el-form-item label="标签">
          <el-select
            v-model="articleForm.tags"
            multiple
            filterable
            allow-create
            default-first-option
            placeholder="请选择或输入标签"
            style="width: 100%;"
          >
            <el-option
              v-for="tag in availableTags"
              :key="tag"
              :label="tag"
              :value="tag"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="内容">
          <RichTextEditor v-model="articleForm.content" placeholder="请输入新闻内容，支持插入图片和视频" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="articleForm.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="articleDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleArticleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 轮播图编辑对话框 -->
    <el-dialog
      v-model="carouselDialogVisible"
      :title="carouselDialogTitle"
      width="800px"
    >
      <el-form :model="carouselForm" label-width="100px">
        <el-form-item label="图片">
          <el-upload
            ref="carouselUploadRef"
            :auto-upload="false"
            :on-change="handleCarouselImageChange"
            :on-remove="handleCarouselImageRemove"
            :file-list="carouselImageList"
            list-type="picture-card"
            accept="image/*"
            multiple
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
          <div class="upload-tip">支持多张图片上传，每张图片可单独配置标题、链接和排序</div>
        </el-form-item>
        <el-divider />
        <div v-if="carouselImageList.length > 0">
          <div
            v-for="(item, index) in carouselImageList"
            :key="index"
            class="carousel-item-config"
          >
            <el-card shadow="hover" style="margin-bottom: 15px;">
              <div class="item-header">
                <el-image
                  :src="item.url"
                  style="width: 120px; height: 80px; margin-right: 15px;"
                  fit="cover"
                />
                <div class="item-form" style="flex: 1;">
                  <el-form-item label="标题" style="margin-bottom: 15px;">
                    <el-input
                      v-model="item.title"
                      placeholder="请输入标题"
                      @input="updateCarouselItemConfig(index, 'title', $event)"
                    />
                  </el-form-item>
                  <el-form-item label="链接地址" style="margin-bottom: 15px;">
                    <el-input
                      v-model="item.link"
                      placeholder="请输入链接地址（可选）"
                      @input="updateCarouselItemConfig(index, 'link', $event)"
                    />
                  </el-form-item>
                  <el-form-item label="排序">
                    <el-input-number
                      v-model="item.sort"
                      :min="0"
                      @change="updateCarouselItemConfig(index, 'sort', $event)"
                    />
                  </el-form-item>
                </div>
              </div>
            </el-card>
          </div>
        </div>
      </el-form>
      <template #footer>
        <el-button @click="carouselDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleCarouselSubmit">确定</el-button>
      </template>
    </el-dialog>
    
    <!-- 公告编辑对话框 -->
    <el-dialog
      v-model="announcementDialogVisible"
      :title="announcementDialogTitle"
      width="1000px"
      :close-on-click-modal="false"
    >
      <el-form :model="announcementForm" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="announcementForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="内容">
          <RichTextEditor
            v-model="announcementForm.content"
            placeholder="请输入公告内容，支持插入图片和视频"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="announcementForm.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="announcementDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAnnouncementSubmit">确定</el-button>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Upload, Picture, Delete } from '@element-plus/icons-vue'
import VuePictureCropper, { cropper } from 'vue-picture-cropper'
import RichTextEditor from '@/components/RichTextEditor.vue'
import * as popularScienceApi from '@/services/popularScienceApi'
import 'cropperjs/dist/cropper.css'

// Tab切换
const activeTab = ref('banner')

// ========== Banner图管理 ==========
const bannerUploadRef = ref(null)
const bannerFileList = ref([])

// 裁剪相关
const bannerCropDialogVisible = ref(false)
const bannerCropImageSrc = ref('')
const bannerPendingFile = ref(null)
const bannerPictureCropperRef = ref(null)
const bannerCropperReady = ref(false)

// 构建完整的图片URL
const getBannerImageUrl = (imageUrl) => {
  if (!imageUrl) return ''
  // 如果是完整URL或base64，直接返回
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://') || imageUrl.startsWith('data:')) {
    return imageUrl
  }
  // 如果是相对路径，需要加上后端基础URL
  if (imageUrl.startsWith('/')) {
    return `http://localhost:8080${imageUrl}`
  }
  return `http://localhost:8080/${imageUrl}`
}

// 加载Banner图
const loadBanner = async () => {
  try {
    const response = await popularScienceApi.getBanner()
    if (response.success && response.data && response.data.imageUrl) {
      const imageUrl = response.data.imageUrl
      bannerFileList.value = [{
        uid: response.data.id || Date.now(),
        url: getBannerImageUrl(imageUrl),
        name: 'Banner图'
      }]
    } else {
      bannerFileList.value = []
    }
  } catch (error) {
    console.error('加载Banner图失败:', error)
    ElMessage.error('加载Banner图失败')
    bannerFileList.value = []
  }
}

const handleBannerChange = async (file, fileList) => {
  // 保存待处理的文件
  bannerPendingFile.value = file
  
  // 读取文件为base64，用于裁剪
  const reader = new FileReader()
  reader.onload = async (e) => {
    bannerCropImageSrc.value = e.target.result
    await nextTick()
    bannerCropDialogVisible.value = true
  }
  
  reader.onerror = () => {
    ElMessage.error('读取文件失败')
    if (bannerUploadRef.value) {
      bannerUploadRef.value.clearFiles()
    }
    bannerPendingFile.value = null
  }
  
  reader.readAsDataURL(file.raw)
}

// 裁剪器准备就绪
const onBannerCropReady = () => {
  bannerCropperReady.value = true
}

// 裁剪事件
const onBannerCrop = () => {
  // 实时裁剪预览（可选）
}

// 取消裁剪
const cancelBannerCrop = () => {
  bannerCropDialogVisible.value = false
  bannerCropImageSrc.value = ''
  bannerPendingFile.value = null
  bannerCropperReady.value = false
  // 清空上传组件的文件列表
  if (bannerUploadRef.value) {
    bannerUploadRef.value.clearFiles()
  }
}

// 确认裁剪并上传
const confirmBannerCrop = async () => {
  if (!bannerCropperReady.value || !cropper || !bannerPendingFile.value) {
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
    
    const croppedImageUrl = croppedCanvas.toDataURL('image/jpeg', 0.9)
    
    // 调用接口上传
    const response = await popularScienceApi.saveBanner(croppedImageUrl)
    
    if (response && response.success) {
      // 上传成功，更新文件列表
      const savedImageUrl = response.data?.imageUrl || croppedImageUrl
      bannerFileList.value = [{
        uid: response.data?.id || Date.now(),
        url: getBannerImageUrl(savedImageUrl),
        name: bannerPendingFile.value.name
      }]
      ElMessage.success('Banner图上传成功')
      
      // 关闭裁剪对话框
      bannerCropDialogVisible.value = false
      bannerCropImageSrc.value = ''
      bannerPendingFile.value = null
      bannerCropperReady.value = false
    } else {
      throw new Error(response?.message || '上传失败')
    }
  } catch (error) {
    console.error('上传Banner图失败:', error)
    ElMessage.error('上传Banner图失败: ' + (error.response?.data?.message || error.message || '未知错误'))
    // 上传失败，恢复之前的文件列表
    await loadBanner()
    if (bannerUploadRef.value) {
      bannerUploadRef.value.clearFiles()
    }
  }
}

const handleBannerExceed = () => {
  ElMessage.warning('Banner图只能上传一张，请先删除现有图片')
}

const handleBannerRemove = async () => {
  try {
    await ElMessageBox.confirm('确定要删除这张Banner图吗？', '提示', {
      type: 'warning'
    })
    
    // 执行后端删除操作
    const response = await popularScienceApi.deleteBanner()
    if (response.success) {
      // 删除成功后，清空文件列表
      bannerFileList.value = []
      if (bannerUploadRef.value) {
        bannerUploadRef.value.clearFiles()
      }
      ElMessage.success('删除成功')
    } else {
      ElMessage.error(response.message || '删除失败')
      // 删除失败，重新加载
      await loadBanner()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除Banner图失败:', error)
      ElMessage.error('删除Banner图失败')
      // 删除失败，重新加载
      await loadBanner()
    }
  }
}

// ========== 轮播图管理 ==========
const carouselList = ref([
  {
    id: 1,
    image: 'https://via.placeholder.com/800x400?text=轮播图1',
    title: '科普教育轮播图1',
    link: '/popular-science',
    sort: 1
  }
])

const carouselDialogVisible = ref(false)
const carouselDialogTitle = ref('添加轮播图')
const carouselUploadRef = ref(null)
const carouselImageList = ref([])

const handleCarouselAdd = () => {
  carouselDialogTitle.value = '添加轮播图'
  carouselImageList.value = []
  carouselDialogVisible.value = true
}

const handleCarouselEdit = (row, index) => {
  carouselDialogTitle.value = '编辑轮播图'
  carouselImageList.value = [{
    uid: row.id,
    url: row.image,
    title: row.title,
    link: row.link,
    sort: row.sort
  }]
  carouselDialogVisible.value = true
}

const handleCarouselImageChange = (file, fileList) => {
  // 读取新上传的图片
  const reader = new FileReader()
  reader.onload = (e) => {
    // 找到当前文件并更新
    const currentFile = fileList.find(f => f.uid === file.uid)
    if (currentFile) {
      currentFile.url = e.target.result
      // 初始化配置项
      if (!currentFile.title) currentFile.title = ''
      if (!currentFile.link) currentFile.link = ''
      if (currentFile.sort === undefined) {
        currentFile.sort = carouselImageList.value.length
      }
    }
    // 更新 carouselImageList
    carouselImageList.value = fileList.map(f => ({
      uid: f.uid,
      url: f.url || f.response?.url || '',
      name: f.name,
      raw: f.raw,
      title: f.title || '',
      link: f.link || '',
      sort: f.sort !== undefined ? f.sort : carouselImageList.value.length
    }))
  }
  reader.readAsDataURL(file.raw)
}

const handleCarouselImageRemove = (file, fileList) => {
  // 更新 carouselImageList
  carouselImageList.value = fileList.map(f => ({
    uid: f.uid,
    url: f.url || f.response?.url || '',
    name: f.name,
    raw: f.raw,
    title: f.title || '',
    link: f.link || '',
    sort: f.sort !== undefined ? f.sort : 0
  }))
}

const updateCarouselItemConfig = (index, field, value) => {
  if (carouselImageList.value[index]) {
    carouselImageList.value[index][field] = value
  }
}

const handleCarouselSubmit = () => {
  if (carouselImageList.value.length === 0) {
    ElMessage.warning('请至少上传一张图片')
    return
  }
  
  // 更新轮播图列表
  carouselList.value = carouselImageList.value.map((item, index) => ({
    id: item.uid || Date.now() + index,
    image: item.url,
    title: item.title || '',
    link: item.link || '',
    sort: item.sort !== undefined ? item.sort : index
  })).sort((a, b) => a.sort - b.sort)
  
  ElMessage.success('保存成功')
  carouselDialogVisible.value = false
}

const handleCarouselDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个轮播图吗？', '提示', {
    type: 'warning'
  }).then(() => {
    carouselList.value.splice(index, 1)
    ElMessage.success('删除成功')
  }).catch(() => {})
}

// ========== 参会公告管理 ==========
const announcementList = ref([
  {
    id: 1,
    title: '科普教育公告',
    content: '欢迎参加科普教育活动',
    publishTime: '2025-01-15 09:00:00',
    status: 'published'
  }
])

const announcementPage = ref(1)
const announcementPageSize = ref(10)
const announcementTotal = ref(1)

const announcementDialogVisible = ref(false)
const announcementDialogTitle = ref('添加公告')
const announcementForm = reactive({
  id: null,
  title: '',
  content: '',
  status: 'draft'
})
const announcementEditIndex = ref(-1)

const handleAnnouncementAdd = () => {
  announcementDialogTitle.value = '添加公告'
  announcementForm.id = null
  announcementForm.title = ''
  announcementForm.content = ''
  announcementForm.status = 'draft'
  announcementEditIndex.value = -1
  announcementDialogVisible.value = true
}

const handleAnnouncementEdit = (row, index) => {
  announcementDialogTitle.value = '编辑公告'
  announcementForm.id = row.id
  announcementForm.title = row.title
  announcementForm.content = row.content
  announcementForm.status = row.status
  announcementEditIndex.value = index
  announcementDialogVisible.value = true
}

const handleAnnouncementSubmit = () => {
  if (!announcementForm.title) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!announcementForm.content || announcementForm.content.trim() === '' || announcementForm.content === '<p><br></p>') {
    ElMessage.warning('请输入内容')
    return
  }
  
  const now = new Date().toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  }).replace(/\//g, '-')
  
  if (announcementEditIndex.value >= 0) {
    // 编辑
    announcementList.value[announcementEditIndex.value] = {
      ...announcementForm,
      publishTime: announcementList.value[announcementEditIndex.value].publishTime
    }
    ElMessage.success('编辑成功')
  } else {
    // 添加
    announcementList.value.push({
      ...announcementForm,
      id: Date.now(),
      publishTime: now
    })
    announcementTotal.value = announcementList.value.length
    ElMessage.success('添加成功')
  }
  announcementDialogVisible.value = false
}

const handleAnnouncementDelete = (index) => {
  ElMessageBox.confirm('确定要删除这条公告吗？', '提示', {
    type: 'warning'
  }).then(() => {
    announcementList.value.splice(index, 1)
    announcementTotal.value = announcementList.value.length
    ElMessage.success('删除成功')
  }).catch(() => {})
}

// ========== 新闻动态管理 ==========
const articleList = ref([
  {
    id: 1,
    title: '建筑节能科普知识',
    author: '管理员',
    publishTime: '2025-01-15 10:00:00',
    tags: ['节能', '科普'],
    content: '<p>建筑节能科普知识内容...</p>',
    status: 'published'
  }
])

const articlePage = ref(1)
const articlePageSize = ref(10)
const articleTotal = ref(1)

const availableTags = ref(['科普', '节能', '环保', '建筑', '技术'])

const articleDialogVisible = ref(false)
const articleDialogTitle = ref('添加新闻')
const articleForm = reactive({
  id: null,
  title: '',
  author: '',
  tags: [],
  content: '',
  status: 'draft'
})
const articleEditIndex = ref(-1)

const handleArticleAdd = () => {
  articleDialogTitle.value = '添加新闻'
  articleForm.id = null
  articleForm.title = ''
  articleForm.author = ''
  articleForm.tags = []
  articleForm.content = ''
  articleForm.status = 'draft'
  articleEditIndex.value = -1
  articleDialogVisible.value = true
}

const handleArticleEdit = (row, index) => {
  articleDialogTitle.value = '编辑新闻'
  articleForm.id = row.id
  articleForm.title = row.title
  articleForm.author = row.author
  articleForm.tags = [...(row.tags || [])]
  articleForm.content = row.content || ''
  articleForm.status = row.status
  articleEditIndex.value = index
  articleDialogVisible.value = true
}

const handleArticleSubmit = () => {
  if (!articleForm.title || !articleForm.title.trim()) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!articleForm.content || articleForm.content.trim() === '' || articleForm.content === '<p><br></p>') {
    ElMessage.warning('请输入内容')
    return
  }
  
  const now = new Date().toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  }).replace(/\//g, '-')
  
  if (articleEditIndex.value >= 0) {
    articleList.value[articleEditIndex.value] = {
      ...articleForm,
      publishTime: articleList.value[articleEditIndex.value].publishTime
    }
    ElMessage.success('编辑成功')
  } else {
    articleList.value.push({
      ...articleForm,
      id: Date.now(),
      publishTime: now
    })
    articleTotal.value = articleList.value.length
    ElMessage.success('添加成功')
  }
  articleDialogVisible.value = false
}

const handleArticleDelete = (index) => {
  ElMessageBox.confirm('确定要删除这篇文章吗？', '提示', { type: 'warning' })
    .then(() => {
      articleList.value.splice(index, 1)
      articleTotal.value = articleList.value.length
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

// 组件挂载时加载Banner图
onMounted(() => {
  loadBanner()
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

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
}

.banner-list {
  margin-top: 20px;
}

.banner-item {
  margin-bottom: 15px;
}

.banner-preview-item {
  display: flex;
  align-items: center;
  padding: 15px;
}

.banner-info {
  flex: 1;
  margin-left: 15px;
}

.banner-info p {
  margin: 5px 0;
  color: #606266;
}

.banner-actions {
  margin-left: 15px;
}

.upload-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 10px;
}

.carousel-item-config {
  margin-bottom: 15px;
}

.item-header {
  display: flex;
  align-items: flex-start;
}

.item-form {
  flex: 1;
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
