import { PAGE_TYPES } from '@/config/pageTypes'

/**
 * 菜单名称到rootType的映射
 */
export const menuNameToRootType = {
  '实验教学': 'experiment-teaching',
  '实验资源': 'experiment-resources',
  '建设成效': 'construction-results',
  '安全管理': 'safety-management'
}

/**
 * rootType到菜单名称的反向映射
 */
export const rootTypeToMenuName = Object.fromEntries(
  Object.entries(menuNameToRootType).map(([name, type]) => [type, name])
)

/**
 * 将后端菜单数据转换为前端需要的格式
 * @param {Array} backendMenus - 后端返回的菜单列表
 * @returns {Object} - 转换后的菜单组对象，格式类似 menuGroups
 */
export function convertBackendMenusToMenuGroups(backendMenus) {
  const menuGroups = {}
  
  backendMenus.forEach(menu => {
    // 只处理有子菜单的顶级菜单
    if (!menu.parent && menu.children && menu.children.length > 0) {
      const rootType = menuNameToRootType[menu.name]
      
      // 只处理已知的通用模块菜单
      if (rootType) {
        const items = menu.children
          .filter(child => child.isActive !== false) // 只包含激活的子菜单
          .sort((a, b) => (a.sortOrder || 0) - (b.sortOrder || 0)) // 按排序顺序
          .map((child, index) => {
            // 生成key（使用菜单ID或索引）
            const key = child.id ? `menu-${child.id}` : `item-${index}`
            
            // 映射pageType
            let pageType = PAGE_TYPES.NEWS_LIST // 默认值
            if (child.pageType) {
              // 后端pageType可能直接是字符串，需要映射
              const pageTypeMap = {
                'news-list': PAGE_TYPES.NEWS_LIST,
                'product-list': PAGE_TYPES.PRODUCT_LIST,
                'image-text': PAGE_TYPES.IMAGE_TEXT,
                'download-list': PAGE_TYPES.DOWNLOAD_LIST
              }
              pageType = pageTypeMap[child.pageType] || child.pageType
            }
            
            return {
              key,
              name: child.name,
              icon: getIconByPageType(pageType),
              pageType,
              defaultId: String(child.id) // 使用菜单ID作为defaultId
            }
          })
        
        menuGroups[rootType] = {
          key: rootType,
          title: menu.name,
          items
        }
      }
    }
  })
  
  return menuGroups
}

/**
 * 根据pageType获取图标名称
 */
function getIconByPageType(pageType) {
  const iconMap = {
    [PAGE_TYPES.NEWS_LIST]: 'Reading',
    [PAGE_TYPES.PRODUCT_LIST]: 'Box',
    [PAGE_TYPES.IMAGE_TEXT]: 'Document',
    [PAGE_TYPES.DOWNLOAD_LIST]: 'Download'
  }
  return iconMap[pageType] || 'Document'
}

/**
 * 将后端菜单数据转换为顶部菜单格式
 * @param {Array} backendMenus - 后端返回的菜单列表
 * @returns {Array} - 顶部菜单数组
 */
export function convertBackendMenusToTopMenus(backendMenus) {
  const result = []
  
  // 菜单名称到路由路径的映射（用于没有子菜单的菜单）
  const menuPathMap = {
    '首页': '/',
    '中心概况': '/center-overview',
    '科普教育': '/popular-science'
  }
  
  // 将后端菜单转换为菜单对象
  backendMenus.forEach(menu => {
    if (!menu.parent) {
      const rootType = menuNameToRootType[menu.name]
      
      // 处理通用模块菜单（有子菜单的）
      if (rootType && menu.children && menu.children.length > 0) {
        const children = menu.children
          .filter(child => child.isActive !== false)
          .sort((a, b) => (a.sortOrder || 0) - (b.sortOrder || 0))
          .map(child => ({
            key: `menu-${child.id}`,
            name: child.name,
            id: child.id,
            pageType: child.pageType
          }))
        
        result.push({
          name: menu.name,
          path: '',
          rootType: rootType,
          children,
          sortOrder: menu.sortOrder || 999
        })
      }
      // 处理没有子菜单的菜单（首页、中心概况、科普教育等）
      else {
        result.push({
          name: menu.name,
          path: menuPathMap[menu.name] || '',
          rootType: null,
          children: [],
          sortOrder: menu.sortOrder || 999
        })
      }
    }
  })
  
  // 按sortOrder排序
  result.sort((a, b) => (a.sortOrder || 999) - (b.sortOrder || 999))
  
  return result
}

