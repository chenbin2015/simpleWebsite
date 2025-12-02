import { getBackendBaseUrl } from '@/config/api'

/**
 * 构建完整的图片 URL
 * 如果图片 URL 是相对路径，则加上后端基础 URL
 * 
 * @param {string} imageUrl - 图片 URL（可能是相对路径、完整 URL 或 base64）
 * @returns {string} 完整的图片 URL
 */
export function buildImageUrl(imageUrl) {
  if (!imageUrl) return ''
  
  // 如果是完整 URL 或 base64，直接返回
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://') || imageUrl.startsWith('data:')) {
    return imageUrl
  }
  
  // 如果是相对路径，需要加上后端基础 URL
  const backendBaseUrl = getBackendBaseUrl()
  if (imageUrl.startsWith('/')) {
    return `${backendBaseUrl}${imageUrl}`
  }
  return `${backendBaseUrl}/${imageUrl}`
}

