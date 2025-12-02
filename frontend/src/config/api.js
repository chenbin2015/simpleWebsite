/**
 * API 配置文件
 * 统一管理后端 API 的基础 URL
 */

// 开发环境配置
// const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://116.62.13.27:8084'
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8084'

// API 路径前缀
const API_PREFIX = '/api'

/**
 * 获取完整的 API 基础 URL
 * @returns {string} 例如: http://localhost:8080/api
 */
export function getApiBaseUrl() {
  return `${API_BASE_URL}${API_PREFIX}`
}

/**
 * 获取后端服务器基础 URL（不含 /api 前缀）
 * @returns {string} 例如: http://localhost:8080
 */
export function getBackendBaseUrl() {
  return API_BASE_URL
}

/**
 * 导出配置常量
 */
export const API_CONFIG = {
  BASE_URL: API_BASE_URL,
  API_PREFIX: API_PREFIX,
  FULL_API_URL: getApiBaseUrl()
}

