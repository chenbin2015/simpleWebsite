# 逻辑删除实现完整指南

## 当前进展
- ✅ 已为 HomeBanner 实体类添加逻辑删除字段
- ⏳ 待完成：其余20个实体类
- ⏳ 待完成：所有Repository查询方法
- ⏳ 待完成：所有Service删除方法
- ⏳ 待完成：数据库表结构更新

## 实现步骤

### 步骤1：为所有实体类添加逻辑删除字段

每个实体类需要添加：

```java
@Column(name = "deleted", nullable = false)
private Boolean deleted = false;

@Column(name = "deleted_at")
private LocalDateTime deletedAt;

// 在 @PrePersist 方法中初始化
if (deleted == null) {
    deleted = false;
}

// Getter和Setter方法
public Boolean getDeleted() { return deleted; }
public void setDeleted(Boolean deleted) { this.deleted = deleted; }
public LocalDateTime getDeletedAt() { return deletedAt; }
public void setDeletedAt(LocalDateTime deletedAt) { this.deletedAt = deletedAt; }
```

### 步骤2：修改Repository查询方法

所有查询需要添加 `WHERE deleted = false` 条件：

```java
@Query("SELECT e FROM EntityName e WHERE e.deleted = false")
List<EntityName> findAll();

@Query("SELECT e FROM EntityName e WHERE e.id = :id AND e.deleted = false")
Optional<EntityName> findById(@Param("id") Long id);
```

### 步骤3：修改Service删除方法

将所有 `repository.deleteById(id)` 改为：

```java
Optional<Entity> entityOpt = repository.findById(id);
if (entityOpt.isEmpty() || entityOpt.get().getDeleted()) {
    result.put("success", false);
    result.put("message", "记录不存在");
    return result;
}
Entity entity = entityOpt.get();
entity.setDeleted(true);
entity.setDeletedAt(LocalDateTime.now());
repository.save(entity);
```

### 步骤4：数据库迁移

为所有表添加字段：

```sql
ALTER TABLE table_name 
ADD COLUMN deleted BOOLEAN NOT NULL DEFAULT FALSE,
ADD COLUMN deleted_at DATETIME DEFAULT NULL;
```

## 需要修改的文件清单

### 实体类（21个）
- ✅ HomeBanner
- ⏳ HomeCarousel
- ⏳ HomeNews
- ⏳ HomeAnnouncement
- ⏳ CenterOverviewBanner
- ⏳ CenterOverviewDetail
- ⏳ CenterOverviewOrganization
- ⏳ CenterOverviewLaboratory
- ⏳ PopularScienceBanner
- ⏳ PopularScienceCarousel
- ⏳ PopularScienceArticle
- ⏳ PopularScienceAnnouncement
- ⏳ PopularScienceVideo
- ⏳ PopularScienceActivity
- ⏳ FooterBasic
- ⏳ FooterContact
- ⏳ FooterLink
- ⏳ Menu
- ⏳ Content
- ⏳ Message
- ⏳ User

### Service类（8个）
需要修改所有删除方法

### Repository接口
需要添加查询条件过滤已删除记录

## 注意事项

1. `deleteAll()` 方法：对于单例模式的实体（如Banner），应逻辑删除所有旧记录
2. 级联删除：需要处理关联关系的逻辑删除
3. 查询性能：考虑为 deleted 字段添加索引

