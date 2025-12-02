#!/bin/bash

# 完整备份脚本
# 功能：依次执行数据库备份、上传文件备份，最后打包所有备份

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "开始完整备份流程"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
echo ""

# 1. 备份数据库
echo "步骤 1/3: 备份数据库..."
"${SCRIPT_DIR}/backup_database.sh"
if [ $? -ne 0 ]; then
    echo "数据库备份失败，终止备份流程"
    exit 1
fi
echo ""

# 2. 备份上传文件
echo "步骤 2/3: 备份上传文件..."
"${SCRIPT_DIR}/backup_uploads.sh"
if [ $? -ne 0 ]; then
    echo "上传文件备份失败，终止备份流程"
    exit 1
fi
echo ""

# 3. 打包所有备份
echo "步骤 3/3: 打包所有备份..."
"${SCRIPT_DIR}/package_backup.sh"
if [ $? -ne 0 ]; then
    echo "打包失败，但备份文件已保存在 backup/ 目录"
    exit 1
fi
echo ""

echo "=========================================="
echo "完整备份流程完成！"
echo "=========================================="

