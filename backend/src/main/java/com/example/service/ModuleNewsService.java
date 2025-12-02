package com.example.service;

import com.example.entity.Menu;
import com.example.entity.ModuleNews;
import com.example.repository.MenuRepository;
import com.example.repository.ModuleNewsRepository;
import com.example.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ModuleNewsService {
    
    @Autowired
    private ModuleNewsRepository moduleNewsRepository;
    
    @Autowired
    private MenuRepository menuRepository;
    
    /**
     * 获取菜单的新闻列表
     */
    public Map<String, Object> getNewsListByMenuId(Long menuId) {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        List<ModuleNews> newsList = moduleNewsRepository.findByMenuIdAndDeletedFalseOrderByPublishTimeDesc(menuId);
        
        List<Map<String, Object>> data = newsList.stream().map(news -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", news.getId());
            item.put("title", news.getTitle());
            item.put("author", news.getAuthor());
            item.put("content", news.getContent());
            item.put("tags", parseTagsFromString(news.getTags()));
            item.put("summary", news.getSummary());
            item.put("status", news.getStatus());
            item.put("publishTime", news.getPublishTime() != null ? news.getPublishTime().toString() : null);
            item.put("date", news.getPublishTime() != null ? news.getPublishTime().toLocalDate().toString() : 
                      (news.getCreatedAt() != null ? news.getCreatedAt().toLocalDate().toString() : null));
            item.put("createdAt", news.getCreatedAt());
            item.put("updatedAt", news.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    /**
     * 获取单个模块新闻详情
     */
    public Map<String, Object> getNewsById(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        ModuleNews news = moduleNewsRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (news == null) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("id", news.getId());
        data.put("title", news.getTitle());
        data.put("author", news.getAuthor());
        data.put("content", news.getContent());
        data.put("tags", parseTagsFromString(news.getTags()));
        data.put("summary", news.getSummary());
        data.put("status", news.getStatus());
        data.put("publishTime", news.getPublishTime() != null ? news.getPublishTime().toString() : null);
        data.put("date", news.getPublishTime() != null ? news.getPublishTime().toLocalDate().toString() : 
                 (news.getCreatedAt() != null ? news.getCreatedAt().toLocalDate().toString() : null));
        data.put("createdAt", news.getCreatedAt());
        data.put("updatedAt", news.getUpdatedAt());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    /**
     * 添加新闻
     */
    @Transactional
    public Map<String, Object> addNews(Long menuId, Map<String, Object> data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        String title = (String) data.get("title");
        String author = (String) data.get("author");
        String content = (String) data.get("content");
        String tags = convertTagsToString(data.get("tags"));
        String summary = (String) data.get("summary");
        String status = data.get("status") != null ? (String) data.get("status") : "draft";
        
        // 处理日期字段
        LocalDateTime publishTime = null;
        if (data.get("date") != null) {
            try {
                String dateStr = (String) data.get("date");
                LocalDate date = LocalDate.parse(dateStr);
                publishTime = date.atStartOfDay();
            } catch (Exception e) {
                // 如果日期解析失败，忽略
            }
        }
        
        // 处理内容中的Base64图片，转换为文件
        String processedContent = content;
        if (content != null && !content.isEmpty()) {
            processedContent = FileUploadUtil.processHtmlImages(content);
        }
        
        ModuleNews news = new ModuleNews(menu, title, author, processedContent, tags, summary, status);
        if (publishTime != null) {
            news.setPublishTime(publishTime);
        }
        news = moduleNewsRepository.save(news);
        
        Map<String, Object> newsData = new HashMap<>();
        newsData.put("id", news.getId());
        newsData.put("title", news.getTitle());
        newsData.put("author", news.getAuthor());
        newsData.put("content", news.getContent());
        newsData.put("tags", parseTagsFromString(news.getTags()));
        newsData.put("summary", news.getSummary());
        newsData.put("status", news.getStatus());
        newsData.put("publishTime", news.getPublishTime() != null ? news.getPublishTime().toString() : null);
        newsData.put("date", news.getPublishTime() != null ? news.getPublishTime().toLocalDate().toString() : 
                     (news.getCreatedAt() != null ? news.getCreatedAt().toLocalDate().toString() : null));
        newsData.put("createdAt", news.getCreatedAt());
        newsData.put("updatedAt", news.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", newsData);
        return result;
    }
    
    /**
     * 更新新闻
     */
    @Transactional
    public Map<String, Object> updateNews(Long id, Map<String, Object> data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        ModuleNews news = moduleNewsRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (news == null) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        
        if (data.get("title") != null) {
            news.setTitle((String) data.get("title"));
        }
        if (data.get("author") != null) {
            news.setAuthor((String) data.get("author"));
        }
        if (data.get("content") != null) {
            String content = (String) data.get("content");
            // 处理内容中的Base64图片，转换为文件
            if (content != null && !content.isEmpty()) {
                content = FileUploadUtil.processHtmlImages(content);
            }
            news.setContent(content);
        }
        if (data.get("tags") != null) {
            news.setTags(convertTagsToString(data.get("tags")));
        }
        if (data.get("summary") != null) {
            news.setSummary((String) data.get("summary"));
        }
        if (data.get("status") != null) {
            news.setStatus((String) data.get("status"));
        }
        // 处理日期字段
        if (data.get("date") != null) {
            try {
                String dateStr = (String) data.get("date");
                LocalDate date = LocalDate.parse(dateStr);
                news.setPublishTime(date.atStartOfDay());
            } catch (Exception e) {
                // 如果日期解析失败，忽略
            }
        }
        
        news = moduleNewsRepository.save(news);
        
        Map<String, Object> newsData = new HashMap<>();
        newsData.put("id", news.getId());
        newsData.put("title", news.getTitle());
        newsData.put("author", news.getAuthor());
        newsData.put("content", news.getContent());
        newsData.put("tags", parseTagsFromString(news.getTags()));
        newsData.put("summary", news.getSummary());
        newsData.put("status", news.getStatus());
        newsData.put("publishTime", news.getPublishTime() != null ? news.getPublishTime().toString() : null);
        newsData.put("date", news.getPublishTime() != null ? news.getPublishTime().toLocalDate().toString() : 
                     (news.getCreatedAt() != null ? news.getCreatedAt().toLocalDate().toString() : null));
        newsData.put("createdAt", news.getCreatedAt());
        newsData.put("updatedAt", news.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", newsData);
        return result;
    }
    
    /**
     * 删除新闻（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteNews(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        ModuleNews news = moduleNewsRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (news == null) {
            result.put("success", false);
            result.put("message", "新闻不存在或已被删除");
            return result;
        }
        
        news.setDeleted(true);
        news.setDeletedAt(LocalDateTime.now());
        moduleNewsRepository.save(news);
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    /**
     * 将标签数组转换为JSON字符串
     */
    private String convertTagsToString(Object tags) {
        if (tags == null) {
            return null;
        }
        if (tags instanceof String) {
            return (String) tags;
        }
        if (tags instanceof List) {
            try {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                return mapper.writeValueAsString(tags);
            } catch (Exception e) {
                return "[]";
            }
        }
        return null;
    }
    
    /**
     * 将JSON字符串解析为标签数组
     */
    @SuppressWarnings("unchecked")
    private List<String> parseTagsFromString(String tagsStr) {
        if (tagsStr == null || tagsStr.trim().isEmpty()) {
            return List.of();
        }
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            return mapper.readValue(tagsStr, List.class);
        } catch (Exception e) {
            return List.of();
        }
    }
}

