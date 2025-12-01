CREATE TABLE messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME DEFAULT NULL,
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
-- 插入初始数据
-- ==========================================
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

-- 注意：默认管理员用户需要通过API创建，密码哈希由后端正确生成
-- 初始化完成后，请运行: node scripts/create_admin_user.js
-- 或者确保后端服务运行后，通过注册接口创建管理员用户

-- ==========================================