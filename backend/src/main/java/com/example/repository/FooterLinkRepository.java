package com.example.repository;

import com.example.entity.FooterLink;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FooterLinkRepository extends JpaRepository<FooterLink, Long> {
    @Query("SELECT l FROM FooterLink l ORDER BY l.sort ASC, l.createdAt DESC")
    List<FooterLink> findAllOrderBySort();
}

