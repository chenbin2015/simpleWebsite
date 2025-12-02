CREATE TABLE home_banners (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image_url TEXT NOT NULL COMMENT 'Banner图片路径（相对路径，如：upload/20251130/xxx.jpg）',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE home_carousels (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image VARCHAR(500) NOT NULL COMMENT '轮播图片路径（相对路径，如：upload/20251130/xxx.jpg）',
    title VARCHAR(200) NOT NULL COMMENT '轮播图标题',
    description VARCHAR(200) DEFAULT NULL COMMENT '轮播图描述',
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

CREATE TABLE home_news (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '新闻标题',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    description VARCHAR(200) DEFAULT NULL COMMENT '新闻描述',
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

CREATE TABLE home_announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '公告标题',
    description VARCHAR(200) DEFAULT NULL COMMENT '公告描述',
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