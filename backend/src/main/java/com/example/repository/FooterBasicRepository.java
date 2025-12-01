package com.example.repository;

import com.example.entity.FooterBasic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FooterBasicRepository extends JpaRepository<FooterBasic, Long> {
    // 基本信息只有一条记录，所以只需要基本的CRUD操作
}

