-- 数据库初始化脚本
-- 此脚本由 scripts/init.js 自动执行
-- 也可以手动执行：mysql -u root -p < scripts/init.sql
-- 输入密码: root123456

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS simple_website DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE simple_website;

-- 删除已存在的表（如果存在）
DROP TABLE IF EXISTS contents;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS users;

-- 创建messages表
CREATE TABLE messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入messages示例数据
INSERT INTO messages (content, created_at) VALUES
('Hello from Spring Boot!', NOW()),
('This is a message from database!', NOW()),
('Welcome to Simple Website Demo!', NOW());

-- 创建menus表（菜单表）
CREATE TABLE menus (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '菜单名称',
    parent_id BIGINT DEFAULT NULL COMMENT '父菜单ID，NULL表示顶级菜单',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES menus(id) ON DELETE CASCADE,
    INDEX idx_parent_id (parent_id),
    INDEX idx_sort_order (sort_order)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入初始菜单数据
INSERT INTO menus (name, parent_id, sort_order) VALUES
('首页', NULL, 1),
('中心概况', NULL, 2),
('实验教学', NULL, 3),
('实验资源', NULL, 4),
('建设成效', NULL, 5),
('安全管理', NULL, 6),
('科普教育', NULL, 7);

-- 插入二级菜单数据
INSERT INTO menus (name, parent_id, sort_order) VALUES
('课程体系', (SELECT id FROM menus WHERE name = '实验教学' LIMIT 1), 1),
('实验课程', (SELECT id FROM menus WHERE name = '实验教学' LIMIT 1), 2),
('实验仪器', (SELECT id FROM menus WHERE name = '实验资源' LIMIT 1), 1),
('实验空间', (SELECT id FROM menus WHERE name = '实验资源' LIMIT 1), 2),
('开放共享', (SELECT id FROM menus WHERE name = '实验资源' LIMIT 1), 3),
('实验教学改革', (SELECT id FROM menus WHERE name = '建设成效' LIMIT 1), 1),
('科研创新成果', (SELECT id FROM menus WHERE name = '建设成效' LIMIT 1), 2),
('实验环境与能力', (SELECT id FROM menus WHERE name = '建设成效' LIMIT 1), 3),
('安全教育', (SELECT id FROM menus WHERE name = '安全管理' LIMIT 1), 1),
('安全准入', (SELECT id FROM menus WHERE name = '安全管理' LIMIT 1), 2),
('管理制度', (SELECT id FROM menus WHERE name = '安全管理' LIMIT 1), 3);

-- 插入users示例数据（可选，用于测试）
-- 注意：密码已使用BCrypt加密存储
-- 由于BCrypt每次加密结果不同，建议通过注册接口创建用户，而不是直接插入数据库
-- 如果需要测试用户，请通过前端注册页面创建

-- 查看数据
SELECT * FROM messages;
SELECT * FROM users;
SELECT * FROM menus ORDER BY parent_id, sort_order;
SELECT * FROM contents;

