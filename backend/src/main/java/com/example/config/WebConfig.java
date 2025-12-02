package com.example.config;

import com.example.interceptor.JwtInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Autowired
    private JwtInterceptor jwtInterceptor;
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/user/login", "/api/user/register", "/api/hello", "/api/public/**");
    }
    
    /**
     * 配置静态资源映射，使上传的文件可以通过HTTP访问
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 获取项目根目录
        String userDir = System.getProperty("user.dir");
        String uploadPath = Paths.get(userDir, "upload").toAbsolutePath().toString().replace("\\", "/");
        
        // 将 /upload/** 映射到项目根目录下的 upload 文件夹
        // 设置缓存时间为0，避免缓存问题
        // 注意：静态资源处理器会自动处理 Range 请求（用于视频流式播放）
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:" + uploadPath + "/")
                .setCachePeriod(0); // 不缓存，确保获取最新文件
    }
}


