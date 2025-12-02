package com.example.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * 静态资源过滤器
 * 为上传的文件（/upload/**）设置响应头，允许在iframe中加载
 */
@Component
@Order(1) // 确保在 Security Filter 之前执行，这样可以在响应头被设置后覆盖它们
public class StaticResourceFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        
        // 如果是上传文件的路径，包装响应以拦截和修改响应头
        if (path != null && path.startsWith("/upload/")) {
            HttpServletResponseWrapper wrappedResponse = new HttpServletResponseWrapper(response) {
                @Override
                public void setHeader(String name, String value) {
                    // 拦截 X-Frame-Options，不设置它（允许iframe加载）
                    if ("X-Frame-Options".equalsIgnoreCase(name)) {
                        return;
                    }
                    super.setHeader(name, value);
                }
                
                @Override
                public void addHeader(String name, String value) {
                    // 拦截 X-Frame-Options，不设置它
                    if ("X-Frame-Options".equalsIgnoreCase(name)) {
                        return;
                    }
                    super.addHeader(name, value);
                }
            };
            
            filterChain.doFilter(request, wrappedResponse);
            
            // 设置允许所有来源在iframe中加载
            response.setHeader("Content-Security-Policy", "frame-ancestors *");
        } else {
            filterChain.doFilter(request, response);
        }
    }
}
