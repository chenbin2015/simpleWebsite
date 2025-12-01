package com.example.controller;

import com.example.service.ModuleBannerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/module-banner")
@CrossOrigin(origins = "*")
public class ModuleBannerController {
    
    @Autowired
    private ModuleBannerService moduleBannerService;
    
    /**
     * 获取指定分类的Banner
     */
    @GetMapping("/{category}")
    public Map<String, Object> getBanner(@PathVariable String category) {
        return moduleBannerService.getBanner(category);
    }
    
    /**
     * 保存或更新Banner（支持Base64图片）
     */
    @PostMapping("/{category}")
    public Map<String, Object> saveBanner(
            @PathVariable String category,
            @RequestParam("type") String type,
            @RequestParam(value = "image", required = false) MultipartFile imageFile,
            @RequestParam(value = "imageUrl", required = false) String imageUrl,
            @RequestParam(value = "video", required = false) MultipartFile videoFile,
            @RequestParam(value = "videoUrlExternal", required = false) String videoUrlExternal) {
        try {
            return moduleBannerService.saveBanner(category, type, imageFile, imageUrl, videoFile, videoUrlExternal);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件上传失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除Banner
     */
    @DeleteMapping("/{category}")
    public Map<String, Object> deleteBanner(@PathVariable String category) {
        return moduleBannerService.deleteBanner(category);
    }
}

