package com.example.controller;

import com.example.service.PopularScienceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 公开科普教育接口控制器
 * 用于前端访问，不需要token验证
 */
@RestController
@RequestMapping("/api/public/popular-science")
@CrossOrigin(origins = "*")
public class PublicPopularScienceController {
    
    @Autowired
    private PopularScienceService popularScienceService;
    
    /**
     * 获取Banner图
     */
    @GetMapping("/banner")
    public Map<String, Object> getBanner() {
        return popularScienceService.getBanner();
    }
    
    /**
     * 获取轮播图列表
     */
    @GetMapping("/carousel")
    public Map<String, Object> getCarouselList() {
        return popularScienceService.getCarouselList();
    }
    
    /**
     * 获取新闻列表（分页，只返回已发布的）
     */
    @GetMapping("/article")
    public Map<String, Object> getArticleList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword) {
        return popularScienceService.getArticleList(page, pageSize, "published", keyword);
    }
    
    /**
     * 获取公告列表（分页，只返回已发布的）
     */
    @GetMapping("/announcement")
    public Map<String, Object> getAnnouncementList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword) {
        return popularScienceService.getAnnouncementList(page, pageSize, "published", keyword);
    }
    
    /**
     * 获取新闻详情（只返回已发布的）
     */
    @GetMapping("/article/{id}")
    public Map<String, Object> getArticleById(@PathVariable Long id) {
        return popularScienceService.getArticleById(id);
    }
    
    /**
     * 获取公告详情（只返回已发布的）
     */
    @GetMapping("/announcement/{id}")
    public Map<String, Object> getAnnouncementById(@PathVariable Long id) {
        return popularScienceService.getAnnouncementById(id);
    }
}

