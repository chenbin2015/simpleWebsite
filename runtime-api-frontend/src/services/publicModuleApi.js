import axios from 'axios'

// 配置 axios 实例（用于公开API，不需要token）
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/public/module',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

/**
 * 获取模块Banner
 * @param {string} category - 分类：experiment-teaching, experiment-resources, construction-results, safety-management
 */
export async function getModuleBanner(category) {
  return await apiClient.get(`/banner/${category}`)
}

/**
 * 获取菜单的新闻列表
 * @param {number} menuId - 菜单ID
 */
export async function getModuleNewsList(menuId) {
  return await apiClient.get(`/news/menu/${menuId}`)
}

/**
 * 获取菜单的产品列表
 * @param {number} menuId - 菜单ID
 */
export async function getModuleProductList(menuId) {
  return await apiClient.get(`/products/menu/${menuId}`)
}

/**
 * 获取菜单的下载列表
 * @param {number} menuId - 菜单ID
 */
export async function getModuleDownloadList(menuId) {
  return await apiClient.get(`/downloads/menu/${menuId}`)
}

/**
 * 获取菜单的图文内容
 * @param {number} menuId - 菜单ID
 */
export async function getModuleContent(menuId) {
  return await apiClient.get(`/content/menu/${menuId}`)
}

