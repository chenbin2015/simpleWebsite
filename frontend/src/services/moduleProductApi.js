import { createJsonClient } from './apiClient'

// 创建 JSON 请求客户端
const apiClient = createJsonClient('/module-products')

// ========== 通用模块产品管理 ==========

/**
 * 获取菜单的产品列表
 * @param {number} menuId - 菜单ID
 */
export async function getProductListByMenuId(menuId) {
  return await apiClient.get(`/menu/${menuId}`)
}

/**
 * 添加产品
 * @param {number} menuId - 菜单ID
 * @param {object} data - 产品数据
 */
export async function addProduct(menuId, data) {
  return await apiClient.post(`/menu/${menuId}`, data)
}

/**
 * 更新产品
 * @param {number} id - 产品ID
 * @param {object} data - 产品数据
 */
export async function updateProduct(id, data) {
  return await apiClient.put(`/${id}`, data)
}

/**
 * 删除产品
 * @param {number} id - 产品ID
 */
export async function deleteProduct(id) {
  return await apiClient.delete(`/${id}`)
}

