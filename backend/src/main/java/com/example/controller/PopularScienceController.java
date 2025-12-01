package com.example.controller;

import com.example.service.PopularScienceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/popular-science")
@CrossOrigin(origins = "*")
public class PopularScienceController {
    
    @Autowired
    private PopularScienceService popularScienceService;
    
    // ========== Banner图管理 ==========
    
    /**
     * 获取Banner图
     */
    @GetMapping("/banner")
    public Map<String, Object> getBanner() {
        return popularScienceService.getBanner();
    }
    
    /**
     * 保存或更新Banner图
     */
    @PostMapping("/banner")
    public Map<String, Object> saveBanner(@RequestBody Map<String, Object> request) {
        String imageUrl = (String) request.get("imageUrl");
        return popularScienceService.saveBanner(imageUrl);
    }
    
    /**
     * 删除Banner图
     */
    @DeleteMapping("/banner")
    public Map<String, Object> deleteBanner() {
        return popularScienceService.deleteBanner();
    }
    
    // ========== 轮播图管理 ==========
    
    /**
     * 获取轮播图列表
     */
    @GetMapping("/carousel")
    public Map<String, Object> getCarouselList() {
        return popularScienceService.getCarouselList();
    }
    
    /**
     * 保存轮播图列表（支持批量）
     */
    @PostMapping("/carousel")
    public Map<String, Object> saveCarouselList(@RequestBody Map<String, Object> request) {
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> carouselList = (List<Map<String, Object>>) request.get("carouselList");
        return popularScienceService.saveCarouselList(carouselList);
    }
    
    /**
     * 删除轮播图
     */
    @DeleteMapping("/carousel/{id}")
    public Map<String, Object> deleteCarousel(@PathVariable Long id) {
        return popularScienceService.deleteCarousel(id);
    }
    
    // ========== 新闻动态管理 ==========
    
    /**
     * 获取新闻列表（分页）
     */
    @GetMapping("/article")
    public Map<String, Object> getArticleList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        return popularScienceService.getArticleList(page, pageSize, status, keyword);
    }
    
    /**
     * 获取单个新闻详情
     */
    @GetMapping("/article/{id}")
    public Map<String, Object> getArticleById(@PathVariable Long id) {
        return popularScienceService.getArticleById(id);
    }
    
    /**
     * 添加新闻
     */
    @PostMapping("/article")
    public Map<String, Object> addArticle(@RequestBody Map<String, Object> request) {
        return popularScienceService.addArticle(request);
    }
    
    /**
     * 更新新闻
     */
    @PutMapping("/article/{id}")
    public Map<String, Object> updateArticle(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        return popularScienceService.updateArticle(id, request);
    }
    
    /**
     * 删除新闻
     */
    @DeleteMapping("/article/{id}")
    public Map<String, Object> deleteArticle(@PathVariable Long id) {
        return popularScienceService.deleteArticle(id);
    }
    
    // ========== 公告管理 ==========
    
    /**
     * 获取公告列表（分页）
     */
    @GetMapping("/announcement")
    public Map<String, Object> getAnnouncementList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        return popularScienceService.getAnnouncementList(page, pageSize, status, keyword);
    }
    
    /**
     * 获取单个公告详情
     */
    @GetMapping("/announcement/{id}")
    public Map<String, Object> getAnnouncementById(@PathVariable Long id) {
        return popularScienceService.getAnnouncementById(id);
    }
    
    /**
     * 添加公告
     */
    @PostMapping("/announcement")
    public Map<String, Object> addAnnouncement(@RequestBody Map<String, Object> request) {
        return popularScienceService.addAnnouncement(request);
    }
    
    /**
     * 更新公告
     */
    @PutMapping("/announcement/{id}")
    public Map<String, Object> updateAnnouncement(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        return popularScienceService.updateAnnouncement(id, request);
    }
    
    /**
     * 删除公告
     */
    @DeleteMapping("/announcement/{id}")
    public Map<String, Object> deleteAnnouncement(@PathVariable Long id) {
        return popularScienceService.deleteAnnouncement(id);
    }
    
    // ========== 视频管理 ==========
    
    /**
     * 获取视频列表（分页）
     */
    @GetMapping("/video")
    public Map<String, Object> getVideoList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        return popularScienceService.getVideoList(page, pageSize, status, keyword);
    }
    
    /**
     * 添加视频
     */
    @PostMapping("/video")
    public Map<String, Object> addVideo(@RequestBody Map<String, Object> request) {
        return popularScienceService.addVideo(request);
    }
    
    /**
     * 更新视频
     */
    @PutMapping("/video/{id}")
    public Map<String, Object> updateVideo(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        return popularScienceService.updateVideo(id, request);
    }
    
    /**
     * 删除视频
     */
    @DeleteMapping("/video/{id}")
    public Map<String, Object> deleteVideo(@PathVariable Long id) {
        return popularScienceService.deleteVideo(id);
    }
    
    // ========== 活动管理 ==========
    
    /**
     * 获取活动列表（分页）
     */
    @GetMapping("/activity")
    public Map<String, Object> getActivityList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        return popularScienceService.getActivityList(page, pageSize, status, keyword);
    }
    
    /**
     * 添加活动
     */
    @PostMapping("/activity")
    public Map<String, Object> addActivity(@RequestBody Map<String, Object> request) {
        return popularScienceService.addActivity(request);
    }
    
    /**
     * 更新活动
     */
    @PutMapping("/activity/{id}")
    public Map<String, Object> updateActivity(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        return popularScienceService.updateActivity(id, request);
    }
    
    /**
     * 删除活动
     */
    @DeleteMapping("/activity/{id}")
    public Map<String, Object> deleteActivity(@PathVariable Long id) {
        return popularScienceService.deleteActivity(id);
    }
}

