/**
 * 认证相关工具函数
 */

/**
 * 清除所有登录信息
 * 包括 localStorage 和 sessionStorage 中的所有登录相关数据
 */
export function clearAuthData() {
  // 清除 localStorage 中的登录相关数据
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  localStorage.removeItem('user')
  localStorage.removeItem('currentUser')
  localStorage.removeItem('username')
  localStorage.removeItem('userId')
  
  // 清除 sessionStorage 中的登录相关数据
  sessionStorage.removeItem('token')
  sessionStorage.removeItem('userInfo')
  sessionStorage.removeItem('user')
  sessionStorage.removeItem('currentUser')
  sessionStorage.removeItem('username')
  sessionStorage.removeItem('userId')
  
  // 清除所有可能的登录相关键（以防有遗漏）
  // 遍历 localStorage 和 sessionStorage 清除所有以特定前缀开头的项
  const authKeys = ['token', 'user', 'auth', 'login', 'session']
  const storageKeys = []
  
  // 收集 localStorage 中所有可能的认证相关键
  for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i)
    if (key && authKeys.some(authKey => key.toLowerCase().includes(authKey))) {
      storageKeys.push({ storage: localStorage, key })
    }
  }
  
  // 收集 sessionStorage 中所有可能的认证相关键
  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i)
    if (key && authKeys.some(authKey => key.toLowerCase().includes(authKey))) {
      storageKeys.push({ storage: sessionStorage, key })
    }
  }
  
  // 清除收集到的所有键
  storageKeys.forEach(({ storage, key }) => {
    storage.removeItem(key)
  })
}

/**
 * 检查用户是否已登录
 * @returns {boolean} 是否已登录
 */
export function isAuthenticated() {
  return !!localStorage.getItem('token')
}

/**
 * 获取 token
 * @returns {string|null} token
 */
export function getToken() {
  return localStorage.getItem('token')
}

/**
 * 保存 token
 * @param {string} token 
 */
export function setToken(token) {
  localStorage.setItem('token', token)
}

