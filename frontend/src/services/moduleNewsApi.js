import { createJsonClient } from './apiClient'

// 创建 JSON 请求客户端
const apiClient = createJsonClient('/module-news')

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

