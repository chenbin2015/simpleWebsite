import { createJsonClient, createUploadClient } from './apiClient'

// 创建 JSON 请求客户端
const jsonClient = createJsonClient('/module-downloads')

// 创建文件上传客户端（下载文件上传可能需要更长时间）
const uploadClient = createUploadClient('/module-downloads', 60000)

// ========== 通用模块下载管理 ==========

/**
 * 获取菜单的下载列表
 * @param {number} menuId - 菜单ID
 */
export async function getDownloadListByMenuId(menuId) {
  return await jsonClient.get(`/menu/${menuId}`)
}

/**
 * 添加下载文件
 * @param {number} menuId - 菜单ID
 * @param {object} formData - FormData对象，包含name, file, category, fileType
 */
export async function addDownload(menuId, formData) {
  return await uploadClient.post(`/menu/${menuId}`, formData)
}

/**
 * 更新下载文件
 * @param {number} id - 文件ID
 * @param {object} formData - FormData对象，包含name, file(可选), category, fileType
 */
export async function updateDownload(id, formData) {
  return await uploadClient.put(`/${id}`, formData)
}

/**
 * 删除下载文件
 * @param {number} id - 文件ID
 */
export async function deleteDownload(id) {
  return await jsonClient.delete(`/${id}`)
}

