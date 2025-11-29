<template>
  <div class="admin-page">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h2>中心概况 - 组织架构</h2>
          <el-alert
            type="warning"
            :closable="false"
            show-icon
            style="display: inline-block; margin: 0;"
          >
            <template #default>
              <span style="font-size: 12px;">至少需要保留一位主任</span>
            </template>
          </el-alert>
        </div>
      </template>
      
      <el-form :model="formData" label-width="120px" label-position="left" class="organization-form">
        <!-- 主任 -->
        <el-form-item label="主任">
          <div class="person-list">
            <div
              v-for="(person, index) in formData.director"
              :key="index"
              class="person-item"
            >
              <el-input
                v-model="formData.director[index]"
                placeholder="请输入主任姓名"
                style="width: 300px; margin-right: 10px;"
              />
              <el-button
                type="danger"
                :icon="Delete"
                circle
                @click="removePerson('director', index)"
              />
            </div>
            <el-button
              type="primary"
              :icon="Plus"
              @click="addPerson('director')"
            >
              添加主任
            </el-button>
          </div>
        </el-form-item>

        <!-- 副主任 -->
        <el-form-item label="副主任">
          <div class="person-list">
            <div
              v-for="(person, index) in formData.deputyDirector"
              :key="index"
              class="person-item"
            >
              <el-input
                v-model="formData.deputyDirector[index]"
                placeholder="请输入副主任姓名"
                style="width: 300px; margin-right: 10px;"
              />
              <el-button
                type="danger"
                :icon="Delete"
                circle
                @click="removePerson('deputyDirector', index)"
              />
            </div>
            <el-button
              type="primary"
              :icon="Plus"
              @click="addPerson('deputyDirector')"
            >
              添加副主任
            </el-button>
          </div>
        </el-form-item>

        <!-- 成员 -->
        <el-form-item label="成员">
          <div class="person-list">
            <div
              v-for="(person, index) in formData.members"
              :key="index"
              class="person-item"
            >
              <el-input
                v-model="formData.members[index]"
                placeholder="请输入成员姓名"
                style="width: 300px; margin-right: 10px;"
              />
              <el-button
                type="danger"
                :icon="Delete"
                circle
                @click="removePerson('members', index)"
              />
            </div>
            <el-button
              type="primary"
              :icon="Plus"
              @click="addPerson('members')"
            >
              添加成员
            </el-button>
          </div>
        </el-form-item>

        <!-- 操作按钮 -->
        <el-form-item>
          <el-button type="primary" size="large" @click="handleSave">
            <el-icon><Check /></el-icon>
            保存
          </el-button>
          <el-button size="large" @click="handleReset">
            <el-icon><RefreshLeft /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete, Check, RefreshLeft } from '@element-plus/icons-vue'

// 表单数据
const formData = reactive({
  director: ['王伟'],
  deputyDirector: ['华好', '冯世虎'],
  members: ['是罪', '李超明', '兰祥启', '刘宇衡', '周海飞']
})

// 添加人员
const addPerson = (type) => {
  formData[type].push('')
}

// 删除人员
const removePerson = (type, index) => {
  if (formData[type].length <= 1 && type === 'director') {
    ElMessage.warning('至少需要保留一位主任')
    return
  }
  ElMessageBox.confirm('确定要删除吗？', '提示', {
    type: 'warning'
  }).then(() => {
    formData[type].splice(index, 1)
    ElMessage.success('删除成功')
  }).catch(() => {})
}

// 保存
const handleSave = () => {
  // 验证至少有一位主任
  if (formData.director.length === 0 || formData.director.every(name => !name.trim())) {
    ElMessage.warning('至少需要设置一位主任')
    return
  }

  // 过滤空值
  const data = {
    director: formData.director.filter(name => name.trim()),
    deputyDirector: formData.deputyDirector.filter(name => name.trim()),
    members: formData.members.filter(name => name.trim())
  }

  // 这里应该调用后端API保存数据
  console.log('保存数据:', data)
  ElMessage.success('保存成功')
}

// 重置
const handleReset = () => {
  ElMessageBox.confirm('确定要重置所有内容吗？', '提示', {
    type: 'warning'
  }).then(() => {
    formData.director = ['王伟']
    formData.deputyDirector = ['华好', '冯世虎']
    formData.members = ['是罪', '李超明', '兰祥启', '刘宇衡', '周海飞']
    ElMessage.success('重置成功')
  }).catch(() => {})
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

.organization-form {
  padding: 20px 0;
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

:deep(.el-form-item__label) {
  font-weight: bold;
}

:deep(.el-card__header) {
  background-color: #fafafa;
  border-bottom: 1px solid #ebeef5;
}

:deep(.el-card__header h2) {
  margin: 0;
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}
</style>
