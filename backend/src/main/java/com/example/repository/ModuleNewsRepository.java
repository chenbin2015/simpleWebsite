package com.example.repository;

import com.example.entity.ModuleNews;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ModuleNewsRepository extends JpaRepository<ModuleNews, Long> {
    @Query("SELECT n FROM ModuleNews n WHERE n.menu.id = :menuId AND (n.deleted IS NULL OR n.deleted = false) ORDER BY n.publishTime DESC, n.createdAt DESC")
    List<ModuleNews> findByMenuIdAndDeletedFalseOrderByPublishTimeDesc(@Param("menuId") Long menuId);
    
    @Query("SELECT n FROM ModuleNews n WHERE n.id = :id AND (n.deleted IS NULL OR n.deleted = false)")
    java.util.Optional<ModuleNews> findByIdAndDeletedFalse(@Param("id") Long id);
}

