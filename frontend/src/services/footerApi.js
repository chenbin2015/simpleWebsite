import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { clearAuthData } from '@/utils/auth'

// 配置 axios 实例
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/footer',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
apiClient.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
apiClient.interceptors.response.use(
  response => {
    return response.data
  },
  error => {
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
)

// ========== 联系方式管理 ==========

export async function getContact() {
  return await apiClient.get('/contact')
}

export async function saveContact(data) {
  return await apiClient.post('/contact', data)
}

// ========== 友情链接管理 ==========

export async function getLinkList() {
  return await apiClient.get('/link')
}

export async function getLinkById(id) {
  return await apiClient.get(`/link/${id}`)
}

export async function addLink(data) {
  return await apiClient.post('/link', data)
}

export async function updateLink(id, data) {
  return await apiClient.put(`/link/${id}`, data)
}

export async function deleteLink(id) {
  return await apiClient.delete(`/link/${id}`)
}

// ========== 基本信息管理 ==========

export async function getBasic() {
  return await apiClient.get('/basic')
}

export async function saveBasic(data) {
  return await apiClient.post('/basic', data)
}

