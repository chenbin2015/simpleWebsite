package com.example.controller;

import com.example.service.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/content")
@CrossOrigin(origins = "http://localhost:3000")
public class ContentController {
    
    @Autowired
    private ContentService contentService;
    
    /**
     * 获取菜单的内容
     */
    @GetMapping("/menu/{menuId}")
    public Map<String, Object> getContentByMenuId(@PathVariable Long menuId) {
        return contentService.getContentByMenuId(menuId);
    }
    
    /**
     * 保存或更新内容
     */
    @PostMapping("/save")
    public Map<String, Object> saveContent(@RequestBody Map<String, Object> request) {
        Long menuId = request.get("menuId") != null ? 
            ((Number) request.get("menuId")).longValue() : null;
        String title = (String) request.get("title");
        String content = (String) request.get("content");
        return contentService.saveContent(menuId, title, content);
    }
}


