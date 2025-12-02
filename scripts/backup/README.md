# 数据备份说明

## 备份内容

1. **数据库数据**：完整的 MySQL 数据库备份（结构和数据）
2. **上传文件**：所有用户上传的文件（`backend/upload/` 目录）

## 快速开始

### 一键备份（推荐）

**Windows:**
```cmd
cd scripts\backup
backup_all.bat
```

**Linux/Mac:**
```bash
cd scripts/backup
chmod +x backup_all.sh
./backup_all.sh
```

这会自动执行：
1. 备份数据库
2. 备份上传文件
3. 打包所有备份

### 分步备份

#### Windows 系统

1. **备份数据库**
   ```cmd
   cd scripts\backup
   backup_database.bat
   ```

2. **备份上传文件**
   ```cmd
   backup_uploads.bat
   ```

3. **打包所有备份**
   ```cmd
   package_backup.bat
   ```

#### Linux/Mac 系统

1. **备份数据库**
   ```bash
   cd scripts/backup
   chmod +x backup_database.sh
   ./backup_database.sh
   ```

2. **备份上传文件**
   ```bash
   chmod +x backup_uploads.sh
   ./backup_uploads.sh
   ```

3. **打包所有备份**
   ```bash
   chmod +x package_backup.sh
   ./package_backup.sh
   ```

## 备份文件位置

所有备份文件会保存在 `scripts/backup/backup/` 目录下：
- 数据库备份：`backup/database/simple_website_YYYYMMDD_HHMMSS.sql.gz`
- 上传文件备份：`backup/uploads/uploads_YYYYMMDD_HHMMSS.tar.gz` (Linux/Mac) 或 `.zip` (Windows)
- 完整打包：`backup/backup_YYYYMMDD_HHMMSS.zip`

## 配置说明

备份前请确认脚本中的配置（在脚本文件顶部）：
- **数据库名称**：`simple_website`
- **数据库用户名**：`root`
- **数据库密码**：`root123456`
- **数据库主机**：`localhost`
- **数据库端口**：`3306`
- **上传目录**：自动检测为 `backend/upload/`

如需修改配置，请编辑相应的脚本文件。

## 部署到服务器

### 1. 在本地执行备份

```bash
cd scripts/backup
./backup_all.sh    # Linux/Mac
# 或
backup_all.bat     # Windows
```

会生成 `backup/backup_YYYYMMDD_HHMMSS.zip` 文件。

### 2. 上传到服务器

```bash
# 使用 scp 上传
scp backup/backup_YYYYMMDD_HHMMSS.zip user@server:/path/to/backup/

# 或使用其他工具（如 WinSCP、FileZilla 等）
```

### 3. 在服务器上恢复

#### 恢复数据库

```bash
# 解压备份文件
cd /path/to/backup/
unzip backup_YYYYMMDD_HHMMSS.zip

# 导入数据库（如果备份是压缩的，先解压）
gunzip -c backup/database/simple_website_YYYYMMDD_HHMMSS.sql.gz | mysql -u root -p simple_website

# 或者如果是未压缩的
mysql -u root -p simple_website < backup/database/simple_website_YYYYMMDD_HHMMSS.sql
```

#### 恢复上传文件

```bash
# Linux/Mac
tar -xzf backup/uploads/uploads_YYYYMMDD_HHMMSS.tar.gz -C /path/to/project/backend/

# Windows (在服务器上使用 PowerShell)
Expand-Archive -Path backup\uploads\uploads_YYYYMMDD_HHMMSS.zip -DestinationPath C:\path\to\project\backend\ -Force
```

## 注意事项

1. **备份前确保数据库服务正在运行**
2. **确保有足够的磁盘空间存储备份文件**
3. **建议定期备份，脚本会自动删除7天前的备份文件**
4. **上传到服务器前，请确认服务器上的数据库名称和配置**
5. **恢复数据库前，建议先备份服务器上的现有数据**

## 故障排查

### 数据库备份失败
- 检查 MySQL 服务是否运行
- 检查数据库用户名和密码是否正确
- 检查是否有备份目录的写入权限
- 检查 `mysqldump` 命令是否可用

### 上传文件备份失败
- 检查 `backend/upload/` 目录是否存在
- 检查是否有备份目录的写入权限
- 检查磁盘空间是否充足

### 打包失败
- 确保已先执行数据库备份和上传文件备份
- 检查是否有备份目录的写入权限

