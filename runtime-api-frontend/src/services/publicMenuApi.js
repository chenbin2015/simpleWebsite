import axios from 'axios'

// 配置 axios 实例（用于公开API，不需要token）
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/public/menu',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

/**
 * 获取所有菜单
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

