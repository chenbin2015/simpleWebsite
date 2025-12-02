package com.example.util;

import com.example.entity.SystemConfig;
import com.example.repository.SystemConfigRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;

/**
 * 配置工具类
 * 用于读取系统配置（如基础URL等）
 */
@Component
public class ConfigUtil {
    
    private static SystemConfigRepository configRepository;
    
    @Autowired
    private SystemConfigRepository systemConfigRepository;
    
    @PostConstruct
    public void init() {
        ConfigUtil.configRepository = this.systemConfigRepository;
    }
    
    /**
     * 获取配置值
     * 
     * @param configKey 配置键
     * @param defaultValue 默认值（如果配置不存在）
     * @return 配置值
     */
    public static String getConfigValue(String configKey, String defaultValue) {
        if (configRepository == null) {
            return defaultValue;
        }
        
        try {
            return configRepository.findByConfigKey(configKey)
                    .map(SystemConfig::getConfigValue)
                    .orElse(defaultValue);
        } catch (Exception e) {
            // 如果查询失败（如数据库未初始化），返回默认值
            System.err.println("获取配置失败: " + configKey + ", 使用默认值: " + defaultValue);
            return defaultValue;
        }
    }
    
    /**
     * 获取基础URL（用于拼接完整的文件访问URL）
     * 
     * @return 基础URL，例如：http://localhost:8080
     */
    public static String getBaseUrl() {
        return getConfigValue("base_url", "http://localhost:8080");
    }
    
    /**
     * 将相对路径转换为完整URL
     * 如果路径已经是完整URL（以http://或https://开头），则直接返回
     * 否则，拼接基础URL
     * 
     * @param relativePath 相对路径，例如：upload/20251201/xxx.jpg
     * @return 完整URL，例如：http://localhost:8080/upload/20251201/xxx.jpg
     */
    public static String buildFullUrl(String relativePath) {
        if (relativePath == null || relativePath.isEmpty()) {
            return relativePath;
        }
        
        // 如果已经是完整URL，直接返回
        if (relativePath.startsWith("http://") || relativePath.startsWith("https://")) {
            return relativePath;
        }
        
        // 获取基础URL并拼接
        String baseUrl = getBaseUrl();
        // 确保baseUrl不以斜杠结尾
        if (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        
        // 确保relativePath以斜杠开头
        if (!relativePath.startsWith("/")) {
            relativePath = "/" + relativePath;
        }
        
        return baseUrl + relativePath;
    }
}

