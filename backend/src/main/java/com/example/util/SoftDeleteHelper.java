package com.example.util;

import java.time.LocalDateTime;

/**
 * 逻辑删除辅助类
 */
public class SoftDeleteHelper {
    
    /**
     * 执行逻辑删除
     * @param entity 实体对象（需要包含 deleted 和 deletedAt 字段）
     */
    public static void softDelete(Object entity) {
        try {
            // 使用反射设置 deleted 和 deletedAt 字段
            entity.getClass().getMethod("setDeleted", Boolean.class).invoke(entity, true);
            entity.getClass().getMethod("setDeletedAt", LocalDateTime.class).invoke(entity, LocalDateTime.now());
        } catch (Exception e) {
            throw new RuntimeException("执行逻辑删除失败", e);
        }
    }
}

