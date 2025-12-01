import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'

// 配置 axios 实例（用于文件上传）
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/center-overview',
  timeout: 30000, // 文件上传可能需要更长时间
  headers: {
    'Content-Type': 'multipart/form-data'
  }
})

// JSON请求的axios实例
const jsonClient = axios.create({
  baseURL: 'http://localhost:8080/api/center-overview',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器（可以添加 token 等）
const requestInterceptor = (config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
}

apiClient.interceptors.request.use(requestInterceptor, error => Promise.reject(error))
jsonClient.interceptors.request.use(requestInterceptor, error => Promise.reject(error))

// 响应拦截器
const responseInterceptor = {
  success: (response) => response.data,
  error: (error) => {
    console.error('API Error:', error)
    
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请重新登录')
      clearAuthData()
      router.push('/admin/login')
      return Promise.reject(error)
    }
    
    if (error.response) {
      const message = error.response.data?.message || error.response.data?.error || '请求失败'
      ElMessage.error(message)
      return Promise.reject(error.response.data)
    }
    
    return Promise.reject(error)
  }
}

apiClient.interceptors.response.use(responseInterceptor.success, responseInterceptor.error)
jsonClient.interceptors.response.use(responseInterceptor.success, responseInterceptor.error)

// ========== Banner管理 ==========

/**
 * 获取Banner
 */
export async function getBanner() {
  return await jsonClient.get('/banner')
}

/**
 * 保存或更新Banner
 * @param {Object} data - Banner数据
 * @param {string} data.type - 类型：image | video
 * @param {File} data.image - 图片文件（type=image时，可选）
 * @param {string} data.imageUrl - Base64图片字符串（type=image时，可选，优先于image）
 * @param {File} data.video - 视频文件（type=video时，可选）
 * @param {string} data.videoUrlExternal - 外部视频URL（type=video时，可选）
 */
export async function saveBanner(data) {
  const formData = new FormData()
  formData.append('type', data.type)
  
  if (data.type === 'image') {
    // 如果提供了 Base64 图片，直接传递
    if (data.imageUrl && data.imageUrl.startsWith('data:image/')) {
      formData.append('imageUrl', data.imageUrl)
    } else if (data.image) {
      // 否则使用文件上传
      formData.append('image', data.image)
    }
  } else if (data.type === 'video') {
    if (data.video) {
      formData.append('video', data.video)
    }
    if (data.videoUrlExternal) {
      formData.append('videoUrlExternal', data.videoUrlExternal)
    }
  }
  
  return await apiClient.post('/banner', formData)
}

/**
 * 删除Banner
 */
export async function deleteBanner() {
  return await jsonClient.delete('/banner')
}

// ========== 详情管理 ==========

/**
 * 获取详情
 */
export async function getDetail() {
  return await jsonClient.get('/detail')
}

/**
 * 保存或更新详情
 * @param {Object} data - 详情数据
 * @param {File} data.video - 视频文件（可选）
 * @param {string} data.videoUrlExternal - 外部视频URL（可选）
 * @param {string} data.mainTitle - 主标题（必填）
 * @param {string} data.background - 建设背景（HTML格式）
 * @param {string} data.overview - 现状概况（HTML格式）
 * @param {string} data.vision - 发展愿景（HTML格式）
 */
export async function saveDetail(data) {
  const formData = new FormData()
  
  if (data.video) {
    formData.append('video', data.video)
  }
  if (data.videoUrlExternal) {
    formData.append('videoUrlExternal', data.videoUrlExternal)
  }
  formData.append('mainTitle', data.mainTitle || '')
  formData.append('background', data.background || '')
  formData.append('overview', data.overview || '')
  formData.append('vision', data.vision || '')
  
  return await apiClient.post('/detail', formData)
}

// ========== 组织架构管理 ==========

/**
 * 获取组织架构
 */
export async function getOrganization() {
  return await jsonClient.get('/organization')
}

/**
 * 保存组织架构（支持动态角色类型）
 * @param {Object} data - 组织架构数据
 * @param {Object} data.roleMembersMap - 角色类型到成员列表的映射，例如: { "主任": ["张三", "李四"], "副主任": ["王五"] }
 */
export async function saveOrganization(data) {
  return await jsonClient.post('/organization', data)
}

/**
 * 添加单个成员
 * @param {string} role - 角色名称
 * @param {string} name - 成员姓名
 */
export async function addOrganizationMember(role, name) {
  const formData = new FormData()
  formData.append('role', role)
  formData.append('name', name)
  return await apiClient.post('/organization/member', formData)
}

/**
 * 删除单个成员（逻辑删除）
 * @param {number} id - 成员ID
 */
export async function deleteOrganizationMember(id) {
  return await jsonClient.delete(`/organization/member/${id}`)
}

/**
 * 更新角色类型名称
 * @param {string} oldRoleName - 原角色名称
 * @param {string} newRoleName - 新角色名称
 */
export async function updateOrganizationRoleName(oldRoleName, newRoleName) {
  const formData = new FormData()
  formData.append('oldRoleName', oldRoleName)
  formData.append('newRoleName', newRoleName)
  return await apiClient.put('/organization/role', formData)
}

/**
 * 删除角色类型（逻辑删除该角色的所有成员）
 * @param {string} roleName - 角色名称
 */
export async function deleteOrganizationRole(roleName) {
  return await jsonClient.delete(`/organization/role/${encodeURIComponent(roleName)}`)
}

// ========== 实验室管理 ==========

/**
 * 获取实验室列表
 */
export async function getLaboratoryList() {
  return await jsonClient.get('/laboratory')
}

/**
 * 添加实验室（支持Base64图片）
 * @param {Object} data - 实验室数据
 * @param {string} data.name - 实验室名称（必填）
 * @param {File} data.image - 图片文件（可选，如果提供了imageUrl则不需要）
 * @param {string} data.imageUrl - Base64图片字符串（可选，优先于image）
 * @param {string} data.link - 链接地址（可选）
 * @param {number} data.sortOrder - 排序（可选）
 */
export async function addLaboratory(data) {
  const formData = new FormData()
  formData.append('name', data.name)
  
  // 优先使用 Base64 图片（来自裁剪）
  if (data.imageUrl && data.imageUrl.startsWith('data:image/')) {
    formData.append('imageUrl', data.imageUrl)
  } else if (data.image) {
    formData.append('image', data.image)
  }
  
  if (data.link) {
    formData.append('link', data.link)
  }
  if (data.sortOrder !== undefined) {
    formData.append('sortOrder', data.sortOrder)
  }
  
  return await apiClient.post('/laboratory', formData)
}

/**
 * 更新实验室（支持Base64图片）
 * @param {number} id - 实验室ID
 * @param {Object} data - 更新数据
 * @param {string} data.name - 实验室名称（可选）
 * @param {File} data.image - 图片文件（可选，如果提供了imageUrl则不需要）
 * @param {string} data.imageUrl - Base64图片字符串（可选，优先于image）
 * @param {string} data.link - 链接地址（可选）
 * @param {number} data.sortOrder - 排序（可选）
 */
export async function updateLaboratory(id, data) {
  const formData = new FormData()
  
  if (data.name) {
    formData.append('name', data.name)
  }
  
  // 优先使用 Base64 图片（来自裁剪）
  if (data.imageUrl && data.imageUrl.startsWith('data:image/')) {
    formData.append('imageUrl', data.imageUrl)
  } else if (data.image) {
    formData.append('image', data.image)
  }
  
  if (data.link !== undefined) {
    formData.append('link', data.link || '')
  }
  if (data.sortOrder !== undefined) {
    formData.append('sortOrder', data.sortOrder)
  }
  
  return await apiClient.put(`/laboratory/${id}`, formData)
}

/**
 * 删除实验室
 * @param {number} id - 实验室ID
 */
export async function deleteLaboratory(id) {
  return await jsonClient.delete(`/laboratory/${id}`)
}

