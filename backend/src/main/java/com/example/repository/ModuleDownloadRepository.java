package com.example.repository;

import com.example.entity.ModuleDownload;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ModuleDownloadRepository extends JpaRepository<ModuleDownload, Long> {
    @Query("SELECT d FROM ModuleDownload d WHERE d.menu.id = :menuId AND (d.deleted IS NULL OR d.deleted = false) ORDER BY d.createdAt DESC")
    List<ModuleDownload> findByMenuIdAndDeletedFalseOrderByCreatedAtDesc(@Param("menuId") Long menuId);
    
    @Query("SELECT d FROM ModuleDownload d WHERE d.id = :id AND (d.deleted IS NULL OR d.deleted = false)")
    java.util.Optional<ModuleDownload> findByIdAndDeletedFalse(@Param("id") Long id);
}

