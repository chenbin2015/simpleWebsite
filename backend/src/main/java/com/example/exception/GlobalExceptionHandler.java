package com.example.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.apache.catalina.connector.ClientAbortException;

import java.util.HashMap;
import java.util.Map;

/**
 * 全局异常处理器
 */
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    /**
     * 处理客户端中断连接的异常（通常发生在视频/大文件传输时）
     * 这种异常不需要特殊处理，只是客户端取消了请求
     */
    @ExceptionHandler(ClientAbortException.class)
    public void handleClientAbortException(ClientAbortException e) {
        // 客户端中断连接是正常情况（例如用户取消下载、页面刷新等）
        // 不需要记录错误或返回响应，静默处理即可
    }
    
    /**
     * 处理文件大小超过限制的异常
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    @ResponseStatus(HttpStatus.PAYLOAD_TOO_LARGE)
    public Map<String, Object> handleMaxUploadSizeExceeded(MaxUploadSizeExceededException e) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", "文件大小超过限制，最大允许500MB");
        return result;
    }
    
    /**
     * 处理文件上传相关的其他异常
     */
    @ExceptionHandler(MultipartException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, Object> handleMultipartException(MultipartException e) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        String message = e.getMessage();
        if (message != null && message.contains("exceeds")) {
            result.put("message", "文件大小超过限制，最大允许500MB");
        } else {
            result.put("message", "文件上传失败: " + (e.getCause() != null ? e.getCause().getMessage() : e.getMessage()));
        }
        return result;
    }
    
    /**
     * 处理其他异常
     * 对于静态资源请求（如视频文件），避免返回 JSON 响应
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Object handleException(Exception e, HttpServletRequest request) {
        // 检查是否是客户端中断连接的异常
        Throwable cause = e;
        while (cause != null) {
            if (cause instanceof ClientAbortException) {
                // 客户端中断，静默处理，不返回响应
                return null;
            }
            cause = cause.getCause();
        }
        
        // 检查请求路径，如果是静态资源请求，不返回 JSON
        if (request != null) {
            String requestPath = request.getRequestURI();
            if (requestPath != null && requestPath.startsWith("/upload/")) {
                // 对于静态资源请求的异常，不返回 JSON，避免 Content-Type 冲突
                // 只记录日志
                System.err.println("静态资源请求异常: " + requestPath + " - " + e.getMessage());
                return null;
            }
        }
        
        // 对于 API 请求，返回 JSON 错误响应
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", "服务器内部错误: " + e.getMessage());
        e.printStackTrace();
        return result;
    }
}

