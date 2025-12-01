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
DROP TABLE IF EXISTS module_downloads;
DROP TABLE IF EXISTS module_products;
DROP TABLE IF EXISTS module_news;
DROP TABLE IF EXISTS module_banners;
DROP TABLE IF EXISTS contents;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS users;
