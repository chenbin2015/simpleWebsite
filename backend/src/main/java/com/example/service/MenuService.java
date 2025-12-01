package com.example.service;

import com.example.entity.Menu;
import com.example.repository.MenuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MenuService {
    
    @Autowired
    private MenuRepository menuRepository;
    
    /**
     * 获取所有顶级菜单及其子菜单（仅返回未删除的）
     */
    public List<Map<String, Object>> getAllMenus() {
        List<Menu> topMenus = menuRepository.findByParentIsNullAndDeletedFalseOrderBySortOrderAsc();
        return topMenus.stream()
                .map(this::menuToMap)
                .collect(Collectors.toList());
    }
    
    /**
     * 获取单个菜单详情（仅返回未删除的）
     */
    public Map<String, Object> getMenuById(Long id) {
        Menu menu = menuRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (menu == null) {
            return null;
        }
        return menuToMap(menu);
    }
    
    /**
     * 创建顶级菜单
     */
    @Transactional
    public Map<String, Object> createTopMenu(String name, Integer sortOrder) {
        Map<String, Object> result = new HashMap<>();
        
        if (name == null || name.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "菜单名称不能为空");
            return result;
        }
        
        if (menuRepository.existsByNameAndParentIsNullAndDeletedFalse(name)) {
            result.put("success", false);
            result.put("message", "顶级菜单名称已存在");
            return result;
        }
        
        Menu menu = new Menu(name);
        menu.setSortOrder(sortOrder != null ? sortOrder : 0);
        menu.setIsActive(true);
        menu = menuRepository.save(menu);
        
        result.put("success", true);
        result.put("message", "创建成功");
        result.put("menu", menuToMap(menu));
        return result;
    }
    
    /**
     * 创建二级菜单
     */
    @Transactional
    public Map<String, Object> createSubMenu(Long parentId, String name, Integer sortOrder, String pageType) {
        Map<String, Object> result = new HashMap<>();
        
        if (name == null || name.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "菜单名称不能为空");
            return result;
        }
        
        Menu parent = menuRepository.findByIdAndDeletedFalse(parentId).orElse(null);
        if (parent == null) {
            result.put("success", false);
            result.put("message", "父菜单不存在");
            return result;
        }
        
        if (parent.getParent() != null) {
            result.put("success", false);
            result.put("message", "只能为顶级菜单添加子菜单");
            return result;
        }
        
        if (menuRepository.existsByNameAndParentIdAndDeletedFalse(name, parentId)) {
            result.put("success", false);
            result.put("message", "该父菜单下已存在同名子菜单");
            return result;
        }
        
        Menu menu = new Menu(name);
        menu.setParent(parent);
        menu.setSortOrder(sortOrder != null ? sortOrder : 0);
        menu.setIsActive(true);
        menu.setPageType(pageType);
        menu = menuRepository.save(menu);
        
        result.put("success", true);
        result.put("message", "创建成功");
        result.put("menu", menuToMap(menu));
        return result;
    }
    
    /**
     * 更新菜单
     */
    @Transactional
    public Map<String, Object> updateMenu(Long id, String name, Integer sortOrder, Boolean isActive, String pageType) {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        if (name != null && !name.trim().isEmpty()) {
            // 检查名称是否重复
            if (menu.getParent() == null) {
                if (menuRepository.existsByNameAndParentIsNullAndDeletedFalse(name) && !name.equals(menu.getName())) {
                    result.put("success", false);
                    result.put("message", "顶级菜单名称已存在");
                    return result;
                }
            } else {
                if (menuRepository.existsByNameAndParentIdAndDeletedFalse(name, menu.getParent().getId()) && !name.equals(menu.getName())) {
                    result.put("success", false);
                    result.put("message", "该父菜单下已存在同名子菜单");
                    return result;
                }
            }
            menu.setName(name);
        }
        
        if (sortOrder != null) {
            menu.setSortOrder(sortOrder);
        }
        
        if (isActive != null) {
            menu.setIsActive(isActive);
        }
        
        if (pageType != null) {
            menu.setPageType(pageType);
        }
        
        menu = menuRepository.save(menu);
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("menu", menuToMap(menu));
        return result;
    }
    
    /**
     * 删除菜单（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteMenu(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在或已被删除");
            return result;
        }
        
        // 逻辑删除：设置deleted为true，记录删除时间
        menu.setDeleted(true);
        menu.setDeletedAt(LocalDateTime.now());
        menuRepository.save(menu);
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    /**
     * 将Menu实体转换为Map
     */
    private Map<String, Object> menuToMap(Menu menu) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", menu.getId());
        map.put("name", menu.getName());
        map.put("sortOrder", menu.getSortOrder());
        map.put("isActive", menu.getIsActive());
        map.put("pageType", menu.getPageType());
        map.put("createdAt", menu.getCreatedAt());
        map.put("updatedAt", menu.getUpdatedAt());
        
        if (menu.getParent() != null) {
            Map<String, Object> parentMap = new HashMap<>();
            parentMap.put("id", menu.getParent().getId());
            parentMap.put("name", menu.getParent().getName());
            map.put("parent", parentMap);
        } else {
            map.put("parent", null);
        }
        
        // 只返回未删除的子菜单
        if (menu.getChildren() != null && !menu.getChildren().isEmpty()) {
            List<Map<String, Object>> children = menu.getChildren().stream()
                    .filter(child -> child.getDeleted() == null || !child.getDeleted())
                    .map(this::menuToMap)
                    .collect(Collectors.toList());
            map.put("children", children);
        } else {
            map.put("children", List.of());
        }
        
        return map;
    }
}


