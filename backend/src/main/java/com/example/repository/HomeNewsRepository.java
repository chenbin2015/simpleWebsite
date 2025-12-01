package com.example.repository;

import com.example.entity.HomeNews;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface HomeNewsRepository extends JpaRepository<HomeNews, Long> {
    @Query("SELECT n FROM HomeNews n WHERE n.deleted = false AND n.status = :status")
    Page<HomeNews> findByStatus(@Param("status") String status, Pageable pageable);
    
    @Query("SELECT n FROM HomeNews n WHERE " +
           "n.deleted = false AND " +
           "(:status IS NULL OR n.status = :status) AND " +
           "(:keyword IS NULL OR n.title LIKE %:keyword% OR n.content LIKE %:keyword%) " +
           "ORDER BY n.publishTime DESC, n.createdAt DESC")
    Page<HomeNews> findByStatusAndKeyword(@Param("status") String status, 
                                          @Param("keyword") String keyword, 
                                          Pageable pageable);
    
    @Query("SELECT n FROM HomeNews n WHERE n.deleted = false ORDER BY n.publishTime DESC, n.createdAt DESC")
    Page<HomeNews> findAllNotDeleted(Pageable pageable);
}


