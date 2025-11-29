// 菜单配置
// 定义每个二级菜单组及其子菜单项
import { PAGE_TYPES } from './pageTypes'

export const menuGroups = {
  // 实验教学
  'experiment-teaching': {
    key: 'experiment-teaching',
    title: '实验教学',
    items: [
      { 
        key: 'course-system', 
        name: '课程体系', 
        icon: 'Document',
        pageType: PAGE_TYPES.IMAGE_TEXT,
        defaultId: '1'
      },
      { 
        key: 'experiment-course', 
        name: '实验课程', 
        icon: 'Reading',
        pageType: PAGE_TYPES.NEWS_LIST,
        defaultId: '2'
      }
    ]
  },
  // 实验资源
  'experiment-resources': {
    key: 'experiment-resources',
    title: '实验资源',
    items: [
      { 
        key: 'experiment-instruments', 
        name: '实验仪器', 
        icon: 'Box',
        pageType: PAGE_TYPES.PRODUCT_LIST,
        defaultId: '3'
      },
      { 
        key: 'experiment-space', 
        name: '实验空间', 
        icon: 'OfficeBuilding',
        pageType: PAGE_TYPES.IMAGE_TEXT,
        defaultId: '4'
      },
      { 
        key: 'open-sharing', 
        name: '开放共享', 
        icon: 'Share',
        pageType: PAGE_TYPES.DOWNLOAD_LIST,
        defaultId: '5'
      }
    ]
  },
  // 建设成效
  'construction-results': {
    key: 'construction-results',
    title: '建设成效',
    items: [
      { 
        key: 'teaching-reform', 
        name: '实验教学改革', 
        icon: 'Edit',
        pageType: PAGE_TYPES.NEWS_LIST,
        defaultId: '6'
      },
      { 
        key: 'research-innovation', 
        name: '科研创新成果', 
        icon: 'Trophy',
        pageType: PAGE_TYPES.NEWS_LIST,
        defaultId: '7'
      },
      { 
        key: 'environment-capability', 
        name: '实验环境与能力', 
        icon: 'Setting',
        pageType: PAGE_TYPES.IMAGE_TEXT,
        defaultId: '8'
      }
    ]
  },
  // 安全管理
  'safety-management': {
    key: 'safety-management',
    title: '安全管理',
    items: [
      { 
        key: 'safety-education', 
        name: '安全教育', 
        icon: 'School',
        pageType: PAGE_TYPES.NEWS_LIST,
        defaultId: '9'
      },
      { 
        key: 'safety-access', 
        name: '安全准入', 
        icon: 'Lock',
        pageType: PAGE_TYPES.DOWNLOAD_LIST,
        defaultId: '10'
      },
      { 
        key: 'management-system', 
        name: '管理制度', 
        icon: 'Files',
        pageType: PAGE_TYPES.DOWNLOAD_LIST,
        defaultId: '11'
      }
    ]
  }
}

// 生成路由路径
export function generateRoutePath(category, pageType, id = '1') {
  return `/${category}/${pageType}/${id}`
}

// 根据路径获取菜单组
export function getMenuGroupByPath(path) {
  const pathParts = path.split('/').filter(Boolean)
  if (pathParts.length < 1) return null
  
  const category = pathParts[0]
  return menuGroups[category] || null
}

// 判断路径是否有二级菜单
export function hasSubMenu(path) {
  return getMenuGroupByPath(path) !== null
}

// 获取默认路由路径（用于菜单链接）
export function getDefaultRoutePath(category, menuKey) {
  const menuGroup = menuGroups[category]
  if (!menuGroup) return '/'
  
  const menuItem = menuGroup.items.find(item => item.key === menuKey)
  if (!menuItem) return '/'
  
  return generateRoutePath(category, menuItem.pageType, menuItem.defaultId)
}
