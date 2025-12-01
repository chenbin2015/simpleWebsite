# 逻辑删除实现方案

## 概述
将所有物理删除改为逻辑删除（软删除），保留数据以便恢复和审计。

## 实现步骤

### 1. 实体类修改
为所有实体类添加以下字段：
- `deleted` (Boolean, default false)
- `deletedAt` (LocalDateTime, nullable)

### 2. Repository修改
所有查询方法需要过滤已删除的记录（deleted = false）

### 3. Service修改
所有删除方法改为：
- 设置 deleted = true
- 设置 deletedAt = now()
- 保存实体（而不是删除）

### 4. 数据库迁移
为所有表添加 deleted 和 deleted_at 字段

## 涉及的文件列表

### 实体类（21个）
- HomeBanner.java
- HomeCarousel.java
- HomeNews.java
- HomeAnnouncement.java
- CenterOverviewBanner.java
- CenterOverviewDetail.java
- CenterOverviewOrganization.java
- CenterOverviewLaboratory.java
- PopularScienceBanner.java
- PopularScienceCarousel.java
- PopularScienceArticle.java
- PopularScienceAnnouncement.java
- PopularScienceVideo.java
- PopularScienceActivity.java
- FooterBasic.java
- FooterContact.java
- FooterLink.java
- Menu.java
- Content.java
- Message.java
- User.java

### Repository接口
所有Repository需要添加过滤条件

### Service类
所有删除方法需要修改为逻辑删除

