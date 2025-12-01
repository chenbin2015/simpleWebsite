package com.example.repository;

import com.example.entity.HomeCarousel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HomeCarouselRepository extends JpaRepository<HomeCarousel, Long> {
    @Query("SELECT c FROM HomeCarousel c WHERE c.deleted = false ORDER BY c.sort ASC, c.createdAt DESC")
    List<HomeCarousel> findAllOrderBySort();
}


