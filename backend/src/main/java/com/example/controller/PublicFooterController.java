package com.example.controller;

import com.example.service.FooterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 公开Footer接口控制器
 * 用于前端访问，不需要token验证
 */
@RestController
@RequestMapping("/api/public/footer")
@CrossOrigin(origins = "*")
public class PublicFooterController {
    
    @Autowired
    private FooterService footerService;
    
    /**
     * 获取联系方式
     */
    @GetMapping("/contact")
    public Map<String, Object> getContact() {
        return footerService.getContact();
    }
    
    /**
     * 获取友情链接列表
     */
    @GetMapping("/link")
    public Map<String, Object> getLinkList() {
        return footerService.getLinkList();
    }
    
    /**
     * 获取基本信息
     */
    @GetMapping("/basic")
    public Map<String, Object> getBasic() {
        return footerService.getBasic();
    }
}

