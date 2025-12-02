package com.example.service;

import com.example.entity.*;
import com.example.repository.*;
import com.example.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;

@Service
public class CenterOverviewService {
    
    @Autowired
    private CenterOverviewBannerRepository bannerRepository;
    
    @Autowired
    private CenterOverviewDetailRepository detailRepository;
    
    @Autowired
    private CenterOverviewOrganizationRepository organizationRepository;
    
    @Autowired
    private CenterOverviewLaboratoryRepository laboratoryRepository;
    
    // ========== Banner管理 ==========
    
    /**
     * 获取Banner（只获取未删除的）
     */
    public Map<String, Object> getBanner() {
        Map<String, Object> result = new HashMap<>();
        List<CenterOverviewBanner> banners = bannerRepository.findAllNotDeleted();
        if (banners.isEmpty()) {
            result.put("success", true);
            result.put("data", null);
        } else {
            CenterOverviewBanner banner = banners.get(0);
            Map<String, Object> bannerData = new HashMap<>();
            bannerData.put("id", banner.getId());
            bannerData.put("type", banner.getType());
            bannerData.put("imageUrl", banner.getImageUrl());
            bannerData.put("videoUrl", banner.getVideoUrl());
            bannerData.put("videoUrlExternal", banner.getVideoUrlExternal());
            bannerData.put("createdAt", banner.getCreatedAt());
            bannerData.put("updatedAt", banner.getUpdatedAt());
            result.put("success", true);
            result.put("data", bannerData);
        }
        return result;
    }
    
    /**
     * 保存或更新Banner（支持Base64图片）
     */
    @Transactional
    public Map<String, Object> saveBanner(String type, MultipartFile imageFile, String imageUrl,
                                          MultipartFile videoFile, String videoUrlExternal) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        // Banner只有一条记录（单例模式），先查找是否存在未删除的记录
        List<CenterOverviewBanner> oldBanners = bannerRepository.findAllNotDeleted();
        CenterOverviewBanner banner;
        
        if (!oldBanners.isEmpty()) {
            // 如果存在，逻辑删除旧的记录
            for (CenterOverviewBanner oldBanner : oldBanners) {
                oldBanner.setDeleted(true);
                oldBanner.setDeletedAt(LocalDateTime.now());
                bannerRepository.save(oldBanner);
            }
            // 创建新记录，但保留原有数据（如果新数据为空）
            CenterOverviewBanner lastBanner = oldBanners.get(0);
            banner = new CenterOverviewBanner();
            // 保留原有的图片和视频数据
            banner.setImageUrl(lastBanner.getImageUrl());
            banner.setVideoUrl(lastBanner.getVideoUrl());
            banner.setVideoUrlExternal(lastBanner.getVideoUrlExternal());
        } else {
            // 如果不存在，创建新记录
            banner = new CenterOverviewBanner();
        }
        
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
            
            // 如果有新图片，更新；否则保留原有图片
            if (finalImageUrl != null) {
                banner.setImageUrl(finalImageUrl);
            }
        } else if ("video".equals(type)) {
            // 如果有新视频，更新；否则保留原有视频
            if (videoFile != null && !videoFile.isEmpty()) {
                String videoUrl = FileUploadUtil.saveFile(videoFile);
                banner.setVideoUrl(videoUrl);
                banner.setVideoUrlExternal(null); // 上传文件时清空外部URL
            } else if (videoUrlExternal != null && !videoUrlExternal.trim().isEmpty()) {
                banner.setVideoUrlExternal(videoUrlExternal.trim());
                banner.setVideoUrl(null); // 设置外部URL时清空上传的视频
            }
            // 如果既没有新文件也没有新外部URL，保留原有数据
        }
        
        banner = bannerRepository.save(banner);
        
        Map<String, Object> bannerData = new HashMap<>();
        bannerData.put("id", banner.getId());
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
    public Map<String, Object> deleteBanner() {
        Map<String, Object> result = new HashMap<>();
        List<CenterOverviewBanner> banners = bannerRepository.findAllNotDeleted();
        for (CenterOverviewBanner banner : banners) {
            banner.setDeleted(true);
            banner.setDeletedAt(LocalDateTime.now());
            bannerRepository.save(banner);
        }
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 详情管理 ==========
    
    /**
     * 获取详情
     */
    public Map<String, Object> getDetail() {
        Map<String, Object> result = new HashMap<>();
        List<CenterOverviewDetail> details = detailRepository.findAll();
        if (details.isEmpty()) {
            result.put("success", true);
            result.put("data", null);
        } else {
            CenterOverviewDetail detail = details.get(0);
            Map<String, Object> detailData = new HashMap<>();
            detailData.put("id", detail.getId());
            detailData.put("videoUrl", detail.getVideoUrl());
            detailData.put("videoUrlExternal", detail.getVideoUrlExternal());
            detailData.put("mainTitle", detail.getMainTitle());
            detailData.put("background", detail.getBackground());
            detailData.put("overview", detail.getOverview());
            detailData.put("vision", detail.getVision());
            detailData.put("createdAt", detail.getCreatedAt());
            detailData.put("updatedAt", detail.getUpdatedAt());
            result.put("success", true);
            result.put("data", detailData);
        }
        return result;
    }
    
    /**
     * 保存或更新详情
     */
    @Transactional
    public Map<String, Object> saveDetail(MultipartFile videoFile, String videoUrlExternal,
                                          String mainTitle, String background, 
                                          String overview, String vision) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        if (mainTitle == null || mainTitle.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "主标题不能为空");
            return result;
        }
        
        // 详情只有一条记录（单例模式），先查找是否存在
        List<CenterOverviewDetail> details = detailRepository.findAll();
        CenterOverviewDetail detail;
        
        if (details.isEmpty()) {
            detail = new CenterOverviewDetail();
        } else {
            detail = details.get(0);
        }
        
        detail.setMainTitle(mainTitle.trim());
        
        // 处理HTML内容中的Base64图片，转换为文件路径
        String processedBackground = FileUploadUtil.processHtmlImages(background != null ? background : "");
        String processedOverview = FileUploadUtil.processHtmlImages(overview != null ? overview : "");
        String processedVision = FileUploadUtil.processHtmlImages(vision != null ? vision : "");
        
        detail.setBackground(processedBackground);
        detail.setOverview(processedOverview);
        detail.setVision(processedVision);
        
        if (videoFile != null && !videoFile.isEmpty()) {
            String videoUrl = FileUploadUtil.saveFile(videoFile);
            detail.setVideoUrl(videoUrl);
            detail.setVideoUrlExternal(null);
        } else if (videoUrlExternal != null && !videoUrlExternal.trim().isEmpty()) {
            detail.setVideoUrlExternal(videoUrlExternal.trim());
            detail.setVideoUrl(null);
        }
        
        detail = detailRepository.save(detail);
        
        Map<String, Object> detailData = new HashMap<>();
        detailData.put("id", detail.getId());
        detailData.put("videoUrl", detail.getVideoUrl());
        detailData.put("videoUrlExternal", detail.getVideoUrlExternal());
        detailData.put("mainTitle", detail.getMainTitle());
        detailData.put("background", detail.getBackground());
        detailData.put("overview", detail.getOverview());
        detailData.put("vision", detail.getVision());
        detailData.put("createdAt", detail.getCreatedAt());
        detailData.put("updatedAt", detail.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "保存成功");
        result.put("data", detailData);
        
        return result;
    }
    
    // ========== 组织架构管理 ==========
    
    /**
     * 获取组织架构（按角色类型分组，支持角色类型顺序）
     */
    public Map<String, Object> getOrganization() {
        Map<String, Object> result = new HashMap<>();
        
        // 获取所有未删除的组织成员，按sortOrder排序
        List<CenterOverviewOrganization> allOrgs = organizationRepository.findAllNotDeleted();
        
        // 先按sortOrder排序（组合排序值：角色顺序 * 10000 + 成员顺序）
        List<CenterOverviewOrganization> sortedOrgs = allOrgs.stream()
            .sorted((o1, o2) -> {
                int sort1 = o1.getSortOrder() != null ? o1.getSortOrder() : 0;
                int sort2 = o2.getSortOrder() != null ? o2.getSortOrder() : 0;
                return Integer.compare(sort1, sort2);
            })
            .collect(Collectors.toList());
        
        // 按角色类型分组，提取角色顺序（sortOrder / 10000）
        Map<String, Integer> roleSortMap = new HashMap<>();
        for (CenterOverviewOrganization org : sortedOrgs) {
            String role = org.getRole();
            if (!roleSortMap.containsKey(role)) {
                int roleSortOrder = (org.getSortOrder() != null ? org.getSortOrder() : 0) / 10000;
                roleSortMap.put(role, roleSortOrder);
            }
        }
        
        // 按角色类型分组，同时保持成员的相对顺序
        LinkedHashMap<String, List<Map<String, Object>>> groupedByRole = sortedOrgs.stream()
            .collect(Collectors.groupingBy(
                CenterOverviewOrganization::getRole,
                LinkedHashMap::new,
                Collectors.collectingAndThen(
                    Collectors.toList(),
                    orgList -> {
                        // 对每个角色内的成员按完整的 sortOrder 排序（保持它们在角色内的相对顺序）
                        orgList.sort((o1, o2) -> {
                            int sort1 = o1.getSortOrder() != null ? o1.getSortOrder() : 0;
                            int sort2 = o2.getSortOrder() != null ? o2.getSortOrder() : 0;
                            return Integer.compare(sort1, sort2);
                        });
                        // 转换为 Map 列表
                        return orgList.stream().map(o -> {
                            Map<String, Object> item = new HashMap<>();
                            item.put("id", o.getId());
                            item.put("name", o.getName());
                            // 成员在该角色内的顺序（sortOrder % 10000）
                            int memberSortOrder = (o.getSortOrder() != null ? o.getSortOrder() : 0) % 10000;
                            item.put("sortOrder", memberSortOrder);
                            return item;
                        }).collect(Collectors.toList());
                    }
                )
            ));
        
        // 按照角色顺序对分组结果进行排序
        LinkedHashMap<String, List<Map<String, Object>>> sortedGroupedByRole = groupedByRole.entrySet().stream()
            .sorted((e1, e2) -> {
                int sort1 = roleSortMap.getOrDefault(e1.getKey(), Integer.MAX_VALUE);
                int sort2 = roleSortMap.getOrDefault(e2.getKey(), Integer.MAX_VALUE);
                return Integer.compare(sort1, sort2);
            })
            .collect(Collectors.toMap(
                Map.Entry::getKey,
                Map.Entry::getValue,
                (e1, e2) -> e1,
                LinkedHashMap::new
            ));
        
        // 构建返回数据，包含角色顺序信息
        List<Map<String, Object>> roleDataList = sortedGroupedByRole.entrySet().stream()
            .map(entry -> {
                Map<String, Object> roleData = new HashMap<>();
                roleData.put("roleName", entry.getKey());
                roleData.put("roleSortOrder", roleSortMap.getOrDefault(entry.getKey(), 0));
                roleData.put("members", entry.getValue());
                return roleData;
            })
            .collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", sortedGroupedByRole); // 保持向后兼容
        result.put("roleData", roleDataList); // 新增：包含角色顺序的数组格式
        
        return result;
    }
    
    /**
     * 保存组织架构（支持动态角色类型）
     */
    @Transactional
    public Map<String, Object> saveOrganization(Map<String, List<String>> roleMembersMap) {
        Map<String, Object> result = new HashMap<>();
        
        if (roleMembersMap == null || roleMembersMap.isEmpty()) {
            result.put("success", false);
            result.put("message", "组织架构数据不能为空");
            return result;
        }
        
        // 先逻辑删除所有现有数据
        List<CenterOverviewOrganization> existingOrgs = organizationRepository.findAllNotDeleted();
        for (CenterOverviewOrganization org : existingOrgs) {
            org.setDeleted(true);
            org.setDeletedAt(LocalDateTime.now());
            organizationRepository.save(org);
        }
        
        // 遍历所有角色类型，保存成员
        for (Map.Entry<String, List<String>> entry : roleMembersMap.entrySet()) {
            String role = entry.getKey();
            List<String> names = entry.getValue();
            
            if (role == null || role.trim().isEmpty()) {
                continue;
            }
            
            int sortOrder = 0;
            for (String name : names) {
                if (name != null && !name.trim().isEmpty()) {
                    CenterOverviewOrganization org = new CenterOverviewOrganization(
                        role.trim(), 
                        name.trim(), 
                        sortOrder++
                    );
                    organizationRepository.save(org);
                }
            }
        }
        
        result.put("success", true);
        result.put("message", "保存成功");
        
        return result;
    }
    
    /**
     * 保存组织架构（支持角色类型顺序）
     * 使用组合排序值：角色顺序 * 10000 + 成员顺序
     */
    @Transactional
    public Map<String, Object> saveOrganizationWithOrder(List<Map<String, Object>> roleData) {
        Map<String, Object> result = new HashMap<>();
        
        if (roleData == null || roleData.isEmpty()) {
            result.put("success", false);
            result.put("message", "组织架构数据不能为空");
            return result;
        }
        
        // 先逻辑删除所有现有数据
        List<CenterOverviewOrganization> existingOrgs = organizationRepository.findAllNotDeleted();
        for (CenterOverviewOrganization org : existingOrgs) {
            org.setDeleted(true);
            org.setDeletedAt(LocalDateTime.now());
            organizationRepository.save(org);
        }
        
        // 遍历所有角色类型，保存成员（使用组合排序值）
        for (Map<String, Object> roleInfo : roleData) {
            String role = (String) roleInfo.get("roleName");
            Integer roleSortOrder = roleInfo.get("roleSortOrder") != null ? 
                ((Number) roleInfo.get("roleSortOrder")).intValue() : 0;
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> members = (List<Map<String, Object>>) roleInfo.get("members");
            
            if (role == null || role.trim().isEmpty()) {
                continue;
            }
            
            if (members != null) {
                int memberIndex = 0;
                for (Map<String, Object> member : members) {
                    String name = (String) member.get("name");
                    if (name != null && !name.trim().isEmpty()) {
                        // 使用组合排序值：角色顺序 * 10000 + 成员顺序
                        int combinedSortOrder = roleSortOrder * 10000 + memberIndex;
                        CenterOverviewOrganization org = new CenterOverviewOrganization(
                            role.trim(), 
                            name.trim(), 
                            combinedSortOrder
                        );
                        organizationRepository.save(org);
                        memberIndex++;
                    }
                }
            }
        }
        
        result.put("success", true);
        result.put("message", "保存成功");
        
        return result;
    }
    
    /**
     * 添加单个成员
     */
    @Transactional
    public Map<String, Object> addMember(String role, String name) {
        Map<String, Object> result = new HashMap<>();
        
        if (role == null || role.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "角色类型不能为空");
            return result;
        }
        
        if (name == null || name.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "成员姓名不能为空");
            return result;
        }
        
        // 获取该角色的最大sortOrder
        List<CenterOverviewOrganization> roleMembers = organizationRepository.findByRoleNotDeletedOrderBySortOrderAsc(role.trim());
        int maxSortOrder = roleMembers.stream()
            .mapToInt(o -> o.getSortOrder() != null ? o.getSortOrder() : 0)
            .max()
            .orElse(-1);
        
        CenterOverviewOrganization org = new CenterOverviewOrganization(role.trim(), name.trim(), maxSortOrder + 1);
        org = organizationRepository.save(org);
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", org);
        
        return result;
    }
    
    /**
     * 删除单个成员（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteMember(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        CenterOverviewOrganization org = organizationRepository.findById(id).orElse(null);
        if (org == null) {
            result.put("success", false);
            result.put("message", "成员不存在");
            return result;
        }
        
        org.setDeleted(true);
        org.setDeletedAt(LocalDateTime.now());
        organizationRepository.save(org);
        
        result.put("success", true);
        result.put("message", "删除成功");
        
        return result;
    }
    
    /**
     * 更新角色类型名称
     */
    @Transactional
    public Map<String, Object> updateRoleName(String oldRoleName, String newRoleName) {
        Map<String, Object> result = new HashMap<>();
        
        if (oldRoleName == null || oldRoleName.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "原角色名称不能为空");
            return result;
        }
        
        if (newRoleName == null || newRoleName.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "新角色名称不能为空");
            return result;
        }
        
        List<CenterOverviewOrganization> orgs = organizationRepository.findByRoleNotDeletedOrderBySortOrderAsc(oldRoleName.trim());
        for (CenterOverviewOrganization org : orgs) {
            org.setRole(newRoleName.trim());
            organizationRepository.save(org);
        }
        
        result.put("success", true);
        result.put("message", "更新成功");
        
        return result;
    }
    
    /**
     * 删除角色类型（逻辑删除该角色的所有成员）
     */
    @Transactional
    public Map<String, Object> deleteRole(String roleName) {
        Map<String, Object> result = new HashMap<>();
        
        if (roleName == null || roleName.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "角色名称不能为空");
            return result;
        }
        
        List<CenterOverviewOrganization> orgs = organizationRepository.findByRoleNotDeletedOrderBySortOrderAsc(roleName.trim());
        for (CenterOverviewOrganization org : orgs) {
            org.setDeleted(true);
            org.setDeletedAt(LocalDateTime.now());
            organizationRepository.save(org);
        }
        
        result.put("success", true);
        result.put("message", "删除成功");
        
        return result;
    }
    
    // ========== 实验室管理 ==========
    
    /**
     * 获取实验室列表（只获取未删除的）
     */
    public Map<String, Object> getLaboratoryList() {
        Map<String, Object> result = new HashMap<>();
        List<CenterOverviewLaboratory> laboratories = laboratoryRepository.findAllNotDeletedOrderBySortOrder();
        
        List<Map<String, Object>> data = laboratories.stream().map(l -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", l.getId());
            item.put("name", l.getName());
            item.put("imageUrl", l.getImageUrl());
            item.put("detail", l.getDetail());
            item.put("sortOrder", l.getSortOrder());
            item.put("createdAt", l.getCreatedAt());
            item.put("updatedAt", l.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        
        return result;
    }
    
    /**
     * 添加实验室（支持Base64图片）
     */
    @Transactional
    public Map<String, Object> addLaboratory(String name, MultipartFile imageFile, String imageUrl,
                                             String detail, Integer sortOrder) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        if (name == null || name.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "实验室名称不能为空");
            return result;
        }
        
        String finalImageUrl = null;
        
        // 优先使用 Base64 图片（来自裁剪）
        if (imageUrl != null && imageUrl.startsWith("data:image/")) {
            // Base64格式，转换为文件保存
            finalImageUrl = FileUploadUtil.saveBase64Image(imageUrl);
        } else if (imageFile != null && !imageFile.isEmpty()) {
            // 使用文件上传
            finalImageUrl = FileUploadUtil.saveFile(imageFile);
        } else {
            result.put("success", false);
            result.put("message", "请上传图片");
            return result;
        }
        
        // 处理富文本详情中的Base64图片，转换为文件路径
        String processedDetail = detail != null ? FileUploadUtil.processHtmlImages(detail.trim()) : null;
        
        CenterOverviewLaboratory laboratory = new CenterOverviewLaboratory(
            name.trim(), 
            finalImageUrl,
            processedDetail,
            sortOrder != null ? sortOrder : 0
        );
        
        laboratory = laboratoryRepository.save(laboratory);
        
        Map<String, Object> labData = new HashMap<>();
        labData.put("id", laboratory.getId());
        labData.put("name", laboratory.getName());
        labData.put("imageUrl", laboratory.getImageUrl());
        labData.put("detail", laboratory.getDetail());
        labData.put("sortOrder", laboratory.getSortOrder());
        labData.put("createdAt", laboratory.getCreatedAt());
        labData.put("updatedAt", laboratory.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", labData);
        
        return result;
    }
    
    /**
     * 更新实验室（支持Base64图片）
     */
    @Transactional
    public Map<String, Object> updateLaboratory(Long id, String name, MultipartFile imageFile, String imageUrl,
                                                String detail, Integer sortOrder) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        CenterOverviewLaboratory laboratory = laboratoryRepository.findById(id).orElse(null);
        if (laboratory == null) {
            result.put("success", false);
            result.put("message", "实验室不存在");
            return result;
        }
        
        if (name != null && !name.trim().isEmpty()) {
            laboratory.setName(name.trim());
        }
        
        // 优先使用 Base64 图片（来自裁剪）
        if (imageUrl != null && imageUrl.startsWith("data:image/")) {
            // Base64格式，转换为文件保存
            String finalImageUrl = FileUploadUtil.saveBase64Image(imageUrl);
            laboratory.setImageUrl(finalImageUrl);
        } else if (imageFile != null && !imageFile.isEmpty()) {
            // 使用文件上传
            String finalImageUrl = FileUploadUtil.saveFile(imageFile);
            laboratory.setImageUrl(finalImageUrl);
        }
        
        // 处理富文本详情中的Base64图片，转换为文件路径
        if (detail != null) {
            String processedDetail = FileUploadUtil.processHtmlImages(detail.trim());
            laboratory.setDetail(processedDetail);
        }
        
        if (sortOrder != null) {
            laboratory.setSortOrder(sortOrder);
        }
        
        laboratory = laboratoryRepository.save(laboratory);
        
        Map<String, Object> labData = new HashMap<>();
        labData.put("id", laboratory.getId());
        labData.put("name", laboratory.getName());
        labData.put("imageUrl", laboratory.getImageUrl());
        labData.put("detail", laboratory.getDetail());
        labData.put("sortOrder", laboratory.getSortOrder());
        labData.put("createdAt", laboratory.getCreatedAt());
        labData.put("updatedAt", laboratory.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", labData);
        
        return result;
    }
    
    /**
     * 删除实验室（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteLaboratory(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        CenterOverviewLaboratory laboratory = laboratoryRepository.findById(id).orElse(null);
        if (laboratory == null) {
            result.put("success", false);
            result.put("message", "实验室不存在");
            return result;
        }
        
        laboratory.setDeleted(true);
        laboratory.setDeletedAt(LocalDateTime.now());
        laboratoryRepository.save(laboratory);
        
        result.put("success", true);
        result.put("message", "删除成功");
        
        return result;
    }
}

