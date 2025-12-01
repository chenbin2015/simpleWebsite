package com.example.repository;

import com.example.entity.ModuleProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ModuleProductRepository extends JpaRepository<ModuleProduct, Long> {
    @Query("SELECT p FROM ModuleProduct p WHERE p.menu.id = :menuId AND (p.deleted IS NULL OR p.deleted = false) ORDER BY p.createdAt DESC")
    List<ModuleProduct> findByMenuIdAndDeletedFalseOrderByCreatedAtDesc(@Param("menuId") Long menuId);
    
    @Query("SELECT p FROM ModuleProduct p WHERE p.id = :id AND (p.deleted IS NULL OR p.deleted = false)")
    java.util.Optional<ModuleProduct> findByIdAndDeletedFalse(@Param("id") Long id);
}

