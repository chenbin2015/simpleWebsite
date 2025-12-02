import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'
import { getApiBaseUrl } from '@/config/api'

// 后端基础URL配置
const BASE_URL = getApiBaseUrl()

/**
 * 创建统一的 axios 实例
 * @param {string} basePath - API路径，例如 '/home', '/footer' 等
 * @param {Object} options - 额外配置选项
 * @param {number} options.timeout - 超时时间（毫秒），默认 10000
 * @param {string} options.contentType - Content-Type，'application/json' 或 'multipart/form-data'，默认 'application/json'
 * @returns {AxiosInstance} axios 实例
 */
export function createApiClient(basePath, options = {}) {
  const {
    timeout = 10000,
    contentType = 'application/json'
  } = options

  const apiClient = axios.create({
    baseURL: `${BASE_URL}${basePath}`,
    timeout,
    headers: {
      'Content-Type': contentType
    }
  })

  // 请求拦截器（添加 token）
  apiClient.interceptors.request.use(
    (config) => {
      const token = localStorage.getItem('token')
      if (token) {
        config.headers.Authorization = `Bearer ${token}`
      }
      return config
    },
    (error) => Promise.reject(error)
  )

  // 响应拦截器
  apiClient.interceptors.response.use(
    (response) => response.data,
    (error) => {
      console.error('API Error:', error)
      
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
  )

  return apiClient
}

/**
 * 创建 JSON 请求客户端（默认配置）
 * @param {string} basePath - API路径
 * @param {number} timeout - 超时时间，默认 10000
 * @returns {AxiosInstance} axios 实例
 */
export function createJsonClient(basePath, timeout = 10000) {
  return createApiClient(basePath, {
    timeout,
    contentType: 'application/json'
  })
}

/**
 * 创建文件上传客户端（用于 multipart/form-data）
 * @param {string} basePath - API路径
 * @param {number} timeout - 超时时间，默认 300000（5分钟）
 * @returns {AxiosInstance} axios 实例
 */
export function createUploadClient(basePath, timeout = 300000) {
  return createApiClient(basePath, {
    timeout,
    contentType: 'multipart/form-data'
  })
}

