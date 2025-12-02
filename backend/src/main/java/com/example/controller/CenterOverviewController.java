package com.example.controller;

import com.example.service.CenterOverviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/center-overview")
@CrossOrigin(origins = "*")
public class CenterOverviewController {
    
    @Autowired
    private CenterOverviewService centerOverviewService;
    
    // ========== Banner管理 ==========
    
    /**
     * 获取Banner
     */
    @GetMapping("/banner")
    public Map<String, Object> getBanner() {
        return centerOverviewService.getBanner();
    }
    
    /**
     * 保存或更新Banner（支持Base64图片）
     */
    @PostMapping("/banner")
    public Map<String, Object> saveBanner(
            @RequestParam("type") String type,
            @RequestParam(value = "image", required = false) MultipartFile imageFile,
            @RequestParam(value = "imageUrl", required = false) String imageUrl,
            @RequestParam(value = "video", required = false) MultipartFile videoFile,
            @RequestParam(value = "videoUrl", required = false) String videoUrl,
            @RequestParam(value = "videoUrlExternal", required = false) String videoUrlExternal) {
        try {
            // 如果提供了 videoUrl，但没有 videoFile，说明是保留原有的视频URL
            if (videoUrl != null && !videoUrl.trim().isEmpty() && (videoFile == null || videoFile.isEmpty())) {
                // 将 videoUrl 作为 videoUrlExternal 传递（如果 videoUrlExternal 为空）
                if (videoUrlExternal == null || videoUrlExternal.trim().isEmpty()) {
                    videoUrlExternal = videoUrl.trim();
                }
            }
            return centerOverviewService.saveBanner(type, imageFile, imageUrl, videoFile, videoUrlExternal);
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
    @DeleteMapping("/banner")
    public Map<String, Object> deleteBanner() {
        return centerOverviewService.deleteBanner();
    }
    
    // ========== 详情管理 ==========
    
    /**
     * 获取详情
     */
    @GetMapping("/detail")
    public Map<String, Object> getDetail() {
        return centerOverviewService.getDetail();
    }
    
    /**
     * 保存或更新详情
     */
    @PostMapping("/detail")
    public Map<String, Object> saveDetail(
            @RequestParam(value = "video", required = false) MultipartFile videoFile,
            @RequestParam(value = "videoUrlExternal", required = false) String videoUrlExternal,
            @RequestParam("mainTitle") String mainTitle,
            @RequestParam(value = "background", required = false) String background,
            @RequestParam(value = "overview", required = false) String overview,
            @RequestParam(value = "vision", required = false) String vision) {
        try {
            return centerOverviewService.saveDetail(videoFile, videoUrlExternal, 
                                                   mainTitle, background, overview, vision);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件上传失败: " + e.getMessage());
            return result;
        }
    }
    
    // ========== 组织架构管理 ==========
    
    /**
     * 获取组织架构
     */
    @GetMapping("/organization")
    public Map<String, Object> getOrganization() {
        return centerOverviewService.getOrganization();
    }
    
    /**
     * 保存组织架构（支持动态角色类型）
     */
    @PostMapping("/organization")
    public Map<String, Object> saveOrganization(@RequestBody Map<String, Object> request) {
        @SuppressWarnings("unchecked")
        Map<String, List<String>> roleMembersMap = (Map<String, List<String>>) request.get("roleMembersMap");
        
        return centerOverviewService.saveOrganization(roleMembersMap);
    }
    
    /**
     * 添加单个成员
     */
    @PostMapping("/organization/member")
    public Map<String, Object> addMember(@RequestParam("role") String role,
                                         @RequestParam("name") String name) {
        return centerOverviewService.addMember(role, name);
    }
    
    /**
     * 删除单个成员（逻辑删除）
     */
    @DeleteMapping("/organization/member/{id}")
    public Map<String, Object> deleteMember(@PathVariable Long id) {
        return centerOverviewService.deleteMember(id);
    }
    
    /**
     * 更新角色类型名称
     */
    @PutMapping("/organization/role")
    public Map<String, Object> updateRoleName(@RequestParam("oldRoleName") String oldRoleName,
                                              @RequestParam("newRoleName") String newRoleName) {
        return centerOverviewService.updateRoleName(oldRoleName, newRoleName);
    }
    
    /**
     * 删除角色类型（逻辑删除该角色的所有成员）
     */
    @DeleteMapping("/organization/role/{roleName}")
    public Map<String, Object> deleteRole(@PathVariable String roleName) {
        return centerOverviewService.deleteRole(roleName);
    }
    
    // ========== 实验室管理 ==========
    
    /**
     * 获取实验室列表
     */
    @GetMapping("/laboratory")
    public Map<String, Object> getLaboratoryList() {
        return centerOverviewService.getLaboratoryList();
    }
    
    /**
     * 添加实验室（支持Base64图片）
     */
    @PostMapping("/laboratory")
    public Map<String, Object> addLaboratory(
            @RequestParam("name") String name,
            @RequestParam(value = "image", required = false) MultipartFile imageFile,
            @RequestParam(value = "imageUrl", required = false) String imageUrl,
            @RequestParam(value = "link", required = false) String link,
            @RequestParam(value = "sortOrder", required = false) Integer sortOrder) {
        try {
            return centerOverviewService.addLaboratory(name, imageFile, imageUrl, link, sortOrder);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件上传失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 更新实验室（支持Base64图片）
     */
    @PutMapping("/laboratory/{id}")
    public Map<String, Object> updateLaboratory(
            @PathVariable Long id,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "image", required = false) MultipartFile imageFile,
            @RequestParam(value = "imageUrl", required = false) String imageUrl,
            @RequestParam(value = "link", required = false) String link,
            @RequestParam(value = "sortOrder", required = false) Integer sortOrder) {
        try {
            return centerOverviewService.updateLaboratory(id, name, imageFile, imageUrl, link, sortOrder);
        } catch (IOException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "文件上传失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除实验室
     */
    @DeleteMapping("/laboratory/{id}")
    public Map<String, Object> deleteLaboratory(@PathVariable Long id) {
        return centerOverviewService.deleteLaboratory(id);
    }
}

