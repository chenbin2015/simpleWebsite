package com.example.repository;

import com.example.entity.CenterOverviewOrganization;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CenterOverviewOrganizationRepository extends JpaRepository<CenterOverviewOrganization, Long> {
    List<CenterOverviewOrganization> findByRoleOrderBySortOrderAsc(String role);
    
    void deleteByRole(String role);
    
    /**
     * 查询所有未删除的组织成员
     */
    @Query("SELECT o FROM CenterOverviewOrganization o WHERE o.deleted = false OR o.deleted IS NULL")
    List<CenterOverviewOrganization> findAllNotDeleted();
    
    /**
     * 查询指定角色的未删除成员，按sortOrder排序
     */
    @Query("SELECT o FROM CenterOverviewOrganization o WHERE o.role = :role AND (o.deleted = false OR o.deleted IS NULL) ORDER BY o.sortOrder ASC")
    List<CenterOverviewOrganization> findByRoleNotDeletedOrderBySortOrderAsc(@Param("role") String role);
}

