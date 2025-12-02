#!/bin/bash

# 打包所有备份脚本
# 功能：将数据库备份和上传文件备份打包成一个 zip 文件

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_ROOT="${SCRIPT_DIR}/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PACKAGE_FILE="${BACKUP_ROOT}/backup_${TIMESTAMP}.zip"

echo "=========================================="
echo "开始打包所有备份文件"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 检查备份目录是否存在
if [ ! -d "${BACKUP_ROOT}" ]; then
    echo "错误: 备份目录不存在，请先执行备份脚本"
    exit 1
fi

# 进入备份根目录
cd "${BACKUP_ROOT}"

# 检查是否有备份文件
DB_COUNT=$(find database -name "simple_website_*.sql.gz" -type f 2>/dev/null | wc -l)
UPLOAD_COUNT=$(find uploads -name "uploads_*.tar.gz" -type f 2>/dev/null | wc -l)

if [ ${DB_COUNT} -eq 0 ] && [ ${UPLOAD_COUNT} -eq 0 ]; then
    echo "错误: 没有找到备份文件，请先执行备份脚本"
    exit 1
fi

# 创建打包文件
echo "正在打包..."
zip -r "${PACKAGE_FILE}" database/ uploads/ -x "*.log" 2>/dev/null

if [ $? -eq 0 ]; then
    FILE_SIZE=$(du -h "${PACKAGE_FILE}" | cut -f1)
    
    echo "=========================================="
    echo "打包完成！"
    echo "打包文件: ${PACKAGE_FILE}"
    echo "文件大小: ${FILE_SIZE}"
    echo ""
    echo "包含内容:"
    if [ ${DB_COUNT} -gt 0 ]; then
        echo "  - 数据库备份: ${DB_COUNT} 个文件"
        ls -1h database/simple_website_*.sql.gz 2>/dev/null | tail -1 | xargs -I {} echo "    最新: {}"
    fi
    if [ ${UPLOAD_COUNT} -gt 0 ]; then
        echo "  - 上传文件备份: ${UPLOAD_COUNT} 个文件"
        ls -1h uploads/uploads_*.tar.gz 2>/dev/null | tail -1 | xargs -I {} echo "    最新: {}"
    fi
    echo "=========================================="
    echo ""
    echo "可以使用以下命令上传到服务器:"
    echo "  scp ${PACKAGE_FILE} user@server:/path/to/backup/"
    echo ""
    
    exit 0
else
    echo "=========================================="
    echo "打包失败！"
    echo "=========================================="
    exit 1
fi

