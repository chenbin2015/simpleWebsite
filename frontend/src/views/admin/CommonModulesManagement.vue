<template>
  <div class="admin-page">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h2>通用模块管理</h2>
        </div>
      </template>
      
      <el-tabs v-model="activeTab" type="card">
        <!-- 实验教学 -->
        <el-tab-pane label="实验教学" name="experiment-teaching">
          <div class="tab-content">
            <div class="management-layout">
              <!-- 左侧菜单列表 -->
              <div class="menu-sidebar">
                <el-card shadow="hover">
                  <template #header>
                    <div class="sidebar-header">
                      <h3>菜单列表</h3>
                      <div class="header-actions">
                        <el-button type="info" size="small" @click="handleOpenBannerDialog('experiment-teaching')">
                          <el-icon><Picture /></el-icon>
                          Banner管理
                        </el-button>
                        <el-button type="primary" size="small" @click="handleAddMenu('experiment-teaching')">
                          <el-icon><Plus /></el-icon>
                          添加菜单
                        </el-button>
                      </div>
                    </div>
                  </template>
                  <div class="menu-list">
                    <div
                      v-for="menu in menuList.experimentTeaching"
                      :key="menu.id"
                      class="menu-item"
                      :class="{ active: selectedMenu?.id === menu.id }"
                      @click="handleSelectMenu(menu)"
                    >
                      <div class="menu-info">
                        <el-icon class="menu-icon">
                          <component :is="getIconComponent(menu.icon)" />
                        </el-icon>
                        <div class="menu-details">
                          <div class="menu-name">{{ menu.name }}</div>
                          <el-tag size="small" :type="getPageTypeTag(menu.pageType)">
                            {{ getPageTypeName(menu.pageType) }}
                          </el-tag>
                        </div>
                      </div>
                      <div class="menu-actions">
                        <el-button type="primary" size="small" text @click.stop="handleEditMenu(menu)">
                          编辑
                        </el-button>
                        <el-button type="danger" size="small" text @click.stop="handleDeleteMenu(menu)">
                          删除
                        </el-button>
                      </div>
                    </div>
                    <el-empty v-if="menuList.experimentTeaching.length === 0" description="暂无菜单" :image-size="80" />
                  </div>
                </el-card>
              </div>

              <!-- 右侧内容管理 -->
              <div class="content-area">
                <div v-if="!selectedMenu" class="empty-selection">
                  <el-empty description="请从左侧选择一个菜单项进行管理" />
                </div>
                <div v-else>
                  <!-- 根据页面类型动态渲染不同的内容管理组件 -->
                  <NewsListManagement
                    v-if="selectedMenu.pageType === 'news-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ProductListManagement
                    v-else-if="selectedMenu.pageType === 'product-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ImageTextManagement
                    v-else-if="selectedMenu.pageType === 'image-text'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <DownloadListManagement
                    v-else-if="selectedMenu.pageType === 'download-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>

        <!-- 实验资源 -->
        <el-tab-pane label="实验资源" name="experiment-resources">
          <div class="tab-content">
            <div class="management-layout">
              <div class="menu-sidebar">
                <el-card shadow="hover">
                  <template #header>
                    <div class="sidebar-header">
                      <h3>菜单列表</h3>
                      <div class="header-actions">
                        <el-button type="info" size="small" @click="handleOpenBannerDialog('experiment-resources')">
                          <el-icon><Picture /></el-icon>
                          Banner管理
                        </el-button>
                        <el-button type="primary" size="small" @click="handleAddMenu('experiment-resources')">
                          <el-icon><Plus /></el-icon>
                          添加菜单
                        </el-button>
                      </div>
                    </div>
                  </template>
                  <div class="menu-list">
                    <div
                      v-for="menu in menuList.experimentResources"
                      :key="menu.id"
                      class="menu-item"
                      :class="{ active: selectedMenu?.id === menu.id }"
                      @click="handleSelectMenu(menu)"
                    >
                      <div class="menu-info">
                        <el-icon class="menu-icon">
                          <component :is="getIconComponent(menu.icon)" />
                        </el-icon>
                        <div class="menu-details">
                          <div class="menu-name">{{ menu.name }}</div>
                          <el-tag size="small" :type="getPageTypeTag(menu.pageType)">
                            {{ getPageTypeName(menu.pageType) }}
                          </el-tag>
                        </div>
                      </div>
                      <div class="menu-actions">
                        <el-button type="primary" size="small" text @click.stop="handleEditMenu(menu)">
                          编辑
                        </el-button>
                        <el-button type="danger" size="small" text @click.stop="handleDeleteMenu(menu)">
                          删除
                        </el-button>
                      </div>
                    </div>
                    <el-empty v-if="menuList.experimentResources.length === 0" description="暂无菜单" :image-size="80" />
                  </div>
                </el-card>
              </div>
              <div class="content-area">
                <div v-if="!selectedMenu" class="empty-selection">
                  <el-empty description="请从左侧选择一个菜单项进行管理" />
                </div>
                <div v-else>
                  <NewsListManagement
                    v-if="selectedMenu.pageType === 'news-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ProductListManagement
                    v-else-if="selectedMenu.pageType === 'product-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ImageTextManagement
                    v-else-if="selectedMenu.pageType === 'image-text'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <DownloadListManagement
                    v-else-if="selectedMenu.pageType === 'download-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>

        <!-- 建设成效 -->
        <el-tab-pane label="建设成效" name="construction-results">
          <div class="tab-content">
            <div class="management-layout">
              <div class="menu-sidebar">
                <el-card shadow="hover">
                  <template #header>
                    <div class="sidebar-header">
                      <h3>菜单列表</h3>
                      <div class="header-actions">
                        <el-button type="info" size="small" @click="handleOpenBannerDialog('construction-results')">
                          <el-icon><Picture /></el-icon>
                          Banner管理
                        </el-button>
                        <el-button type="primary" size="small" @click="handleAddMenu('construction-results')">
                          <el-icon><Plus /></el-icon>
                          添加菜单
                        </el-button>
                      </div>
                    </div>
                  </template>
                  <div class="menu-list">
                    <div
                      v-for="menu in menuList.constructionResults"
                      :key="menu.id"
                      class="menu-item"
                      :class="{ active: selectedMenu?.id === menu.id }"
                      @click="handleSelectMenu(menu)"
                    >
                      <div class="menu-info">
                        <el-icon class="menu-icon">
                          <component :is="getIconComponent(menu.icon)" />
                        </el-icon>
                        <div class="menu-details">
                          <div class="menu-name">{{ menu.name }}</div>
                          <el-tag size="small" :type="getPageTypeTag(menu.pageType)">
                            {{ getPageTypeName(menu.pageType) }}
                          </el-tag>
                        </div>
                      </div>
                      <div class="menu-actions">
                        <el-button type="primary" size="small" text @click.stop="handleEditMenu(menu)">
                          编辑
                        </el-button>
                        <el-button type="danger" size="small" text @click.stop="handleDeleteMenu(menu)">
                          删除
                        </el-button>
                      </div>
                    </div>
                    <el-empty v-if="menuList.constructionResults.length === 0" description="暂无菜单" :image-size="80" />
                  </div>
                </el-card>
              </div>
              <div class="content-area">
                <div v-if="!selectedMenu" class="empty-selection">
                  <el-empty description="请从左侧选择一个菜单项进行管理" />
                </div>
                <div v-else>
                  <NewsListManagement
                    v-if="selectedMenu.pageType === 'news-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ProductListManagement
                    v-else-if="selectedMenu.pageType === 'product-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ImageTextManagement
                    v-else-if="selectedMenu.pageType === 'image-text'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <DownloadListManagement
                    v-else-if="selectedMenu.pageType === 'download-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>

        <!-- 安全管理 -->
        <el-tab-pane label="安全管理" name="safety-management">
          <div class="tab-content">
            <div class="management-layout">
              <div class="menu-sidebar">
                <el-card shadow="hover">
                  <template #header>
                    <div class="sidebar-header">
                      <h3>菜单列表</h3>
                      <div class="header-actions">
                        <el-button type="info" size="small" @click="handleOpenBannerDialog('safety-management')">
                          <el-icon><Picture /></el-icon>
                          Banner管理
                        </el-button>
                        <el-button type="primary" size="small" @click="handleAddMenu('safety-management')">
                          <el-icon><Plus /></el-icon>
                          添加菜单
                        </el-button>
                      </div>
                    </div>
                  </template>
                  <div class="menu-list">
                    <div
                      v-for="menu in menuList.safetyManagement"
                      :key="menu.id"
                      class="menu-item"
                      :class="{ active: selectedMenu?.id === menu.id }"
                      @click="handleSelectMenu(menu)"
                    >
                      <div class="menu-info">
                        <el-icon class="menu-icon">
                          <component :is="getIconComponent(menu.icon)" />
                        </el-icon>
                        <div class="menu-details">
                          <div class="menu-name">{{ menu.name }}</div>
                          <el-tag size="small" :type="getPageTypeTag(menu.pageType)">
                            {{ getPageTypeName(menu.pageType) }}
                          </el-tag>
                        </div>
                      </div>
                      <div class="menu-actions">
                        <el-button type="primary" size="small" text @click.stop="handleEditMenu(menu)">
                          编辑
                        </el-button>
                        <el-button type="danger" size="small" text @click.stop="handleDeleteMenu(menu)">
                          删除
                        </el-button>
                      </div>
                    </div>
                    <el-empty v-if="menuList.safetyManagement.length === 0" description="暂无菜单" :image-size="80" />
                  </div>
                </el-card>
              </div>
              <div class="content-area">
                <div v-if="!selectedMenu" class="empty-selection">
                  <el-empty description="请从左侧选择一个菜单项进行管理" />
                </div>
                <div v-else>
                  <NewsListManagement
                    v-if="selectedMenu.pageType === 'news-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ProductListManagement
                    v-else-if="selectedMenu.pageType === 'product-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <ImageTextManagement
                    v-else-if="selectedMenu.pageType === 'image-text'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                  <DownloadListManagement
                    v-else-if="selectedMenu.pageType === 'download-list'"
                    :menu="selectedMenu"
                    @update="handleContentUpdate"
                  />
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <!-- Banner管理对话框 -->
    <el-dialog
      v-model="bannerDialogVisible"
      :title="bannerDialogTitle"
      width="1000px"
      :close-on-click-modal="false"
    >
      <BannerManagement
        v-model="currentBannerData"
        @save="handleBannerSave"
      />
    </el-dialog>

    <!-- 菜单编辑对话框 -->
    <el-dialog v-model="menuDialogVisible" :title="menuDialogTitle" width="500px">
      <el-form :model="menuForm" label-width="100px">
        <el-form-item label="菜单名称">
          <el-input v-model="menuForm.name" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="图标">
          <el-select v-model="menuForm.icon" placeholder="请选择图标" style="width: 100%;">
            <el-option
              v-for="icon in availableIcons"
              :key="icon.value"
              :label="icon.label"
              :value="icon.value"
            >
              <el-icon><component :is="getIconComponent(icon.value)" /></el-icon>
              <span style="margin-left: 8px;">{{ icon.label }}</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="页面类型">
          <el-select v-model="menuForm.pageType" placeholder="请选择页面类型" style="width: 100%;">
            <el-option label="新闻列表" value="news-list" />
            <el-option label="产品列表" value="product-list" />
            <el-option label="图文" value="image-text" />
            <el-option label="下载列表" value="download-list" />
          </el-select>
        </el-form-item>
        <el-form-item label="内容ID">
          <el-input v-model="menuForm.contentId" placeholder="请输入内容ID" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="menuDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleMenuSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Picture } from '@element-plus/icons-vue'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import { menuGroups } from '@/config/menuConfig'
import NewsListManagement from '@/components/admin/NewsListManagement.vue'
import ProductListManagement from '@/components/admin/ProductListManagement.vue'
import ImageTextManagement from '@/components/admin/ImageTextManagement.vue'
import DownloadListManagement from '@/components/admin/DownloadListManagement.vue'
import BannerManagement from '@/components/admin/BannerManagement.vue'

// Tab切换
const activeTab = ref('experiment-teaching')
const selectedMenu = ref(null)

// Banner数据管理
const bannerData = reactive({
  experimentTeaching: {
    type: 'image',
    imageUrl: '',
    videoUrl: '',
    videoUrlExternal: ''
  },
  experimentResources: {
    type: 'image',
    imageUrl: '',
    videoUrl: '',
    videoUrlExternal: ''
  },
  constructionResults: {
    type: 'image',
    imageUrl: '',
    videoUrl: '',
    videoUrlExternal: ''
  },
  safetyManagement: {
    type: 'image',
    imageUrl: '',
    videoUrl: '',
    videoUrlExternal: ''
  }
})

// Banner对话框
const bannerDialogVisible = ref(false)
const bannerDialogTitle = ref('Banner管理')
const currentBannerCategory = ref('')
const currentBannerData = ref({
  type: 'image',
  imageUrl: '',
  videoUrl: '',
  videoUrlExternal: ''
})

// 打开Banner管理对话框
const handleOpenBannerDialog = (category) => {
  const categoryNames = {
    'experiment-teaching': '实验教学',
    'experiment-resources': '实验资源',
    'construction-results': '建设成效',
    'safety-management': '安全管理'
  }
  bannerDialogTitle.value = `${categoryNames[category]} - Banner管理`
  currentBannerCategory.value = category
  
  // 根据分类获取对应的Banner数据
  const categoryKeyMap = {
    'experiment-teaching': 'experimentTeaching',
    'experiment-resources': 'experimentResources',
    'construction-results': 'constructionResults',
    'safety-management': 'safetyManagement'
  }
  const dataKey = categoryKeyMap[category]
  currentBannerData.value = { ...bannerData[dataKey] }
  
  bannerDialogVisible.value = true
}

// Banner保存处理
const handleBannerSave = (data) => {
  const categoryKeyMap = {
    'experiment-teaching': 'experimentTeaching',
    'experiment-resources': 'experimentResources',
    'construction-results': 'constructionResults',
    'safety-management': 'safetyManagement'
  }
  const dataKey = categoryKeyMap[currentBannerCategory.value]
  if (dataKey) {
    Object.assign(bannerData[dataKey], data)
    console.log(`保存${currentBannerCategory.value}的Banner数据:`, data)
    // 这里可以调用API保存数据
    bannerDialogVisible.value = false
  }
}

// 菜单列表数据（从menuConfig初始化）
const menuList = reactive({
  experimentTeaching: [],
  experimentResources: [],
  constructionResults: [],
  safetyManagement: []
})

// 初始化菜单列表
const initMenuList = () => {
  // 实验教学
  menuList.experimentTeaching = (menuGroups['experiment-teaching']?.items || []).map((item, index) => ({
    id: `experiment-teaching-${index + 1}`,
    category: 'experiment-teaching',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType,
    contentId: item.defaultId
  }))

  // 实验资源
  menuList.experimentResources = (menuGroups['experiment-resources']?.items || []).map((item, index) => ({
    id: `experiment-resources-${index + 1}`,
    category: 'experiment-resources',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType,
    contentId: item.defaultId
  }))

  // 建设成效
  menuList.constructionResults = (menuGroups['construction-results']?.items || []).map((item, index) => ({
    id: `construction-results-${index + 1}`,
    category: 'construction-results',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType,
    contentId: item.defaultId
  }))

  // 安全管理
  menuList.safetyManagement = (menuGroups['safety-management']?.items || []).map((item, index) => ({
    id: `safety-management-${index + 1}`,
    category: 'safety-management',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType,
    contentId: item.defaultId
  }))
}

// 菜单编辑对话框
const menuDialogVisible = ref(false)
const menuDialogTitle = ref('添加菜单')
const menuForm = reactive({
  id: null,
  category: '',
  key: '',
  name: '',
  icon: 'Document',
  pageType: 'news-list',
  contentId: ''
})
const menuEditIndex = ref(-1)

// 可用图标列表
const availableIcons = [
  { label: '文档', value: 'Document' },
  { label: '阅读', value: 'Reading' },
  { label: '盒子', value: 'Box' },
  { label: '建筑', value: 'OfficeBuilding' },
  { label: '分享', value: 'Share' },
  { label: '编辑', value: 'Edit' },
  { label: '奖杯', value: 'Trophy' },
  { label: '设置', value: 'Setting' },
  { label: '学校', value: 'School' },
  { label: '锁定', value: 'Lock' },
  { label: '文件', value: 'Files' }
]

// 获取图标组件
const getIconComponent = (iconName) => {
  return ElementPlusIconsVue[iconName] || ElementPlusIconsVue['Document']
}

// 获取页面类型名称
const getPageTypeName = (pageType) => {
  const map = {
    'news-list': '新闻列表',
    'product-list': '产品列表',
    'image-text': '图文',
    'download-list': '下载列表'
  }
  return map[pageType] || pageType
}

// 获取页面类型标签类型
const getPageTypeTag = (pageType) => {
  const map = {
    'news-list': 'success',
    'product-list': 'warning',
    'image-text': 'info',
    'download-list': ''
  }
  return map[pageType] || ''
}

// 选择菜单
const handleSelectMenu = (menu) => {
  selectedMenu.value = { ...menu }
}

// 添加菜单
const handleAddMenu = (category) => {
  menuDialogTitle.value = '添加菜单'
  menuForm.id = null
  menuForm.category = category
  menuForm.key = ''
  menuForm.name = ''
  menuForm.icon = 'Document'
  menuForm.pageType = 'news-list'
  menuForm.contentId = ''
  menuEditIndex.value = -1
  menuDialogVisible.value = true
}

// 编辑菜单
const handleEditMenu = (menu) => {
  menuDialogTitle.value = '编辑菜单'
  menuForm.id = menu.id
  menuForm.category = menu.category
  menuForm.key = menu.key
  menuForm.name = menu.name
  menuForm.icon = menu.icon
  menuForm.pageType = menu.pageType
  menuForm.contentId = menu.contentId
  
  // 找到菜单在列表中的索引
  const list = getMenuListByCategory(menu.category)
  menuEditIndex.value = list.findIndex(m => m.id === menu.id)
  menuDialogVisible.value = true
}

// 删除菜单
const handleDeleteMenu = (menu) => {
  ElMessageBox.confirm('确定要删除这个菜单吗？删除后关联的内容也会被删除。', '提示', {
    type: 'warning'
  }).then(() => {
    const list = getMenuListByCategory(menu.category)
    const index = list.findIndex(m => m.id === menu.id)
    if (index >= 0) {
      list.splice(index, 1)
      if (selectedMenu.value?.id === menu.id) {
        selectedMenu.value = null
      }
      ElMessage.success('删除成功')
    }
  }).catch(() => {})
}

// 获取分类对应的菜单列表
const getMenuListByCategory = (category) => {
  const map = {
    'experiment-teaching': menuList.experimentTeaching,
    'experiment-resources': menuList.experimentResources,
    'construction-results': menuList.constructionResults,
    'safety-management': menuList.safetyManagement
  }
  return map[category] || []
}

// 提交菜单
const handleMenuSubmit = () => {
  if (!menuForm.name || !menuForm.name.trim()) {
    ElMessage.warning('请输入菜单名称')
    return
  }
  if (!menuForm.contentId || !menuForm.contentId.trim()) {
    ElMessage.warning('请输入内容ID')
    return
  }

  const list = getMenuListByCategory(menuForm.category)
  
  if (menuEditIndex.value >= 0) {
    // 编辑
    const menu = list[menuEditIndex.value]
    Object.assign(menu, {
      key: menuForm.key || menu.key,
      name: menuForm.name,
      icon: menuForm.icon,
      pageType: menuForm.pageType,
      contentId: menuForm.contentId
    })
    // 如果页面类型改变，需要更新选中的菜单
    if (selectedMenu.value?.id === menu.id) {
      selectedMenu.value = { ...menu }
    }
    ElMessage.success('编辑成功')
  } else {
    // 添加
    const newMenu = {
      id: `${menuForm.category}-${Date.now()}`,
      category: menuForm.category,
      key: menuForm.key || `menu-${Date.now()}`,
      name: menuForm.name,
      icon: menuForm.icon,
      pageType: menuForm.pageType,
      contentId: menuForm.contentId
    }
    list.push(newMenu)
    ElMessage.success('添加成功')
  }
  menuDialogVisible.value = false
}

// 内容更新回调
const handleContentUpdate = () => {
  // 内容更新后的处理
  console.log('内容已更新')
}

// 切换Tab时重置选中菜单
watch(activeTab, () => {
  selectedMenu.value = null
})

// 初始化
initMenuList()
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

.management-layout {
  display: flex;
  gap: 20px;
  min-height: 600px;
}

.menu-sidebar {
  width: 320px;
  flex-shrink: 0;
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  gap: 8px;
}

.sidebar-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
}

.menu-list {
  max-height: 600px;
  overflow-y: auto;
}

.menu-item {
  padding: 12px;
  margin-bottom: 10px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
  background-color: #fff;
}

.menu-item:hover {
  border-color: #409eff;
  background-color: #ecf5ff;
}

.menu-item.active {
  border-color: #409eff;
  background-color: #ecf5ff;
}

.menu-info {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}

.menu-icon {
  font-size: 20px;
  color: #409eff;
}

.menu-details {
  flex: 1;
}

.menu-name {
  font-weight: bold;
  margin-bottom: 4px;
  color: #303133;
}

.menu-actions {
  display: flex;
  justify-content: flex-end;
  gap: 5px;
}

.content-area {
  flex: 1;
  min-width: 0;
}

.empty-selection {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 400px;
}

:deep(.el-card__header) {
  background-color: #fafafa;
  border-bottom: 1px solid #ebeef5;
}
</style>

