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

    <!-- 视频编辑对话框 -->
    <el-dialog v-model="videoDialogVisible" :title="videoDialogTitle" width="600px">
      <el-form :model="videoForm" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="videoForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="封面">
          <el-upload
            :auto-upload="false"
            :on-change="handleVideoCoverChange"
            :file-list="videoCoverFileList"
            list-type="picture-card"
            :limit="1"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="视频">
          <el-upload
            :auto-upload="false"
            :on-change="handleVideoFileChange"
            :file-list="videoFileFileList"
            :limit="1"
            accept="video/*"
            list-type="text"
          >
            <el-button type="primary">
              <el-icon><Upload /></el-icon>
              上传视频
            </el-button>
          </el-upload>
          <el-input
            v-model="videoForm.videoUrl"
            placeholder="或输入视频URL"
            style="margin-top: 10px;"
          />
        </el-form-item>
        <el-form-item label="时长">
          <el-input v-model="videoForm.duration" placeholder="例如：10:30" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="videoForm.description" type="textarea" :rows="3" placeholder="请输入视频描述" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="videoForm.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="videoDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleVideoSubmit">确定</el-button>
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

    <!-- 活动编辑对话框 -->
    <el-dialog v-model="activityDialogVisible" :title="activityDialogTitle" width="800px">
      <el-form :model="activityForm" label-width="100px">
        <el-form-item label="活动标题">
          <el-input v-model="activityForm.title" placeholder="请输入活动标题" />
        </el-form-item>
        <el-form-item label="封面">
          <el-upload
            :auto-upload="false"
            :on-change="handleActivityCoverChange"
            :file-list="activityCoverFileList"
            list-type="picture-card"
            :limit="1"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="地点">
          <el-input v-model="activityForm.location" placeholder="请输入活动地点" />
        </el-form-item>
        <el-form-item label="开始时间">
          <el-date-picker
            v-model="activityForm.startTime"
            type="datetime"
            placeholder="选择开始时间"
            style="width: 100%;"
          />
        </el-form-item>
        <el-form-item label="结束时间">
          <el-date-picker
            v-model="activityForm.endTime"
            type="datetime"
            placeholder="选择结束时间"
            style="width: 100%;"
          />
        </el-form-item>
        <el-form-item label="内容">
          <RichTextEditor v-model="activityForm.content" placeholder="请输入活动内容" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="activityForm.status">
            <el-radio label="draft">草稿</el-radio>
            <el-radio label="published">已发布</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="activityDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleActivitySubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Upload, Picture, Delete } from '@element-plus/icons-vue'
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

// ========== 科普视频管理 ==========
const videoList = ref([
  {
    id: 1,
    title: '建筑节能技术科普视频',
    cover: 'https://via.placeholder.com/400x300?text=视频封面',
    videoUrl: '/uploads/videos/video1.mp4',
    duration: '10:30',
    description: '介绍建筑节能技术的科普视频',
    publishTime: '2025-01-15 10:00:00',
    status: 'published'
  }
])

const videoPage = ref(1)
const videoPageSize = ref(10)
const videoTotal = ref(1)

const videoDialogVisible = ref(false)
const videoDialogTitle = ref('添加视频')
const videoForm = reactive({
  id: null,
  title: '',
  cover: '',
  videoUrl: '',
  duration: '',
  description: '',
  status: 'draft'
})
const videoCoverFileList = ref([])
const videoFileFileList = ref([])
const videoEditIndex = ref(-1)

const handleVideoAdd = () => {
  videoDialogTitle.value = '添加视频'
  videoForm.id = null
  videoForm.title = ''
  videoForm.cover = ''
  videoForm.videoUrl = ''
  videoForm.duration = ''
  videoForm.description = ''
  videoForm.status = 'draft'
  videoCoverFileList.value = []
  videoFileFileList.value = []
  videoEditIndex.value = -1
  videoDialogVisible.value = true
}

const handleVideoEdit = (row, index) => {
  videoDialogTitle.value = '编辑视频'
  videoForm.id = row.id
  videoForm.title = row.title
  videoForm.cover = row.cover
  videoForm.videoUrl = row.videoUrl
  videoForm.duration = row.duration
  videoForm.description = row.description || ''
  videoForm.status = row.status
  videoCoverFileList.value = row.cover ? [{ url: row.cover }] : []
  videoFileFileList.value = []
  videoEditIndex.value = index
  videoDialogVisible.value = true
}

const handleVideoCoverChange = (file) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    videoForm.cover = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

const handleVideoFileChange = (file) => {
  const maxSize = 200 * 1024 * 1024
  if (file.size > maxSize) {
    ElMessage.warning('视频文件大小不能超过200MB')
    return false
  }
  const reader = new FileReader()
  reader.onload = (e) => {
    videoForm.videoUrl = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

const handleVideoSubmit = () => {
  if (!videoForm.title || !videoForm.title.trim()) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!videoForm.videoUrl || !videoForm.videoUrl.trim()) {
    ElMessage.warning('请上传视频或输入视频URL')
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
  
  if (videoEditIndex.value >= 0) {
    videoList.value[videoEditIndex.value] = {
      ...videoForm,
      publishTime: videoList.value[videoEditIndex.value].publishTime
    }
    ElMessage.success('编辑成功')
  } else {
    videoList.value.push({
      ...videoForm,
      id: Date.now(),
      publishTime: now
    })
    videoTotal.value = videoList.value.length
    ElMessage.success('添加成功')
  }
  videoDialogVisible.value = false
}

const handleVideoDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个视频吗？', '提示', { type: 'warning' })
    .then(() => {
      videoList.value.splice(index, 1)
      videoTotal.value = videoList.value.length
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

// ========== 科普活动管理 ==========
const activityList = ref([
  {
    id: 1,
    title: '建筑节能科普讲座',
    cover: 'https://via.placeholder.com/400x300?text=活动封面',
    location: '学术报告厅',
    startTime: '2025-02-01 14:00:00',
    endTime: '2025-02-01 16:00:00',
    content: '<p>活动内容...</p>',
    status: 'published'
  }
])

const activityPage = ref(1)
const activityPageSize = ref(10)
const activityTotal = ref(1)

const activityDialogVisible = ref(false)
const activityDialogTitle = ref('添加活动')
const activityForm = reactive({
  id: null,
  title: '',
  cover: '',
  location: '',
  startTime: '',
  endTime: '',
  content: '',
  status: 'draft'
})
const activityCoverFileList = ref([])
const activityEditIndex = ref(-1)

const handleActivityAdd = () => {
  activityDialogTitle.value = '添加活动'
  activityForm.id = null
  activityForm.title = ''
  activityForm.cover = ''
  activityForm.location = ''
  activityForm.startTime = ''
  activityForm.endTime = ''
  activityForm.content = ''
  activityForm.status = 'draft'
  activityCoverFileList.value = []
  activityEditIndex.value = -1
  activityDialogVisible.value = true
}

const handleActivityEdit = (row, index) => {
  activityDialogTitle.value = '编辑活动'
  activityForm.id = row.id
  activityForm.title = row.title
  activityForm.cover = row.cover
  activityForm.location = row.location
  activityForm.startTime = row.startTime
  activityForm.endTime = row.endTime
  activityForm.content = row.content || ''
  activityForm.status = row.status
  activityCoverFileList.value = row.cover ? [{ url: row.cover }] : []
  activityEditIndex.value = index
  activityDialogVisible.value = true
}

const handleActivityCoverChange = (file) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    activityForm.cover = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

const handleActivitySubmit = () => {
  if (!activityForm.title || !activityForm.title.trim()) {
    ElMessage.warning('请输入活动标题')
    return
  }
  if (!activityForm.startTime || !activityForm.endTime) {
    ElMessage.warning('请选择活动时间')
    return
  }
  
  if (activityEditIndex.value >= 0) {
    activityList.value[activityEditIndex.value] = { ...activityForm }
    ElMessage.success('编辑成功')
  } else {
    activityList.value.push({
      ...activityForm,
      id: Date.now()
    })
    activityTotal.value = activityList.value.length
    ElMessage.success('添加成功')
  }
  activityDialogVisible.value = false
}

const handleActivityDelete = (index) => {
  ElMessageBox.confirm('确定要删除这个活动吗？', '提示', { type: 'warning' })
    .then(() => {
      activityList.value.splice(index, 1)
      activityTotal.value = activityList.value.length
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const getActivityStatusTag = (activity) => {
  const now = new Date()
  const start = new Date(activity.startTime)
  const end = new Date(activity.endTime)
  
  if (now < start) return 'info' // 未开始
  if (now >= start && now <= end) return 'success' // 进行中
  return '' // 已结束
}

const getActivityStatusText = (activity) => {
  const now = new Date()
  const start = new Date(activity.startTime)
  const end = new Date(activity.endTime)
  
  if (now < start) return '未开始'
  if (now >= start && now <= end) return '进行中'
  return '已结束'
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
</style>
