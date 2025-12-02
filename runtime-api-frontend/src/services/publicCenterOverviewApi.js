import axios from 'axios'

// 配置 axios 实例（用于公开API，不需要token）
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/public/center-overview',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

/**
 * 获取Banner
 */
export async function getBanner() {
  return await apiClient.get('/banner')
}

/**
 * 获取详情
 */
export async function getDetail() {
  return await apiClient.get('/detail')
}

/**
 * 获取组织架构
 */
export async function getOrganization() {
  return await apiClient.get('/organization')
}

/**
 * 获取实验室列表
 */
export async function getLaboratoryList() {
  return await apiClient.get('/laboratory')
}

