package com.example.service;

import com.example.entity.*;
import com.example.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class FooterService {
    
    @Autowired
    private FooterContactRepository contactRepository;
    
    @Autowired
    private FooterLinkRepository linkRepository;
    
    @Autowired
    private FooterBasicRepository basicRepository;
    
    // ========== 联系方式管理 ==========
    
    /**
     * 获取联系方式
     */
    public Map<String, Object> getContact() {
        Map<String, Object> result = new HashMap<>();
        List<FooterContact> contacts = contactRepository.findAll();
        if (contacts.isEmpty()) {
            result.put("success", true);
            result.put("data", null);
        } else {
            FooterContact contact = contacts.get(0);
            Map<String, Object> data = new HashMap<>();
            data.put("id", contact.getId());
            data.put("address", contact.getAddress());
            data.put("postcode", contact.getPostcode());
            data.put("phone", contact.getPhone());
            data.put("fax", contact.getFax());
            data.put("email", contact.getEmail());
            data.put("workTime", contact.getWorkTime());
            data.put("createdAt", contact.getCreatedAt());
            data.put("updatedAt", contact.getUpdatedAt());
            result.put("success", true);
            result.put("data", data);
        }
        return result;
    }
    
    /**
     * 保存或更新联系方式
     */
    @Transactional
    public Map<String, Object> saveContact(Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        // 联系方式只有一条记录，先删除旧的
        contactRepository.deleteAll();
        
        FooterContact contact = new FooterContact();
        contact.setAddress((String) data.get("address"));
        contact.setPostcode((String) data.get("postcode"));
        contact.setPhone((String) data.get("phone"));
        contact.setFax((String) data.get("fax"));
        contact.setEmail((String) data.get("email"));
        contact.setWorkTime((String) data.get("workTime"));
        
        contact = contactRepository.save(contact);
        
        Map<String, Object> contactData = new HashMap<>();
        contactData.put("id", contact.getId());
        contactData.put("address", contact.getAddress());
        contactData.put("postcode", contact.getPostcode());
        contactData.put("phone", contact.getPhone());
        contactData.put("fax", contact.getFax());
        contactData.put("email", contact.getEmail());
        contactData.put("workTime", contact.getWorkTime());
        contactData.put("createdAt", contact.getCreatedAt());
        contactData.put("updatedAt", contact.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "保存成功");
        result.put("data", contactData);
        return result;
    }
    
    // ========== 友情链接管理 ==========
    
    /**
     * 获取友情链接列表
     */
    public Map<String, Object> getLinkList() {
        Map<String, Object> result = new HashMap<>();
        List<FooterLink> links = linkRepository.findAllOrderBySort();
        List<Map<String, Object>> data = links.stream().map(l -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", l.getId());
            item.put("name", l.getName());
            item.put("url", l.getUrl());
            item.put("target", l.getTarget());
            item.put("sort", l.getSort());
            item.put("createdAt", l.getCreatedAt());
            item.put("updatedAt", l.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    /**
     * 获取单个友情链接
     */
    public Map<String, Object> getLinkById(Long id) {
        Map<String, Object> result = new HashMap<>();
        FooterLink link = linkRepository.findById(id).orElse(null);
        if (link == null) {
            result.put("success", false);
            result.put("message", "链接不存在");
            return result;
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("id", link.getId());
        data.put("name", link.getName());
        data.put("url", link.getUrl());
        data.put("target", link.getTarget());
        data.put("sort", link.getSort());
        data.put("createdAt", link.getCreatedAt());
        data.put("updatedAt", link.getUpdatedAt());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    /**
     * 添加友情链接
     */
    @Transactional
    public Map<String, Object> addLink(Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        String name = (String) data.get("name");
        String url = (String) data.get("url");
        String target = data.get("target") != null ? (String) data.get("target") : "_blank";
        Integer sort = data.get("sort") != null ? ((Number) data.get("sort")).intValue() : 0;
        
        FooterLink link = new FooterLink(name, url, target, sort);
        link = linkRepository.save(link);
        
        Map<String, Object> linkData = new HashMap<>();
        linkData.put("id", link.getId());
        linkData.put("name", link.getName());
        linkData.put("url", link.getUrl());
        linkData.put("target", link.getTarget());
        linkData.put("sort", link.getSort());
        linkData.put("createdAt", link.getCreatedAt());
        linkData.put("updatedAt", link.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", linkData);
        return result;
    }
    
    /**
     * 更新友情链接
     */
    @Transactional
    public Map<String, Object> updateLink(Long id, Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        FooterLink link = linkRepository.findById(id).orElse(null);
        if (link == null) {
            result.put("success", false);
            result.put("message", "链接不存在");
            return result;
        }
        
        if (data.containsKey("name")) {
            link.setName((String) data.get("name"));
        }
        if (data.containsKey("url")) {
            link.setUrl((String) data.get("url"));
        }
        if (data.containsKey("target")) {
            link.setTarget((String) data.get("target"));
        }
        if (data.containsKey("sort")) {
            link.setSort(((Number) data.get("sort")).intValue());
        }
        
        link = linkRepository.save(link);
        
        Map<String, Object> linkData = new HashMap<>();
        linkData.put("id", link.getId());
        linkData.put("name", link.getName());
        linkData.put("url", link.getUrl());
        linkData.put("target", link.getTarget());
        linkData.put("sort", link.getSort());
        linkData.put("createdAt", link.getCreatedAt());
        linkData.put("updatedAt", link.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", linkData);
        return result;
    }
    
    /**
     * 删除友情链接
     */
    @Transactional
    public Map<String, Object> deleteLink(Long id) {
        Map<String, Object> result = new HashMap<>();
        if (!linkRepository.existsById(id)) {
            result.put("success", false);
            result.put("message", "链接不存在");
            return result;
        }
        linkRepository.deleteById(id);
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
    
    // ========== 基本信息管理 ==========
    
    /**
     * 获取基本信息
     */
    public Map<String, Object> getBasic() {
        Map<String, Object> result = new HashMap<>();
        List<FooterBasic> basics = basicRepository.findAll();
        if (basics.isEmpty()) {
            result.put("success", true);
            result.put("data", null);
        } else {
            FooterBasic basic = basics.get(0);
            Map<String, Object> data = new HashMap<>();
            data.put("id", basic.getId());
            data.put("copyright", basic.getCopyright());
            data.put("icp", basic.getIcp());
            data.put("logo", basic.getLogo());
            data.put("description", basic.getDescription());
            data.put("createdAt", basic.getCreatedAt());
            data.put("updatedAt", basic.getUpdatedAt());
            result.put("success", true);
            result.put("data", data);
        }
        return result;
    }
    
    /**
     * 保存或更新基本信息
     */
    @Transactional
    public Map<String, Object> saveBasic(Map<String, Object> data) {
        Map<String, Object> result = new HashMap<>();
        
        // 基本信息只有一条记录，先删除旧的
        basicRepository.deleteAll();
        
        FooterBasic basic = new FooterBasic();
        basic.setCopyright((String) data.get("copyright"));
        basic.setIcp((String) data.get("icp"));
        basic.setLogo((String) data.get("logo"));
        basic.setDescription((String) data.get("description"));
        
        basic = basicRepository.save(basic);
        
        Map<String, Object> basicData = new HashMap<>();
        basicData.put("id", basic.getId());
        basicData.put("copyright", basic.getCopyright());
        basicData.put("icp", basic.getIcp());
        basicData.put("logo", basic.getLogo());
        basicData.put("description", basic.getDescription());
        basicData.put("createdAt", basic.getCreatedAt());
        basicData.put("updatedAt", basic.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "保存成功");
        result.put("data", basicData);
        return result;
    }
}

