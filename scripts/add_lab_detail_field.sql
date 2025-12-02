-- 添加实验室视频和详情字段
-- 修改 detail 字段为 VARCHAR(500)（详情链接）
-- 添加 video_url 字段

-- 如果 detail 字段已存在，先删除
ALTER TABLE center_overview_laboratory 
DROP COLUMN IF EXISTS detail;

-- 添加 detail 字段（详情链接）
ALTER TABLE center_overview_laboratory 
ADD COLUMN detail VARCHAR(500) COMMENT '详情链接' AFTER image_url;

-- 添加 video_url 字段（视频文件路径）
ALTER TABLE center_overview_laboratory 
ADD COLUMN video_url VARCHAR(500) COMMENT '视频文件路径' AFTER image_url;

-- 如果需要保留 link 字段数据到 detail，可以执行：
-- UPDATE center_overview_laboratory SET detail = link WHERE link IS NOT NULL AND link != '';

-- 如果确定不需要 link 字段，可以删除：
-- ALTER TABLE center_overview_laboratory DROP COLUMN link;
