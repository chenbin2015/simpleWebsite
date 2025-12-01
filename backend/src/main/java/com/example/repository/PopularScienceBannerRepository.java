package com.example.repository;

import com.example.entity.PopularScienceBanner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PopularScienceBannerRepository extends JpaRepository<PopularScienceBanner, Long> {
    // Banner只有一张，所以只需要基本的CRUD操作
}

