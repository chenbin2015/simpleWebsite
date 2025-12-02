-- ==========================================
-- 修复 center_overview_laboratory 表结构
-- ==========================================

-- 方案1：直接执行（推荐，因为错误信息显示detail字段不存在）

-- 1. 添加detail字段（LONGTEXT类型）
ALTER TABLE center_overview_laboratory 
ADD COLUMN detail LONGTEXT COMMENT '实验室图文详情（富文本HTML内容）' AFTER image_url;

-- 2. 删除video_url字段（如果存在，如果不存在会报错可以忽略）
-- 如果该字段不存在，请注释掉下面这行
ALTER TABLE center_overview_laboratory DROP COLUMN video_url;

-- ==========================================
-- 如果上面的ADD COLUMN报错说字段已存在，请使用下面的MODIFY语句
-- ==========================================
-- ALTER TABLE center_overview_laboratory 
-- MODIFY COLUMN detail LONGTEXT COMMENT '实验室图文详情（富文本HTML内容）';

