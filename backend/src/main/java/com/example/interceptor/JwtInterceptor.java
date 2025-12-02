package com.example.interceptor;

import com.example.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class JwtInterceptor implements HandlerInterceptor {
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 允许OPTIONS请求通过（CORS预检请求）
        if ("OPTIONS".equals(request.getMethod())) {
            return true;
        }
        
        // 公开接口不需要验证token
        String path = request.getRequestURI();
        if (path.startsWith("/api/user/login") || path.startsWith("/api/user/register") || path.startsWith("/api/hello")) {
            return true;
        }
        
        // 公开API路径不需要验证token（用于前端访问）
        if (path.startsWith("/api/public/")) {
            return true;
        }
        
        // 菜单和内容管理接口需要验证token
        if (path.startsWith("/api/menu") || path.startsWith("/api/content")) {
            // 继续验证token
        }
        
        // 从请求头获取token
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        } else {
            // 如果没有Authorization头，尝试从请求参数获取
            token = request.getParameter("token");
        }
        
        if (token == null || token.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"未提供认证token\"}");
            return false;
        }
        
        // 验证token
        if (!jwtUtil.validateToken(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"token无效或已过期\"}");
            return false;
        }
        
        // 将用户信息存储到request中，供后续使用
        String username = jwtUtil.getUsernameFromToken(token);
        Long userId = jwtUtil.getUserIdFromToken(token);
        request.setAttribute("userId", userId);
        request.setAttribute("username", username);
        
        return true;
    }
}

