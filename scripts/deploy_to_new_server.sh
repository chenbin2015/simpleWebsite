#!/bin/bash

# 一键部署脚本 - 将备份部署到新服务器
# 使用方法: ./deploy_to_new_server.sh <新服务器IP> <数据库密码>
# 例如: ./deploy_to_new_server.sh 192.168.1.100 mypassword123

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检查参数
if [ $# -lt 2 ]; then
    echo -e "${RED}错误: 缺少参数${NC}"
    echo "使用方法: $0 <服务器IP> <数据库密码>"
    echo "例如: $0 192.168.1.100 mypassword123"
    exit 1
fi

NEW_SERVER_IP=$1
NEW_DB_PASSWORD=$2
BACKUP_DIR="$(cd "$(dirname "$0")/../backups/server_backup_20260919" && pwd)"

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}一键部署脚本${NC}"
echo -e "${BLUE}==========================================${NC}"
echo -e "目标服务器: ${YELLOW}${NEW_SERVER_IP}${NC}"
echo -e "备份目录: ${YELLOW}${BACKUP_DIR}${NC}"
echo -e "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${BLUE}==========================================${NC}"
echo ""

# 检查备份文件
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}错误: 备份目录不存在: ${BACKUP_DIR}${NC}"
    exit 1
fi

if [ ! -f "$BACKUP_DIR/database_backup.sql.gz" ]; then
    echo -e "${RED}错误: 数据库备份文件不存在${NC}"
    exit 1
fi

# ==================== 步骤 1: 安装依赖 ====================
echo -e "${YELLOW}[1/7] 安装系统依赖...${NC}"

# 检测系统类型
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt-get"
    sudo apt-get update -qq
elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
    sudo yum update -y -q
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    sudo dnf update -y -q
else
    echo -e "${RED}错误: 不支持的包管理器${NC}"
    exit 1
fi

# 安装 Java 17
if ! command -v java &> /dev/null; then
    echo "安装 Java 17..."
    sudo $PKG_MANAGER install -y -q java-17-openjdk java-17-openjdk-devel
fi
echo -e "${GREEN}✓ Java: $(java -version 2>&1 | head -1)${NC}"

# 安装 MySQL
if ! command -v mysql &> /dev/null; then
    echo "安装 MySQL..."
    if [ "$PKG_MANAGER" = "apt-get" ]; then
        sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${NEW_DB_PASSWORD}"
        sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${NEW_DB_PASSWORD}"
        sudo $PKG_MANAGER install -y -q mysql-server
    else
        sudo $PKG_MANAGER install -y -q mysql-server
    fi
    sudo systemctl start mysqld 2>/dev/null || sudo systemctl start mysql 2>/dev/null
    sudo systemctl enable mysqld 2>/dev/null || sudo systemctl enable mysql 2>/dev/null
fi
echo -e "${GREEN}✓ MySQL 已安装${NC}"

# 安装 Node.js
if ! command -v node &> /dev/null; then
    echo "安装 Node.js..."
    curl -fsSL https://rpm.nodesource.com/setup_18.x 2>/dev/null | sudo bash - 2>/dev/null || \
    curl -fsSL https://deb.nodesource.com/setup_18.x 2>/dev/null | sudo -E bash - 2>/dev/null
    sudo $PKG_MANAGER install -y -q nodejs
fi
echo -e "${GREEN}✓ Node.js: $(node --version)${NC}"

# 安装 Nginx
if ! command -v nginx &> /dev/null; then
    echo "安装 Nginx..."
    sudo $PKG_MANAGER install -y -q nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
fi
echo -e "${GREEN}✓ Nginx 已安装${NC}"

echo ""

# ==================== 步骤 2: 配置 MySQL ====================
echo -e "${YELLOW}[2/7] 配置 MySQL 数据库...${NC}"

# 设置 root 密码（如果是新安装）
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_DB_PASSWORD}';" 2>/dev/null || true

# 创建数据库并导入
gunzip -c "$BACKUP_DIR/database_backup.sql.gz" | mysql -u root -p"${NEW_DB_PASSWORD}" 2>/dev/null

echo -e "${GREEN}✓ 数据库已导入${NC}"
echo ""

# ==================== 步骤 3: 部署后端 ====================
echo -e "${YELLOW}[3/7] 部署后端服务...${NC}"

# 创建目录
sudo mkdir -p /etc/eastSouth/backend
sudo mkdir -p /etc/eastSouth/backend/upload
sudo chown -R $USER:$USER /etc/eastSouth

# 解压上传文件
if [ -f "$BACKUP_DIR/uploads_backup.tar.gz" ]; then
    tar -xzf "$BACKUP_DIR/uploads_backup.tar.gz" -C /etc/eastSouth/backend/
    echo "✓ 上传文件已解压"
fi

# 检查是否有 JAR 包，如果没有则构建
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAR_FILE="$PROJECT_ROOT/backend/target/simple-website-backend-0.0.1-SNAPSHOT.jar"

if [ ! -f "$JAR_FILE" ]; then
    echo "构建后端 JAR 包..."
    cd "$PROJECT_ROOT/backend"
    ./mvnw clean package -DskipTests -q
fi

# 复制 JAR 包
cp "$JAR_FILE" /etc/eastSouth/backend/
JAR_NAME=$(basename "$JAR_FILE")

# 创建 application.properties 覆盖配置
cat > /etc/eastSouth/backend/application-prod.properties << EOF
# 生产环境配置
server.port=8084

# 数据库配置
spring.datasource.url=jdbc:mysql://localhost:3306/simple_website?useSSL=false&serverTimezone=UTC&characterEncoding=utf8&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=${NEW_DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA配置
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect

# 文件上传配置
spring.servlet.multipart.max-file-size=500MB
spring.servlet.multipart.max-request-size=500MB
EOF

echo -e "${GREEN}✓ 后端部署完成${NC}"
echo ""

# ==================== 步骤 4: 部署管理后台 ====================
echo -e "${YELLOW}[4/7] 部署管理后台 (frontend)...${NC}"

cd "$PROJECT_ROOT/frontend"
npm install --silent
npm run build

sudo mkdir -p /etc/simpleBackendFrontend
sudo cp -r dist/* /etc/simpleBackendFrontend/
sudo chown -R $USER:$USER /etc/simpleBackendFrontend

echo -e "${GREEN}✓ 管理后台部署完成${NC}"
echo ""

# ==================== 步骤 5: 部署展示网站 ====================
echo -e "${YELLOW}[5/7] 部署展示网站 (runtime-api-frontend)...${NC}"

cd "$PROJECT_ROOT/runtime-api-frontend"
npm install --silent

# 使用环境变量设置 API 地址
VITE_API_BASE_URL="http://${NEW_SERVER_IP}:8084" npm run build

sudo mkdir -p /etc/simpleWebsite
sudo cp -r dist/* /etc/simpleWebsite/
sudo chown -R $USER:$USER /etc/simpleWebsite

echo -e "${GREEN}✓ 展示网站部署完成${NC}"
echo ""

# ==================== 步骤 6: 配置 Nginx ====================
echo -e "${YELLOW}[6/7] 配置 Nginx...${NC}"

sudo tee /etc/nginx/conf.d/simplewebsite.conf > /dev/null << EOF
# 展示网站
server {
    listen 80;
    server_name ${NEW_SERVER_IP};

    root /etc/simpleWebsite;
    index index.html;

    # API 反向代理
    location /api/ {
        proxy_pass http://127.0.0.1:8084/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        client_max_body_size 500M;
    }

    # 上传文件访问
    location /upload/ {
        alias /etc/eastSouth/backend/upload/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # 前端路由
    location / {
        try_files \$uri \$uri/ /index.html;
    }
}

# 管理后台
server {
    listen 8080;
    server_name ${NEW_SERVER_IP};

    root /etc/simpleBackendFrontend;
    index index.html;

    # API 反向代理
    location /api/ {
        proxy_pass http://127.0.0.1:8084/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        client_max_body_size 500M;
    }

    # 上传文件访问
    location /upload/ {
        alias /etc/eastSouth/backend/upload/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # 前端路由
    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

# 测试并重载 Nginx
sudo nginx -t
sudo systemctl reload nginx

echo -e "${GREEN}✓ Nginx 配置完成${NC}"
echo ""

# ==================== 步骤 7: 启动后端服务 ====================
echo -e "${YELLOW}[7/7] 启动后端服务...${NC}"

# 创建 systemd 服务
sudo tee /etc/systemd/system/simplewebsite-backend.service > /dev/null << EOF
[Unit]
Description=Simple Website Backend
After=network.target mysql.service

[Service]
Type=simple
User=$USER
WorkingDirectory=/etc/eastSouth/backend
ExecStart=/usr/bin/java -Xms512m -Xmx1024m -jar /etc/eastSouth/backend/${JAR_NAME} --spring.config.location=file:/etc/eastSouth/backend/application-prod.properties
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 启动服务
sudo systemctl daemon-reload
sudo systemctl enable simplewebsite-backend
sudo systemctl start simplewebsite-backend

# 等待服务启动
sleep 5

# 检查服务状态
if sudo systemctl is-active --quiet simplewebsite-backend; then
    echo -e "${GREEN}✓ 后端服务已启动${NC}"
else
    echo -e "${RED}✗ 后端服务启动失败，请检查日志${NC}"
    sudo journalctl -u simplewebsite-backend -n 20 --no-pager
fi

echo ""

# ==================== 完成 ====================
echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}部署完成！${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""
echo -e "访问地址:"
echo -e "  展示网站: ${YELLOW}http://${NEW_SERVER_IP}${NC}"
echo -e "  管理后台: ${YELLOW}http://${NEW_SERVER_IP}:8080${NC}"
echo -e "  后端 API: ${YELLOW}http://${NEW_SERVER_IP}:8084/api/${NC}"
echo ""
echo -e "服务管理:"
echo -e "  查看状态: ${YELLOW}sudo systemctl status simplewebsite-backend${NC}"
echo -e "  重启服务: ${YELLOW}sudo systemctl restart simplewebsite-backend${NC}"
echo -e "  查看日志: ${YELLOW}sudo journalctl -u simplewebsite-backend -f${NC}"
echo ""
echo -e "${BLUE}==========================================${NC}"
