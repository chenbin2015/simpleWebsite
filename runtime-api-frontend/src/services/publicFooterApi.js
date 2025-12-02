import axios from 'axios'

// 配置 axios 实例（用于公开API，不需要token）
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/public/footer',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

/**
 * 获取联系方式
 */
export async function getContact() {
  return await apiClient.get('/contact')
}

/**
 * 获取友情链接列表
 */
export async function getLinkList() {
  return await apiClient.get('/link')
}

/**
 * 获取基本信息（Logo、版权信息等）
 */
export async function getBasic() {
  return await apiClient.get('/basic')
}

