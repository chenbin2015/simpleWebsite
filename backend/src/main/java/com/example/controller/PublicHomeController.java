package com.example.controller;

import com.example.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 公开首页接口控制器
 * 用于前端访问，不需要token验证
 */
@RestController
@RequestMapping("/api/public/home")
@CrossOrigin(origins = "*")
public class PublicHomeController {
    
    @Autowired
    private HomeService homeService;
    
    /**
     * 获取Banner图
     */
    @GetMapping("/banner")
    public Map<String, Object> getBanner() {
        return homeService.getBanner();
    }
    
    /**
     * 获取轮播图列表
     */
    @GetMapping("/carousel")
    public Map<String, Object> getCarouselList() {
        return homeService.getCarouselList();
    }
    
    /**
     * 获取新闻列表（分页）
     */
    @GetMapping("/news")
    public Map<String, Object> getNewsList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        // 公开接口只返回已发布的新闻
        return homeService.getNewsList(page, pageSize, "published", keyword);
    }
    
    /**
     * 获取单个新闻详情
     */
    @GetMapping("/news/{id}")
    public Map<String, Object> getNewsById(@PathVariable Long id) {
        return homeService.getNewsById(id);
    }
    
    /**
     * 获取公告列表（分页）
     */
    @GetMapping("/announcement")
    public Map<String, Object> getAnnouncementList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        // 公开接口只返回已发布的公告
        return homeService.getAnnouncementList(page, pageSize, "published", keyword);
    }
    
    /**
     * 获取单个公告详情
     */
    @GetMapping("/announcement/{id}")
    public Map<String, Object> getAnnouncementById(@PathVariable Long id) {
        return homeService.getAnnouncementById(id);
    }
}

