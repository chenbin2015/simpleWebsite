package com.example.repository;

import com.example.entity.ModuleBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ModuleBannerRepository extends JpaRepository<ModuleBanner, Long> {
    
    /**
     * 根据分类查询所有未删除的Banner
     */
    @Query("SELECT b FROM ModuleBanner b WHERE b.category = :category AND (b.deleted = false OR b.deleted IS NULL)")
    List<ModuleBanner> findByCategoryNotDeleted(@Param("category") String category);
    
    /**
     * 根据分类查询单个未删除的Banner（每个分类只有一个）
     */
    @Query("SELECT b FROM ModuleBanner b WHERE b.category = :category AND (b.deleted = false OR b.deleted IS NULL)")
    Optional<ModuleBanner> findOneByCategoryNotDeleted(@Param("category") String category);
    
    /**
     * 查询所有未删除的Banner
     */
    @Query("SELECT b FROM ModuleBanner b WHERE b.deleted = false OR b.deleted IS NULL")
    List<ModuleBanner> findAllNotDeleted();
}

