package com.example.controller;

import com.example.service.ModuleNewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api/module-news")
@CrossOrigin(origins = "http://localhost:3000")
public class ModuleNewsController {
    
    @Autowired
    private ModuleNewsService moduleNewsService;
    
    /**
     * 获取菜单的新闻列表
     */
    @GetMapping("/menu/{menuId}")
    public Map<String, Object> getNewsListByMenuId(@PathVariable Long menuId) {
        return moduleNewsService.getNewsListByMenuId(menuId);
    }
    
    /**
     * 添加新闻
     */
    @PostMapping("/menu/{menuId}")
    public Map<String, Object> addNews(@PathVariable Long menuId, @RequestBody Map<String, Object> request) {
        try {
            return moduleNewsService.addNews(menuId, request);
        } catch (IOException e) {
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("success", false);
            result.put("message", "处理内容中的图片失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 更新新闻
     */
    @PutMapping("/{id}")
    public Map<String, Object> updateNews(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        try {
            return moduleNewsService.updateNews(id, request);
        } catch (IOException e) {
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("success", false);
            result.put("message", "处理内容中的图片失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除新闻
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteNews(@PathVariable Long id) {
        return moduleNewsService.deleteNews(id);
    }
}

