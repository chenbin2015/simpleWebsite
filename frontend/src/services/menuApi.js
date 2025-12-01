import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'

// 配置 axios 实例
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/menu',
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
    console.error('Menu API Error:', error)
    
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

// ========== 菜单管理 ==========

/**
 * 获取所有菜单（包括顶级菜单和子菜单）
 */
export async function getAllMenus() {
  return await apiClient.get('/list')
}

/**
 * 获取单个菜单详情
 * @param {number} id - 菜单ID
 */
export async function getMenuById(id) {
  return await apiClient.get(`/${id}`)
}

/**
 * 创建顶级菜单
 * @param {string} name - 菜单名称
 * @param {number} sortOrder - 排序顺序（可选）
 */
export async function createTopMenu(name, sortOrder = null) {
  return await apiClient.post('/top', {
    name,
    sortOrder
  })
}

/**
 * 创建二级菜单
 * @param {number} parentId - 父菜单ID
 * @param {string} name - 菜单名称
 * @param {number} sortOrder - 排序顺序（可选）
 * @param {string} pageType - 页面类型（可选）
 */
export async function createSubMenu(parentId, name, sortOrder = null, pageType = null) {
  return await apiClient.post('/sub', {
    parentId,
    name,
    sortOrder,
    pageType
  })
}

/**
 * 更新菜单
 * @param {number} id - 菜单ID
 * @param {string} name - 菜单名称（可选）
 * @param {number} sortOrder - 排序顺序（可选）
 * @param {boolean} isActive - 是否激活（可选）
 * @param {string} pageType - 页面类型（可选）
 */
export async function updateMenu(id, name = null, sortOrder = null, isActive = null, pageType = null) {
  return await apiClient.put(`/${id}`, {
    name,
    sortOrder,
    isActive,
    pageType
  })
}

/**
 * 删除菜单
 * @param {number} id - 菜单ID
 */
export async function deleteMenu(id) {
  return await apiClient.delete(`/${id}`)
}

