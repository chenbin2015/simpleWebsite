package com.example.repository;

import com.example.entity.FooterContact;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FooterContactRepository extends JpaRepository<FooterContact, Long> {
    // 联系方式只有一条记录，所以只需要基本的CRUD操作
}

