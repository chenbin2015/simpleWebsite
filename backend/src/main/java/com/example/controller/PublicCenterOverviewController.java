package com.example.controller;

import com.example.service.CenterOverviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 公开中心概况接口控制器
 * 用于前端访问，不需要token验证
 */
@RestController
@RequestMapping("/api/public/center-overview")
@CrossOrigin(origins = "*")
public class PublicCenterOverviewController {
    
    @Autowired
    private CenterOverviewService centerOverviewService;
    
    /**
     * 获取Banner
     */
    @GetMapping("/banner")
    public Map<String, Object> getBanner() {
        return centerOverviewService.getBanner();
    }
    
    /**
     * 获取详情
     */
    @GetMapping("/detail")
    public Map<String, Object> getDetail() {
        return centerOverviewService.getDetail();
    }
    
    /**
     * 获取组织架构
     */
    @GetMapping("/organization")
    public Map<String, Object> getOrganization() {
        return centerOverviewService.getOrganization();
    }
    
    /**
     * 获取实验室列表
     */
    @GetMapping("/laboratory")
    public Map<String, Object> getLaboratoryList() {
        return centerOverviewService.getLaboratoryList();
    }
}

