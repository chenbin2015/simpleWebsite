package com.example.controller;

import com.example.service.FooterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/footer")
@CrossOrigin(origins = "*")
public class FooterController {
    
    @Autowired
    private FooterService footerService;
    
    // ========== 联系方式管理 ==========
    
    /**
     * 获取联系方式
     */
    @GetMapping("/contact")
    public Map<String, Object> getContact() {
        return footerService.getContact();
    }
    
    /**
     * 保存或更新联系方式
     */
    @PostMapping("/contact")
    public Map<String, Object> saveContact(@RequestBody Map<String, Object> request) {
        return footerService.saveContact(request);
    }
    
    // ========== 友情链接管理 ==========
    
    /**
     * 获取友情链接列表
     */
    @GetMapping("/link")
    public Map<String, Object> getLinkList() {
        return footerService.getLinkList();
    }
    
    /**
     * 获取单个友情链接
     */
    @GetMapping("/link/{id}")
    public Map<String, Object> getLinkById(@PathVariable Long id) {
        return footerService.getLinkById(id);
    }
    
    /**
     * 添加友情链接
     */
    @PostMapping("/link")
    public Map<String, Object> addLink(@RequestBody Map<String, Object> request) {
        return footerService.addLink(request);
    }
    
    /**
     * 更新友情链接
     */
    @PutMapping("/link/{id}")
    public Map<String, Object> updateLink(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        return footerService.updateLink(id, request);
    }
    
    /**
     * 删除友情链接
     */
    @DeleteMapping("/link/{id}")
    public Map<String, Object> deleteLink(@PathVariable Long id) {
        return footerService.deleteLink(id);
    }
    
    // ========== 基本信息管理 ==========
    
    /**
     * 获取基本信息
     */
    @GetMapping("/basic")
    public Map<String, Object> getBasic() {
        return footerService.getBasic();
    }
    
    /**
     * 保存或更新基本信息
     */
    @PostMapping("/basic")
    public Map<String, Object> saveBasic(@RequestBody Map<String, Object> request) {
        return footerService.saveBasic(request);
    }
}

