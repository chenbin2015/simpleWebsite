package com.example.controller;

import com.example.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/home")
@CrossOrigin(origins = "*")
public class HomeController {
    
    @Autowired
    private HomeService homeService;
    
    // ========== Banner图管理 ==========
    
    /**
     * 获取Banner图
     */
    @GetMapping("/banner")
    public Map<String, Object> getBanner() {
        return homeService.getBanner();
    }
    
    /**
     * 保存或更新Banner图（支持Base64和文件URL）
     * 如果imageUrl是Base64格式，会自动转换为文件保存
     */
    @PostMapping("/banner")
    public Map<String, Object> saveBanner(@RequestBody Map<String, Object> request) {
        try {
            String imageUrl = (String) request.get("imageUrl");
            return homeService.saveBanner(null, imageUrl);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件保存失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除Banner图
     */
    @DeleteMapping("/banner")
    public Map<String, Object> deleteBanner() {
        return homeService.deleteBanner();
    }
    
    // ========== 轮播图管理 ==========
    
    /**
     * 获取轮播图列表
     */
    @GetMapping("/carousel")
    public Map<String, Object> getCarouselList() {
        return homeService.getCarouselList();
    }
    
    /**
     * 添加轮播图（支持批量）
     * 如果image是Base64格式，会自动转换为文件保存
     */
    @PostMapping("/carousel")
    public Map<String, Object> addCarousel(@RequestBody Map<String, Object> request) {
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> carouselList = (List<Map<String, Object>>) request.get("carouselList");
            return homeService.addCarousel(carouselList);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件保存失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 更新轮播图
     * 如果image是Base64格式，会自动转换为文件保存
     */
    @PutMapping("/carousel/{id}")
    public Map<String, Object> updateCarousel(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        try {
            return homeService.updateCarousel(id, request);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件保存失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除轮播图
     */
    @DeleteMapping("/carousel/{id}")
    public Map<String, Object> deleteCarousel(@PathVariable Long id) {
        return homeService.deleteCarousel(id);
    }
    
    // ========== 新闻列表管理 ==========
    
    /**
     * 获取新闻列表（分页）
     */
    @GetMapping("/news")
    public Map<String, Object> getNewsList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        return homeService.getNewsList(page, pageSize, status, keyword);
    }
    
    /**
     * 获取单个新闻详情
     */
    @GetMapping("/news/{id}")
    public Map<String, Object> getNewsById(@PathVariable Long id) {
        return homeService.getNewsById(id);
    }
    
    /**
     * 添加新闻（支持处理内容中的Base64图片）
     */
    @PostMapping("/news")
    public Map<String, Object> addNews(@RequestBody Map<String, Object> request) {
        try {
            return homeService.addNews(request);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "图片处理失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 更新新闻（支持处理内容中的Base64图片）
     */
    @PutMapping("/news/{id}")
    public Map<String, Object> updateNews(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        try {
            return homeService.updateNews(id, request);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "图片处理失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除新闻
     */
    @DeleteMapping("/news/{id}")
    public Map<String, Object> deleteNews(@PathVariable Long id) {
        return homeService.deleteNews(id);
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
        return homeService.getAnnouncementList(page, pageSize, status, keyword);
    }
    
    /**
     * 获取单个公告详情
     */
    @GetMapping("/announcement/{id}")
    public Map<String, Object> getAnnouncementById(@PathVariable Long id) {
        return homeService.getAnnouncementById(id);
    }
    
    /**
     * 添加公告（支持附件上传）
     */
    @PostMapping("/announcement")
    public Map<String, Object> addAnnouncement(
            @RequestParam("title") String title,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("content") String content,
            @RequestParam(value = "status", required = false, defaultValue = "draft") String status,
            @RequestParam(value = "attachment", required = false) MultipartFile attachmentFile) {
        try {
            Map<String, Object> data = new HashMap<>();
            data.put("title", title);
            data.put("description", description);
            data.put("content", content);
            data.put("status", status);
            return homeService.addAnnouncement(data, attachmentFile);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件保存失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 更新公告（支持附件上传）
     */
    @PutMapping("/announcement/{id}")
    public Map<String, Object> updateAnnouncement(
            @PathVariable Long id,
            @RequestParam("title") String title,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("content") String content,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "attachment", required = false) MultipartFile attachmentFile,
            @RequestParam(value = "removeAttachment", required = false, defaultValue = "false") Boolean removeAttachment) {
        try {
            Map<String, Object> data = new HashMap<>();
            data.put("title", title);
            data.put("description", description);
            data.put("content", content);
            data.put("status", status);
            // 如果标记为删除附件，设置attachmentUrl为null
            if (removeAttachment != null && removeAttachment) {
                data.put("attachmentUrl", null);
            }
            return homeService.updateAnnouncement(id, data, attachmentFile);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件保存失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除公告
     */
    @DeleteMapping("/announcement/{id}")
    public Map<String, Object> deleteAnnouncement(@PathVariable Long id) {
        return homeService.deleteAnnouncement(id);
    }
    
    // ========== 通用文件上传 ==========
    
    /**
     * 上传文件（用于编辑器中的图片、视频等）
     */
    @PostMapping("/upload")
    public Map<String, Object> uploadFile(@RequestParam("file") MultipartFile file) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (file == null || file.isEmpty()) {
                result.put("success", false);
                result.put("message", "文件不能为空");
                return result;
            }
            
            // 记录文件信息（用于调试）
            System.out.println("上传文件信息: 文件名=" + file.getOriginalFilename() + 
                             ", 大小=" + file.getSize() + " 字节, " +
                             "类型=" + file.getContentType());
            
            // 使用 FileUploadUtil 保存文件
            String filePath = com.example.util.FileUploadUtil.saveFile(file);
            
            result.put("success", true);
            result.put("message", "上传成功");
            result.put("data", Map.of("filePath", filePath));
            return result;
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", "文件上传失败: " + e.getMessage());
            e.printStackTrace();
            return result;
        } catch (IOException e) {
            result.put("success", false);
            result.put("message", "文件上传失败: " + e.getMessage());
            e.printStackTrace();
            return result;
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "文件上传失败: " + e.getMessage());
            e.printStackTrace();
            return result;
        }
    }
}


