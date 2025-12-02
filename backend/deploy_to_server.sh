#!/bin/bash

# 后端部署脚本：将 target 下的 jar 文件上传到服务器
# 使用方法: ./deploy_to_server.sh
# 注意：此脚本只负责上传，不负责构建和启动

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
SERVER_HOST="116.62.13.27"
SERVER_PATH="/etc/eastSouth/backend"
JAR_NAME="simple-website-backend-1.0.0.jar"
USERNAME="root"

echo -e "${GREEN}开始部署后端项目到服务器...${NC}"

# 检查 JAR 文件是否存在
if [ ! -f "target/${JAR_NAME}" ]; then
    echo -e "${RED}错误: JAR文件 target/${JAR_NAME} 不存在${NC}"
    echo -e "${YELLOW}请先运行: mvn clean package -DskipTests${NC}"
    exit 1
fi

echo -e "${YELLOW}服务器: $USERNAME@$SERVER_HOST${NC}"
echo -e "${YELLOW}目标路径: $SERVER_PATH${NC}"

# 确保服务器目录存在
echo -e "${YELLOW}检查并创建服务器目录...${NC}"
ssh $USERNAME@$SERVER_HOST "mkdir -p $SERVER_PATH && chmod 755 $SERVER_PATH"

# 停止旧服务（如果存在）
echo -e "${YELLOW}停止旧服务...${NC}"
ssh $USERNAME@$SERVER_HOST "cd $SERVER_PATH && if [ -f ${JAR_NAME} ]; then pkill -f ${JAR_NAME} || true; sleep 2; fi"

# 备份旧JAR文件（如果存在）
echo -e "${YELLOW}备份旧JAR文件...${NC}"
ssh $USERNAME@$SERVER_HOST "cd $SERVER_PATH && if [ -f ${JAR_NAME} ]; then cp ${JAR_NAME} ${JAR_NAME}.backup.\$(date +%Y%m%d_%H%M%S); fi"

# 上传新的JAR文件
echo -e "${YELLOW}上传JAR文件到服务器...${NC}"
scp "target/${JAR_NAME}" $USERNAME@$SERVER_HOST:$SERVER_PATH/

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 上传失败！${NC}"
    exit 1
fi

# 上传启动脚本
echo -e "${YELLOW}上传启动脚本到服务器...${NC}"
scp "start.sh" $USERNAME@$SERVER_HOST:$SERVER_PATH/

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ 启动脚本上传失败！${NC}"
    exit 1
fi

# 给启动脚本添加执行权限
echo -e "${YELLOW}设置启动脚本执行权限...${NC}"
ssh $USERNAME@$SERVER_HOST "chmod +x $SERVER_PATH/start.sh"

echo -e "${GREEN}✓ 部署完成！${NC}"
echo -e "${YELLOW}JAR文件已上传到: $SERVER_PATH/${JAR_NAME}${NC}"
echo -e "${YELLOW}启动脚本已上传到: $SERVER_PATH/start.sh${NC}"
echo -e "${GREEN}现在可以在服务器上运行以下命令启动服务：${NC}"
echo -e "${YELLOW}  ssh $USERNAME@$SERVER_HOST 'cd $SERVER_PATH && ./start.sh'${NC}"

