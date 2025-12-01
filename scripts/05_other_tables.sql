CREATE TABLE popular_science_banners (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image_url TEXT NOT NULL COMMENT 'Banner图片URL',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- ==========================================
-- 创建通用模块管理相关表
-- ==========================================

-- 创建module_banners表（实验教学、实验资源、建设成效、安全管理的Banner）
CREATE TABLE module_banners (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL COMMENT '模块分类：experiment-teaching-实验教学，experiment-resources-实验资源，construction-results-建设成效，safety-management-安全管理',
    type VARCHAR(20) NOT NULL DEFAULT 'image' COMMENT '类型：image-图片，video-视频',
    image_url TEXT DEFAULT NULL COMMENT '图片路径（相对路径）',
    video_url VARCHAR(500) DEFAULT NULL COMMENT '视频路径（相对路径）',
    video_url_external VARCHAR(500) DEFAULT NULL COMMENT '外部视频URL',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_category (category),
    INDEX idx_deleted (deleted),
    INDEX idx_category_deleted (category, deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建module_news表（通用模块新闻列表）
CREATE TABLE module_news (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    menu_id BIGINT NOT NULL COMMENT '关联的菜单ID',
    title VARCHAR(200) NOT NULL COMMENT '新闻标题',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    content TEXT COMMENT '新闻内容（HTML格式）',
    tags VARCHAR(500) DEFAULT NULL COMMENT '标签（JSON格式）',
    summary TEXT DEFAULT NULL COMMENT '摘要',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿，published-已发布',
    publish_time DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE,
    INDEX idx_menu_id (menu_id),
    INDEX idx_status (status),
    INDEX idx_publish_time (publish_time),
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建module_products表（通用模块产品列表）
CREATE TABLE module_products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    menu_id BIGINT NOT NULL COMMENT '关联的菜单ID',
    name VARCHAR(200) NOT NULL COMMENT '产品名称',
    image TEXT DEFAULT NULL COMMENT '产品图片URL',
    category VARCHAR(100) DEFAULT NULL COMMENT '分类',
    description TEXT DEFAULT NULL COMMENT '描述',
    link VARCHAR(500) DEFAULT NULL COMMENT '链接地址',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE,
    INDEX idx_menu_id (menu_id),
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建module_downloads表（通用模块下载列表）
CREATE TABLE module_downloads (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    menu_id BIGINT NOT NULL COMMENT '关联的菜单ID',
    name VARCHAR(200) NOT NULL COMMENT '文件名',
    file_url TEXT NOT NULL COMMENT '文件URL',
    category VARCHAR(100) DEFAULT NULL COMMENT '分类',
    file_type VARCHAR(50) DEFAULT NULL COMMENT '文件类型：pdf, doc, xls, other',
    file_size BIGINT DEFAULT NULL COMMENT '文件大小（字节）',
    download_count INT DEFAULT 0 COMMENT '下载次数',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE,
    INDEX idx_menu_id (menu_id),
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;