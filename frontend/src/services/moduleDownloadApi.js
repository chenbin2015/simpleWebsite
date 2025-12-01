import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'

// 配置 axios 实例
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/module-downloads',
  timeout: 60000, // 文件上传可能需要更长时间
  headers: {
    'Content-Type': 'multipart/form-data'
  }
})

// 请求拦截器（添加 token）
const requestInterceptor = (config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
}

apiClient.interceptors.request.use(requestInterceptor, error => Promise.reject(error))

// 响应拦截器
const responseInterceptor = {
  success: (response) => response.data,
  error: (error) => {
    console.error('Module Download API Error:', error)
    
    // 处理401未授权错误
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请重新登录')
      clearAuthData()
      router.push('/admin/login')
      return Promise.reject(error)
    }
    
    // 处理其他错误
    if (error.response) {
      const message = error.response.data?.message || error.response.data?.error || '请求失败'
      ElMessage.error(message)
      return Promise.reject(error.response.data)
    }
    
    return Promise.reject(error)
  }
}

apiClient.interceptors.response.use(responseInterceptor.success, responseInterceptor.error)

// ========== 通用模块下载管理 ==========

/**
 * 获取菜单的下载列表
 * @param {number} menuId - 菜单ID
 */
export async function getDownloadListByMenuId(menuId) {
  // 获取请求使用 JSON 格式
  const token = localStorage.getItem('token')
  return await axios.get(`http://localhost:8080/api/module-downloads/menu/${menuId}`, {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': token ? `Bearer ${token}` : ''
    },
    timeout: 10000
  }).then(response => response.data)
}

/**
 * 添加下载文件
 * @param {number} menuId - 菜单ID
 * @param {object} formData - FormData对象，包含name, file, category, fileType
 */
export async function addDownload(menuId, formData) {
  const token = localStorage.getItem('token')
  return await apiClient.post(`/menu/${menuId}`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
      'Authorization': token ? `Bearer ${token}` : ''
    },
    timeout: 60000
  })
}

/**
 * 更新下载文件
 * @param {number} id - 文件ID
 * @param {object} formData - FormData对象，包含name, file(可选), category, fileType
 */
export async function updateDownload(id, formData) {
  const token = localStorage.getItem('token')
  return await apiClient.put(`/${id}`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
      'Authorization': token ? `Bearer ${token}` : ''
    },
    timeout: 60000
  })
}

/**
 * 删除下载文件
 * @param {number} id - 文件ID
 */
export async function deleteDownload(id) {
  const token = localStorage.getItem('token')
  return await axios.delete(`http://localhost:8080/api/module-downloads/${id}`, {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': token ? `Bearer ${token}` : ''
    },
    timeout: 10000
  }).then(response => response.data)
}

