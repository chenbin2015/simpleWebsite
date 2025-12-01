package com.example.service;

import com.example.entity.ModuleBanner;
import com.example.repository.ModuleBannerRepository;
import com.example.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ModuleBannerService {
    
    @Autowired
    private ModuleBannerRepository bannerRepository;
    
    /**
     * 获取指定分类的Banner（只获取未删除的）
     */
    public Map<String, Object> getBanner(String category) {
        Map<String, Object> result = new HashMap<>();
        Optional<ModuleBanner> bannerOpt = bannerRepository.findOneByCategoryNotDeleted(category);
        
        if (bannerOpt.isPresent()) {
            ModuleBanner banner = bannerOpt.get();
            Map<String, Object> bannerData = new HashMap<>();
            bannerData.put("id", banner.getId());
            bannerData.put("category", banner.getCategory());
            bannerData.put("type", banner.getType());
            bannerData.put("imageUrl", banner.getImageUrl());
            bannerData.put("videoUrl", banner.getVideoUrl());
            bannerData.put("videoUrlExternal", banner.getVideoUrlExternal());
            bannerData.put("createdAt", banner.getCreatedAt());
            bannerData.put("updatedAt", banner.getUpdatedAt());
            result.put("success", true);
            result.put("data", bannerData);
        } else {
            result.put("success", true);
            result.put("data", null);
        }
        
        return result;
    }
    
    /**
     * 保存或更新Banner（支持Base64图片）
     */
    @Transactional
    public Map<String, Object> saveBanner(String category, String type, MultipartFile imageFile, String imageUrl,
                                          MultipartFile videoFile, String videoUrlExternal) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        // 验证category
        if (category == null || category.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "模块分类不能为空");
            return result;
        }
        
        // 每个分类只有一条记录（单例模式），先逻辑删除旧的未删除记录
        List<ModuleBanner> oldBanners = bannerRepository.findByCategoryNotDeleted(category);
        LocalDateTime now = LocalDateTime.now();
        for (ModuleBanner oldBanner : oldBanners) {
            oldBanner.setDeleted(true);
            oldBanner.setDeletedAt(now);
            bannerRepository.save(oldBanner);
        }
        
        ModuleBanner banner = new ModuleBanner();
        banner.setCategory(category);
        banner.setType(type);
        
        if ("image".equals(type)) {
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
                    // 普通URL，直接使用
                    finalImageUrl = imageUrl.trim();
                }
            }
            
            if (finalImageUrl != null) {
                banner.setImageUrl(finalImageUrl);
            }
        } else if ("video".equals(type)) {
            if (videoFile != null && !videoFile.isEmpty()) {
                String videoUrl = FileUploadUtil.saveFile(videoFile);
                banner.setVideoUrl(videoUrl);
            } else if (videoUrlExternal != null && !videoUrlExternal.trim().isEmpty()) {
                banner.setVideoUrlExternal(videoUrlExternal.trim());
            }
        }
        
        banner = bannerRepository.save(banner);
        
        Map<String, Object> bannerData = new HashMap<>();
        bannerData.put("id", banner.getId());
        bannerData.put("category", banner.getCategory());
        bannerData.put("type", banner.getType());
        bannerData.put("imageUrl", banner.getImageUrl());
        bannerData.put("videoUrl", banner.getVideoUrl());
        bannerData.put("videoUrlExternal", banner.getVideoUrlExternal());
        bannerData.put("createdAt", banner.getCreatedAt());
        bannerData.put("updatedAt", banner.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "保存成功");
        result.put("data", bannerData);
        
        return result;
    }
    
    /**
     * 删除Banner（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteBanner(String category) {
        Map<String, Object> result = new HashMap<>();
        
        if (category == null || category.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "模块分类不能为空");
            return result;
        }
        
        List<ModuleBanner> banners = bannerRepository.findByCategoryNotDeleted(category);
        LocalDateTime now = LocalDateTime.now();
        for (ModuleBanner banner : banners) {
            banner.setDeleted(true);
            banner.setDeletedAt(now);
            bannerRepository.save(banner);
        }
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}

