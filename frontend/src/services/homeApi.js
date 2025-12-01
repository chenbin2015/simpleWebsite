import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'

// 配置 axios 实例（用于 JSON 请求）
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/home',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 配置 axios 实例（用于文件上传）
const uploadClient = axios.create({
  baseURL: 'http://localhost:8080/api/home',
  timeout: 300000, // 文件上传可能需要更长时间（5分钟）
  headers: {
    'Content-Type': 'multipart/form-data'
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
uploadClient.interceptors.request.use(requestInterceptor, error => Promise.reject(error))

// 响应拦截器
const responseInterceptor = {
  success: (response) => response.data,
  error: (error) => {
    console.error('API Error:', error)
    
    // 处理401未授权错误
    if (error.response && error.response.status === 401) {
      ElMessage.error('登录已过期，请重新登录')
      // 清除所有登录信息
      clearAuthData()
      // 跳转到登录页
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
uploadClient.interceptors.response.use(responseInterceptor.success, responseInterceptor.error)

// ========== Banner图管理 ==========

/**
 * 获取Banner图
 */
export async function getBanner() {
  return await apiClient.get('/banner')
}

/**
 * 保存或更新Banner图
 * @param {string} imageUrl - 图片URL（base64或服务器URL）
 */
export async function saveBanner(imageUrl) {
  return await apiClient.post('/banner', { imageUrl })
}

/**
 * 删除Banner图
 */
export async function deleteBanner() {
  return await apiClient.delete('/banner')
}

// ========== 轮播图管理 ==========

/**
 * 获取轮播图列表
 */
export async function getCarouselList() {
  return await apiClient.get('/carousel')
}

/**
 * 添加轮播图（支持批量）
 * @param {Array} carouselList - 轮播图列表
 */
export async function addCarousel(carouselList) {
  return await apiClient.post('/carousel', { carouselList })
}

/**
 * 更新轮播图
 * @param {number} id - 轮播图ID
 * @param {Object} data - 更新数据
 */
export async function updateCarousel(id, data) {
  return await apiClient.put(`/carousel/${id}`, data)
}

/**
 * 删除轮播图
 * @param {number} id - 轮播图ID
 */
export async function deleteCarousel(id) {
  return await apiClient.delete(`/carousel/${id}`)
}

// ========== 新闻列表管理 ==========

/**
 * 获取新闻列表（分页）
 * @param {Object} params - 查询参数
 * @param {number} params.page - 页码
 * @param {number} params.pageSize - 每页数量
 * @param {string} params.status - 状态筛选（可选）
 * @param {string} params.keyword - 关键词搜索（可选）
 */
export async function getNewsList(params = {}) {
  const { page = 1, pageSize = 10, status, keyword } = params
  const queryParams = { page, pageSize }
  if (status) queryParams.status = status
  if (keyword) queryParams.keyword = keyword
  
  return await apiClient.get('/news', { params: queryParams })
}

/**
 * 获取单个新闻详情
 * @param {number} id - 新闻ID
 */
export async function getNewsById(id) {
  return await apiClient.get(`/news/${id}`)
}

/**
 * 添加新闻
 * @param {Object} data - 新闻数据
 */
export async function addNews(data) {
  return await apiClient.post('/news', data)
}

/**
 * 更新新闻
 * @param {number} id - 新闻ID
 * @param {Object} data - 更新数据
 */
export async function updateNews(id, data) {
  return await apiClient.put(`/news/${id}`, data)
}

/**
 * 删除新闻
 * @param {number} id - 新闻ID
 */
export async function deleteNews(id) {
  return await apiClient.delete(`/news/${id}`)
}

// ========== 公告管理 ==========

/**
 * 获取公告列表（分页）
 * @param {Object} params - 查询参数
 * @param {number} params.page - 页码
 * @param {number} params.pageSize - 每页数量
 * @param {string} params.status - 状态筛选（可选）
 * @param {string} params.keyword - 关键词搜索（可选）
 */
export async function getAnnouncementList(params = {}) {
  const { page = 1, pageSize = 10, status, keyword } = params
  const queryParams = { page, pageSize }
  if (status) queryParams.status = status
  if (keyword) queryParams.keyword = keyword
  
  return await apiClient.get('/announcement', { params: queryParams })
}

/**
 * 获取单个公告详情
 * @param {number} id - 公告ID
 */
export async function getAnnouncementById(id) {
  return await apiClient.get(`/announcement/${id}`)
}

/**
 * 添加公告
 * @param {Object} data - 公告数据
 */
export async function addAnnouncement(data) {
  return await apiClient.post('/announcement', data)
}

/**
 * 更新公告
 * @param {number} id - 公告ID
 * @param {Object} data - 更新数据
 */
export async function updateAnnouncement(id, data) {
  return await apiClient.put(`/announcement/${id}`, data)
}

/**
 * 删除公告
 * @param {number} id - 公告ID
 */
export async function deleteAnnouncement(id) {
  return await apiClient.delete(`/announcement/${id}`)
}

// ========== 通用文件上传 ==========

/**
 * 上传文件（用于编辑器中的图片、视频等）
 * @param {File} file - 要上传的文件
 * @returns {Promise<Object>} 返回 { success: boolean, message: string, data: { filePath: string } }
 */
export async function uploadFile(file) {
  const formData = new FormData()
  formData.append('file', file)
  return await uploadClient.post('/upload', formData)
}

