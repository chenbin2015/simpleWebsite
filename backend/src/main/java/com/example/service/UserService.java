package com.example.service;

import com.example.entity.User;
import com.example.repository.UserRepository;
import com.example.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    // 邮箱验证正则表达式
    private static final String EMAIL_PATTERN = 
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);
    
    /**
     * 验证邮箱格式
     */
    public boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return pattern.matcher(email).matches();
    }
    
    /**
     * 用户注册
     */
    public Map<String, Object> register(String username, String password, String confirmPassword, String email) {
        Map<String, Object> result = new HashMap<>();
        
        // 验证用户名
        if (username == null || username.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "用户名不能为空");
            return result;
        }
        
        if (username.length() < 3 || username.length() > 20) {
            result.put("success", false);
            result.put("message", "用户名长度必须在3-20个字符之间");
            return result;
        }
        
        // 验证密码
        if (password == null || password.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "密码不能为空");
            return result;
        }
        
        if (password.length() < 6 || password.length() > 20) {
            result.put("success", false);
            result.put("message", "密码长度必须在6-20个字符之间");
            return result;
        }
        
        // 验证确认密码
        if (!password.equals(confirmPassword)) {
            result.put("success", false);
            result.put("message", "两次输入的密码不一致");
            return result;
        }
        
        // 验证邮箱
        if (email == null || email.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "邮箱不能为空");
            return result;
        }
        
        if (!isValidEmail(email)) {
            result.put("success", false);
            result.put("message", "邮箱格式不正确");
            return result;
        }
        
        // 检查用户名是否已存在
        if (userRepository.existsByUsername(username)) {
            result.put("success", false);
            result.put("message", "用户名已存在");
            return result;
        }
        
        // 检查邮箱是否已存在
        if (userRepository.existsByEmail(email)) {
            result.put("success", false);
            result.put("message", "邮箱已被注册");
            return result;
        }
        
        // 创建用户，对密码进行BCrypt加密
        String encodedPassword = passwordEncoder.encode(password);
        User user = new User(username, encodedPassword, email);
        user.setEmailVerified(false);
        userRepository.save(user);
        
        result.put("success", true);
        result.put("message", "注册成功");
        result.put("user", Map.of(
            "id", user.getId(),
            "username", user.getUsername(),
            "email", user.getEmail()
        ));
        
        return result;
    }
    
    /**
     * 用户登录
     */
    public Map<String, Object> login(String username, String password) {
        Map<String, Object> result = new HashMap<>();
        
        // 验证输入
        if (username == null || username.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "用户名不能为空");
            return result;
        }
        
        if (password == null || password.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "密码不能为空");
            return result;
        }
        
        // 查找用户
        User user = userRepository.findByUsername(username).orElse(null);
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
            return result;
        }
        
        // 验证密码（使用BCrypt进行密码匹配）
        if (!passwordEncoder.matches(password, user.getPassword())) {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
            return result;
        }
        
        // 生成JWT Token（24小时有效期）
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        
        result.put("success", true);
        result.put("message", "登录成功");
        result.put("token", token);
        result.put("user", Map.of(
            "id", user.getId(),
            "username", user.getUsername(),
            "email", user.getEmail(),
            "emailVerified", user.getEmailVerified()
        ));
        
        return result;
    }
}

