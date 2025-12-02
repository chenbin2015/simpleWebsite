import { createJsonClient } from './apiClient'

// 创建 JSON 请求客户端
const apiClient = createJsonClient('/menu')

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

