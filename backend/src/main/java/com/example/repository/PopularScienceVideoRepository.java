package com.example.repository;

import com.example.entity.PopularScienceVideo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PopularScienceVideoRepository extends JpaRepository<PopularScienceVideo, Long> {
    @Query("SELECT v FROM PopularScienceVideo v WHERE v.status = 'published' ORDER BY v.publishTime DESC")
    List<PopularScienceVideo> findAllPublished();
    
    @Query("SELECT v FROM PopularScienceVideo v ORDER BY v.createdAt DESC")
    List<PopularScienceVideo> findAllOrderByCreatedAt();
}

