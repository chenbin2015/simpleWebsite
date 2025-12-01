package com.example.repository;

import com.example.entity.PopularScienceArticle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PopularScienceArticleRepository extends JpaRepository<PopularScienceArticle, Long> {
    @Query("SELECT a FROM PopularScienceArticle a WHERE a.status = 'published' ORDER BY a.publishTime DESC")
    List<PopularScienceArticle> findAllPublished();
    
    @Query("SELECT a FROM PopularScienceArticle a ORDER BY a.createdAt DESC")
    List<PopularScienceArticle> findAllOrderByCreatedAt();
    
    Page<PopularScienceArticle> findByStatus(String status, Pageable pageable);
    
    @Query("SELECT a FROM PopularScienceArticle a WHERE " +
           "(:status IS NULL OR a.status = :status) AND " +
           "(:keyword IS NULL OR a.title LIKE %:keyword% OR a.content LIKE %:keyword%) " +
           "ORDER BY a.publishTime DESC, a.createdAt DESC")
    Page<PopularScienceArticle> findByStatusAndKeyword(@Param("status") String status, 
                                                       @Param("keyword") String keyword, 
                                                       Pageable pageable);
}

