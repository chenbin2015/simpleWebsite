/**
 * 认证工具类
 */

/**
 * 检查token是否过期
 */
export function isTokenExpired() {
  const expireTime = localStorage.getItem('tokenExpire')
  if (!expireTime) {
    return true
  }
  return Date.now() > parseInt(expireTime)
}

/**
 * 获取token
 */
export function getToken() {
  return localStorage.getItem('token')
}

/**
 * 清除认证信息
 */
export function clearAuth() {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  localStorage.removeItem('tokenExpire')
}

/**
 * 检查是否已登录
 */
export function isAuthenticated() {
  const token = getToken()
  if (!token) {
    return false
  }
  return !isTokenExpired()
}


