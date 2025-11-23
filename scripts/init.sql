-- 数据库初始化脚本
-- 此脚本由 scripts/init.js 自动执行
-- 也可以手动执行：mysql -u root -p < scripts/init.sql
-- 输入密码: root123456

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS simple_website DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE simple_website;

-- 删除已存在的表（如果存在）
DROP TABLE IF EXISTS messages;

-- 创建messages表
CREATE TABLE messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入示例数据
INSERT INTO messages (content, created_at) VALUES
('Hello from Spring Boot!', NOW()),
('This is a message from database!', NOW()),
('Welcome to Simple Website Demo!', NOW());

-- 查看数据
SELECT * FROM messages;

