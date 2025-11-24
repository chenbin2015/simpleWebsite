package com.example.controller;

import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/user")
@CrossOrigin(origins = "http://localhost:3000")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    /**
     * 用户注册接口
     */
    @PostMapping("/register")
    public Map<String, Object> register(@RequestBody Map<String, String> request) {
        String username = request.get("username");
        String password = request.get("password");
        String confirmPassword = request.get("confirmPassword");
        String email = request.get("email");
        
        return userService.register(username, password, confirmPassword, email);
    }
    
    /**
     * 用户登录接口
     */
    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> request) {
        String username = request.get("username");
        String password = request.get("password");
        
        return userService.login(username, password);
    }
}


