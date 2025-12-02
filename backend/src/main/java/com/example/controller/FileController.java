package com.example.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 文件访问控制器
 * 专门处理文件下载，确保正确的 Content-Type 和响应头
 */
@RestController
@RequestMapping("/file")
// 不设置 @CrossOrigin，使用全局 CorsConfig 统一处理 CORS
public class FileController {
    
    private static final Logger logger = LoggerFactory.getLogger(FileController.class);
    
    /**
     * 下载或访问上传的文件
     * 路径格式：/file/upload/20251202/xxx.docx
     */
    @GetMapping("/upload/**")
    public ResponseEntity<Resource> downloadFile(
            HttpServletRequest request,
            @RequestParam(value = "download", defaultValue = "false") boolean download) throws IOException {
        
        // 获取完整的请求路径
        String requestURI = request.getRequestURI();
        logger.info("========== 文件访问请求 ==========");
        logger.info("请求URI: {}", requestURI);
        logger.info("下载模式: {}", download);
        
        // 移除 /file 前缀，得到实际的相对路径
        String relativePath = requestURI.replaceFirst("^/file", "");
        logger.info("相对路径: {}", relativePath);
        
        if (!relativePath.startsWith("/upload/")) {
            logger.warn("路径不合法，不是 /upload/ 开头");
            return ResponseEntity.notFound().build();
        }
        
        // 获取项目根目录
        String userDir = System.getProperty("user.dir");
        Path filePath = Paths.get(userDir, relativePath.substring(1)); // 移除开头的 /
        logger.info("项目根目录: {}", userDir);
        logger.info("完整文件路径: {}", filePath.toAbsolutePath());
        
        File file = filePath.toFile();
        
        // 检查文件是否存在
        if (!file.exists() || !file.isFile()) {
            logger.error("文件不存在或不是文件: {}", filePath.toAbsolutePath());
            logger.error("文件存在: {}, 是文件: {}", file.exists(), file.isFile());
            
            // 检查父目录是否存在
            File parentDir = file.getParentFile();
            if (parentDir != null) {
                logger.error("父目录存在: {}, 是目录: {}", parentDir.exists(), parentDir.isDirectory());
                if (parentDir.exists() && parentDir.isDirectory()) {
                    String[] files = parentDir.list();
                    if (files != null) {
                        logger.error("父目录中的文件列表: {}", java.util.Arrays.toString(files));
                    }
                }
            }
            
            return ResponseEntity.notFound().build();
        }
        
        logger.info("文件存在，大小: {} bytes", file.length());
        
        Resource resource = new FileSystemResource(file);
        
        // 根据文件扩展名确定 Content-Type（优先使用扩展名，更准确）
        String fileName = file.getName().toLowerCase();
        logger.info("文件名: {}", fileName);
        
        String contentType = null;
        
        // 优先根据扩展名设置 Content-Type（更可靠）
        if (fileName.endsWith(".pdf")) {
            contentType = "application/pdf";
        } else if (fileName.endsWith(".docx")) {
            contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        } else if (fileName.endsWith(".doc")) {
            contentType = "application/msword";
        } else if (fileName.endsWith(".xlsx")) {
            contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        } else if (fileName.endsWith(".xls")) {
            contentType = "application/vnd.ms-excel";
        } else if (fileName.endsWith(".pptx")) {
            contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
        } else if (fileName.endsWith(".ppt")) {
            contentType = "application/vnd.ms-powerpoint";
        } else {
            // 对于未知类型，尝试自动检测
            contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
        }
        logger.info("设置的Content-Type: {}", contentType);
        
        HttpHeaders headers = new HttpHeaders();
        // 确保 contentType 不为 null
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        headers.setContentType(MediaType.parseMediaType(contentType));
        logger.info("最终设置的Content-Type: {}", contentType);
        
        // 如果是下载请求，设置 Content-Disposition 头
        if (download) {
            headers.setContentDispositionFormData("attachment", file.getName());
        } else {
            // 预览模式：inline，允许在浏览器中显示
            headers.setContentDispositionFormData("inline", file.getName());
        }
        
        // 设置允许 iframe 加载（CORS 由全局 CorsConfig 统一处理，不在这里重复设置）
        headers.set("Content-Security-Policy", "frame-ancestors *");
        // 移除 X-Frame-Options 限制（如果 Security 设置了）
        headers.remove("X-Frame-Options");
        
        logger.info("响应头设置完成，准备返回文件");
        logger.info("========== 文件访问请求处理完成 ==========");
        
        return ResponseEntity.ok()
                .headers(headers)
                .body(resource);
    }
}

