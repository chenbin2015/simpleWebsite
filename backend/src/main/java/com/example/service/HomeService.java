package com.example.service;

import com.example.entity.*;
import com.example.repository.*;
import com.example.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class HomeService {
    
    @Autowired
    private HomeBannerRepository bannerRepository;
    
    @Autowired
    private HomeCarouselRepository carouselRepository;
    
    @Autowired
    private HomeNewsRepository newsRepository;
    
    @Autowired
    private HomeAnnouncementRepository announcementRepository;
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
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
            // 如果是数组或列表，转换为JSON字符串
            return objectMapper.writeValueAsString(tags);
        } catch (Exception e) {
            // 如果转换失败，返回toString
            return tags.toString();
        }
    }
    
    /**
     * 将tags的JSON字符串解析为对象（数组或列表）
     */
    private Object parseTagsFromString(String tags) {
        if (tags == null || tags.isEmpty()) {
            return null;
        }
        try {
            return objectMapper.readValue(tags, Object.class);
        } catch (Exception e) {
            // 如果解析失败，返回原字符串
            return tags;
        }
    }
    
    // ========== Banner图管理 ==========
    
    /**
     * 获取Banner图
     */
    public Map<String, Object> getBanner() {
        Map<String, Object> result = new HashMap<>();
        List<HomeBanner> banners = bannerRepository.findAllNotDeleted();
        if (banners.isEmpty()) {
            result.put("success", true);
            result.put("data", null);
        } else {
            HomeBanner banner = banners.get(0);
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
    
    /**
     * 保存或更新Banner图（支持文件上传和Base64）
     */
    @Transactional
    public Map<String, Object> saveBanner(MultipartFile imageFile, String imageUrl) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        // Banner只有一张，先逻辑删除旧的
        List<HomeBanner> oldBanners = bannerRepository.findAllNotDeleted();
        LocalDateTime now = LocalDateTime.now();
        for (HomeBanner oldBanner : oldBanners) {
            oldBanner.setDeleted(true);
            oldBanner.setDeletedAt(now);
            bannerRepository.save(oldBanner);
        }
        
        String finalImageUrl = null;
        
        // 优先使用上传的文件
        if (imageFile != null && !imageFile.isEmpty()) {
            finalImageUrl = FileUploadUtil.saveFile(imageFile);
        } else if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            // 如果imageUrl是base64，需要先转换为文件
            if (imageUrl.startsWith("data:image/")) {
                // Base64格式，转换为文件保存
                finalImageUrl = FileUploadUtil.saveBase64Image(imageUrl);
            } else {
                // 普通URL，直接使用（但建议也保存为文件）
                finalImageUrl = imageUrl.trim();
            }
        }
        
        if (finalImageUrl == null) {
            result.put("success", false);
            result.put("message", "图片不能为空");
            return result;
        }
        
        HomeBanner banner = new HomeBanner(finalImageUrl);
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
    
    /**
     * 删除Banner图
     */
    @Transactional
    public Map<String, Object> deleteBanner() {
        Map<String, Object> result = new HashMap<>();
        
        // 逻辑删除所有未删除的Banner
        List<HomeBanner> banners = bannerRepository.findAllNotDeleted();
        if (banners.isEmpty()) {
            result.put("success", false);
            result.put("message", "没有找到Banner图");
            return result;
        }
        
        LocalDateTime now = LocalDateTime.now();
        for (HomeBanner banner : banners) {
            banner.setDeleted(true);
            banner.setDeletedAt(now);
            bannerRepository.save(banner);
        }
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 轮播图管理 ==========
    
    /**
     * 获取轮播图列表
     */
    public Map<String, Object> getCarouselList() {
        Map<String, Object> result = new HashMap<>();
        List<HomeCarousel> carousels = carouselRepository.findAllOrderBySort();
        List<Map<String, Object>> data = carousels.stream().map(c -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", c.getId());
            item.put("image", c.getImage());
            item.put("title", c.getTitle());
            item.put("description", c.getDescription());
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
    
    /**
     * 添加轮播图（支持批量）
     */
    @Transactional
    public Map<String, Object> addCarousel(List<Map<String, Object>> carouselList) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        for (Map<String, Object> item : carouselList) {
            String image = (String) item.get("image");
            String title = (String) item.get("title");
            String description = item.get("description") != null ? (String) item.get("description") : null;
            String link = item.get("link") != null ? (String) item.get("link") : "";
            Integer sort = item.get("sort") != null ? ((Number) item.get("sort")).intValue() : 0;
            
            // 处理图片：如果是Base64，转换为文件保存
            String finalImageUrl = null;
            if (image != null && !image.trim().isEmpty()) {
                if (image.startsWith("data:image/")) {
                    // Base64格式，转换为文件保存
                    finalImageUrl = FileUploadUtil.saveBase64Image(image);
                } else {
                    // 普通URL，直接使用
                    finalImageUrl = image.trim();
                }
            }
            
            if (finalImageUrl == null) {
                result.put("success", false);
                result.put("message", "图片不能为空");
                return result;
            }
            
            HomeCarousel carousel = new HomeCarousel(finalImageUrl, title, description, link, sort);
            carouselRepository.save(carousel);
        }
        
        result.put("success", true);
        result.put("message", "添加成功");
        return result;
    }
    
    /**
     * 更新轮播图
     */
    @Transactional
    public Map<String, Object> updateCarousel(Long id, Map<String, Object> data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        HomeCarousel carousel = carouselRepository.findById(id).orElse(null);
        if (carousel == null) {
            result.put("success", false);
            result.put("message", "轮播图不存在");
            return result;
        }
        
        // 处理图片：如果是Base64，转换为文件保存
        if (data.containsKey("image")) {
            String image = (String) data.get("image");
            if (image != null && !image.trim().isEmpty()) {
                if (image.startsWith("data:image/")) {
                    // Base64格式，转换为文件保存
                    String finalImageUrl = FileUploadUtil.saveBase64Image(image);
                    carousel.setImage(finalImageUrl);
                } else {
                    // 普通URL，直接使用
                    carousel.setImage(image.trim());
                }
            }
        }
        if (data.containsKey("title")) {
            carousel.setTitle((String) data.get("title"));
        }
        if (data.containsKey("description")) {
            carousel.setDescription((String) data.get("description"));
        }
        if (data.containsKey("link")) {
            carousel.setLink((String) data.get("link"));
        }
        if (data.containsKey("sort")) {
            carousel.setSort(((Number) data.get("sort")).intValue());
        }
        
        carousel = carouselRepository.save(carousel);
        
        Map<String, Object> carouselData = new HashMap<>();
        carouselData.put("id", carousel.getId());
        carouselData.put("image", carousel.getImage());
        carouselData.put("title", carousel.getTitle());
        carouselData.put("description", carousel.getDescription());
        carouselData.put("link", carousel.getLink());
        carouselData.put("sort", carousel.getSort());
        carouselData.put("createdAt", carousel.getCreatedAt());
        carouselData.put("updatedAt", carousel.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", carouselData);
        
        return result;
    }
    
    /**
     * 删除轮播图（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteCarousel(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        HomeCarousel carousel = carouselRepository.findById(id).orElse(null);
        if (carousel == null || carousel.getDeleted()) {
            result.put("success", false);
            result.put("message", "轮播图不存在");
            return result;
        }
        
        // 逻辑删除
        carousel.setDeleted(true);
        carousel.setDeletedAt(LocalDateTime.now());
        carouselRepository.save(carousel);
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 新闻列表管理 ==========
    
    /**
     * 获取新闻列表（分页）
     */
    public Map<String, Object> getNewsList(Integer page, Integer pageSize, String status, String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Page<HomeNews> newsPage;
        
        if ((status == null || status.isEmpty()) && (keyword == null || keyword.isEmpty())) {
            newsPage = newsRepository.findAllNotDeleted(pageable);
        } else {
            newsPage = newsRepository.findByStatusAndKeyword(status, keyword, pageable);
        }
        
        List<Map<String, Object>> data = newsPage.getContent().stream().map(n -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", n.getId());
            item.put("title", n.getTitle());
            item.put("author", n.getAuthor());
            item.put("description", n.getDescription());
            item.put("content", n.getContent());
            item.put("tags", parseTagsFromString(n.getTags()));
            item.put("status", n.getStatus());
            item.put("publishTime", n.getPublishTime() != null ? n.getPublishTime().toString() : null);
            item.put("createdAt", n.getCreatedAt());
            item.put("updatedAt", n.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        result.put("total", newsPage.getTotalElements());
        result.put("page", page);
        result.put("pageSize", pageSize);
        
        return result;
    }
    
    /**
     * 获取单个新闻详情
     */
    public Map<String, Object> getNewsById(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        HomeNews news = newsRepository.findById(id).orElse(null);
        if (news == null || news.getDeleted()) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("id", news.getId());
        data.put("title", news.getTitle());
        data.put("author", news.getAuthor());
        data.put("description", news.getDescription());
        data.put("content", news.getContent());
        data.put("tags", parseTagsFromString(news.getTags()));
        data.put("status", news.getStatus());
        data.put("publishTime", news.getPublishTime() != null ? news.getPublishTime().toString() : null);
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
    public Map<String, Object> addNews(Map<String, Object> data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        String title = (String) data.get("title");
        String author = (String) data.get("author");
        String description = data.get("description") != null ? (String) data.get("description") : null;
        String content = (String) data.get("content");
        String tags = convertTagsToString(data.get("tags"));
        String status = data.get("status") != null ? (String) data.get("status") : "draft";
        
        // 处理内容中的Base64图片，转换为文件
        String processedContent = content;
        if (content != null && !content.isEmpty()) {
            processedContent = FileUploadUtil.processHtmlImages(content);
        }
        
        HomeNews news = new HomeNews(title, author, description, processedContent, tags, status);
        news = newsRepository.save(news);
        
        Map<String, Object> newsData = new HashMap<>();
        newsData.put("id", news.getId());
        newsData.put("title", news.getTitle());
        newsData.put("author", news.getAuthor());
        newsData.put("description", news.getDescription());
        newsData.put("content", news.getContent());
        newsData.put("tags", parseTagsFromString(news.getTags()));
        newsData.put("status", news.getStatus());
        newsData.put("publishTime", news.getPublishTime() != null ? news.getPublishTime().toString() : null);
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
        
        HomeNews news = newsRepository.findById(id).orElse(null);
        if (news == null || news.getDeleted()) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        
        if (data.containsKey("title")) {
            news.setTitle((String) data.get("title"));
        }
        if (data.containsKey("author")) {
            news.setAuthor((String) data.get("author"));
        }
        if (data.containsKey("description")) {
            news.setDescription(data.get("description") != null ? (String) data.get("description") : null);
        }
        if (data.containsKey("content")) {
            String content = (String) data.get("content");
            // 处理内容中的Base64图片，转换为文件
            if (content != null && !content.isEmpty()) {
                content = FileUploadUtil.processHtmlImages(content);
            }
            news.setContent(content);
        }
        if (data.containsKey("tags")) {
            news.setTags(convertTagsToString(data.get("tags")));
        }
        if (data.containsKey("status")) {
            news.setStatus((String) data.get("status"));
        }
        
        news = newsRepository.save(news);
        
        Map<String, Object> newsData = new HashMap<>();
        newsData.put("id", news.getId());
        newsData.put("title", news.getTitle());
        newsData.put("author", news.getAuthor());
        newsData.put("description", news.getDescription());
        newsData.put("content", news.getContent());
        newsData.put("tags", parseTagsFromString(news.getTags()));
        newsData.put("status", news.getStatus());
        newsData.put("publishTime", news.getPublishTime() != null ? news.getPublishTime().toString() : null);
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
        
        HomeNews news = newsRepository.findById(id).orElse(null);
        if (news == null || news.getDeleted()) {
            result.put("success", false);
            result.put("message", "新闻不存在");
            return result;
        }
        
        // 逻辑删除
        news.setDeleted(true);
        news.setDeletedAt(LocalDateTime.now());
        newsRepository.save(news);
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 公告管理 ==========
    
    /**
     * 获取公告列表（分页）
     */
    public Map<String, Object> getAnnouncementList(Integer page, Integer pageSize, String status, String keyword) {
        Map<String, Object> result = new HashMap<>();
        
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Page<HomeAnnouncement> announcementPage;
        
        if ((status == null || status.isEmpty()) && (keyword == null || keyword.isEmpty())) {
            announcementPage = announcementRepository.findAllNotDeleted(pageable);
        } else {
            announcementPage = announcementRepository.findByStatusAndKeyword(status, keyword, pageable);
        }
        
        List<Map<String, Object>> data = announcementPage.getContent().stream().map(a -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", a.getId());
            item.put("title", a.getTitle());
            item.put("description", a.getDescription());
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
    
    /**
     * 获取单个公告详情
     */
    public Map<String, Object> getAnnouncementById(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        HomeAnnouncement announcement = announcementRepository.findById(id).orElse(null);
        if (announcement == null || announcement.getDeleted()) {
            result.put("success", false);
            result.put("message", "公告不存在");
            return result;
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("id", announcement.getId());
        data.put("title", announcement.getTitle());
        data.put("description", announcement.getDescription());
        data.put("content", announcement.getContent());
        data.put("attachmentUrl", announcement.getAttachmentUrl());
        data.put("attachmentName", announcement.getAttachmentName());
        data.put("status", announcement.getStatus());
        data.put("publishTime", announcement.getPublishTime() != null ? announcement.getPublishTime().toString() : null);
        data.put("createdAt", announcement.getCreatedAt());
        data.put("updatedAt", announcement.getUpdatedAt());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    /**
     * 添加公告
     */
    @Transactional
    public Map<String, Object> addAnnouncement(Map<String, Object> data, org.springframework.web.multipart.MultipartFile attachmentFile) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        String title = (String) data.get("title");
        String description = data.get("description") != null ? (String) data.get("description") : null;
        String content = (String) data.get("content");
        String status = data.get("status") != null ? (String) data.get("status") : "draft";
        
        // 处理内容中的Base64图片，转换为文件
        String processedContent = content;
        if (content != null && !content.isEmpty()) {
            processedContent = FileUploadUtil.processHtmlImages(content);
        }
        
        // 处理附件上传
        String attachmentUrl = null;
        String attachmentName = null;
        if (attachmentFile != null && !attachmentFile.isEmpty()) {
            // 验证文件类型：只允许PDF
            String originalFilename = attachmentFile.getOriginalFilename();
            if (originalFilename == null || !originalFilename.toLowerCase().endsWith(".pdf")) {
                result.put("success", false);
                result.put("message", "公告附件仅支持PDF格式");
                return result;
            }
            attachmentUrl = FileUploadUtil.saveFile(attachmentFile);
            attachmentName = attachmentFile.getOriginalFilename();
        }
        
        HomeAnnouncement announcement = new HomeAnnouncement(title, description, processedContent, status);
        announcement.setAttachmentUrl(attachmentUrl);
        announcement.setAttachmentName(attachmentName);
        announcement = announcementRepository.save(announcement);
        
        Map<String, Object> announcementData = new HashMap<>();
        announcementData.put("id", announcement.getId());
        announcementData.put("title", announcement.getTitle());
        announcementData.put("description", announcement.getDescription());
        announcementData.put("content", announcement.getContent());
        announcementData.put("attachmentUrl", announcement.getAttachmentUrl());
        announcementData.put("attachmentName", announcement.getAttachmentName());
        announcementData.put("status", announcement.getStatus());
        announcementData.put("publishTime", announcement.getPublishTime() != null ? announcement.getPublishTime().toString() : null);
        announcementData.put("createdAt", announcement.getCreatedAt());
        announcementData.put("updatedAt", announcement.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", announcementData);
        return result;
    }
    
    /**
     * 更新公告
     */
    @Transactional
    public Map<String, Object> updateAnnouncement(Long id, Map<String, Object> data, org.springframework.web.multipart.MultipartFile attachmentFile) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        HomeAnnouncement announcement = announcementRepository.findById(id).orElse(null);
        if (announcement == null || announcement.getDeleted()) {
            result.put("success", false);
            result.put("message", "公告不存在");
            return result;
        }
        
        if (data.containsKey("title")) {
            announcement.setTitle((String) data.get("title"));
        }
        if (data.containsKey("description")) {
            announcement.setDescription(data.get("description") != null ? (String) data.get("description") : null);
        }
        if (data.containsKey("content")) {
            String content = (String) data.get("content");
            // 处理内容中的Base64图片，转换为文件
            if (content != null && !content.isEmpty()) {
                content = FileUploadUtil.processHtmlImages(content);
            }
            announcement.setContent(content);
        }
        if (data.containsKey("status")) {
            announcement.setStatus((String) data.get("status"));
        }
        
        // 处理附件上传（如果有新附件，则更新；如果数据中包含删除标记，则删除）
        if (attachmentFile != null && !attachmentFile.isEmpty()) {
            // 验证文件类型：只允许PDF
            String originalFilename = attachmentFile.getOriginalFilename();
            if (originalFilename == null || !originalFilename.toLowerCase().endsWith(".pdf")) {
                result.put("success", false);
                result.put("message", "公告附件仅支持PDF格式");
                return result;
            }
            // 删除旧附件文件
            if (announcement.getAttachmentUrl() != null && !announcement.getAttachmentUrl().isEmpty()) {
                try {
                    FileUploadUtil.deleteFile(announcement.getAttachmentUrl());
                } catch (Exception e) {
                    // 忽略删除旧文件失败的错误
                }
            }
            // 保存新附件
            announcement.setAttachmentUrl(FileUploadUtil.saveFile(attachmentFile));
            announcement.setAttachmentName(attachmentFile.getOriginalFilename());
        } else if (data.containsKey("attachmentUrl") && data.get("attachmentUrl") == null) {
            // 如果数据中明确设置为null，表示删除附件
            if (announcement.getAttachmentUrl() != null && !announcement.getAttachmentUrl().isEmpty()) {
                try {
                    FileUploadUtil.deleteFile(announcement.getAttachmentUrl());
                } catch (Exception e) {
                    // 忽略删除文件失败的错误
                }
            }
            announcement.setAttachmentUrl(null);
            announcement.setAttachmentName(null);
        }
        
        announcement = announcementRepository.save(announcement);
        
        Map<String, Object> announcementData = new HashMap<>();
        announcementData.put("id", announcement.getId());
        announcementData.put("title", announcement.getTitle());
        announcementData.put("description", announcement.getDescription());
        announcementData.put("content", announcement.getContent());
        announcementData.put("attachmentUrl", announcement.getAttachmentUrl());
        announcementData.put("attachmentName", announcement.getAttachmentName());
        announcementData.put("status", announcement.getStatus());
        announcementData.put("publishTime", announcement.getPublishTime() != null ? announcement.getPublishTime().toString() : null);
        announcementData.put("createdAt", announcement.getCreatedAt());
        announcementData.put("updatedAt", announcement.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", announcementData);
        return result;
    }
    
    /**
     * 删除公告（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteAnnouncement(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        HomeAnnouncement announcement = announcementRepository.findById(id).orElse(null);
        if (announcement == null || announcement.getDeleted()) {
            result.put("success", false);
            result.put("message", "公告不存在");
            return result;
        }
        
        // 逻辑删除
        announcement.setDeleted(true);
        announcement.setDeletedAt(LocalDateTime.now());
        announcementRepository.save(announcement);
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}

