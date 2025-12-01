package com.example.repository;

import com.example.entity.Menu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MenuRepository extends JpaRepository<Menu, Long> {
    List<Menu> findByParentIsNullOrderBySortOrderAsc();
    List<Menu> findByParentIdOrderBySortOrderAsc(Long parentId);
    Optional<Menu> findById(Long id);
    boolean existsByNameAndParentId(String name, Long parentId);
    boolean existsByNameAndParentIsNull(String name);
    
    // 逻辑删除相关查询方法
    @Query("SELECT m FROM Menu m WHERE m.parent IS NULL AND (m.deleted IS NULL OR m.deleted = false) ORDER BY m.sortOrder ASC")
    List<Menu> findByParentIsNullAndDeletedFalseOrderBySortOrderAsc();
    
    @Query("SELECT m FROM Menu m WHERE m.parent.id = :parentId AND (m.deleted IS NULL OR m.deleted = false) ORDER BY m.sortOrder ASC")
    List<Menu> findByParentIdAndDeletedFalseOrderBySortOrderAsc(@Param("parentId") Long parentId);
    
    @Query("SELECT m FROM Menu m WHERE m.id = :id AND (m.deleted IS NULL OR m.deleted = false)")
    Optional<Menu> findByIdAndDeletedFalse(@Param("id") Long id);
    
    @Query("SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM Menu m WHERE m.name = :name AND m.parent.id = :parentId AND (m.deleted IS NULL OR m.deleted = false)")
    boolean existsByNameAndParentIdAndDeletedFalse(@Param("name") String name, @Param("parentId") Long parentId);
    
    @Query("SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM Menu m WHERE m.name = :name AND m.parent IS NULL AND (m.deleted IS NULL OR m.deleted = false)")
    boolean existsByNameAndParentIsNullAndDeletedFalse(@Param("name") String name);
}


