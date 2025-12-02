import { createJsonClient } from './apiClient'

// 创建 JSON 请求客户端
const apiClient = createJsonClient('/footer')

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

