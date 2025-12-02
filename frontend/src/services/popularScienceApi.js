import { createJsonClient } from './apiClient'

// 创建 JSON 请求客户端
const apiClient = createJsonClient('/popular-science')

// ========== Banner图管理 ==========

export async function getBanner() {
  return await apiClient.get('/banner')
}

export async function saveBanner(imageUrl) {
  return await apiClient.post('/banner', { imageUrl })
}

export async function deleteBanner() {
  return await apiClient.delete('/banner')
}

// ========== 轮播图管理 ==========

export async function getCarouselList() {
  return await apiClient.get('/carousel')
}

export async function saveCarouselList(carouselList) {
  return await apiClient.post('/carousel', { carouselList })
}

export async function deleteCarousel(id) {
  return await apiClient.delete(`/carousel/${id}`)
}

// ========== 新闻动态管理 ==========

export async function getArticleList(params = {}) {
  const { page = 1, pageSize = 10, status, keyword } = params
  const queryParams = { page, pageSize }
  if (status) queryParams.status = status
  if (keyword) queryParams.keyword = keyword
  
  return await apiClient.get('/article', { params: queryParams })
}

export async function getArticleById(id) {
  return await apiClient.get(`/article/${id}`)
}

export async function addArticle(data) {
  return await apiClient.post('/article', data)
}

export async function updateArticle(id, data) {
  return await apiClient.put(`/article/${id}`, data)
}

export async function deleteArticle(id) {
  return await apiClient.delete(`/article/${id}`)
}

// ========== 公告管理 ==========

export async function getAnnouncementList(params = {}) {
  const { page = 1, pageSize = 10, status, keyword } = params
  const queryParams = { page, pageSize }
  if (status) queryParams.status = status
  if (keyword) queryParams.keyword = keyword
  
  return await apiClient.get('/announcement', { params: queryParams })
}

export async function getAnnouncementById(id) {
  return await apiClient.get(`/announcement/${id}`)
}

export async function addAnnouncement(data) {
  return await apiClient.post('/announcement', data)
}

export async function updateAnnouncement(id, data) {
  return await apiClient.put(`/announcement/${id}`, data)
}

export async function deleteAnnouncement(id) {
  return await apiClient.delete(`/announcement/${id}`)
}

// ========== 视频管理 ==========

export async function getVideoList(params = {}) {
  const { page = 1, pageSize = 10, status, keyword } = params
  const queryParams = { page, pageSize }
  if (status) queryParams.status = status
  if (keyword) queryParams.keyword = keyword
  
  return await apiClient.get('/video', { params: queryParams })
}

export async function addVideo(data) {
  return await apiClient.post('/video', data)
}

export async function updateVideo(id, data) {
  return await apiClient.put(`/video/${id}`, data)
}

export async function deleteVideo(id) {
  return await apiClient.delete(`/video/${id}`)
}

// ========== 活动管理 ==========

export async function getActivityList(params = {}) {
  const { page = 1, pageSize = 10, status, keyword } = params
  const queryParams = { page, pageSize }
  if (status) queryParams.status = status
  if (keyword) queryParams.keyword = keyword
  
  return await apiClient.get('/activity', { params: queryParams })
}

export async function addActivity(data) {
  return await apiClient.post('/activity', data)
}

export async function updateActivity(id, data) {
  return await apiClient.put(`/activity/${id}`, data)
}

export async function deleteActivity(id) {
  return await apiClient.delete(`/activity/${id}`)
}

