package com.example.repository;

import com.example.entity.PopularScienceCarousel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PopularScienceCarouselRepository extends JpaRepository<PopularScienceCarousel, Long> {
    /**
     * 查找所有未删除的轮播图，按排序和创建时间排序
     */
    @Query("SELECT c FROM PopularScienceCarousel c WHERE c.deleted = false ORDER BY c.sort ASC, c.createdAt DESC")
    List<PopularScienceCarousel> findAllOrderBySort();
    
    /**
     * 根据ID查找未删除的轮播图
     */
    @Query("SELECT c FROM PopularScienceCarousel c WHERE c.id = :id AND c.deleted = false")
    java.util.Optional<PopularScienceCarousel> findByIdAndDeletedFalse(@org.springframework.data.repository.query.Param("id") Long id);
    
    /**
     * 查找所有未删除的轮播图
     */
    @Query("SELECT c FROM PopularScienceCarousel c WHERE c.deleted = false")
    List<PopularScienceCarousel> findAllNotDeleted();
}

