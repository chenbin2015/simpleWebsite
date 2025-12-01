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
                <el-input v-model="basicForm.copyright" placeholder="请输入版权信息，例如：© 2025 东南大学建筑学院实验教学中心" />
              </el-form-item>
              <el-form-item label="ICP备案号">
                <el-input v-model="basicForm.icp" placeholder="请输入ICP备案号" />
              </el-form-item>
              <el-form-item label="Logo">
                <el-upload
                  :auto-upload="false"
                  :on-change="handleLogoChange"
                  :file-list="logoFileList"
                  list-type="picture-card"
                  :limit="1"
                  accept="image/*"
                >
                  <el-icon><Plus /></el-icon>
                </el-upload>
                <div class="form-tip">支持上传Logo图片</div>
                <div v-if="basicForm.logo" class="logo-preview">
                  <el-image :src="basicForm.logo" style="width: 200px; height: 80px; margin-top: 10px;" fit="contain" />
                </div>
              </el-form-item>
              <el-form-item label="描述">
                <el-input v-model="basicForm.description" type="textarea" :rows="4" placeholder="请输入描述信息" />
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
                <el-input v-model="contactForm.address" placeholder="请输入详细地址" />
              </el-form-item>
              <el-form-item label="邮编">
                <el-input v-model="contactForm.postcode" placeholder="请输入邮编" />
              </el-form-item>
              <el-form-item label="电话">
                <el-input v-model="contactForm.phone" placeholder="请输入联系电话" />
              </el-form-item>
              <el-form-item label="传真">
                <el-input v-model="contactForm.fax" placeholder="请输入传真号码" />
              </el-form-item>
              <el-form-item label="邮箱">
                <el-input v-model="contactForm.email" placeholder="请输入邮箱地址" />
              </el-form-item>
              <el-form-item label="工作时间">
                <el-input v-model="contactForm.workTime" placeholder="请输入工作时间，例如：周一至周五 9:00-17:00" />
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

    <!-- 友情链接编辑对话框 -->
    <el-dialog v-model="linkDialogVisible" :title="linkDialogTitle" width="600px">
      <el-form :model="linkForm" label-width="100px">
        <el-form-item label="链接名称">
          <el-input v-model="linkForm.name" placeholder="请输入链接名称" />
        </el-form-item>
        <el-form-item label="链接地址">
          <el-input v-model="linkForm.url" placeholder="请输入链接地址，例如：https://www.example.com" />
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import * as footerApi from '@/services/footerApi'

// Tab切换
const activeTab = ref('contact')

// ========== 基本信息 ==========
const basicForm = reactive({
  copyright: '© 2025 东南大学建筑学院实验教学中心',
  icp: '',
  logo: '',
  description: ''
})

const logoFileList = ref([])

const handleLogoChange = (file) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    basicForm.logo = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

const handleBasicSave = async () => {
  try {
    const result = await footerApi.saveBasic(basicForm)
    if (result.success) {
      ElMessage.success(result.message || '保存成功')
      loadBasic()
    }
  } catch (error) {
    console.error('保存基本信息失败:', error)
  }
}

const loadBasic = async () => {
  try {
    const result = await footerApi.getBasic()
    if (result.success && result.data) {
      Object.assign(basicForm, {
        copyright: result.data.copyright || '',
        icp: result.data.icp || '',
        logo: result.data.logo || '',
        description: result.data.description || ''
      })
      if (result.data.logo) {
        logoFileList.value = [{ url: result.data.logo }]
      }
    }
  } catch (error) {
    console.error('加载基本信息失败:', error)
  }
}

const handleBasicReset = () => {
  basicForm.copyright = '© 2025 东南大学建筑学院实验教学中心'
  basicForm.icp = ''
  basicForm.logo = ''
  basicForm.description = ''
  logoFileList.value = []
  ElMessage.info('已重置')
}

// ========== 联系方式 ==========
const contactForm = reactive({
  address: '',
  postcode: '',
  phone: '',
  fax: '',
  email: '',
  workTime: ''
})

const handleContactSave = async () => {
  try {
    const result = await footerApi.saveContact(contactForm)
    if (result.success) {
      ElMessage.success(result.message || '保存成功')
      loadContact()
    }
  } catch (error) {
    console.error('保存联系方式失败:', error)
  }
}

const loadContact = async () => {
  try {
    const result = await footerApi.getContact()
    if (result.success && result.data) {
      Object.assign(contactForm, {
        address: result.data.address || '',
        postcode: result.data.postcode || '',
        phone: result.data.phone || '',
        fax: result.data.fax || '',
        email: result.data.email || '',
        workTime: result.data.workTime || ''
      })
    }
  } catch (error) {
    console.error('加载联系方式失败:', error)
  }
}

const handleContactReset = () => {
  contactForm.address = ''
  contactForm.postcode = ''
  contactForm.phone = ''
  contactForm.fax = ''
  contactForm.email = ''
  contactForm.workTime = ''
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
      loadLinkList()
    }
  } catch (error) {
    console.error('保存链接失败:', error)
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
          loadLinkList()
        }
      } catch (error) {
        console.error('删除链接失败:', error)
      }
    })
    .catch(() => {})
}

const loadLinkList = async () => {
  try {
    const result = await footerApi.getLinkList()
    if (result.success && result.data) {
      linkList.value = result.data
    }
  } catch (error) {
    console.error('加载链接列表失败:', error)
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
</style>
