package com.example.service;

import com.example.entity.Content;
import com.example.entity.Menu;
import com.example.repository.ContentRepository;
import com.example.repository.MenuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class ContentService {
    
    @Autowired
    private ContentRepository contentRepository;
    
    @Autowired
    private MenuRepository menuRepository;
    
    /**
     * 获取菜单的内容
     */
    public Map<String, Object> getContentByMenuId(Long menuId) {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findById(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        // 只能为二级菜单添加内容
        if (menu.getParent() == null) {
            result.put("success", false);
            result.put("message", "只能为二级菜单添加内容");
            return result;
        }
        
        Optional<Content> contentOpt = contentRepository.findByMenuId(menuId);
        if (contentOpt.isPresent()) {
            Content content = contentOpt.get();
            result.put("success", true);
            result.put("content", Map.of(
                "id", content.getId(),
                "menuId", content.getMenu().getId(),
                "title", content.getTitle() != null ? content.getTitle() : "",
                "content", content.getContent() != null ? content.getContent() : "",
                "createdAt", content.getCreatedAt(),
                "updatedAt", content.getUpdatedAt()
            ));
        } else {
            result.put("success", true);
            result.put("content", Map.of(
                "id", null,
                "menuId", menuId,
                "title", "",
                "content", "",
                "createdAt", null,
                "updatedAt", null
            ));
        }
        
        return result;
    }
    
    /**
     * 保存或更新内容
     */
    @Transactional
    public Map<String, Object> saveContent(Long menuId, String title, String content) {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findById(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        // 只能为二级菜单添加内容
        if (menu.getParent() == null) {
            result.put("success", false);
            result.put("message", "只能为二级菜单添加内容");
            return result;
        }
        
        Optional<Content> contentOpt = contentRepository.findByMenuId(menuId);
        Content contentEntity;
        
        if (contentOpt.isPresent()) {
            // 更新现有内容
            contentEntity = contentOpt.get();
            contentEntity.setTitle(title);
            contentEntity.setContent(content);
        } else {
            // 创建新内容
            contentEntity = new Content(menu, title, content);
        }
        
        contentEntity = contentRepository.save(contentEntity);
        
        result.put("success", true);
        result.put("message", "保存成功");
        result.put("content", Map.of(
            "id", contentEntity.getId(),
            "menuId", contentEntity.getMenu().getId(),
            "title", contentEntity.getTitle() != null ? contentEntity.getTitle() : "",
            "content", contentEntity.getContent() != null ? contentEntity.getContent() : "",
            "createdAt", contentEntity.getCreatedAt(),
            "updatedAt", contentEntity.getUpdatedAt()
        ));
        
        return result;
    }
}


