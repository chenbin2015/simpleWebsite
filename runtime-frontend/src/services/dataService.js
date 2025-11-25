// 数据服务：根据 id 查找对应的 pageType
import { fetchMockData } from './mockClient'

// 缓存 id 到 pageType 的映射
const idToPageTypeCache = new Map()
// 缓存 id 到 categoryKey 的映射（用于找到对应的菜单项）
const idToCategoryKeyCache = new Map()

/**
 * 根据 id 查找对应的 pageType
 * @param {string} id - 模块 ID
 * @returns {Promise<string|null>} pageType 或 null
 */
export async function getPageTypeById(id) {
  console.log('getPageTypeById 被调用，id:', id, 'type:', typeof id)
  // 如果缓存中有，直接返回
  if (idToPageTypeCache.has(id)) {
    const cached = idToPageTypeCache.get(id)
    console.log('从缓存获取 pageType:', cached)
    return cached
  }

  try {
    // 尝试从各个 mock 数据文件中查找
    const files = ['news-list.json', 'product-list.json', 'image-text.json', 'download-list.json']
    console.log('开始搜索文件:', files)
    
    for (const fileName of files) {
      try {
        const data = await fetchMockData(fileName)
        
        // 遍历数据结构查找 id
        for (const key in data) {
          const category = data[key]
          console.log(`检查 ${fileName} 中的 key:`, key, 'category:', category)
          
          // 检查是否是列表结构
          if (category.items && Array.isArray(category.items)) {
            console.log(`在 ${fileName} 的 key ${key} 中找到 ${category.items.length} 个 items`)
            // 支持字符串和数字类型的 id 匹配
            const foundItem = category.items.find(item => {
              const match = String(item.id) === String(id) || item.id === id
              if (match) {
                console.log('找到匹配的 item:', item)
              }
              return match
            })
            if (foundItem) {
              // 根据文件名确定 pageType
              let pageType = null
              if (fileName === 'news-list.json') {
                pageType = 'news-list'
              } else if (fileName === 'product-list.json') {
                pageType = 'product-list'
              } else if (fileName === 'image-text.json') {
                pageType = 'image-text'
              } else if (fileName === 'download-list.json') {
                pageType = 'download-list'
              }
              
              if (pageType) {
                console.log('找到 pageType:', pageType, 'categoryKey:', key, '缓存结果')
                idToPageTypeCache.set(id, pageType)
                idToCategoryKeyCache.set(id, key) // 缓存 categoryKey
                return pageType
              }
            }
          }
          
          // 检查是否是直接的数据项（用于 image-text）
          if (category.id === id || key === id) {
            let pageType = null
            if (fileName === 'image-text.json') {
              pageType = 'image-text'
            }
            
            if (pageType) {
              idToPageTypeCache.set(id, pageType)
              return pageType
            }
          }
        }
      } catch (err) {
        // 继续查找下一个文件
        console.warn(`Failed to search in ${fileName}:`, err)
      }
    }
    
    return null
  } catch (err) {
    console.error('Failed to get pageType by id:', err)
    return null
  }
}

/**
 * 根据 id 查找对应的 categoryKey（数据分类的 key，对应菜单项的 defaultId）
 * @param {string} id - 模块 ID
 * @returns {Promise<string|null>} categoryKey 或 null
 */
export async function getCategoryKeyById(id) {
  // 如果缓存中有，直接返回
  if (idToCategoryKeyCache.has(id)) {
    return idToCategoryKeyCache.get(id)
  }
  
  // 如果 pageType 缓存中有，说明已经查找过，但 categoryKey 可能还没缓存
  // 需要重新查找并缓存 categoryKey
  if (idToPageTypeCache.has(id)) {
    // 重新查找以获取 categoryKey
    await getPageTypeById(id)
    return idToCategoryKeyCache.get(id) || null
  }
  
  // 如果都没有，先查找 pageType
  await getPageTypeById(id)
  return idToCategoryKeyCache.get(id) || null
}

