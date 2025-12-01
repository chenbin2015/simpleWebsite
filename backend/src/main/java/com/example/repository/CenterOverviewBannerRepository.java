package com.example.repository;

import com.example.entity.CenterOverviewBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CenterOverviewBannerRepository extends JpaRepository<CenterOverviewBanner, Long> {
    // Banner只有一条记录（单例模式）
    
    /**
     * 查询所有未删除的Banner
     */
    @Query("SELECT b FROM CenterOverviewBanner b WHERE b.deleted = false OR b.deleted IS NULL")
    List<CenterOverviewBanner> findAllNotDeleted();
}

