import { getBackendBaseUrl } from '@/config/api'

/**
 * 构建完整的图片 URL
 * 生产环境下通过 Nginx 代理，返回相对路径
 * 
 * @param {string} imageUrl - 图片 URL（可能是相对路径、完整 URL 或 base64）
 * @returns {string} 图片 URL
 */
export function buildImageUrl(imageUrl) {
  if (!imageUrl) return ''
  
  if (imageUrl.startsWith('data:')) return imageUrl

  // 如果是完整 URL，提取路径部分（通过 Nginx 代理）
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
    try {
      const url = new URL(imageUrl)
      return url.pathname + url.search
    } catch (e) {
      return imageUrl
    }
  }

  // 相对路径：开发环境加后端地址，生产环境直接用相对路径
  const backendBaseUrl = getBackendBaseUrl()
  if (backendBaseUrl) {
    if (imageUrl.startsWith('/')) {
      return `${backendBaseUrl}${imageUrl}`
    }
    return `${backendBaseUrl}/${imageUrl}`
  }

  return imageUrl.startsWith('/') ? imageUrl : `/${imageUrl}`
}

/**
 * 从完整 URL 中提取后端路径（移除后端基础 URL）
 * 
 * @param {string} fullUrl - 完整的 URL
 * @returns {string} 后端路径（相对路径）
 */
export function extractBackendPath(fullUrl) {
  if (!fullUrl) return ''
  
  const backendBaseUrl = getBackendBaseUrl()
  
  // 如果是完整 URL，移除后端基础 URL
  if (fullUrl.startsWith(backendBaseUrl)) {
    return fullUrl.replace(backendBaseUrl, '')
  }
  
  // 如果已经是相对路径或 base64，直接返回
  return fullUrl
}

