package com.example.service;

import com.example.entity.Menu;
import com.example.entity.ModuleDownload;
import com.example.repository.MenuRepository;
import com.example.repository.ModuleDownloadRepository;
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
import java.util.stream.Collectors;

@Service
public class ModuleDownloadService {
    
    @Autowired
    private ModuleDownloadRepository moduleDownloadRepository;
    
    @Autowired
    private MenuRepository menuRepository;
    
    /**
     * 获取菜单的下载列表
     */
    public Map<String, Object> getDownloadListByMenuId(Long menuId) {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        List<ModuleDownload> downloadList = moduleDownloadRepository.findByMenuIdAndDeletedFalseOrderByCreatedAtDesc(menuId);
        
        List<Map<String, Object>> data = downloadList.stream().map(download -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", download.getId());
            item.put("name", download.getName());
            item.put("fileUrl", download.getFileUrl());
            item.put("category", download.getCategory());
            item.put("type", download.getFileType());
            item.put("fileSize", download.getFileSize());
            item.put("size", formatFileSize(download.getFileSize()));
            item.put("downloadCount", download.getDownloadCount());
            item.put("updateTime", download.getUpdatedAt() != null ? download.getUpdatedAt().toString() : 
                       (download.getCreatedAt() != null ? download.getCreatedAt().toString() : null));
            item.put("createdAt", download.getCreatedAt());
            item.put("updatedAt", download.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    /**
     * 添加下载文件
     */
    @Transactional
    public Map<String, Object> addDownload(Long menuId, String name, MultipartFile file, String category, String fileType) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        if (file == null || file.isEmpty()) {
            result.put("success", false);
            result.put("message", "文件不能为空");
            return result;
        }
        
        // 保存文件
        String filePath = FileUploadUtil.saveFile(file);
        
        ModuleDownload download = new ModuleDownload(menu, name, filePath, category, fileType, file.getSize());
        download = moduleDownloadRepository.save(download);
        
        Map<String, Object> downloadData = new HashMap<>();
        downloadData.put("id", download.getId());
        downloadData.put("name", download.getName());
        downloadData.put("fileUrl", download.getFileUrl());
        downloadData.put("category", download.getCategory());
        downloadData.put("type", download.getFileType());
        downloadData.put("fileSize", download.getFileSize());
        downloadData.put("size", formatFileSize(download.getFileSize()));
        downloadData.put("downloadCount", download.getDownloadCount());
        downloadData.put("updateTime", download.getUpdatedAt() != null ? download.getUpdatedAt().toString() : 
                         (download.getCreatedAt() != null ? download.getCreatedAt().toString() : null));
        downloadData.put("createdAt", download.getCreatedAt());
        downloadData.put("updatedAt", download.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", downloadData);
        return result;
    }
    
    /**
     * 更新下载文件
     */
    @Transactional
    public Map<String, Object> updateDownload(Long id, String name, MultipartFile file, String category, String fileType) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        ModuleDownload download = moduleDownloadRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (download == null) {
            result.put("success", false);
            result.put("message", "下载文件不存在");
            return result;
        }
        
        if (name != null) {
            download.setName(name);
        }
        if (category != null) {
            download.setCategory(category);
        }
        if (fileType != null) {
            download.setFileType(fileType);
        }
        
        // 如果上传了新文件，保存并更新
        if (file != null && !file.isEmpty()) {
            // 删除旧文件
            FileUploadUtil.deleteFile(download.getFileUrl());
            
            // 保存新文件
            String filePath = FileUploadUtil.saveFile(file);
            download.setFileUrl(filePath);
            download.setFileSize(file.getSize());
        }
        
        download = moduleDownloadRepository.save(download);
        
        Map<String, Object> downloadData = new HashMap<>();
        downloadData.put("id", download.getId());
        downloadData.put("name", download.getName());
        downloadData.put("fileUrl", download.getFileUrl());
        downloadData.put("category", download.getCategory());
        downloadData.put("type", download.getFileType());
        downloadData.put("fileSize", download.getFileSize());
        downloadData.put("size", formatFileSize(download.getFileSize()));
        downloadData.put("downloadCount", download.getDownloadCount());
        downloadData.put("updateTime", download.getUpdatedAt() != null ? download.getUpdatedAt().toString() : 
                         (download.getCreatedAt() != null ? download.getCreatedAt().toString() : null));
        downloadData.put("createdAt", download.getCreatedAt());
        downloadData.put("updatedAt", download.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", downloadData);
        return result;
    }
    
    /**
     * 删除下载文件（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteDownload(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        ModuleDownload download = moduleDownloadRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (download == null) {
            result.put("success", false);
            result.put("message", "下载文件不存在或已被删除");
            return result;
        }
        
        download.setDeleted(true);
        download.setDeletedAt(LocalDateTime.now());
        moduleDownloadRepository.save(download);
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    /**
     * 格式化文件大小
     */
    private String formatFileSize(Long bytes) {
        if (bytes == null || bytes == 0) {
            return "0 B";
        }
        long k = 1024;
        String[] sizes = {"B", "KB", "MB", "GB"};
        int i = (int) Math.floor(Math.log(bytes) / Math.log(k));
        return Math.round(bytes / Math.pow(k, i) * 100.0) / 100.0 + " " + sizes[i];
    }
}

