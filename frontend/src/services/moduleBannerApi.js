import { createJsonClient, createUploadClient } from './apiClient'

// 创建 JSON 请求客户端
const jsonClient = createJsonClient('/module-banner')

// 创建文件上传客户端
const apiClient = createUploadClient('/module-banner', 30000)

// ========== Banner管理 ==========

/**
 * 获取指定分类的Banner
 * @param {string} category - 模块分类：experiment-teaching | experiment-resources | construction-results | safety-management
 */
export async function getBanner(category) {
  return await jsonClient.get(`/${category}`)
}

/**
 * 保存或更新Banner
 * @param {string} category - 模块分类
 * @param {Object} data - Banner数据
 * @param {string} data.type - 类型：image | video
 * @param {File} data.imageFile - 图片文件（type=image时，可选）
 * @param {string} data.imageUrl - Base64图片字符串（type=image时，可选，优先于imageFile）
 * @param {File} data.videoFile - 视频文件（type=video时，可选）
 * @param {string} data.videoUrlExternal - 外部视频URL（type=video时，可选）
 */
export async function saveBanner(category, data) {
  const formData = new FormData()
  formData.append('type', data.type)
  
  if (data.type === 'image') {
    // 如果提供了 Base64 图片，直接传递
    if (data.imageUrl && data.imageUrl.startsWith('data:image/')) {
      formData.append('imageUrl', data.imageUrl)
    } else if (data.imageFile) {
      // 否则使用文件上传
      formData.append('image', data.imageFile)
    }
  } else if (data.type === 'video') {
    if (data.videoFile) {
      formData.append('video', data.videoFile)
    }
    if (data.videoUrlExternal) {
      formData.append('videoUrlExternal', data.videoUrlExternal)
    }
  }
  
  return await apiClient.post(`/${category}`, formData)
}

/**
 * 删除Banner
 * @param {string} category - 模块分类
 */
export async function deleteBanner(category) {
  return await jsonClient.delete(`/${category}`)
}

