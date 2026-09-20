#!/bin/bash

# 从远程服务器备份数据库和上传文件
# 使用方法: ./backup_from_server.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 服务器配置
SERVER_HOST="116.62.13.27"
SERVER_USER="root"
SERVER_UPLOAD_PATH="/etc/eastSouth/backend/upload"

# 数据库配置（服务器上的）
DB_NAME="simple_website"
DB_USER="root"
DB_PASSWORD='k9#Qz$mR!pX2@L8'
DB_PORT="8024"

# 本地备份目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="${SCRIPT_DIR}/backup/server_${TIMESTAMP}"
DB_BACKUP_DIR="${BACKUP_DIR}/database"
UPLOAD_BACKUP_DIR="${BACKUP_DIR}/uploads"

mkdir -p "${DB_BACKUP_DIR}"
mkdir -p "${UPLOAD_BACKUP_DIR}"

echo "=========================================="
echo "开始从服务器备份"
echo "服务器: ${SERVER_USER}@${SERVER_HOST}"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
echo ""

# 1. 备份数据库
echo -e "${YELLOW}步骤 1/2: 备份服务器数据库...${NC}"
REMOTE_DUMP="/tmp/${DB_NAME}_${TIMESTAMP}.sql"

ssh ${SERVER_USER}@${SERVER_HOST} \
  "mysqldump -h127.0.0.1 -P${DB_PORT} -u${DB_USER} -p'${DB_PASSWORD}' \
  --single-transaction --routines --triggers --events \
  --hex-blob --default-character-set=utf8mb4 \
  ${DB_NAME} > ${REMOTE_DUMP} && gzip -f ${REMOTE_DUMP}"

if [ $? -ne 0 ]; then
    echo -e "${RED}数据库备份失败！${NC}"
    exit 1
fi

echo -e "${YELLOW}下载数据库备份文件...${NC}"
scp ${SERVER_USER}@${SERVER_HOST}:${REMOTE_DUMP}.gz "${DB_BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"

ssh ${SERVER_USER}@${SERVER_HOST} "rm -f ${REMOTE_DUMP}.gz"

echo -e "${GREEN}数据库备份完成${NC}"
echo ""

# 2. 备份上传文件
echo -e "${YELLOW}步骤 2/2: 下载服务器上传文件...${NC}"

if ssh ${SERVER_USER}@${SERVER_HOST} "test -d ${SERVER_UPLOAD_PATH}"; then
    scp -r ${SERVER_USER}@${SERVER_HOST}:${SERVER_UPLOAD_PATH} "${UPLOAD_BACKUP_DIR}/upload"
    echo -e "${GREEN}上传文件备份完成${NC}"
else
    echo -e "${YELLOW}警告: 服务器上传目录不存在，跳过${NC}"
fi

echo ""

# 3. 打包
echo -e "${YELLOW}打包所有备份...${NC}"
cd "${SCRIPT_DIR}/backup"
zip -r "server_backup_${TIMESTAMP}.zip" "server_${TIMESTAMP}/"

if [ $? -eq 0 ]; then
    FILE_SIZE=$(du -h "server_backup_${TIMESTAMP}.zip" | cut -f1)
    echo -e "${GREEN}打包完成！${NC}"
    echo -e "备份文件: ${SCRIPT_DIR}/backup/server_backup_${TIMESTAMP}.zip"
    echo -e "文件大小: ${FILE_SIZE}"
    rm -rf "server_${TIMESTAMP}"
else
    echo -e "${YELLOW}打包失败，备份文件保留在: ${BACKUP_DIR}${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}服务器备份全部完成！${NC}"
echo "=========================================="
