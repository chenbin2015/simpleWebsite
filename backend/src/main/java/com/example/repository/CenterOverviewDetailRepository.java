package com.example.repository;

import com.example.entity.CenterOverviewDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CenterOverviewDetailRepository extends JpaRepository<CenterOverviewDetail, Long> {
    // 详情只有一条记录（单例模式）
}

