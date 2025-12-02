#!/bin/bash

# 后端部署脚本：构建项目并上传到服务器
# 使用方法: ./deploy.sh [用户名]
# 例如: ./deploy.sh root

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
SERVER_HOST="116.62.13.27"
SERVER_PATH="/etc/eastSouth/backend"
JAR_NAME="simple-website-backend-1.0.0.jar"
USERNAME="${1:-root}"

echo -e "${GREEN}开始构建后端项目...${NC}"
mvn clean package -DskipTests

if [ ! -f "target/${JAR_NAME}" ]; then
    echo -e "${RED}错误: JAR文件 target/${JAR_NAME} 不存在${NC}"
    exit 1
fi

echo -e "${GREEN}构建完成，开始上传到服务器...${NC}"
echo -e "${YELLOW}服务器: $USERNAME@$SERVER_HOST${NC}"
echo -e "${YELLOW}目标路径: $SERVER_PATH${NC}"

# 上传JAR文件
echo -e "${YELLOW}上传JAR文件...${NC}"
scp "target/${JAR_NAME}" $USERNAME@$SERVER_HOST:$SERVER_PATH/
echo -e "${GREEN}✓ JAR文件上传成功${NC}"

# 上传启动脚本
if [ -f "start.sh" ]; then
    echo -e "${YELLOW}上传启动脚本...${NC}"
    scp "start.sh" $USERNAME@$SERVER_HOST:$SERVER_PATH/
    ssh $USERNAME@$SERVER_HOST "chmod +x $SERVER_PATH/start.sh"
    echo -e "${GREEN}✓ 启动脚本上传成功${NC}"
else
    echo -e "${RED}错误: start.sh 文件不存在！${NC}"
    exit 1
fi

echo -e "${GREEN}部署完成！${NC}"
