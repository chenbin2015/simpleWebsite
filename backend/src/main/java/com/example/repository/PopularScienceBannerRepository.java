package com.example.repository;

import com.example.entity.PopularScienceBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PopularScienceBannerRepository extends JpaRepository<PopularScienceBanner, Long> {
    /**
     * 查找所有未删除的Banner
     */
    @Query("SELECT b FROM PopularScienceBanner b WHERE b.deleted = false ORDER BY b.createdAt DESC")
    List<PopularScienceBanner> findAllNotDeleted();
    
    /**
     * 查找第一个未删除的Banner
     */
    @Query("SELECT b FROM PopularScienceBanner b WHERE b.deleted = false ORDER BY b.createdAt DESC")
    Optional<PopularScienceBanner> findFirstNotDeleted();
}

