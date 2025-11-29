<template>
  <div class="admin-home">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>首页管理</h2>
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
            
            <div v-if="bannerList.length > 0" class="banner-list">
              <div
                v-for="(banner, index) in bannerList"
                :key="index"
                class="banner-item"
              >
                <el-card shadow="hover">
                  <div class="banner-preview-item">
                    <el-image
                      :src="banner.url"
                      style="width: 200px; height: 120px; margin-right: 15px;"
                      fit="cover"
                      :preview-src-list="bannerList.map(b => b.url)"
                    />
                    <div class="banner-info">
                      <p><strong>文件名：</strong>{{ banner.name }}</p>
                      <p><strong>大小：</strong>{{ formatFileSize(banner.size) }}</p>
                    </div>
                    <div class="banner-actions">
                      <el-button
                        type="danger"
                        @click="handleBannerDelete(index)"
                      >
                        <el-icon><Delete /></el-icon>
                        删除
                      </el-button>
                    </div>
                  </div>
                </el-card>
              </div>
            </div>
            
            <el-empty v-if="bannerList.length === 0" description="暂无Banner图，请上传" />
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
        
        <!-- 新闻列表管理 -->
        <el-tab-pane label="新闻列表管理" name="news">
          <div class="tab-content">
            <div class="section-header">
              <h3>新闻列表</h3>
              <el-button type="primary" @click="handleNewsAdd">
                <el-icon><Plus /></el-icon>
                添加新闻
              </el-button>
            </div>
            
            <el-table :data="newsList" border style="width: 100%">
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
                  <el-button
                    type="primary"
                    size="small"
                    @click="handleNewsEdit(row, $index)"
                  >
                    编辑
                  </el-button>
                  <el-button
                    type="danger"
                    size="small"
                    @click="handleNewsDelete($index)"
                  >
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
            
            <el-pagination
              v-model:current-page="newsPage"
              v-model:page-size="newsPageSize"
              :page-sizes="[10, 20, 50, 100]"
              :total="newsTotal"
              layout="total, sizes, prev, pager, next, jumper"
              style="margin-top: 20px; justify-content: flex-end;"
            />
          </div>
        </el-tab-pane>
        
        <!-- 公告管理 -->
        <el-tab-pane label="公告管理" name="announcement">
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
    
    <!-- 新闻编辑对话框 -->
    <el-dialog
      v-model="newsDialogVisible"
      :title="newsDialogTitle"
      width="1000px"
      :close-on-click-modal="false"
    >
      <el-form :model="newsForm" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="newsForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="newsForm.author" placeholder="请输入作者" />
        </el-form-item>
        <el-form-item label="标签">
          <el-select
            v-model="newsForm.tags"
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
          <RichTextEditor
            v-model="newsForm.content"
            placeholder="请输入新闻内容，支持插入图片和视频"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="newsForm.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="newsDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleNewsSubmit">确定</el-button>
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
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Upload,
  Plus,
  Delete,
  Edit
} from '@element-plus/icons-vue'
import RichTextEditor from '@/components/RichTextEditor.vue'

// Tab切换
const activeTab = ref('banner')

// ========== Banner图管理 ==========
const bannerUploadRef = ref(null)
const bannerFileList = ref([])
const bannerList = ref([])

const handleBannerChange = (file, fileList) => {
  // 如果已经有图片了，不允许再上传
  if (bannerList.value.length >= 1 && !bannerList.value.some(b => b.uid === file.uid)) {
    ElMessage.warning('Banner图只能上传一张，请先删除现有图片')
    // 移除新添加的文件
    const index = fileList.findIndex(f => f.uid === file.uid)
    if (index >= 0) {
      fileList.splice(index, 1)
      bannerFileList.value = fileList
    }
    return
  }
  
  // 读取新上传的图片
  const reader = new FileReader()
  reader.onload = (e) => {
    // 检查是否已存在相同的文件
    const exists = bannerList.value.some(b => b.uid === file.uid)
    if (!exists) {
      // 如果已经有图片，先清空
      if (bannerList.value.length >= 1) {
        bannerList.value = []
        bannerFileList.value = []
      }
      
      bannerList.value.push({
        uid: file.uid,
        url: e.target.result,
        name: file.name,
        size: file.size,
        raw: file.raw
      })
      ElMessage.success(`Banner图 "${file.name}" 上传成功`)
    }
  }
  reader.readAsDataURL(file.raw)
  
  // 更新文件列表
  bannerFileList.value = fileList
}

const handleBannerExceed = () => {
  ElMessage.warning('Banner图只能上传一张，请先删除现有图片')
}

const handleBannerRemove = (file, fileList) => {
  // 从bannerList中移除
  const index = bannerList.value.findIndex(b => b.uid === file.uid)
  if (index >= 0) {
    bannerList.value.splice(index, 1)
  }
  // 更新文件列表
  bannerFileList.value = fileList
  ElMessage.success('Banner图已删除')
}

const handleBannerDelete = (index) => {
  ElMessageBox.confirm('确定要删除这张Banner图吗？', '提示', {
    type: 'warning'
  }).then(() => {
    const banner = bannerList.value[index]
    // 从bannerList中移除
    bannerList.value.splice(index, 1)
    // 从文件列表中移除
    const fileIndex = bannerFileList.value.findIndex(f => f.uid === banner.uid)
    if (fileIndex >= 0) {
      bannerFileList.value.splice(fileIndex, 1)
    }
    ElMessage.success('删除成功')
  }).catch(() => {})
}

const formatFileSize = (bytes) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

// ========== 轮播图管理 ==========
const carouselList = ref([
  {
    id: 1,
    image: 'https://via.placeholder.com/800x400?text=轮播图1',
    title: '轮播图标题1',
    link: 'https://example.com',
    sort: 1
  },
  {
    id: 2,
    image: 'https://via.placeholder.com/800x400?text=轮播图2',
    title: '轮播图标题2',
    link: '',
    sort: 2
  }
])

const carouselDialogVisible = ref(false)
const carouselDialogTitle = ref('添加轮播图')
const carouselUploadRef = ref(null)
const carouselForm = reactive({
  id: null,
  image: '',
  title: '',
  link: '',
  sort: 0
})
const carouselImageList = ref([])
const carouselEditIndex = ref(-1)

const handleCarouselAdd = () => {
  carouselDialogTitle.value = '添加轮播图'
  carouselForm.id = null
  carouselForm.image = ''
  carouselForm.title = ''
  carouselForm.link = ''
  carouselForm.sort = carouselList.value.length + 1
  carouselImageList.value = []
  carouselEditIndex.value = -1
  // 清空上传组件的文件列表
  if (carouselUploadRef.value) {
    carouselUploadRef.value.clearFiles()
  }
  carouselDialogVisible.value = true
}

const handleCarouselEdit = (row, index) => {
  carouselDialogTitle.value = '编辑轮播图'
  carouselForm.id = row.id
  carouselForm.image = row.image
  carouselForm.title = row.title
  carouselForm.link = row.link
  carouselForm.sort = row.sort
  carouselImageList.value = row.image ? [{
    url: row.image,
    name: `image-${row.id}`,
    title: row.title || '',
    link: row.link || '',
    sort: row.sort || 0
  }] : []
  carouselEditIndex.value = index
  // 清空上传组件的文件列表
  if (carouselUploadRef.value) {
    carouselUploadRef.value.clearFiles()
  }
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
  
  // 验证所有图片是否都有标题
  const hasEmptyTitle = carouselImageList.value.some(item => !item.title || item.title.trim() === '')
  if (hasEmptyTitle) {
    ElMessage.warning('请为所有图片填写标题')
    return
  }
  
  if (carouselEditIndex.value >= 0) {
    // 编辑单条轮播图
    const firstImage = carouselImageList.value[0]
    carouselList.value[carouselEditIndex.value] = {
      id: carouselForm.id || Date.now(),
      image: firstImage.url,
      title: firstImage.title,
      link: firstImage.link || '',
      sort: firstImage.sort || 0
    }
    ElMessage.success('编辑成功')
  } else {
    // 添加多条轮播图（支持批量添加）
    const newItems = carouselImageList.value.map((item, index) => ({
      id: Date.now() + index,
      image: item.url,
      title: item.title,
      link: item.link || '',
      sort: item.sort !== undefined ? item.sort : (carouselList.value.length + index + 1)
    }))
    carouselList.value.push(...newItems)
    // 按排序字段排序
    carouselList.value.sort((a, b) => a.sort - b.sort)
    ElMessage.success(`成功添加 ${newItems.length} 张轮播图`)
  }
  carouselDialogVisible.value = false
}

const handleCarouselDelete = (index) => {
  ElMessageBox.confirm('确定要删除这条轮播图吗？', '提示', {
    type: 'warning'
  }).then(() => {
    carouselList.value.splice(index, 1)
    ElMessage.success('删除成功')
  }).catch(() => {})
}

// ========== 新闻列表管理 ==========
const newsList = ref([
  {
    id: 1,
    title: '新闻标题1',
    author: '管理员',
    content: '<p>这是新闻内容1</p>',
    tags: ['重要', '通知'],
    publishTime: '2025-01-15 10:00:00',
    status: 'published'
  },
  {
    id: 2,
    title: '新闻标题2',
    author: '管理员',
    content: '<p>这是新闻内容2</p>',
    tags: ['公告'],
    publishTime: '2025-01-14 15:30:00',
    status: 'draft'
  }
])

const newsPage = ref(1)
const newsPageSize = ref(10)
const newsTotal = ref(2)

// 可用标签列表（从所有新闻中提取，也可以单独维护）
const availableTags = ref(['重要', '通知', '公告', '活动', '新闻', '更新'])

const newsDialogVisible = ref(false)
const newsDialogTitle = ref('添加新闻')
const newsForm = reactive({
  id: null,
  title: '',
  author: '',
  content: '',
  tags: [],
  status: 'draft'
})
const newsEditIndex = ref(-1)

const handleNewsAdd = () => {
  newsDialogTitle.value = '添加新闻'
  newsForm.id = null
  newsForm.title = ''
  newsForm.author = ''
  newsForm.content = ''
  newsForm.tags = []
  newsForm.status = 'draft'
  newsEditIndex.value = -1
  newsDialogVisible.value = true
}

const handleNewsEdit = (row, index) => {
  newsDialogTitle.value = '编辑新闻'
  newsForm.id = row.id
  newsForm.title = row.title
  newsForm.author = row.author
  newsForm.content = row.content || ''
  newsForm.tags = row.tags ? [...row.tags] : []
  newsForm.status = row.status
  newsEditIndex.value = index
  newsDialogVisible.value = true
}

const handleNewsSubmit = () => {
  if (!newsForm.title) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!newsForm.content || newsForm.content.trim() === '' || newsForm.content === '<p><br></p>') {
    ElMessage.warning('请输入内容')
    return
  }
  
  // 更新可用标签列表（添加新标签）
  newsForm.tags.forEach(tag => {
    if (!availableTags.value.includes(tag)) {
      availableTags.value.push(tag)
    }
  })
  
  const now = new Date().toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  }).replace(/\//g, '-')
  
  if (newsEditIndex.value >= 0) {
    // 编辑
    newsList.value[newsEditIndex.value] = {
      ...newsForm,
      tags: [...newsForm.tags],
      publishTime: newsList.value[newsEditIndex.value].publishTime
    }
    ElMessage.success('编辑成功')
  } else {
    // 添加
    newsList.value.push({
      ...newsForm,
      id: Date.now(),
      tags: [...newsForm.tags],
      publishTime: now
    })
    newsTotal.value = newsList.value.length
    ElMessage.success('添加成功')
  }
  newsDialogVisible.value = false
}

const handleNewsDelete = (index) => {
  ElMessageBox.confirm('确定要删除这条新闻吗？', '提示', {
    type: 'warning'
  }).then(() => {
    newsList.value.splice(index, 1)
    newsTotal.value = newsList.value.length
    ElMessage.success('删除成功')
  }).catch(() => {})
}

// ========== 公告管理 ==========
const announcementList = ref([
  {
    id: 1,
    title: '系统维护公告',
    content: '系统将于今晚进行维护，预计维护时间2小时',
    publishTime: '2025-01-15 09:00:00',
    status: 'published'
  },
  {
    id: 2,
    title: '春节放假通知',
    content: '春节期间系统正常开放，祝大家春节快乐',
    publishTime: '2025-01-14 14:00:00',
    status: 'published'
  }
])

const announcementPage = ref(1)
const announcementPageSize = ref(10)
const announcementTotal = ref(2)

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
</script>

<style scoped>
.admin-home {
  padding: 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
  font-size: 20px;
  font-weight: bold;
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

.banner-preview {
  margin-top: 20px;
}

.preview-wrapper {
  position: relative;
  max-width: 800px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
}

.preview-wrapper img {
  width: 100%;
  height: auto;
  display: block;
}

.preview-actions {
  position: absolute;
  top: 10px;
  right: 10px;
  display: flex;
  gap: 10px;
}

.upload-tip {
  color: #909399;
  font-size: 12px;
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
}

.banner-info {
  flex: 1;
  margin-left: 15px;
}

.banner-info p {
  margin: 8px 0;
  color: #606266;
}

.banner-actions {
  margin-left: 15px;
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
</style>
