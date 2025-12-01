import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'

// 配置 axios 实例
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/module-news',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
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
    console.error('Module News API Error:', error)
    
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

// ========== 通用模块新闻管理 ==========

/**
 * 获取菜单的新闻列表
 * @param {number} menuId - 菜单ID
 */
export async function getNewsListByMenuId(menuId) {
  return await apiClient.get(`/menu/${menuId}`)
}

/**
 * 添加新闻
 * @param {number} menuId - 菜单ID
 * @param {object} data - 新闻数据
 */
export async function addNews(menuId, data) {
  return await apiClient.post(`/menu/${menuId}`, data)
}

/**
 * 更新新闻
 * @param {number} id - 新闻ID
 * @param {object} data - 新闻数据
 */
export async function updateNews(id, data) {
  return await apiClient.put(`/${id}`, data)
}

/**
 * 删除新闻
 * @param {number} id - 新闻ID
 */
export async function deleteNews(id) {
  return await apiClient.delete(`/${id}`)
}

