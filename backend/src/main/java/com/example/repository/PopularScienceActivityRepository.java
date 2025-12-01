package com.example.repository;

import com.example.entity.PopularScienceActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PopularScienceActivityRepository extends JpaRepository<PopularScienceActivity, Long> {
    @Query("SELECT a FROM PopularScienceActivity a WHERE a.status = 'published' ORDER BY a.startTime DESC")
    List<PopularScienceActivity> findAllPublished();
    
    @Query("SELECT a FROM PopularScienceActivity a ORDER BY a.createdAt DESC")
    List<PopularScienceActivity> findAllOrderByCreatedAt();
}

