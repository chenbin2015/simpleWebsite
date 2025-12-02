-- 简化版本：直接执行SQL（如果字段不存在会有错误，但可以手动处理）
-- 适用于已知当前表结构的情况

-- 1. 添加detail字段（如果不存在，先检查）
-- 如果detail字段已存在，请注释掉下面的ADD COLUMN语句
ALTER TABLE center_overview_laboratory 
ADD COLUMN detail LONGTEXT COMMENT '实验室图文详情（富文本HTML内容）' AFTER image_url;

-- 2. 如果detail字段已存在，只需要修改类型
-- 取消注释下面的语句，并注释掉上面的ADD COLUMN
-- ALTER TABLE center_overview_laboratory 
-- MODIFY COLUMN detail LONGTEXT COMMENT '实验室图文详情（富文本HTML内容）';

-- 3. 删除video_url字段（如果存在）
-- 如果video_url字段不存在，这个语句会报错，可以忽略或手动删除
-- ALTER TABLE center_overview_laboratory DROP COLUMN video_url;

