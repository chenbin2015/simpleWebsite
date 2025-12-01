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