package com.example.controller;

import com.example.service.ModuleProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api/module-products")
@CrossOrigin(origins = "http://localhost:3000")
public class ModuleProductController {
    
    @Autowired
    private ModuleProductService moduleProductService;
    
    /**
     * 获取菜单的产品列表
     */
    @GetMapping("/menu/{menuId}")
    public Map<String, Object> getProductListByMenuId(@PathVariable Long menuId) {
        return moduleProductService.getProductListByMenuId(menuId);
    }
    
    /**
     * 添加产品
     */
    @PostMapping("/menu/{menuId}")
    public Map<String, Object> addProduct(@PathVariable Long menuId, @RequestBody Map<String, Object> request) {
        try {
            return moduleProductService.addProduct(menuId, request);
        } catch (IOException e) {
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("success", false);
            result.put("message", "处理图片失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 更新产品
     */
    @PutMapping("/{id}")
    public Map<String, Object> updateProduct(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        try {
            return moduleProductService.updateProduct(id, request);
        } catch (IOException e) {
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("success", false);
            result.put("message", "处理图片失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除产品
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteProduct(@PathVariable Long id) {
        return moduleProductService.deleteProduct(id);
    }
}

