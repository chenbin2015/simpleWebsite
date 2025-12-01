package com.example.repository;

import com.example.entity.PopularScienceCarousel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PopularScienceCarouselRepository extends JpaRepository<PopularScienceCarousel, Long> {
    @Query("SELECT c FROM PopularScienceCarousel c ORDER BY c.sort ASC, c.createdAt DESC")
    List<PopularScienceCarousel> findAllOrderBySort();
}

