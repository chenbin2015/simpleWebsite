package com.example.controller;

import com.example.service.ModuleNewsService;
import com.example.service.ModuleProductService;
import com.example.service.ModuleDownloadService;
import com.example.service.ContentService;
import com.example.service.ModuleBannerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 公开模块接口控制器
 * 用于前端访问，不需要token验证
 * 根据不同的类型（实验教学、实验资源、建设成效、安全管理）加载不同的数据
 */
@RestController
@RequestMapping("/api/public/module")
@CrossOrigin(origins = "*")
public class PublicModuleController {
    
    @Autowired
    private ModuleNewsService moduleNewsService;
    
    @Autowired
    private ModuleProductService moduleProductService;
    
    @Autowired
    private ModuleDownloadService moduleDownloadService;
    
    @Autowired
    private ContentService contentService;
    
    @Autowired
    private ModuleBannerService moduleBannerService;
    
    /**
     * 获取模块Banner
     * @param category - 分类：experiment-teaching, experiment-resources, construction-results, safety-management
     */
    @GetMapping("/banner/{category}")
    public Map<String, Object> getBanner(@PathVariable String category) {
        return moduleBannerService.getBanner(category);
    }
    
    /**
     * 获取菜单的新闻列表
     * @param menuId - 菜单ID
     */
    @GetMapping("/news/menu/{menuId}")
    public Map<String, Object> getNewsListByMenuId(@PathVariable Long menuId) {
        return moduleNewsService.getNewsListByMenuId(menuId);
    }
    
    /**
     * 获取菜单的产品列表
     * @param menuId - 菜单ID
     */
    @GetMapping("/products/menu/{menuId}")
    public Map<String, Object> getProductListByMenuId(@PathVariable Long menuId) {
        return moduleProductService.getProductListByMenuId(menuId);
    }
    
    /**
     * 获取菜单的下载列表
     * @param menuId - 菜单ID
     */
    @GetMapping("/downloads/menu/{menuId}")
    public Map<String, Object> getDownloadListByMenuId(@PathVariable Long menuId) {
        return moduleDownloadService.getDownloadListByMenuId(menuId);
    }
    
    /**
     * 获取菜单的图文内容
     * @param menuId - 菜单ID
     */
    @GetMapping("/content/menu/{menuId}")
    public Map<String, Object> getContentByMenuId(@PathVariable Long menuId) {
        Map<String, Object> result = contentService.getContentByMenuId(menuId);
        // 统一返回格式，将content字段转换为data字段
        if (result.containsKey("content")) {
            result.put("data", result.get("content"));
            result.remove("content");
        }
        return result;
    }
}

