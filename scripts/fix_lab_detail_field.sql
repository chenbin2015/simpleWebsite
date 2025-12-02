-- 修复实验室表的detail字段
-- 执行此脚本前，请先检查表结构：DESC center_overview_laboratory;

-- 步骤1：删除video_url字段（如果存在）
-- 如果字段不存在，会报错，但可以忽略继续执行下一步
-- 手动删除时，如果报错说字段不存在，说明已经删除了，直接执行步骤2即可
ALTER TABLE center_overview_laboratory DROP COLUMN video_url;

-- 步骤2：添加detail字段为LONGTEXT（如果不存在）
-- 如果字段已存在，会报错，请改用步骤3
ALTER TABLE center_overview_laboratory 
ADD COLUMN detail LONGTEXT COMMENT '实验室图文详情（富文本HTML内容）' AFTER image_url;

-- 步骤3：如果detail字段已存在但类型不对，修改为LONGTEXT
-- 如果步骤2报错说字段已存在，请取消注释下面的语句，并注释掉步骤2
-- ALTER TABLE center_overview_laboratory 
-- MODIFY COLUMN detail LONGTEXT COMMENT '实验室图文详情（富文本HTML内容）';

