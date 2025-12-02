-- 为首页公告表添加附件字段
ALTER TABLE home_announcements 
ADD COLUMN IF NOT EXISTS attachment_url VARCHAR(500) COMMENT '附件URL',
ADD COLUMN IF NOT EXISTS attachment_name VARCHAR(255) COMMENT '附件文件名';

