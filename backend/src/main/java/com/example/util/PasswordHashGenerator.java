package com.example.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * 生成BCrypt密码哈希的工具类
 * 用于初始化脚本生成默认管理员密码
 */
public class PasswordHashGenerator {
    
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "admin123";
        
        // 生成多个哈希值供选择
        System.out.println("为密码 '" + password + "' 生成BCrypt哈希值：");
        System.out.println();
        
        for (int i = 0; i < 3; i++) {
            String hash = encoder.encode(password);
            System.out.println("哈希 " + (i + 1) + ": " + hash);
            
            // 验证哈希是否正确
            boolean matches = encoder.matches(password, hash);
            System.out.println("验证结果: " + (matches ? "✓ 正确" : "✗ 错误"));
            System.out.println();
        }
        
        // 输出SQL语句
        String selectedHash = encoder.encode(password);
        System.out.println("SQL INSERT语句：");
        System.out.println("INSERT INTO users (username, password, email, email_verified, created_at, updated_at) VALUES");
        System.out.println("('admin', '" + selectedHash + "', 'admin@example.com', TRUE, NOW(), NOW());");
    }
}

