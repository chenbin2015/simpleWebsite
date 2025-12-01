package com.example.service;

import com.example.entity.Content;
import com.example.entity.Menu;
import com.example.repository.ContentRepository;
import com.example.repository.MenuRepository;
import com.example.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
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
            Map<String, Object> contentMap = new HashMap<>();
            contentMap.put("id", content.getId());
            contentMap.put("menuId", content.getMenu().getId());
            contentMap.put("title", content.getTitle() != null ? content.getTitle() : "");
            contentMap.put("content", content.getContent() != null ? content.getContent() : "");
            contentMap.put("createdAt", content.getCreatedAt());
            contentMap.put("updatedAt", content.getUpdatedAt());
            
            result.put("success", true);
            result.put("content", contentMap);
        } else {
            Map<String, Object> contentMap = new HashMap<>();
            contentMap.put("id", null);
            contentMap.put("menuId", menuId);
            contentMap.put("title", "");
            contentMap.put("content", "");
            contentMap.put("createdAt", null);
            contentMap.put("updatedAt", null);
            
            result.put("success", true);
            result.put("content", contentMap);
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
        
        // 处理HTML内容中的Base64图片，转换为文件并替换为文件路径
        String processedContent = content;
        if (content != null && !content.isEmpty()) {
            try {
                processedContent = FileUploadUtil.processHtmlImages(content);
            } catch (IOException e) {
                result.put("success", false);
                result.put("message", "处理内容中的图片失败: " + e.getMessage());
                return result;
            }
        }
        
        Optional<Content> contentOpt = contentRepository.findByMenuId(menuId);
        Content contentEntity;
        
        if (contentOpt.isPresent()) {
            // 更新现有内容
            contentEntity = contentOpt.get();
            contentEntity.setTitle(title);
            contentEntity.setContent(processedContent);
        } else {
            // 创建新内容
            contentEntity = new Content(menu, title, processedContent);
        }
        
        contentEntity = contentRepository.save(contentEntity);
        
        Map<String, Object> contentMap = new HashMap<>();
        contentMap.put("id", contentEntity.getId());
        contentMap.put("menuId", contentEntity.getMenu().getId());
        contentMap.put("title", contentEntity.getTitle() != null ? contentEntity.getTitle() : "");
        contentMap.put("content", contentEntity.getContent() != null ? contentEntity.getContent() : "");
        contentMap.put("createdAt", contentEntity.getCreatedAt());
        contentMap.put("updatedAt", contentEntity.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "保存成功");
        result.put("content", contentMap);
        
        return result;
    }
}


