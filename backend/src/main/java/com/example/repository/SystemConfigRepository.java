package com.example.repository;

import com.example.entity.SystemConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SystemConfigRepository extends JpaRepository<SystemConfig, Long> {
    /**
     * 根据配置键查找配置
     */
    Optional<SystemConfig> findByConfigKey(String configKey);
}

