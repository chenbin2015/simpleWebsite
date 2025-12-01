package com.example.repository;

import com.example.entity.CenterOverviewLaboratory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CenterOverviewLaboratoryRepository extends JpaRepository<CenterOverviewLaboratory, Long> {
    @Query("SELECT l FROM CenterOverviewLaboratory l ORDER BY l.sortOrder ASC")
    List<CenterOverviewLaboratory> findAllOrderBySortOrder();
    
    /**
     * 查询所有未删除的实验室，按sortOrder排序
     */
    @Query("SELECT l FROM CenterOverviewLaboratory l WHERE l.deleted = false OR l.deleted IS NULL ORDER BY l.sortOrder ASC")
    List<CenterOverviewLaboratory> findAllNotDeletedOrderBySortOrder();
}

