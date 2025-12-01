package com.example.service;

import com.example.entity.*;
import com.example.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class PopularScienceService {
    
    @Autowired
    private PopularScienceBannerRepository bannerRepository;
    
    @Autowired
    private PopularScienceCarouselRepository carouselRepository;
    
    @Autowired
    private PopularScienceArticleRepository articleRepository;
    
    @Autowired
    private PopularScienceAnnouncementRepository announcementRepository;
    
    @Autowired
    private PopularScienceVideoRepository videoRepository;
    
    @Autowired
    private PopularScienceActivityRepository activityRepository;
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    /**
     * 将tags转换为JSON字符串
     */
    private String convertTagsToString(Object tags) {
        if (tags == null) {
            return null;
        }
        try {
            if (tags instanceof String) {
                return (String) tags;
            }
            return objectMapper.writeValueAsString(tags);
        } catch (Exception e) {
            return tags.toString();
        }
    }
    
    /**
     * 将tags的JSON字符串解析为对象
     */
    private Object parseTagsFromString(String tags) {
        if (tags == null || tags.isEmpty()) {
            return null;
        }
        try {
            return objectMapper.readValue(tags, Object.class);
        } catch (Exception e) {
            return tags;
        }
    }
    
    /**
     * 解析日期时间字符串
     */
    private LocalDateTime parseDateTime(String dateTimeStr) {
        if (dateTimeStr == null || dateTimeStr.isEmpty()) {
            return null;
        }
        try {
            return LocalDateTime.parse(dateTimeStr, dateTimeFormatter);
        } catch (Exception e) {
            try {
                return LocalDateTime.parse(dateTimeStr);
            } catch (Exception ex) {
                return null;
            }
        }
    }
    
    // ========== Banner图管理 ==========
    
    public Map<String, Object> getBanner() {
        Map<String, Object> result = new HashMap<>();
        List<PopularScienceBanner> banners = bannerRepository.findAll();
        if (banners.isEmpty()) {
            result.put("success", true);
            result.put("data", null);
        } else {
            PopularScienceBanner banner = banners.get(0);
            Map<String, Object> bannerData = new HashMap<>();
            bannerData.put("id", banner.getId());
            bannerData.put("imageUrl", banner.getImageUrl());
            bannerData.put("createdAt", banner.getCreatedAt());
            bannerData.put("updatedAt", banner.getUpdatedAt());
            result.put("success", true);
            result.put("data", bannerData);
        }
        return result;
    }
    
    @Transactional
    public Map<String, Object> saveBanner(String imageUrl) {
        Map<String, Object> result = new HashMap<>();
        bannerRepository.deleteAll();
        PopularScienceBanner banner = new PopularScienceBanner(imageUrl);
        banner = bannerRepository.save(banner);
        
        Map<String, Object> bannerData = new HashMap<>();
        bannerData.put("id", banner.getId());
        bannerData.put("imageUrl", banner.getImageUrl());
        bannerData.put("createdAt", banner.getCreatedAt());
        bannerData.put("updatedAt", banner.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "保存成功");
        result.put("data", bannerData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> deleteBanner() {
        Map<String, Object> result = new HashMap<>();
        bannerRepository.deleteAll();
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 轮播图管理 ==========
    
    public Map<String, Object> getCarouselList() {
        Map<String, Object> result = new HashMap<>();
        List<PopularScienceCarousel> carousels = carouselRepository.findAllOrderBySort();
        List<Map<String, Object>> data = carousels.stream().map(c -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", c.getId());
            item.put("image", c.getImage());
            item.put("title", c.getTitle());
            item.put("link", c.getLink() != null ? c.getLink() : "");
            item.put("sort", c.getSort());
            item.put("createdAt", c.getCreatedAt());
            item.put("updatedAt", c.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    @Transactional
    public Map<String, Object> saveCarouselList(List<Map<String, Object>> carouselList) {
        Map<String, Object> result = new HashMap<>();
        
        // 先删除所有现有的轮播图
        carouselRepository.deleteAll();
        
        for (Map<String, Object> item : carouselList) {
            String image = (String) item.get("image");
            String title = (String) item.get("title");
            String link = item.get("link") != null ? (String) item.get("link") : "";
            Integer sort = item.get("sort") != null ? ((Number) item.get("sort")).intValue() : 0;
            
            PopularScienceCarousel carousel = new PopularScienceCarousel(image, title, link, sort);
            carouselRepository.save(carousel);
        }
        
        result.put("success", true);
        result.put("message", "保存成功");
        return result;
    }
    
    @Transactional
    public Map<String, Object> deleteCarousel(Long id) {
        Map<String, Object> result = new HashMap<>();
        if (!carouselRepository.existsById(id)) {
            result.put("success", false);
            result.put("message", "轮播图不存在");
            return result;
        }
        carouselRepository.deleteById(id);
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 新闻动态管理 ==========
    
    public Map<String, Object> getArticleList(Integer page, Integer pageSize, String status, String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Page<PopularScienceArticle> articlePage;
        
        if ((status == null || status.isEmpty()) && (keyword == null || keyword.isEmpty())) {
            articlePage = articleRepository.findAll(pageable);
        } else {
            articlePage = articleRepository.findByStatusAndKeyword(status, keyword, pageable);
        }
        
        List<Map<String, Object>> data = articlePage.getContent().stream().map(a -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", a.getId());
            item.put("title", a.getTitle());
            item.put("author", a.getAuthor());
            item.put("content", a.getContent());
            item.put("tags", parseTagsFromString(a.getTags()));
            item.put("status", a.getStatus());
            item.put("publishTime", a.getPublishTime() != null ? a.getPublishTime().toString() : null);
            item.put("createdAt", a.getCreatedAt());
            item.put("updatedAt", a.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        result.put("total", articlePage.getTotalElements());
        result.put("page", page);
        result.put("pageSize", pageSize);
        
        return result;
    }
    
    public Map<String, Object> getArticleById(Long id) {
        Map<String, Object> result = new HashMap<>();
        PopularScienceArticle article = articleRepository.findById(id).orElse(null);
        if (article == null) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("id", article.getId());
        data.put("title", article.getTitle());
        data.put("author", article.getAuthor());
        data.put("content", article.getContent());
        data.put("tags", parseTagsFromString(article.getTags()));
        data.put("status", article.getStatus());
        data.put("publishTime", article.getPublishTime() != null ? article.getPublishTime().toString() : null);
        data.put("createdAt", article.getCreatedAt());
        data.put("updatedAt", article.getUpdatedAt());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    @Transactional
    public Map<String, Object> addArticle(Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        String title = (String) data.get("title");
        String author = (String) data.get("author");
        String content = (String) data.get("content");
        String tags = convertTagsToString(data.get("tags"));
        String status = data.get("status") != null ? (String) data.get("status") : "draft";
        
        PopularScienceArticle article = new PopularScienceArticle(title, author, content, tags, status);
        article = articleRepository.save(article);
        
        Map<String, Object> articleData = new HashMap<>();
        articleData.put("id", article.getId());
        articleData.put("title", article.getTitle());
        articleData.put("author", article.getAuthor());
        articleData.put("content", article.getContent());
        articleData.put("tags", parseTagsFromString(article.getTags()));
        articleData.put("status", article.getStatus());
        articleData.put("publishTime", article.getPublishTime() != null ? article.getPublishTime().toString() : null);
        articleData.put("createdAt", article.getCreatedAt());
        articleData.put("updatedAt", article.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", articleData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> updateArticle(Long id, Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        PopularScienceArticle article = articleRepository.findById(id).orElse(null);
        if (article == null) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        
        if (data.containsKey("title")) {
            article.setTitle((String) data.get("title"));
        }
        if (data.containsKey("author")) {
            article.setAuthor((String) data.get("author"));
        }
        if (data.containsKey("content")) {
            article.setContent((String) data.get("content"));
        }
        if (data.containsKey("tags")) {
            article.setTags(convertTagsToString(data.get("tags")));
        }
        if (data.containsKey("status")) {
            article.setStatus((String) data.get("status"));
        }
        
        article = articleRepository.save(article);
        
        Map<String, Object> articleData = new HashMap<>();
        articleData.put("id", article.getId());
        articleData.put("title", article.getTitle());
        articleData.put("author", article.getAuthor());
        articleData.put("content", article.getContent());
        articleData.put("tags", parseTagsFromString(article.getTags()));
        articleData.put("status", article.getStatus());
        articleData.put("publishTime", article.getPublishTime() != null ? article.getPublishTime().toString() : null);
        articleData.put("createdAt", article.getCreatedAt());
        articleData.put("updatedAt", article.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", articleData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> deleteArticle(Long id) {
        Map<String, Object> result = new HashMap<>();
        if (!articleRepository.existsById(id)) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        articleRepository.deleteById(id);
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 公告管理 ==========
    
    public Map<String, Object> getAnnouncementList(Integer page, Integer pageSize, String status, String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Page<PopularScienceAnnouncement> announcementPage;
        
        if ((status == null || status.isEmpty()) && (keyword == null || keyword.isEmpty())) {
            announcementPage = announcementRepository.findAll(pageable);
        } else {
            announcementPage = announcementRepository.findByStatusAndKeyword(status, keyword, pageable);
        }
        
        List<Map<String, Object>> data = announcementPage.getContent().stream().map(a -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", a.getId());
            item.put("title", a.getTitle());
            item.put("content", a.getContent());
            item.put("status", a.getStatus());
            item.put("publishTime", a.getPublishTime() != null ? a.getPublishTime().toString() : null);
            item.put("createdAt", a.getCreatedAt());
            item.put("updatedAt", a.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        result.put("total", announcementPage.getTotalElements());
        result.put("page", page);
        result.put("pageSize", pageSize);
        
        return result;
    }
    
    public Map<String, Object> getAnnouncementById(Long id) {
        Map<String, Object> result = new HashMap<>();
        PopularScienceAnnouncement announcement = announcementRepository.findById(id).orElse(null);
        if (announcement == null) {
            result.put("success", false);
            result.put("message", "公告不存在");
            return result;
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("id", announcement.getId());
        data.put("title", announcement.getTitle());
        data.put("content", announcement.getContent());
        data.put("status", announcement.getStatus());
        data.put("publishTime", announcement.getPublishTime() != null ? announcement.getPublishTime().toString() : null);
        data.put("createdAt", announcement.getCreatedAt());
        data.put("updatedAt", announcement.getUpdatedAt());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    @Transactional
    public Map<String, Object> addAnnouncement(Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        String title = (String) data.get("title");
        String content = (String) data.get("content");
        String status = data.get("status") != null ? (String) data.get("status") : "draft";
        
        PopularScienceAnnouncement announcement = new PopularScienceAnnouncement(title, content, status);
        announcement = announcementRepository.save(announcement);
        
        Map<String, Object> announcementData = new HashMap<>();
        announcementData.put("id", announcement.getId());
        announcementData.put("title", announcement.getTitle());
        announcementData.put("content", announcement.getContent());
        announcementData.put("status", announcement.getStatus());
        announcementData.put("publishTime", announcement.getPublishTime() != null ? announcement.getPublishTime().toString() : null);
        announcementData.put("createdAt", announcement.getCreatedAt());
        announcementData.put("updatedAt", announcement.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", announcementData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> updateAnnouncement(Long id, Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        PopularScienceAnnouncement announcement = announcementRepository.findById(id).orElse(null);
        if (announcement == null) {
            result.put("success", false);
            result.put("message", "公告不存在");
            return result;
        }
        
        if (data.containsKey("title")) {
            announcement.setTitle((String) data.get("title"));
        }
        if (data.containsKey("content")) {
            announcement.setContent((String) data.get("content"));
        }
        if (data.containsKey("status")) {
            announcement.setStatus((String) data.get("status"));
        }
        
        announcement = announcementRepository.save(announcement);
        
        Map<String, Object> announcementData = new HashMap<>();
        announcementData.put("id", announcement.getId());
        announcementData.put("title", announcement.getTitle());
        announcementData.put("content", announcement.getContent());
        announcementData.put("status", announcement.getStatus());
        announcementData.put("publishTime", announcement.getPublishTime() != null ? announcement.getPublishTime().toString() : null);
        announcementData.put("createdAt", announcement.getCreatedAt());
        announcementData.put("updatedAt", announcement.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", announcementData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> deleteAnnouncement(Long id) {
        Map<String, Object> result = new HashMap<>();
        if (!announcementRepository.existsById(id)) {
            result.put("success", false);
            result.put("message", "公告不存在");
            return result;
        }
        announcementRepository.deleteById(id);
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 视频管理 ==========
    
    public Map<String, Object> getVideoList(Integer page, Integer pageSize, String status, String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Page<PopularScienceVideo> videoPage = videoRepository.findAll(pageable);
        
        List<Map<String, Object>> data = videoPage.getContent().stream()
            .filter(v -> (status == null || status.isEmpty() || v.getStatus().equals(status)))
            .filter(v -> (keyword == null || keyword.isEmpty() || 
                         v.getTitle().contains(keyword) || 
                         (v.getDescription() != null && v.getDescription().contains(keyword))))
            .map(v -> {
                Map<String, Object> item = new HashMap<>();
                item.put("id", v.getId());
                item.put("title", v.getTitle());
                item.put("cover", v.getCover());
                item.put("videoUrl", v.getVideoUrl());
                item.put("duration", v.getDuration());
                item.put("description", v.getDescription());
                item.put("status", v.getStatus());
                item.put("publishTime", v.getPublishTime() != null ? v.getPublishTime().toString() : null);
                item.put("createdAt", v.getCreatedAt());
                item.put("updatedAt", v.getUpdatedAt());
                return item;
            }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        result.put("total", data.size());
        result.put("page", page);
        result.put("pageSize", pageSize);
        
        return result;
    }
    
    @Transactional
    public Map<String, Object> addVideo(Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        String title = (String) data.get("title");
        String cover = (String) data.get("cover");
        String videoUrl = (String) data.get("videoUrl");
        String duration = (String) data.get("duration");
        String description = (String) data.get("description");
        String status = data.get("status") != null ? (String) data.get("status") : "draft";
        
        PopularScienceVideo video = new PopularScienceVideo(title, cover, videoUrl, duration, description, status);
        video = videoRepository.save(video);
        
        Map<String, Object> videoData = new HashMap<>();
        videoData.put("id", video.getId());
        videoData.put("title", video.getTitle());
        videoData.put("cover", video.getCover());
        videoData.put("videoUrl", video.getVideoUrl());
        videoData.put("duration", video.getDuration());
        videoData.put("description", video.getDescription());
        videoData.put("status", video.getStatus());
        videoData.put("publishTime", video.getPublishTime() != null ? video.getPublishTime().toString() : null);
        videoData.put("createdAt", video.getCreatedAt());
        videoData.put("updatedAt", video.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", videoData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> updateVideo(Long id, Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        PopularScienceVideo video = videoRepository.findById(id).orElse(null);
        if (video == null) {
            result.put("success", false);
            result.put("message", "视频不存在");
            return result;
        }
        
        if (data.containsKey("title")) {
            video.setTitle((String) data.get("title"));
        }
        if (data.containsKey("cover")) {
            video.setCover((String) data.get("cover"));
        }
        if (data.containsKey("videoUrl")) {
            video.setVideoUrl((String) data.get("videoUrl"));
        }
        if (data.containsKey("duration")) {
            video.setDuration((String) data.get("duration"));
        }
        if (data.containsKey("description")) {
            video.setDescription((String) data.get("description"));
        }
        if (data.containsKey("status")) {
            video.setStatus((String) data.get("status"));
        }
        
        video = videoRepository.save(video);
        
        Map<String, Object> videoData = new HashMap<>();
        videoData.put("id", video.getId());
        videoData.put("title", video.getTitle());
        videoData.put("cover", video.getCover());
        videoData.put("videoUrl", video.getVideoUrl());
        videoData.put("duration", video.getDuration());
        videoData.put("description", video.getDescription());
        videoData.put("status", video.getStatus());
        videoData.put("publishTime", video.getPublishTime() != null ? video.getPublishTime().toString() : null);
        videoData.put("createdAt", video.getCreatedAt());
        videoData.put("updatedAt", video.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", videoData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> deleteVideo(Long id) {
        Map<String, Object> result = new HashMap<>();
        if (!videoRepository.existsById(id)) {
            result.put("success", false);
            result.put("message", "视频不存在");
            return result;
        }
        videoRepository.deleteById(id);
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 活动管理 ==========
    
    public Map<String, Object> getActivityList(Integer page, Integer pageSize, String status, String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Page<PopularScienceActivity> activityPage = activityRepository.findAll(pageable);
        
        List<Map<String, Object>> data = activityPage.getContent().stream()
            .filter(a -> (status == null || status.isEmpty() || a.getStatus().equals(status)))
            .filter(a -> (keyword == null || keyword.isEmpty() || 
                         a.getTitle().contains(keyword) || 
                         (a.getContent() != null && a.getContent().contains(keyword))))
            .map(a -> {
                Map<String, Object> item = new HashMap<>();
                item.put("id", a.getId());
                item.put("title", a.getTitle());
                item.put("cover", a.getCover());
                item.put("location", a.getLocation());
                item.put("startTime", a.getStartTime() != null ? a.getStartTime().toString() : null);
                item.put("endTime", a.getEndTime() != null ? a.getEndTime().toString() : null);
                item.put("content", a.getContent());
                item.put("status", a.getStatus());
                item.put("publishTime", a.getPublishTime() != null ? a.getPublishTime().toString() : null);
                item.put("createdAt", a.getCreatedAt());
                item.put("updatedAt", a.getUpdatedAt());
                return item;
            }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        result.put("total", data.size());
        result.put("page", page);
        result.put("pageSize", pageSize);
        
        return result;
    }
    
    @Transactional
    public Map<String, Object> addActivity(Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        String title = (String) data.get("title");
        String cover = (String) data.get("cover");
        String location = (String) data.get("location");
        LocalDateTime startTime = parseDateTime((String) data.get("startTime"));
        LocalDateTime endTime = parseDateTime((String) data.get("endTime"));
        String content = (String) data.get("content");
        String status = data.get("status") != null ? (String) data.get("status") : "draft";
        
        PopularScienceActivity activity = new PopularScienceActivity(title, cover, location, startTime, endTime, content, status);
        activity = activityRepository.save(activity);
        
        Map<String, Object> activityData = new HashMap<>();
        activityData.put("id", activity.getId());
        activityData.put("title", activity.getTitle());
        activityData.put("cover", activity.getCover());
        activityData.put("location", activity.getLocation());
        activityData.put("startTime", activity.getStartTime() != null ? activity.getStartTime().toString() : null);
        activityData.put("endTime", activity.getEndTime() != null ? activity.getEndTime().toString() : null);
        activityData.put("content", activity.getContent());
        activityData.put("status", activity.getStatus());
        activityData.put("publishTime", activity.getPublishTime() != null ? activity.getPublishTime().toString() : null);
        activityData.put("createdAt", activity.getCreatedAt());
        activityData.put("updatedAt", activity.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", activityData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> updateActivity(Long id, Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        PopularScienceActivity activity = activityRepository.findById(id).orElse(null);
        if (activity == null) {
            result.put("success", false);
            result.put("message", "活动不存在");
            return result;
        }
        
        if (data.containsKey("title")) {
            activity.setTitle((String) data.get("title"));
        }
        if (data.containsKey("cover")) {
            activity.setCover((String) data.get("cover"));
        }
        if (data.containsKey("location")) {
            activity.setLocation((String) data.get("location"));
        }
        if (data.containsKey("startTime")) {
            activity.setStartTime(parseDateTime((String) data.get("startTime")));
        }
        if (data.containsKey("endTime")) {
            activity.setEndTime(parseDateTime((String) data.get("endTime")));
        }
        if (data.containsKey("content")) {
            activity.setContent((String) data.get("content"));
        }
        if (data.containsKey("status")) {
            activity.setStatus((String) data.get("status"));
        }
        
        activity = activityRepository.save(activity);
        
        Map<String, Object> activityData = new HashMap<>();
        activityData.put("id", activity.getId());
        activityData.put("title", activity.getTitle());
        activityData.put("cover", activity.getCover());
        activityData.put("location", activity.getLocation());
        activityData.put("startTime", activity.getStartTime() != null ? activity.getStartTime().toString() : null);
        activityData.put("endTime", activity.getEndTime() != null ? activity.getEndTime().toString() : null);
        activityData.put("content", activity.getContent());
        activityData.put("status", activity.getStatus());
        activityData.put("publishTime", activity.getPublishTime() != null ? activity.getPublishTime().toString() : null);
        activityData.put("createdAt", activity.getCreatedAt());
        activityData.put("updatedAt", activity.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", activityData);
        return result;
    }
    
    @Transactional
    public Map<String, Object> deleteActivity(Long id) {
        Map<String, Object> result = new HashMap<>();
        if (!activityRepository.existsById(id)) {
            result.put("success", false);
            result.put("message", "活动不存在");
            return result;
        }
        activityRepository.deleteById(id);
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}

