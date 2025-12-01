package com.example.repository;

import com.example.entity.HomeBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HomeBannerRepository extends JpaRepository<HomeBanner, Long> {
    // Banner只有一张，所以只需要基本的CRUD操作
    
    /**
     * 查询所有未删除的Banner
     */
    @Query("SELECT b FROM HomeBanner b WHERE b.deleted = false")
    List<HomeBanner> findAllNotDeleted();
}


