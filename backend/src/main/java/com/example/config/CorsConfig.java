package com.example.config;

import org.springframework.context.annotation.Configuration;

/**
 * CORS 配置已移至 SecurityConfig 统一管理，避免重复设置 CORS 响应头
 */
@Configuration
public class CorsConfig {
    // CORS 配置已移至 SecurityConfig.corsConfigurationSource()
    // 这里保留类是为了避免其他可能的引用
}

