#!/bin/bash

# 数据库备份脚本
# 功能：导出 MySQL 数据库的完整数据（结构和数据）

# 配置信息
DB_NAME="simple_website"
DB_USER="root"
DB_PASSWORD="root123456"
DB_HOST="localhost"
DB_PORT="3306"

# 备份目录
BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)/backup/database"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/simple_website_${TIMESTAMP}.sql"

# 创建备份目录
mkdir -p "${BACKUP_DIR}"

echo "=========================================="
echo "开始备份数据库: ${DB_NAME}"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 执行备份
mysqldump -h${DB_HOST} -P${DB_PORT} -u${DB_USER} -p${DB_PASSWORD} \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --hex-blob \
  --default-character-set=utf8mb4 \
  ${DB_NAME} > "${BACKUP_FILE}"

# 检查备份是否成功
if [ $? -eq 0 ]; then
    # 压缩备份文件
    gzip -f "${BACKUP_FILE}"
    BACKUP_FILE="${BACKUP_FILE}.gz"
    
    # 获取文件大小
    FILE_SIZE=$(du -h "${BACKUP_FILE}" | cut -f1)
    
    echo "=========================================="
    echo "数据库备份完成！"
    echo "备份文件: ${BACKUP_FILE}"
    echo "文件大小: ${FILE_SIZE}"
    echo "=========================================="
    
    # 删除7天前的备份文件（可选）
    find "${BACKUP_DIR}" -name "simple_website_*.sql.gz" -mtime +7 -delete
    
    exit 0
else
    echo "=========================================="
    echo "数据库备份失败！"
    echo "请检查数据库连接信息和权限"
    echo "=========================================="
    exit 1
fi

