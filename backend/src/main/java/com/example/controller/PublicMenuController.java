package com.example.controller;

import com.example.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 公开菜单接口控制器
 * 用于前端访问，不需要token验证
 */
@RestController
@RequestMapping("/api/public/menu")
@CrossOrigin(origins = "*")
public class PublicMenuController {
    
    @Autowired
    private MenuService menuService;
    
    /**
     * 获取所有菜单（仅返回未删除且激活的）
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
}

