package com.example.service;

import com.example.entity.Menu;
import com.example.entity.ModuleProduct;
import com.example.repository.MenuRepository;
import com.example.repository.ModuleProductRepository;
import com.example.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ModuleProductService {
    
    @Autowired
    private ModuleProductRepository moduleProductRepository;
    
    @Autowired
    private MenuRepository menuRepository;
    
    /**
     * 获取菜单的产品列表
     */
    public Map<String, Object> getProductListByMenuId(Long menuId) {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        List<ModuleProduct> productList = moduleProductRepository.findByMenuIdAndDeletedFalseOrderByCreatedAtDesc(menuId);
        
        List<Map<String, Object>> data = productList.stream().map(product -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", product.getId());
            item.put("name", product.getName());
            item.put("image", product.getImage());
            item.put("category", product.getCategory());
            item.put("description", product.getDescription());
            item.put("link", product.getLink());
            item.put("createdAt", product.getCreatedAt());
            item.put("updatedAt", product.getUpdatedAt());
            return item;
        }).collect(Collectors.toList());
        
        result.put("success", true);
        result.put("data", data);
        return result;
    }
    
    /**
     * 添加产品
     */
    @Transactional
    public Map<String, Object> addProduct(Long menuId, Map<String, Object> data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        Menu menu = menuRepository.findByIdAndDeletedFalse(menuId).orElse(null);
        if (menu == null) {
            result.put("success", false);
            result.put("message", "菜单不存在");
            return result;
        }
        
        String name = (String) data.get("name");
        String image = (String) data.get("image");
        String category = (String) data.get("category");
        String description = (String) data.get("description");
        String link = (String) data.get("link");
        
        // 处理Base64图片，转换为文件
        String processedImage = image;
        if (image != null && image.startsWith("data:image")) {
            processedImage = FileUploadUtil.saveBase64Image(image);
        }
        
        ModuleProduct product = new ModuleProduct(menu, name, processedImage, category, description, link);
        product = moduleProductRepository.save(product);
        
        Map<String, Object> productData = new HashMap<>();
        productData.put("id", product.getId());
        productData.put("name", product.getName());
        productData.put("image", product.getImage());
        productData.put("category", product.getCategory());
        productData.put("description", product.getDescription());
        productData.put("link", product.getLink());
        productData.put("createdAt", product.getCreatedAt());
        productData.put("updatedAt", product.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "添加成功");
        result.put("data", productData);
        return result;
    }
    
    /**
     * 更新产品
     */
    @Transactional
    public Map<String, Object> updateProduct(Long id, Map<String, Object> data) throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        ModuleProduct product = moduleProductRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (product == null) {
            result.put("success", false);
            result.put("message", "产品不存在");
            return result;
        }
        
        if (data.get("name") != null) {
            product.setName((String) data.get("name"));
        }
        if (data.get("image") != null) {
            String image = (String) data.get("image");
            // 处理Base64图片，转换为文件
            if (image != null && image.startsWith("data:image")) {
                image = FileUploadUtil.saveBase64Image(image);
            }
            product.setImage(image);
        }
        if (data.get("category") != null) {
            product.setCategory((String) data.get("category"));
        }
        if (data.get("description") != null) {
            product.setDescription((String) data.get("description"));
        }
        if (data.get("link") != null) {
            product.setLink((String) data.get("link"));
        }
        
        product = moduleProductRepository.save(product);
        
        Map<String, Object> productData = new HashMap<>();
        productData.put("id", product.getId());
        productData.put("name", product.getName());
        productData.put("image", product.getImage());
        productData.put("category", product.getCategory());
        productData.put("description", product.getDescription());
        productData.put("link", product.getLink());
        productData.put("createdAt", product.getCreatedAt());
        productData.put("updatedAt", product.getUpdatedAt());
        
        result.put("success", true);
        result.put("message", "更新成功");
        result.put("data", productData);
        return result;
    }
    
    /**
     * 删除产品（逻辑删除）
     */
    @Transactional
    public Map<String, Object> deleteProduct(Long id) {
        Map<String, Object> result = new HashMap<>();
        
        ModuleProduct product = moduleProductRepository.findByIdAndDeletedFalse(id).orElse(null);
        if (product == null) {
            result.put("success", false);
            result.put("message", "产品不存在或已被删除");
            return result;
        }
        
        product.setDeleted(true);
        product.setDeletedAt(LocalDateTime.now());
        moduleProductRepository.save(product);
        
        result.put("success", true);
        result.put("message", "删除成功");
        return result;
    }
}

