#!/bin/bash

# 发布脚本：构建项目并上传到服务器
# 使用方法: ./deploy.sh [用户名]
# 例如: ./deploy.sh root

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
SERVER_HOST="116.62.13.27"
SERVER_PATH="/etc/eastSouth/runtime-frontend"
BUILD_DIR="dist"
USERNAME="${1:-root}"  # 默认使用 root 用户，可以通过参数传入

echo -e "${GREEN}开始构建项目...${NC}"
npm run build

if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}错误: 构建目录 $BUILD_DIR 不存在${NC}"
    exit 1
fi

echo -e "${GREEN}构建完成，开始上传到服务器...${NC}"
echo -e "${YELLOW}服务器: $USERNAME@$SERVER_HOST${NC}"
echo -e "${YELLOW}目标路径: $SERVER_PATH${NC}"

# 确保服务器目录存在
echo -e "${YELLOW}检查并创建服务器目录...${NC}"
ssh $USERNAME@$SERVER_HOST "mkdir -p $SERVER_PATH && chmod 755 $SERVER_PATH"

# 使用 tar 压缩上传，更可靠
TEMP_FILE="deploy_temp.tar.gz"
TEMP_PATH="${SERVER_PATH}_tmp"
REMOTE_TEMP_FILE="${TEMP_PATH}.tar.gz"

# 清理本地临时文件（如果存在）
if [ -f "$TEMP_FILE" ]; then
    rm -f "$TEMP_FILE"
fi

# 打包 dist 目录
echo -e "${YELLOW}打包文件...${NC}"
tar -czf "$TEMP_FILE" -C "$BUILD_DIR" .

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 打包失败！${NC}"
    rm -f "$TEMP_FILE"
    exit 1
fi

# 准备服务器临时目录
echo -e "${YELLOW}准备服务器目录...${NC}"
ssh $USERNAME@$SERVER_HOST "mkdir -p $TEMP_PATH && chmod 755 $TEMP_PATH; rm -rf $SERVER_PATH/* $SERVER_PATH/.[^.]* 2>/dev/null; rm -f $REMOTE_TEMP_FILE"

# 上传压缩包
echo -e "${YELLOW}上传文件到服务器...${NC}"
scp "$TEMP_FILE" $USERNAME@$SERVER_HOST:$REMOTE_TEMP_FILE

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 上传失败！${NC}"
    rm -f "$TEMP_FILE"
    ssh $USERNAME@$SERVER_HOST "rm -rf $TEMP_PATH $REMOTE_TEMP_FILE" 2>/dev/null
    exit 1
fi

# 在服务器上解压并移动到目标位置
echo -e "${YELLOW}解压文件到目标目录...${NC}"
ssh $USERNAME@$SERVER_HOST "cd $TEMP_PATH && tar -xzf $REMOTE_TEMP_FILE && cp -r . $SERVER_PATH/ && cd / && rm -rf $TEMP_PATH $REMOTE_TEMP_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 上传成功！${NC}"
    echo -e "${GREEN}文件已上传到: $USERNAME@$SERVER_HOST:$SERVER_PATH${NC}"
    # 清理本地临时文件
    rm -f "$TEMP_FILE"
else
    echo -e "${RED}✗ 解压文件失败！${NC}"
    rm -f "$TEMP_FILE"
    ssh $USERNAME@$SERVER_HOST "rm -rf $TEMP_PATH $REMOTE_TEMP_FILE" 2>/dev/null
    exit 1
fi

