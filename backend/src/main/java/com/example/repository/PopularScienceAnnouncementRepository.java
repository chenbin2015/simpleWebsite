package com.example.repository;

import com.example.entity.PopularScienceAnnouncement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PopularScienceAnnouncementRepository extends JpaRepository<PopularScienceAnnouncement, Long> {
    @Query("SELECT a FROM PopularScienceAnnouncement a WHERE a.status = 'published' ORDER BY a.publishTime DESC")
    List<PopularScienceAnnouncement> findAllPublished();
    
    @Query("SELECT a FROM PopularScienceAnnouncement a ORDER BY a.createdAt DESC")
    List<PopularScienceAnnouncement> findAllOrderByCreatedAt();
    
    Page<PopularScienceAnnouncement> findByStatus(String status, Pageable pageable);
    
    @Query("SELECT a FROM PopularScienceAnnouncement a WHERE " +
           "(:status IS NULL OR a.status = :status) AND " +
           "(:keyword IS NULL OR a.title LIKE %:keyword% OR a.content LIKE %:keyword%) " +
           "ORDER BY a.publishTime DESC, a.createdAt DESC")
    Page<PopularScienceAnnouncement> findByStatusAndKeyword(@Param("status") String status, 
                                                            @Param("keyword") String keyword, 
                                                            Pageable pageable);
}

