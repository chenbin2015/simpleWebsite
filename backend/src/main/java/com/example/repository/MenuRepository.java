package com.example.repository;

import com.example.entity.Menu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
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
}


