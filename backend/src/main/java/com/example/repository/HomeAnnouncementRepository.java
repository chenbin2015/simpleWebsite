package com.example.repository;

import com.example.entity.HomeAnnouncement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface HomeAnnouncementRepository extends JpaRepository<HomeAnnouncement, Long> {
    @Query("SELECT a FROM HomeAnnouncement a WHERE a.deleted = false AND a.status = :status")
    Page<HomeAnnouncement> findByStatus(@Param("status") String status, Pageable pageable);
    
    @Query("SELECT a FROM HomeAnnouncement a WHERE " +
           "a.deleted = false AND " +
           "(:status IS NULL OR a.status = :status) AND " +
           "(:keyword IS NULL OR a.title LIKE %:keyword% OR a.content LIKE %:keyword%) " +
           "ORDER BY a.publishTime DESC, a.createdAt DESC")
    Page<HomeAnnouncement> findByStatusAndKeyword(@Param("status") String status, 
                                                   @Param("keyword") String keyword, 
                                                   Pageable pageable);
    
    @Query("SELECT a FROM HomeAnnouncement a WHERE a.deleted = false ORDER BY a.publishTime DESC, a.createdAt DESC")
    Page<HomeAnnouncement> findAllNotDeleted(Pageable pageable);
}


