#!/bin/bash

# 上传文件备份脚本
# 功能：打包 backend/upload/ 目录下的所有上传文件

# 获取脚本所在目录的父目录（项目根目录）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
UPLOAD_DIR="${PROJECT_ROOT}/backend/upload"

# 备份目录
BACKUP_DIR="${SCRIPT_DIR}/backup/uploads"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/uploads_${TIMESTAMP}.tar.gz"

# 创建备份目录
mkdir -p "${BACKUP_DIR}"

echo "=========================================="
echo "开始备份上传文件"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "源目录: ${UPLOAD_DIR}"
echo "=========================================="

# 检查源目录是否存在
if [ ! -d "${UPLOAD_DIR}" ]; then
    echo "错误: 上传目录不存在: ${UPLOAD_DIR}"
    exit 1
fi

# 检查源目录是否为空
if [ -z "$(ls -A ${UPLOAD_DIR})" ]; then
    echo "警告: 上传目录为空，跳过备份"
    exit 0
fi

# 进入项目根目录执行打包
cd "${PROJECT_ROOT}"

# 打包 upload 目录
tar -czf "${BACKUP_FILE}" -C backend upload/

# 检查打包是否成功
if [ $? -eq 0 ]; then
    # 获取文件大小
    FILE_SIZE=$(du -h "${BACKUP_FILE}" | cut -f1)
    
    # 统计文件数量
    FILE_COUNT=$(find "${UPLOAD_DIR}" -type f | wc -l)
    
    echo "=========================================="
    echo "上传文件备份完成！"
    echo "备份文件: ${BACKUP_FILE}"
    echo "文件大小: ${FILE_SIZE}"
    echo "文件数量: ${FILE_COUNT}"
    echo "=========================================="
    
    # 删除7天前的备份文件（可选）
    find "${BACKUP_DIR}" -name "uploads_*.tar.gz" -mtime +7 -delete
    
    exit 0
else
    echo "=========================================="
    echo "上传文件备份失败！"
    echo "=========================================="
    exit 1
fi

