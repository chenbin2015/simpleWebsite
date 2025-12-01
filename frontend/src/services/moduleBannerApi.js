import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'

// 配置 axios 实例（用于文件上传）
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/module-banner',
  timeout: 30000, // 文件上传可能需要更长时间
  headers: {
    'Content-Type': 'multipart/form-data'
  }
})

// JSON请求的axios实例
const jsonClient = axios.create({
  baseURL: 'http://localhost:8080/api/module-banner',
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
    console.error('Module Banner API Error:', error)
    
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
 * 获取指定分类的Banner
 * @param {string} category - 模块分类：experiment-teaching | experiment-resources | construction-results | safety-management
 */
export async function getBanner(category) {
  return await jsonClient.get(`/${category}`)
}

/**
 * 保存或更新Banner
 * @param {string} category - 模块分类
 * @param {Object} data - Banner数据
 * @param {string} data.type - 类型：image | video
 * @param {File} data.imageFile - 图片文件（type=image时，可选）
 * @param {string} data.imageUrl - Base64图片字符串（type=image时，可选，优先于imageFile）
 * @param {File} data.videoFile - 视频文件（type=video时，可选）
 * @param {string} data.videoUrlExternal - 外部视频URL（type=video时，可选）
 */
export async function saveBanner(category, data) {
  const formData = new FormData()
  formData.append('type', data.type)
  
  if (data.type === 'image') {
    // 如果提供了 Base64 图片，直接传递
    if (data.imageUrl && data.imageUrl.startsWith('data:image/')) {
      formData.append('imageUrl', data.imageUrl)
    } else if (data.imageFile) {
      // 否则使用文件上传
      formData.append('image', data.imageFile)
    }
  } else if (data.type === 'video') {
    if (data.videoFile) {
      formData.append('video', data.videoFile)
    }
    if (data.videoUrlExternal) {
      formData.append('videoUrlExternal', data.videoUrlExternal)
    }
  }
  
  return await apiClient.post(`/${category}`, formData)
}

/**
 * 删除Banner
 * @param {string} category - 模块分类
 */
export async function deleteBanner(category) {
  return await jsonClient.delete(`/${category}`)
}

