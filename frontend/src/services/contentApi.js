import { createJsonClient } from './apiClient'

// 创建 JSON 请求客户端
const apiClient = createJsonClient('/content')

// ========== 内容管理 ==========

/**
 * 获取菜单的内容
 * @param {number} menuId - 菜单ID
 */
export async function getContentByMenuId(menuId) {
  return await apiClient.get(`/menu/${menuId}`)
}

/**
 * 保存或更新内容
 * @param {number} menuId - 菜单ID
 * @param {string} title - 标题（图文模式下固定为菜单名称）
 * @param {string} content - 内容（HTML格式）
 */
export async function saveContent(menuId, title, content) {
  return await apiClient.post('/save', {
    menuId,
    title,
    content
  })
}

