package com.example.controller;

import com.example.service.ModuleDownloadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api/module-downloads")
@CrossOrigin(origins = "http://localhost:3000")
public class ModuleDownloadController {
    
    @Autowired
    private ModuleDownloadService moduleDownloadService;
    
    /**
     * 获取菜单的下载列表
     */
    @GetMapping("/menu/{menuId}")
    public Map<String, Object> getDownloadListByMenuId(@PathVariable Long menuId) {
        return moduleDownloadService.getDownloadListByMenuId(menuId);
    }
    
    /**
     * 添加下载文件
     */
    @PostMapping("/menu/{menuId}")
    public Map<String, Object> addDownload(
            @PathVariable Long menuId,
            @RequestParam("name") String name,
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "fileType", required = false) String fileType) {
        try {
            return moduleDownloadService.addDownload(menuId, name, file, category, fileType);
        } catch (IOException e) {
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("success", false);
            result.put("message", "文件保存失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 更新下载文件
     */
    @PutMapping("/{id}")
    public Map<String, Object> updateDownload(
            @PathVariable Long id,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "file", required = false) MultipartFile file,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "fileType", required = false) String fileType) {
        try {
            return moduleDownloadService.updateDownload(id, name, file, category, fileType);
        } catch (IOException e) {
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("success", false);
            result.put("message", "文件保存失败: " + e.getMessage());
            return result;
        }
    }
    
    /**
     * 删除下载文件
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteDownload(@PathVariable Long id) {
        return moduleDownloadService.deleteDownload(id);
    }
}

