-- 修改实验室detail字段为LONGTEXT，移除video_url字段
-- 注意：MySQL不支持DROP COLUMN IF EXISTS，需要手动检查或使用存储过程

-- 首先，检查并删除video_url字段（如果存在）
-- 如果video_url字段不存在，这个语句会报错，但可以通过存储过程处理
-- 为了简化，我们先尝试删除（如果不存在会报错，但可以忽略）

-- 方案1：使用存储过程安全删除video_url字段
DELIMITER $$
DROP PROCEDURE IF EXISTS alter_lab_table$$
CREATE PROCEDURE alter_lab_table()
BEGIN
    -- 删除video_url字段（如果存在）
    SET @sql = (
        SELECT IF(
            COUNT(*) > 0,
            'ALTER TABLE center_overview_laboratory DROP COLUMN video_url',
            'SELECT 1'
        )
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'center_overview_laboratory'
        AND COLUMN_NAME = 'video_url'
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- 添加或修改detail字段为LONGTEXT
    SET @sql = (
        SELECT IF(
            COUNT(*) > 0,
            'ALTER TABLE center_overview_laboratory MODIFY COLUMN detail LONGTEXT COMMENT ''实验室图文详情（富文本HTML内容）''',
            'ALTER TABLE center_overview_laboratory ADD COLUMN detail LONGTEXT COMMENT ''实验室图文详情（富文本HTML内容）'' AFTER image_url'
        )
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'center_overview_laboratory'
        AND COLUMN_NAME = 'detail'
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

-- 执行存储过程
CALL alter_lab_table();

-- 删除存储过程
DROP PROCEDURE IF EXISTS alter_lab_table;

