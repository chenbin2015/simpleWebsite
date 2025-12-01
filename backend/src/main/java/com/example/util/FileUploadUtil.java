package com.example.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 文件上传工具类
 */
public class FileUploadUtil {
    
    // 上传目录根路径（相对于项目根目录或工作目录）
    private static final String UPLOAD_DIR = "upload";
    
    /**
     * 获取上传目录的绝对路径（在项目根目录下）
     */
    private static Path getUploadBasePath() {
        // 获取项目根目录（工作目录）
        String userDir = System.getProperty("user.dir");
        Path basePath = Paths.get(userDir, UPLOAD_DIR);
        return basePath;
    }
    
    /**
     * 保存上传的文件
     * 
     * @param file 上传的文件
     * @return 相对路径，例如：upload/20251130/1701234567890_abc123.jpg
     * @throws IOException 文件保存失败
     */
    public static String saveFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }
        
        // 1. 创建日期目录（格式：YYYYMMDD，例如：20251130）
        LocalDate today = LocalDate.now();
        String dateDir = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        
        // 2. 生成文件名：时间戳 + 随机字符 + 原始文件扩展名
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        // 生成随机字符（取UUID的前8位）
        String randomStr = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        String fileName = System.currentTimeMillis() + "_" + randomStr + extension;
        
        // 3. 构建完整路径（使用绝对路径，在项目根目录下）
        Path basePath = getUploadBasePath();
        Path uploadPath = basePath.resolve(dateDir);
        Path filePath = uploadPath.resolve(fileName);
        
        // 4. 创建目录（如果不存在）
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // 5. 保存文件（使用绝对路径）
        file.transferTo(filePath.toFile());
        
        // 6. 返回相对路径（使用正斜杠，适用于Web路径）
        String relativePath = UPLOAD_DIR + "/" + dateDir + "/" + fileName;
        return relativePath;
    }
    
    /**
     * 删除文件
     * 
     * @param filePath 相对路径，例如：upload/20251130/1701234567890_abc123.jpg
     * @return 是否删除成功
     */
    public static boolean deleteFile(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return false;
        }
        
        try {
            // 将相对路径转换为绝对路径
            Path path = Paths.get(filePath.replace("/", File.separator));
            File file = path.toFile();
            
            if (file.exists() && file.isFile()) {
                return file.delete();
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 验证文件是否为图片
     * 
     * @param file 文件
     * @return 是否为图片
     */
    public static boolean isImage(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return false;
        }
        
        String contentType = file.getContentType();
        if (contentType == null) {
            return false;
        }
        
        return contentType.startsWith("image/");
    }
    
    /**
     * 验证文件是否为视频
     * 
     * @param file 文件
     * @return 是否为视频
     */
    public static boolean isVideo(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return false;
        }
        
        String contentType = file.getContentType();
        if (contentType == null) {
            return false;
        }
        
        return contentType.startsWith("video/");
    }
    
    /**
     * 验证文件大小（单位：字节）
     * 
     * @param file 文件
     * @param maxSize 最大大小（字节）
     * @return 是否符合要求
     */
    public static boolean isValidSize(MultipartFile file, long maxSize) {
        if (file == null || file.isEmpty()) {
            return false;
        }
        return file.getSize() <= maxSize;
    }
    
    /**
     * 保存Base64格式的图片
     * 
     * @param base64Image Base64格式的图片数据，格式：data:image/png;base64,iVBORw0KG...
     * @return 相对路径，例如：upload/20251130/1701234567890_abc123.jpg
     * @throws IOException 文件保存失败
     */
    public static String saveBase64Image(String base64Image) throws IOException {
        if (base64Image == null || base64Image.isEmpty()) {
            throw new IllegalArgumentException("Base64图片数据不能为空");
        }
        
        // 解析Base64数据
        String[] parts = base64Image.split(",");
        if (parts.length != 2) {
            throw new IllegalArgumentException("Base64格式不正确");
        }
        
        String header = parts[0]; // data:image/png;base64
        String base64Data = parts[1];
        
        // 获取图片格式
        String extension = ".jpg";
        if (header.contains("image/png")) {
            extension = ".png";
        } else if (header.contains("image/gif")) {
            extension = ".gif";
        } else if (header.contains("image/webp")) {
            extension = ".webp";
        }
        
        // 解码Base64数据
        byte[] imageBytes = java.util.Base64.getDecoder().decode(base64Data);
        
        // 创建日期目录
        LocalDate today = LocalDate.now();
        String dateDir = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        
        // 生成文件名
        String randomStr = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        String fileName = System.currentTimeMillis() + "_" + randomStr + extension;
        
        // 构建完整路径（使用绝对路径，在项目根目录下）
        Path basePath = getUploadBasePath();
        Path uploadPath = basePath.resolve(dateDir);
        Path filePath = uploadPath.resolve(fileName);
        
        // 创建目录（如果不存在）
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // 保存文件
        Files.write(filePath, imageBytes);
        
        // 返回相对路径（使用正斜杠，适用于Web路径）
        return UPLOAD_DIR + "/" + dateDir + "/" + fileName;
    }
    
    /**
     * 处理HTML内容中的Base64图片，将其转换为文件并替换为文件路径
     * 
     * @param htmlContent HTML内容
     * @return 处理后的HTML内容（Base64图片已被替换为文件路径）
     * @throws IOException 文件保存失败
     */
    public static String processHtmlImages(String htmlContent) throws IOException {
        if (htmlContent == null || htmlContent.isEmpty()) {
            return htmlContent;
        }
        
        // 使用正则表达式匹配 img 标签中的 Base64 图片
        // 匹配 <img ... src="data:image/..." ...> 格式，支持各种属性顺序
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
            "<img\\s+([^>]*?\\s+)?src=['\"](data:image/[^'\"]+)['\"]([^>]*?)>",
            java.util.regex.Pattern.CASE_INSENSITIVE | java.util.regex.Pattern.DOTALL
        );
        
        java.util.regex.Matcher matcher = pattern.matcher(htmlContent);
        StringBuffer result = new StringBuffer();
        
        while (matcher.find()) {
            String base64Image = matcher.group(2); // 获取 Base64 图片数据
            String beforeSrc = matcher.group(1) != null ? matcher.group(1) : "";   // src 之前的属性
            String afterSrc = matcher.group(3) != null ? matcher.group(3) : "";    // src 之后的属性
            
            try {
                // 将 Base64 图片转换为文件
                String filePath = saveBase64Image(base64Image);
                
                // 替换为文件路径（保留原有属性，只替换src）
                String replacement;
                if (beforeSrc.isEmpty() && afterSrc.isEmpty()) {
                    replacement = "<img src=\"/" + filePath + "\">";
                } else if (beforeSrc.isEmpty()) {
                    replacement = "<img src=\"/" + filePath + "\"" + afterSrc + ">";
                } else if (afterSrc.isEmpty()) {
                    replacement = "<img" + beforeSrc + " src=\"/" + filePath + "\">";
                } else {
                    replacement = "<img" + beforeSrc + " src=\"/" + filePath + "\"" + afterSrc + ">";
                }
                matcher.appendReplacement(result, java.util.regex.Matcher.quoteReplacement(replacement));
            } catch (Exception e) {
                // 如果转换失败，保持原样
                System.err.println("转换Base64图片失败: " + e.getMessage());
                matcher.appendReplacement(result, matcher.group(0));
            }
        }
        matcher.appendTail(result);
        
        return result.toString();
    }
}

