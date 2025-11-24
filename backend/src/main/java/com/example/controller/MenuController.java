package com.example.controller;

import com.example.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/menu")
@CrossOrigin(origins = "http://localhost:3000")
public class MenuController {
    
    @Autowired
    private MenuService menuService;
    
    /**
     * 获取所有菜单
     */
    @GetMapping("/list")
    public Map<String, Object> getAllMenus() {
        List<Map<String, Object>> menus = menuService.getAllMenus();
        return Map.of(
            "success", true,
            "data", menus
        );
    }
    
    /**
     * 获取单个菜单详情
     */
    @GetMapping("/{id}")
    public Map<String, Object> getMenuById(@PathVariable Long id) {
        Map<String, Object> menu = menuService.getMenuById(id);
        if (menu == null) {
            return Map.of("success", false, "message", "菜单不存在");
        }
        return Map.of("success", true, "data", menu);
    }
    
    /**
     * 创建顶级菜单
     */
    @PostMapping("/top")
    public Map<String, Object> createTopMenu(@RequestBody Map<String, Object> request) {
        String name = (String) request.get("name");
        Integer sortOrder = request.get("sortOrder") != null ? 
            ((Number) request.get("sortOrder")).intValue() : null;
        return menuService.createTopMenu(name, sortOrder);
    }
    
    /**
     * 创建二级菜单
     */
    @PostMapping("/sub")
    public Map<String, Object> createSubMenu(@RequestBody Map<String, Object> request) {
        Long parentId = request.get("parentId") != null ? 
            ((Number) request.get("parentId")).longValue() : null;
        String name = (String) request.get("name");
        Integer sortOrder = request.get("sortOrder") != null ? 
            ((Number) request.get("sortOrder")).intValue() : null;
        return menuService.createSubMenu(parentId, name, sortOrder);
    }
    
    /**
     * 更新菜单
     */
    @PutMapping("/{id}")
    public Map<String, Object> updateMenu(
            @PathVariable Long id,
            @RequestBody Map<String, Object> request) {
        String name = (String) request.get("name");
        Integer sortOrder = request.get("sortOrder") != null ? 
            ((Number) request.get("sortOrder")).intValue() : null;
        Boolean isActive = request.get("isActive") != null ? 
            (Boolean) request.get("isActive") : null;
        return menuService.updateMenu(id, name, sortOrder, isActive);
    }
    
    /**
     * 删除菜单
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteMenu(@PathVariable Long id) {
        return menuService.deleteMenu(id);
    }
}


