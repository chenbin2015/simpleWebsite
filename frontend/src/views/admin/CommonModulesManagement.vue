<template>
  <div class="admin-page">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h2>{{ currentCategoryTitle }} - 通用模块管理</h2>
        </div>
      </template>
      
      <div class="management-layout">
        <!-- 左侧菜单列表区域 -->
        <div class="left-panel">
          <el-card shadow="hover">
            <template #header>
              <div class="panel-header">
                <h3>{{ currentCategoryTitle }} - 菜单列表</h3>
                <div class="header-actions">
                  <el-button type="info" size="small" @click="handleOpenBannerDialog(activeCategory)">
                    <el-icon><Picture /></el-icon>
                    Banner管理
                  </el-button>
                  <el-button type="primary" size="small" @click="handleAddMenu(activeCategory)">
                    <el-icon><Plus /></el-icon>
                    添加菜单
                  </el-button>
                </div>
              </div>
            </template>
            <div class="menu-list">
              <div
                v-for="menu in currentMenuList"
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
              <el-empty v-if="currentMenuList.length === 0" description="暂无菜单" :image-size="80" />
            </div>
          </el-card>
        </div>

        <!-- 右侧内容管理区域 -->
        <div class="right-panel">
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
        @delete="handleBannerDelete"
      />
    </el-dialog>

    <!-- 菜单编辑对话框 -->
    <el-dialog v-model="menuDialogVisible" :title="menuDialogTitle" width="500px">
      <el-form :model="menuForm" label-width="100px">
        <el-form-item label="菜单名称" required>
          <el-input v-model="menuForm.name" placeholder="请输入菜单名称" maxlength="50" show-word-limit />
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
          <el-select 
            v-model="menuForm.pageType" 
            placeholder="请选择页面类型" 
            style="width: 100%;"
            :disabled="isEditMode"
          >
            <el-option label="新闻列表" value="news-list" />
            <el-option label="产品列表" value="product-list" />
            <el-option label="图文" value="image-text" />
            <el-option label="下载列表" value="download-list" />
          </el-select>
          <div v-if="isEditMode" style="font-size: 12px; color: #909399; margin-top: 4px;">
            编辑模式下不允许修改页面类型，以确保数据一致性
          </div>
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
import * as moduleBannerApi from '@/services/moduleBannerApi'
import * as menuApi from '@/services/menuApi'
import { buildImageUrl } from '@/utils/url'

// 接收路由参数
const props = defineProps({
  category: {
    type: String,
    default: 'experiment-teaching'
  }
})

// 分类切换
const activeCategory = ref(props.category)
const selectedMenu = ref(null)

// 分类名称映射
const categoryNames = {
  'experiment-teaching': '实验教学',
  'experiment-resources': '实验资源',
  'construction-results': '建设成效',
  'safety-management': '安全管理'
}

// 当前分类标题
const currentCategoryTitle = computed(() => {
  return categoryNames[activeCategory.value] || '通用模块管理'
})

// 监听props变化，更新activeCategory
watch(() => props.category, (newCategory) => {
  activeCategory.value = newCategory
  selectedMenu.value = null
}, { immediate: true })

// 当前菜单列表
const currentMenuList = computed(() => {
  const map = {
    'experiment-teaching': menuList.experimentTeaching,
    'experiment-resources': menuList.experimentResources,
    'construction-results': menuList.constructionResults,
    'safety-management': menuList.safetyManagement
  }
  return map[activeCategory.value] || []
})

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
const handleOpenBannerDialog = async (category) => {
  const categoryNames = {
    'experiment-teaching': '实验教学',
    'experiment-resources': '实验资源',
    'construction-results': '建设成效',
    'safety-management': '安全管理'
  }
  bannerDialogTitle.value = `${categoryNames[category]} - Banner管理`
  currentBannerCategory.value = category
  
  // 构建完整的图片/视频URL
  const buildFullUrl = buildImageUrl
  
  // 从后端加载Banner数据
  try {
    const response = await moduleBannerApi.getBanner(category)
    if (response.success) {
      if (response.data) {
        currentBannerData.value = {
          type: response.data.type || 'image',
          imageUrl: buildFullUrl(response.data.imageUrl) || '',
          videoUrl: buildFullUrl(response.data.videoUrl) || '',
          videoUrlExternal: response.data.videoUrlExternal || ''
        }
      } else {
        // 没有数据，使用默认值
        currentBannerData.value = {
          type: 'image',
          imageUrl: '',
          videoUrl: '',
          videoUrlExternal: ''
        }
      }
    }
  } catch (error) {
    console.error('加载Banner数据失败:', error)
    ElMessage.error('加载Banner数据失败')
    currentBannerData.value = {
      type: 'image',
      imageUrl: '',
      videoUrl: '',
      videoUrlExternal: ''
    }
  }
  
  bannerDialogVisible.value = true
}

// Banner保存处理
const handleBannerSave = async (data) => {
  if (!currentBannerCategory.value) {
    ElMessage.error('模块分类不能为空')
    return
  }
  
  try {
    const response = await moduleBannerApi.saveBanner(currentBannerCategory.value, data)
    if (response.success) {
      ElMessage.success('保存成功')
      // 更新本地数据
      const categoryKeyMap = {
        'experiment-teaching': 'experimentTeaching',
        'experiment-resources': 'experimentResources',
        'construction-results': 'constructionResults',
        'safety-management': 'safetyManagement'
      }
      const dataKey = categoryKeyMap[currentBannerCategory.value]
      if (dataKey && response.data) {
        Object.assign(bannerData[dataKey], {
          type: response.data.type || data.type,
          imageUrl: response.data.imageUrl || '',
          videoUrl: response.data.videoUrl || '',
          videoUrlExternal: response.data.videoUrlExternal || ''
        })
      }
      bannerDialogVisible.value = false
    } else {
      throw new Error(response.message || '保存失败')
    }
  } catch (error) {
    console.error('保存Banner失败:', error)
    ElMessage.error(error.message || '保存Banner失败')
  }
}

// Banner删除处理
const handleBannerDelete = async ({ type }) => {
  if (!currentBannerCategory.value) {
    ElMessage.error('模块分类不能为空')
    return
  }
  
  try {
    const response = await moduleBannerApi.deleteBanner(currentBannerCategory.value)
    if (response.success) {
      ElMessage.success('删除成功')
      
      // 构建完整的图片/视频URL（用于重新加载）
      const buildFullUrl = (url) => {
        if (!url) return ''
        if (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('data:')) {
          return url
        }
        return buildImageUrl(url)
      }
      
      // 重新加载Banner数据（更新对话框中的显示）
      const reloadResponse = await moduleBannerApi.getBanner(currentBannerCategory.value)
      if (reloadResponse.success) {
        if (reloadResponse.data) {
          currentBannerData.value = {
            type: reloadResponse.data.type || 'image',
            imageUrl: buildFullUrl(reloadResponse.data.imageUrl) || '',
            videoUrl: buildFullUrl(reloadResponse.data.videoUrl) || '',
            videoUrlExternal: reloadResponse.data.videoUrlExternal || ''
          }
        } else {
          // 没有数据，清空显示
          currentBannerData.value = {
            type: 'image',
            imageUrl: '',
            videoUrl: '',
            videoUrlExternal: ''
          }
        }
      }
      
      // 更新本地数据
      const categoryKeyMap = {
        'experiment-teaching': 'experimentTeaching',
        'experiment-resources': 'experimentResources',
        'construction-results': 'constructionResults',
        'safety-management': 'safetyManagement'
      }
      const dataKey = categoryKeyMap[currentBannerCategory.value]
      if (dataKey) {
        if (reloadResponse.data) {
          bannerData[dataKey].type = reloadResponse.data.type || 'image'
          bannerData[dataKey].imageUrl = reloadResponse.data.imageUrl || ''
          bannerData[dataKey].videoUrl = reloadResponse.data.videoUrl || ''
          bannerData[dataKey].videoUrlExternal = reloadResponse.data.videoUrlExternal || ''
        } else {
          bannerData[dataKey].imageUrl = ''
          bannerData[dataKey].videoUrl = ''
          bannerData[dataKey].videoUrlExternal = ''
        }
      }
    } else {
      throw new Error(response.message || '删除失败')
    }
  } catch (error) {
    console.error('删除Banner失败:', error)
    ElMessage.error(error.message || '删除Banner失败')
  }
}

// 菜单列表数据（从menuConfig初始化）
const menuList = reactive({
  experimentTeaching: [],
  experimentResources: [],
  constructionResults: [],
  safetyManagement: []
})

// 父菜单ID映射：category -> parentMenuId
const parentMenuIdMap = reactive({
  'experiment-teaching': null,
  'experiment-resources': null,
  'construction-results': null,
  'safety-management': null
})

// 从后端加载菜单数据，完全基于后端返回的数据构建菜单列表
const loadMenusFromBackend = async () => {
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
      
      // 初始化所有分类的菜单列表为空
      menuList.experimentTeaching = []
      menuList.experimentResources = []
      menuList.constructionResults = []
      menuList.safetyManagement = []
      
      // 从后端数据构建菜单列表
      response.data.forEach(parentMenu => {
        // 找到对应的分类
        const category = Object.keys(categoryToParentName).find(
          cat => categoryToParentName[cat] === parentMenu.name
        )
        
        if (category) {
          // 保存父菜单ID映射
          parentMenuIdMap[category] = parentMenu.id
          
          // 从后端返回的子菜单数据构建菜单列表
          if (parentMenu.children && parentMenu.children.length > 0) {
            const categoryMenuList = parentMenu.children.map((childMenu, index) => {
              // 尝试从配置中找到对应的菜单项以获取图标和页面类型
              const configItem = menuGroups[category]?.items?.find(
                item => item.name === childMenu.name
              )
              
              return {
                id: `${category}-${index + 1}`, // 前端ID用于显示
                menuId: childMenu.id, // 数据库ID，用于API调用
                category: category,
                key: configItem?.key || `menu-${childMenu.id}`, // 从配置获取key，如果没有则生成
                name: childMenu.name,
                icon: configItem?.icon || 'Document', // 从配置获取图标，如果没有则使用默认
                pageType: childMenu.pageType || configItem?.pageType || 'news-list' // 优先使用数据库中的页面类型，如果没有则使用配置中的，最后使用默认值
              }
            })
            
            // 根据分类设置对应的菜单列表
            switch (category) {
              case 'experiment-teaching':
                menuList.experimentTeaching = categoryMenuList
                break
              case 'experiment-resources':
                menuList.experimentResources = categoryMenuList
                break
              case 'construction-results':
                menuList.constructionResults = categoryMenuList
                break
              case 'safety-management':
                menuList.safetyManagement = categoryMenuList
                break
            }
          }
        }
      })
    } else {
      // 如果后端加载失败，使用前端配置
      initMenuListFromConfig()
    }
  } catch (error) {
    console.error('加载菜单数据失败，使用前端配置:', error)
    // 如果后端加载失败，使用前端配置
    initMenuListFromConfig()
  }
}

// 从配置初始化菜单列表（作为fallback）
const initMenuListFromConfig = () => {
  // 实验教学
  menuList.experimentTeaching = (menuGroups['experiment-teaching']?.items || []).map((item, index) => ({
    id: `experiment-teaching-${index + 1}`,
    menuId: null,
    category: 'experiment-teaching',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType
  }))

  // 实验资源
  menuList.experimentResources = (menuGroups['experiment-resources']?.items || []).map((item, index) => ({
    id: `experiment-resources-${index + 1}`,
    menuId: null,
    category: 'experiment-resources',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType
  }))

  // 建设成效
  menuList.constructionResults = (menuGroups['construction-results']?.items || []).map((item, index) => ({
    id: `construction-results-${index + 1}`,
    menuId: null,
    category: 'construction-results',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType
  }))

  // 安全管理
  menuList.safetyManagement = (menuGroups['safety-management']?.items || []).map((item, index) => ({
    id: `safety-management-${index + 1}`,
    menuId: null,
    category: 'safety-management',
    key: item.key,
    name: item.name,
    icon: item.icon,
    pageType: item.pageType
  }))
}

// 初始化菜单列表（兼容旧代码）
const initMenuList = () => {
  // 优先从后端加载，如果失败则使用前端配置
  loadMenusFromBackend()
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
  pageType: 'news-list'
})
const menuEditIndex = ref(-1)

// 判断是否是编辑模式
const isEditMode = computed(() => menuEditIndex.value >= 0)

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
  
  // 找到菜单在列表中的索引
  const list = getMenuListByCategory(menu.category)
  menuEditIndex.value = list.findIndex(m => m.id === menu.id)
  menuDialogVisible.value = true
}

// 删除菜单
const handleDeleteMenu = (menu) => {
  ElMessageBox.confirm('确定要删除这个菜单吗？删除后关联的内容也会被删除。', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      // 如果有数据库ID，调用后端API删除
      if (menu.menuId) {
        const response = await menuApi.deleteMenu(menu.menuId)
        
        if (!response.success) {
          throw new Error(response.message || '删除失败')
        }
        
        ElMessage.success('删除成功')
        // 清除选中的菜单
        if (selectedMenu.value?.id === menu.id) {
          selectedMenu.value = null
        }
        // 重新加载菜单列表以获取最新数据（已删除的菜单不会显示）
        await loadMenusFromBackend()
      } else {
        // 如果没有数据库ID，只从前端列表中移除
        const list = getMenuListByCategory(menu.category)
        const index = list.findIndex(m => m.id === menu.id)
        if (index >= 0) {
          list.splice(index, 1)
          if (selectedMenu.value?.id === menu.id) {
            selectedMenu.value = null
          }
          ElMessage.success('删除成功')
        }
      }
    } catch (error) {
      console.error('删除菜单失败:', error)
      ElMessage.error(error.message || '删除菜单失败')
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
const handleMenuSubmit = async () => {
  if (!menuForm.name || !menuForm.name.trim()) {
    ElMessage.warning('请输入菜单名称')
    return
  }

  const list = getMenuListByCategory(menuForm.category)
  
  try {
    if (menuEditIndex.value >= 0) {
      // 编辑
      const menu = list[menuEditIndex.value]
      
      if (!menu.menuId) {
        ElMessage.error('菜单缺少数据库ID，无法更新')
        return
      }
      
      // 调用后端API更新菜单
      const response = await menuApi.updateMenu(menu.menuId, menuForm.name, null, null)
      
      if (response.success) {
        ElMessage.success('编辑成功')
        menuDialogVisible.value = false
        // 重新加载菜单列表以获取最新数据
        await loadMenusFromBackend()
        // 更新选中的菜单（如果有的话）
        if (selectedMenu.value?.menuId === menu.menuId) {
          const updatedMenu = getMenuListByCategory(menuForm.category).find(m => m.menuId === menu.menuId)
          if (updatedMenu) {
            selectedMenu.value = { ...updatedMenu }
          }
        }
      } else {
        throw new Error(response.message || '更新失败')
      }
    } else {
      // 添加
      const parentId = parentMenuIdMap[menuForm.category]
      
      if (!parentId) {
        ElMessage.error('无法找到父菜单ID，请刷新页面重试')
        return
      }
      
      // 计算排序顺序（新菜单放在最后）
      const sortOrder = list.length
      
      // 调用后端API创建子菜单
      const response = await menuApi.createSubMenu(parentId, menuForm.name, sortOrder, menuForm.pageType)
      
      if (response.success && response.menu) {
        ElMessage.success('添加成功')
        menuDialogVisible.value = false
        // 重新加载菜单列表以获取最新数据
        await loadMenusFromBackend()
      } else {
        throw new Error(response.message || '添加失败')
      }
    }
  } catch (error) {
    console.error('保存菜单失败:', error)
    ElMessage.error(error.message || '保存菜单失败')
  }
}

// 内容更新回调
const handleContentUpdate = () => {
  // 内容更新后的处理
  console.log('内容已更新')
}

// 切换分类时重置选中菜单
watch(activeCategory, () => {
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

.management-layout {
  display: flex;
  gap: 20px;
  min-height: 600px;
}

.left-panel {
  width: 280px;
  flex-shrink: 0;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.panel-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
}

.header-actions {
  display: flex;
  gap: 8px;
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

.right-panel {
  flex: 1;
  min-width: 0;
  overflow: hidden;
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

