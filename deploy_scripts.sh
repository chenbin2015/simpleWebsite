#!/bin/bash

# 上传 scripts 目录到服务器
# 使用方法: ./deploy_scripts.sh

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
SERVER_HOST="116.62.13.27"
SERVER_PATH="/etc/eastSouth/scripts"
USERNAME="root"

echo -e "${GREEN}开始上传 scripts 目录到服务器...${NC}"
echo -e "${YELLOW}服务器: $USERNAME@$SERVER_HOST${NC}"
echo -e "${YELLOW}目标路径: $SERVER_PATH${NC}"

# 检查当前目录是否是项目根目录（包含 scripts 目录）
if [ ! -d "scripts" ]; then
    echo -e "${RED}错误: 当前目录下没有找到 scripts 目录${NC}"
    echo -e "${YELLOW}请确保在项目根目录下运行此脚本${NC}"
    exit 1
fi

# 创建服务器目录
echo -e "${YELLOW}创建服务器目录...${NC}"
ssh $USERNAME@$SERVER_HOST "mkdir -p $SERVER_PATH && chmod 755 $SERVER_PATH"

# 上传整个 scripts 目录（排除 node_modules）
echo -e "${YELLOW}上传 scripts 目录...${NC}"
rsync -avz --exclude 'node_modules' --exclude '*.log' scripts/ $USERNAME@$SERVER_HOST:$SERVER_PATH/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ scripts 目录上传成功${NC}"
    echo -e "${YELLOW}文件已上传到: $SERVER_PATH${NC}"
else
    echo -e "${YELLOW}rsync 不可用，使用 scp 方式上传...${NC}"
    # 如果 rsync 不可用，使用 scp
    scp -r scripts/* $USERNAME@$SERVER_HOST:$SERVER_PATH/ 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ scripts 目录上传成功${NC}"
    else
        echo -e "${RED}✗ scripts 目录上传失败！${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}部署完成！${NC}"

