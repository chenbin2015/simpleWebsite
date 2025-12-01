-- ==========================================
-- 数据库初始化脚本
-- ==========================================
-- 使用方法: 
--   方式1: mysql -u root -proot123456 < scripts/init.sql
--   方式2: 在 MySQL 客户端中执行 source scripts/init.sql
-- 
-- 说明：
--   此脚本会创建完整的数据库结构，包括所有表
--   如果表已存在，会先删除后重建（请谨慎使用）

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS simple_website DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE simple_website;

-- ==========================================
-- 删除已存在的表（如果存在）
-- ==========================================
DROP TABLE IF EXISTS center_overview_laboratory;
DROP TABLE IF EXISTS center_overview_organization;
DROP TABLE IF EXISTS center_overview_detail;
DROP TABLE IF EXISTS center_overview_banner;
DROP TABLE IF EXISTS home_announcements;
DROP TABLE IF EXISTS home_news;
DROP TABLE IF EXISTS home_carousels;
DROP TABLE IF EXISTS home_banners;
DROP TABLE IF EXISTS footer_links;
DROP TABLE IF EXISTS footer_contacts;
DROP TABLE IF EXISTS footer_basics;
DROP TABLE IF EXISTS popular_science_activities;
DROP TABLE IF EXISTS popular_science_videos;
DROP TABLE IF EXISTS popular_science_announcements;
DROP TABLE IF EXISTS popular_science_articles;
DROP TABLE IF EXISTS popular_science_carousels;
DROP TABLE IF EXISTS popular_science_banners;
DROP TABLE IF EXISTS contents;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS users;

-- ==========================================
-- 创建基础表
-- ==========================================

-- 创建messages表
CREATE TABLE messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建users表
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建menus表（菜单表）
CREATE TABLE menus (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '菜单名称',
    parent_id BIGINT DEFAULT NULL COMMENT '父菜单ID，NULL表示顶级菜单',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    page_type VARCHAR(50) DEFAULT NULL COMMENT '页面类型：news-list, product-list, image-text, download-list',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES menus(id) ON DELETE CASCADE,
    INDEX idx_parent_id (parent_id),
    INDEX idx_sort_order (sort_order),
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建contents表（内容表，存储二级菜单的图文内容）
CREATE TABLE contents (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    menu_id BIGINT NOT NULL COMMENT '关联的菜单ID（二级菜单）',
    title VARCHAR(200) COMMENT '内容标题',
    content TEXT COMMENT '图文内容（HTML格式）',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE,
    UNIQUE KEY uk_menu_id (menu_id)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 创建首页管理相关表
-- ==========================================

-- 创建home_banners表（首页Banner图）
CREATE TABLE home_banners (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image_url TEXT NOT NULL COMMENT 'Banner图片路径（相对路径，如：upload/20251130/xxx.jpg）',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建home_carousels表（首页轮播图）
CREATE TABLE home_carousels (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image VARCHAR(500) NOT NULL COMMENT '轮播图片路径（相对路径，如：upload/20251130/xxx.jpg）',
    title VARCHAR(200) NOT NULL COMMENT '轮播图标题',
    link VARCHAR(500) DEFAULT NULL COMMENT '链接地址',
    sort INT DEFAULT 0 COMMENT '排序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sort (sort)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建home_news表（首页新闻）
CREATE TABLE home_news (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '新闻标题',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    content TEXT COMMENT '新闻内容（HTML格式）',
    tags VARCHAR(500) DEFAULT NULL COMMENT '标签（JSON格式）',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
    publish_time DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_publish_time (publish_time)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建home_announcements表（首页公告）
CREATE TABLE home_announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '公告标题',
    content TEXT COMMENT '公告内容（HTML格式）',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
    publish_time DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_publish_time (publish_time)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 创建中心概况管理相关表
-- ==========================================

-- 创建center_overview_banner表（中心概况Banner）
CREATE TABLE center_overview_banner (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(20) NOT NULL DEFAULT 'image' COMMENT '类型：image-图片，video-视频',
    image_url TEXT DEFAULT NULL COMMENT '图片路径（相对路径）',
    video_url VARCHAR(500) DEFAULT NULL COMMENT '视频路径（相对路径）',
    video_url_external VARCHAR(500) DEFAULT NULL COMMENT '外部视频URL',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建center_overview_detail表（中心概况详情）
CREATE TABLE center_overview_detail (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    video_url VARCHAR(500) DEFAULT NULL COMMENT '视频路径（相对路径）',
    video_url_external VARCHAR(500) DEFAULT NULL COMMENT '外部视频URL',
    main_title VARCHAR(200) NOT NULL COMMENT '主标题',
    background TEXT COMMENT '建设背景（HTML格式）',
    overview TEXT COMMENT '现状概况（HTML格式）',
    vision TEXT COMMENT '发展愿景（HTML格式）',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建center_overview_organization表（组织架构）
CREATE TABLE center_overview_organization (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role VARCHAR(50) NOT NULL COMMENT '角色名称，支持中文，如：主任、副主任、成员等',
    name VARCHAR(100) NOT NULL COMMENT '姓名',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_role (role),
    INDEX idx_sort_order (sort_order)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建center_overview_laboratory表（下设实验室）
CREATE TABLE center_overview_laboratory (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL COMMENT '实验室名称',
    image_url TEXT NOT NULL COMMENT '图片路径（相对路径）',
    link VARCHAR(500) DEFAULT NULL COMMENT '链接地址',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sort_order (sort_order)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 插入初始数据
-- ==========================================

-- 插入messages示例数据
INSERT INTO messages (content, created_at) VALUES
('Hello from Spring Boot!', NOW()),
('This is a message from database!', NOW()),
('Welcome to Simple Website Demo!', NOW());

-- 插入初始菜单数据（一级菜单）
INSERT INTO menus (name, parent_id, sort_order) VALUES
('首页', NULL, 1),
('中心概况', NULL, 2),
('实验教学', NULL, 3),
('实验资源', NULL, 4),
('建设成效', NULL, 5),
('安全管理', NULL, 6),
('科普教育', NULL, 7);

-- 插入二级菜单数据（使用临时变量避免子查询问题）
SET @experiment_teaching_id = (SELECT id FROM menus WHERE name = '实验教学' LIMIT 1);
SET @experiment_resources_id = (SELECT id FROM menus WHERE name = '实验资源' LIMIT 1);
SET @construction_results_id = (SELECT id FROM menus WHERE name = '建设成效' LIMIT 1);
SET @safety_management_id = (SELECT id FROM menus WHERE name = '安全管理' LIMIT 1);

INSERT INTO menus (name, parent_id, sort_order) VALUES
('课程体系', @experiment_teaching_id, 1),
('实验课程', @experiment_teaching_id, 2),
('实验仪器', @experiment_resources_id, 1),
('实验空间', @experiment_resources_id, 2),
('开放共享', @experiment_resources_id, 3),
('实验教学改革', @construction_results_id, 1),
('科研创新成果', @construction_results_id, 2),
('实验环境与能力', @construction_results_id, 3),
('安全教育', @safety_management_id, 1),
('安全准入', @safety_management_id, 2),
('管理制度', @safety_management_id, 3);

-- ==========================================
-- 初始化完成提示
-- ==========================================
SELECT '数据库初始化完成！' AS message;
SELECT '已创建以下表：' AS info;
SELECT '  - messages' AS table_name;
SELECT '  - users' AS table_name;
SELECT '  - menus' AS table_name;
SELECT '  - contents' AS table_name;
SELECT '  - home_banners' AS table_name;
SELECT '  - home_carousels' AS table_name;
SELECT '  - home_news' AS table_name;
SELECT '  - home_announcements' AS table_name;
SELECT '  - center_overview_banner' AS table_name;
SELECT '  - center_overview_detail' AS table_name;
SELECT '  - center_overview_organization' AS table_name;
SELECT '  - center_overview_laboratory' AS table_name;
SELECT '  - popular_science_banners' AS table_name;
SELECT '  - popular_science_carousels' AS table_name;
SELECT '  - popular_science_articles' AS table_name;
SELECT '  - popular_science_announcements' AS table_name;
SELECT '  - popular_science_videos' AS table_name;
SELECT '  - popular_science_activities' AS table_name;
SELECT '  - footer_contacts' AS table_name;
SELECT '  - footer_links' AS table_name;
SELECT '  - footer_basics' AS table_name;

-- ==========================================
-- 创建科普教育管理相关表
-- ==========================================

-- 创建popular_science_banners表（科普教育Banner）
CREATE TABLE popular_science_banners (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image_url TEXT NOT NULL COMMENT 'Banner图片URL',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建popular_science_carousels表（科普教育轮播图）
CREATE TABLE popular_science_carousels (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image TEXT NOT NULL COMMENT '轮播图片URL',
    title VARCHAR(200) NOT NULL COMMENT '轮播图标题',
    link VARCHAR(500) DEFAULT NULL COMMENT '链接地址',
    sort INT DEFAULT 0 COMMENT '排序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sort (sort)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建popular_science_articles表（科普教育新闻）
CREATE TABLE popular_science_articles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '新闻标题',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    content TEXT COMMENT '新闻内容（HTML格式）',
    tags VARCHAR(500) DEFAULT NULL COMMENT '标签（JSON格式）',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
    publish_time DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_publish_time (publish_time)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建popular_science_announcements表（科普教育公告）
CREATE TABLE popular_science_announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '公告标题',
    content TEXT COMMENT '公告内容（HTML格式）',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
    publish_time DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_publish_time (publish_time)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建popular_science_videos表（科普教育视频）
CREATE TABLE popular_science_videos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '视频标题',
    cover TEXT DEFAULT NULL COMMENT '封面图片URL',
    video_url TEXT NOT NULL COMMENT '视频URL',
    duration VARCHAR(50) DEFAULT NULL COMMENT '视频时长',
    description TEXT DEFAULT NULL COMMENT '视频描述',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
    publish_time DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_publish_time (publish_time)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建popular_science_activities表（科普教育活动）
CREATE TABLE popular_science_activities (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '活动标题',
    cover TEXT DEFAULT NULL COMMENT '封面图片URL',
    location VARCHAR(200) DEFAULT NULL COMMENT '活动地点',
    start_time DATETIME DEFAULT NULL COMMENT '开始时间',
    end_time DATETIME DEFAULT NULL COMMENT '结束时间',
    content TEXT DEFAULT NULL COMMENT '活动内容（HTML格式）',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
    publish_time DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_start_time (start_time)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==========================================
-- 创建Footer管理相关表
-- ==========================================

-- 创建footer_contacts表（Footer联系方式）
CREATE TABLE footer_contacts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(500) DEFAULT NULL COMMENT '地址',
    postcode VARCHAR(20) DEFAULT NULL COMMENT '邮编',
    phone VARCHAR(50) DEFAULT NULL COMMENT '电话',
    fax VARCHAR(50) DEFAULT NULL COMMENT '传真',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    work_time VARCHAR(200) DEFAULT NULL COMMENT '工作时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建footer_links表（Footer友情链接）
CREATE TABLE footer_links (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL COMMENT '链接名称',
    url TEXT NOT NULL COMMENT '链接地址',
    target VARCHAR(20) DEFAULT '_blank' COMMENT '打开方式：_self或_blank',
    sort INT DEFAULT 0 COMMENT '排序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sort (sort)
,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建footer_basics表（Footer基本信息）
CREATE TABLE footer_basics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    copyright TEXT DEFAULT NULL COMMENT '版权信息',
    icp VARCHAR(200) DEFAULT NULL COMMENT 'ICP备案号',
    logo TEXT DEFAULT NULL COMMENT 'Logo URL',
    description TEXT DEFAULT NULL COMMENT '描述信息',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
