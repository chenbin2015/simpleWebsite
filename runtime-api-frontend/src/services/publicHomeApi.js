import axios from 'axios'
import { getApiBaseUrl } from '@/config/api'

// 配置 axios 实例（用于公开API，不需要token）
const apiClient = axios.create({
  baseURL: `${getApiBaseUrl()}/public/home`,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

/**
 * 获取Banner图
 */
export async function getBanner() {
  return await apiClient.get('/banner')
}

/**
 * 获取轮播图列表
 */
export async function getCarouselList() {
  return await apiClient.get('/carousel')
}

/**
 * 获取新闻列表
 * @param {Object} params - 查询参数
 * @param {number} params.page - 页码，默认1
 * @param {number} params.pageSize - 每页数量，默认10
 * @param {string} params.keyword - 关键词搜索（可选）
 */
export async function getNewsList(params = {}) {
  const { page = 1, pageSize = 10, keyword } = params
  return await apiClient.get('/news', {
    params: {
      page,
      pageSize,
      keyword
    }
  })
}

/**
 * 获取新闻详情
 * @param {number} id - 新闻ID
 */
export async function getNewsById(id) {
  return await apiClient.get(`/news/${id}`)
}

/**
 * 获取公告列表
 * @param {Object} params - 查询参数
 * @param {number} params.page - 页码，默认1
 * @param {number} params.pageSize - 每页数量，默认10
 * @param {string} params.keyword - 关键词搜索（可选）
 */
export async function getAnnouncementList(params = {}) {
  const { page = 1, pageSize = 10, keyword } = params
  return await apiClient.get('/announcement', {
    params: {
      page,
      pageSize,
      keyword
    }
  })
}

/**
 * 获取公告详情
 * @param {number} id - 公告ID
 */
export async function getAnnouncementById(id) {
  return await apiClient.get(`/announcement/${id}`)
}

