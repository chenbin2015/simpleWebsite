<template>
  <div class="business-management">
    <el-row :gutter="20">
      <!-- 左侧：菜单树 -->
      <el-col :span="8">
        <el-card shadow="never" class="menu-tree-card">
          <template #header>
            <div class="card-header">
              <span>菜单管理</span>
              <span class="header-tip">顶级菜单为内置菜单</span>
            </div>
          </template>
          
          <el-tree
            :data="menuTree"
            :props="{ children: 'children', label: 'name' }"
            default-expand-all
            node-key="id"
            :highlight-current="true"
            @node-click="handleMenuClick"
            class="menu-tree"
          >
            <template #default="{ node, data }">
              <div class="tree-node">
                <span class="node-label">{{ data.name }}</span>
                <span class="node-actions">
                  <el-button
                    v-if="!data.parent"
                    type="primary"
                    link
                    size="small"
                    @click.stop="showAddSubMenuDialog(data)"
                  >
                    <el-icon><Plus /></el-icon>
                  </el-button>
                  <el-button
                    type="primary"
                    link
                    size="small"
                    @click.stop="showEditMenuDialog(data)"
                  >
                    <el-icon><Edit /></el-icon>
                  </el-button>
                  <el-button
                    type="danger"
                    link
                    size="small"
                    @click.stop="handleDeleteMenu(data)"
                  >
                    <el-icon><Delete /></el-icon>
                  </el-button>
                </span>
              </div>
            </template>
          </el-tree>
        </el-card>
      </el-col>
      
      <!-- 右侧：内容编辑区 -->
      <el-col :span="16">
        <el-card shadow="never" class="content-editor-card" v-if="selectedMenu">
          <template #header>
            <div class="card-header">
              <span>{{ selectedMenu.name }} - 内容编辑</span>
            </div>
          </template>
          
          <div v-if="selectedMenu.parent">
            <!-- 二级菜单：显示内容编辑器 -->
            <el-form :model="contentForm" label-width="80px">
              <el-form-item label="标题">
                <el-input v-model="contentForm.title" placeholder="请输入内容标题" />
              </el-form-item>
              <el-form-item label="内容">
                <div class="editor-wrapper">
                  <div class="editor-toolbar">
                    <el-button-group>
                      <el-button size="small" @click="insertText('**', '**')">
                        <strong>B</strong>
                      </el-button>
                      <el-button size="small" @click="insertText('*', '*')">
                        <em>I</em>
                      </el-button>
                      <el-button size="small" @click="insertText('&lt;h2&gt;', '&lt;/h2&gt;')">
                        H2
                      </el-button>
                      <el-button size="small" @click="insertText('&lt;p&gt;', '&lt;/p&gt;')">
                        P
                      </el-button>
                      <el-button size="small" @click="insertImageTag">
                        图片
                      </el-button>
                    </el-button-group>
                  </div>
                  <el-input
                    v-model="contentForm.content"
                    type="textarea"
                    :rows="15"
                    placeholder="请输入内容，支持HTML格式。可以使用工具栏按钮快速插入格式标签。"
                    class="content-textarea"
                  />
                  <div class="editor-preview" v-if="contentForm.content">
                    <h4>预览：</h4>
                    <div class="preview-content" v-html="contentForm.content"></div>
                  </div>
                </div>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="saveContent" :loading="saving">
                  保存内容
                </el-button>
                <el-button @click="resetContent">重置</el-button>
              </el-form-item>
            </el-form>
          </div>
          <div v-else class="no-content-tip">
            <el-empty description="顶级菜单不能添加内容，请选择二级菜单进行编辑" />
          </div>
        </el-card>
        <el-card v-else shadow="never" class="content-editor-card">
          <el-empty description="请从左侧选择一个菜单" />
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 添加/编辑菜单对话框 -->
    <el-dialog
      v-model="menuDialogVisible"
      :title="menuDialogTitle"
      width="500px"
    >
      <el-form :model="menuForm" label-width="100px">
        <el-form-item label="菜单名称" required>
          <el-input v-model="menuForm.name" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="排序顺序">
          <el-input-number v-model="menuForm.sortOrder" :min="0" />
        </el-form-item>
        <el-form-item label="是否启用" v-if="menuForm.id">
          <el-switch v-model="menuForm.isActive" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="menuDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveMenu" :loading="savingMenu">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import request from '../utils/request'

export default {
  name: 'BusinessManagement',
  components: {
    Plus,
    Edit,
    Delete
  },
  props: {
    menuKey: {
      type: String,
      default: ''
    }
  },
  setup(props) {
    const menuTree = ref([])
    const selectedMenu = ref(null)
    const menuDialogVisible = ref(false)
    const menuDialogTitle = ref('添加菜单')
    const menuForm = ref({
      id: null,
      name: '',
      parentId: null,
      sortOrder: 0,
      isActive: true
    })
    const contentForm = ref({
      title: '',
      content: ''
    })
    const saving = ref(false)
    const savingMenu = ref(false)
    
    // 插入文本标签
    const insertText = (prefix, suffix) => {
      const textarea = document.querySelector('.content-textarea textarea')
      if (textarea) {
        const start = textarea.selectionStart
        const end = textarea.selectionEnd
        const selectedText = contentForm.value.content.substring(start, end)
        // 解码HTML实体
        const decodedPrefix = prefix.replace(/&lt;/g, '<').replace(/&gt;/g, '>')
        const decodedSuffix = suffix.replace(/&lt;/g, '<').replace(/&gt;/g, '>')
        const newText = decodedPrefix + selectedText + decodedSuffix
        contentForm.value.content = 
          contentForm.value.content.substring(0, start) + 
          newText + 
          contentForm.value.content.substring(end)
        
        // 设置光标位置
        setTimeout(() => {
          textarea.focus()
          textarea.setSelectionRange(start + decodedPrefix.length, start + decodedPrefix.length + selectedText.length)
        }, 0)
      }
    }
    
    // 插入图片标签
    const insertImageTag = () => {
      const textarea = document.querySelector('.content-textarea textarea')
      if (textarea) {
        const start = textarea.selectionStart
        const imageTag = '<img src="" alt="" />'
        contentForm.value.content = 
          contentForm.value.content.substring(0, start) + 
          imageTag + 
          contentForm.value.content.substring(start)
        
        // 设置光标位置到src属性中
        setTimeout(() => {
          textarea.focus()
          const newPos = start + 10 // '<img src="' 的长度
          textarea.setSelectionRange(newPos, newPos)
        }, 0)
      }
    }
    
    // 菜单映射：管理后台菜单key -> 数据库菜单名称
    const menuKeyMap = {
      'business-home': '首页',
      'business-overview': '中心概况',
      'business-teaching': '实验教学',
      'business-resources': '实验资源',
      'business-achievements': '建设成效',
      'business-safety': '安全管理',
      'business-science': '科普教育'
    }
    
    // 加载菜单列表
    const loadMenus = async () => {
      try {
        const response = await request.get('/menu/list')
        if (response.success) {
          menuTree.value = response.data
          
          // 如果有传入的menuKey，自动选中对应的菜单
          if (props.menuKey && menuKeyMap[props.menuKey]) {
            const targetMenuName = menuKeyMap[props.menuKey]
            const targetMenu = findMenuByName(menuTree.value, targetMenuName)
            if (targetMenu) {
              selectedMenu.value = targetMenu
              if (targetMenu.parent) {
                await loadContent(targetMenu.id)
              }
            }
          }
        }
      } catch (error) {
        ElMessage.error('加载菜单失败')
      }
    }
    
    // 根据名称查找菜单
    const findMenuByName = (menus, name) => {
      for (const menu of menus) {
        if (menu.name === name) {
          return menu
        }
        if (menu.children && menu.children.length > 0) {
          const found = findMenuByName(menu.children, name)
          if (found) return found
        }
      }
      return null
    }
    
    // 菜单点击
    const handleMenuClick = async (data) => {
      selectedMenu.value = data
      if (data.parent) {
        // 加载内容
        await loadContent(data.id)
      } else {
        // 顶级菜单，清空内容
        contentForm.value = {
          title: '',
          content: ''
        }
      }
    }
    
    // 加载内容
    const loadContent = async (menuId) => {
      try {
        const response = await request.get(`/content/menu/${menuId}`)
        if (response.success) {
          const content = response.content
          contentForm.value = {
            title: content.title || '',
            content: content.content || ''
          }
        }
      } catch (error) {
        ElMessage.error('加载内容失败')
      }
    }
    
    // 显示添加二级菜单对话框
    const showAddSubMenuDialog = (parentMenu) => {
      menuDialogTitle.value = '添加二级菜单'
      menuForm.value = {
        id: null,
        name: '',
        parentId: parentMenu.id,
        sortOrder: 0,
        isActive: true
      }
      menuDialogVisible.value = true
    }
    
    // 显示编辑菜单对话框
    const showEditMenuDialog = (menu) => {
      if (!menu.parent) {
        menuDialogTitle.value = '编辑顶级菜单'
      } else {
        menuDialogTitle.value = '编辑二级菜单'
      }
      menuForm.value = {
        id: menu.id,
        name: menu.name,
        parentId: menu.parent ? menu.parent.id : null,
        sortOrder: menu.sortOrder,
        isActive: menu.isActive
      }
      menuDialogVisible.value = true
    }
    
    // 保存菜单
    const saveMenu = async () => {
      if (!menuForm.value.name || menuForm.value.name.trim() === '') {
        ElMessage.warning('请输入菜单名称')
        return
      }
      
      savingMenu.value = true
      try {
        let response
        if (menuForm.value.id) {
          // 更新
          response = await request.put(`/menu/${menuForm.value.id}`, {
            name: menuForm.value.name,
            sortOrder: menuForm.value.sortOrder,
            isActive: menuForm.value.isActive
          })
        } else {
          // 创建二级菜单（只能创建二级菜单，顶级菜单为内置）
          if (!menuForm.value.parentId) {
            ElMessage.warning('顶级菜单为内置菜单，不能创建')
            savingMenu.value = false
            return
          }
          response = await request.post('/menu/sub', {
            parentId: menuForm.value.parentId,
            name: menuForm.value.name,
            sortOrder: menuForm.value.sortOrder
          })
        }
        
        if (response.success) {
          ElMessage.success(response.message)
          menuDialogVisible.value = false
          await loadMenus()
        } else {
          ElMessage.error(response.message)
        }
      } catch (error) {
        ElMessage.error(error.message || '操作失败')
      } finally {
        savingMenu.value = false
      }
    }
    
    // 删除菜单
    const handleDeleteMenu = async (menu) => {
      // 顶级菜单不允许删除
      if (!menu.parent) {
        ElMessage.warning('顶级菜单为内置菜单，不允许删除')
        return
      }
      
      try {
        await ElMessageBox.confirm(
          `确定要删除菜单"${menu.name}"吗？`,
          '确认删除',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        
        const response = await request.delete(`/menu/${menu.id}`)
        if (response.success) {
          ElMessage.success('删除成功')
          selectedMenu.value = null
          await loadMenus()
        } else {
          ElMessage.error(response.message)
        }
      } catch (error) {
        if (error !== 'cancel') {
          ElMessage.error(error.message || '删除失败')
        }
      }
    }
    
    // 保存内容
    const saveContent = async () => {
      if (!selectedMenu.value || !selectedMenu.value.parent) {
        ElMessage.warning('只能为二级菜单添加内容')
        return
      }
      
      saving.value = true
      try {
        const response = await request.post('/content/save', {
          menuId: selectedMenu.value.id,
          title: contentForm.value.title,
          content: contentForm.value.content
        })
        
        if (response.success) {
          ElMessage.success('保存成功')
        } else {
          ElMessage.error(response.message)
        }
      } catch (error) {
        ElMessage.error(error.message || '保存失败')
      } finally {
        saving.value = false
      }
    }
    
    // 重置内容
    const resetContent = () => {
      if (selectedMenu.value && selectedMenu.value.parent) {
        loadContent(selectedMenu.value.id)
      }
    }
    
    onMounted(() => {
      loadMenus()
    })
    
    return {
      menuTree,
      selectedMenu,
      menuDialogVisible,
      menuDialogTitle,
      menuForm,
      contentForm,
      saving,
      savingMenu,
      insertText,
      insertImageTag,
      handleMenuClick,
      showAddSubMenuDialog,
      showEditMenuDialog,
      saveMenu,
      handleDeleteMenu,
      saveContent,
      resetContent
    }
  }
}
</script>

<style scoped>
.business-management {
  padding: 0;
}

.menu-tree-card,
.content-editor-card {
  min-height: 600px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-tip {
  font-size: 12px;
  color: #909399;
}

.menu-tree {
  margin-top: 10px;
}

.tree-node {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex: 1;
  padding-right: 8px;
}

.node-label {
  flex: 1;
}

.node-actions {
  display: flex;
  gap: 4px;
  opacity: 0;
  transition: opacity 0.3s;
}

.tree-node:hover .node-actions {
  opacity: 1;
}

.no-content-tip {
  padding: 40px 0;
  text-align: center;
}

:deep(.el-tree-node__content) {
  height: 36px;
}

:deep(.el-tree-node__content:hover) {
  background-color: #F5F7FA;
}

.editor-wrapper {
  border: 1px solid #DCDFE6;
  border-radius: 4px;
  overflow: hidden;
}

.editor-toolbar {
  padding: 8px;
  background: #F5F7FA;
  border-bottom: 1px solid #DCDFE6;
}

.content-textarea {
  border: none;
}

.content-textarea :deep(.el-textarea__inner) {
  border: none;
  resize: vertical;
  font-family: 'Courier New', monospace;
}

.editor-preview {
  margin-top: 20px;
  padding: 16px;
  background: #F8F9FA;
  border-top: 1px solid #DCDFE6;
}

.editor-preview h4 {
  margin: 0 0 12px 0;
  color: #606266;
  font-size: 14px;
}

.preview-content {
  min-height: 100px;
  padding: 12px;
  background: #FFFFFF;
  border: 1px solid #E4E7ED;
  border-radius: 4px;
}

.preview-content img {
  max-width: 100%;
  height: auto;
}
</style>

