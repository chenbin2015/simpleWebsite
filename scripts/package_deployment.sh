#!/bin/bash

# 打包部署包 - 将所有部署需要的文件打包
# 使用方法: ./package_deployment.sh
# 生成的包传到新服务器后，运行 deploy.sh <数据库密码> 即可部署

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$PROJECT_ROOT/backups/server_backup_20260919"
PACKAGE_DIR="$PROJECT_ROOT/backups/deployment_package"

echo -e "${GREEN}开始打包部署文件...${NC}"
echo ""

rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR"

# 1. 数据库备份
echo -e "${YELLOW}[1/6] 复制数据库备份...${NC}"
cp "$BACKUP_DIR/database_backup.sql.gz" "$PACKAGE_DIR/"
echo -e "${GREEN}✓ 完成${NC}"

# 2. 上传文件
echo -e "${YELLOW}[2/6] 复制上传文件...${NC}"
cp "$BACKUP_DIR/uploads_backup.tar.gz" "$PACKAGE_DIR/"
echo -e "${GREEN}✓ 完成${NC}"

# 3. 构建后端 JAR
echo -e "${YELLOW}[3/6] 构建后端 JAR 包...${NC}"
cd "$PROJECT_ROOT/backend"
if [ -f "./mvnw" ]; then
    ./mvnw clean package -DskipTests -q
else
    mvn clean package -DskipTests -q
fi
cp target/simple-website-backend-*.jar "$PACKAGE_DIR/"
echo -e "${GREEN}✓ 完成${NC}"

# 4. 打包管理后台源码（不构建，部署时在新机器上构建）
echo -e "${YELLOW}[4/6] 打包管理后台源码...${NC}"
cd "$PROJECT_ROOT/frontend"
tar --exclude='node_modules' --exclude='dist' -czf "$PACKAGE_DIR/frontend_src.tar.gz" .
echo -e "${GREEN}✓ 完成${NC}"

# 5. 打包展示网站源码（不构建，部署时在新机器上构建以写入正确 IP）
echo -e "${YELLOW}[5/6] 打包展示网站源码...${NC}"
cd "$PROJECT_ROOT/runtime-api-frontend"
tar --exclude='node_modules' --exclude='dist' -czf "$PACKAGE_DIR/runtime_api_frontend_src.tar.gz" .
echo -e "${GREEN}✓ 完成${NC}"

# 6. 创建一键部署脚本
echo -e "${YELLOW}[6/6] 创建部署脚本...${NC}"

cat > "$PACKAGE_DIR/deploy.sh" << 'DEPLOY_SCRIPT'
#!/bin/bash
# 一键部署脚本 - 在新服务器上运行
# 使用方法: ./deploy.sh <数据库密码>

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -lt 1 ]; then
    echo -e "${RED}用法: ./deploy.sh <数据库密码>${NC}"
    exit 1
fi

DB_PASSWORD=$1
DEPLOY_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_IP=$(hostname -I | awk '{print $1}')

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}一键部署${NC}"
echo -e "${BLUE}==========================================${NC}"
echo -e "服务器 IP: ${YELLOW}${SERVER_IP}${NC}"
echo ""

# ===== 1. 安装依赖 =====
echo -e "${YELLOW}[1/7] 安装系统依赖...${NC}"

if command -v apt-get &> /dev/null; then
    PM="apt-get"
    sudo apt-get update -qq
elif command -v yum &> /dev/null; then
    PM="yum"
    sudo yum install -y epel-release -q
    sudo yum update -y -q
elif command -v dnf &> /dev/null; then
    PM="dnf"
    sudo dnf update -y -q
else
    echo -e "${RED}不支持的包管理器${NC}" && exit 1
fi

# Java
if ! command -v java &> /dev/null; then
    sudo $PM install -y -q java-17-openjdk java-17-openjdk-devel
fi
echo -e "  ${GREEN}✓ Java $(java -version 2>&1 | head -1)${NC}"

# MySQL
if ! command -v mysql &> /dev/null; then
    sudo $PM install -y -q mysql-server
    sudo systemctl start mysqld 2>/dev/null || sudo systemctl start mysql 2>/dev/null
    sudo systemctl enable mysqld 2>/dev/null || sudo systemctl enable mysql 2>/dev/null
    # 设置密码
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';" 2>/dev/null || true
fi
echo -e "  ${GREEN}✓ MySQL${NC}"

# Node.js
if ! command -v node &> /dev/null; then
    curl -fsSL https://rpm.nodesource.com/setup_18.x 2>/dev/null | sudo bash - 2>/dev/null || \
    curl -fsSL https://deb.nodesource.com/setup_18.x 2>/dev/null | sudo -E bash - 2>/dev/null || true
    sudo $PM install -y -q nodejs
fi
echo -e "  ${GREEN}✓ Node.js $(node --version)${NC}"

# Nginx
if ! command -v nginx &> /dev/null; then
    sudo $PM install -y -q nginx
fi
echo -e "  ${GREEN}✓ Nginx${NC}"
echo ""

# ===== 2. 导入数据库 =====
echo -e "${YELLOW}[2/7] 导入数据库...${NC}"
gunzip -c "$DEPLOY_DIR/database_backup.sql.gz" | mysql -u root -p"${DB_PASSWORD}" 2>/dev/null
echo -e "  ${GREEN}✓ 数据库已导入${NC}"
echo ""

# ===== 3. 部署后端 =====
echo -e "${YELLOW}[3/7] 部署后端...${NC}"

sudo mkdir -p /etc/eastSouth/backend
sudo chown -R $USER:$USER /etc/eastSouth

cp "$DEPLOY_DIR"/simple-website-backend-*.jar /etc/eastSouth/backend/
tar -xzf "$DEPLOY_DIR/uploads_backup.tar.gz" -C /etc/eastSouth/backend/

cat > /etc/eastSouth/backend/application-prod.properties << CONF
server.port=8084
spring.datasource.url=jdbc:mysql://localhost:3306/simple_website?useSSL=false&serverTimezone=UTC&characterEncoding=utf8&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.servlet.multipart.max-file-size=500MB
spring.servlet.multipart.max-request-size=500MB
CONF

echo -e "  ${GREEN}✓ 后端已部署${NC}"
echo ""

# ===== 4. 构建并部署管理后台 =====
echo -e "${YELLOW}[4/7] 构建管理后台...${NC}"

ADMIN_DIR=$(mktemp -d)
tar -xzf "$DEPLOY_DIR/frontend_src.tar.gz" -C "$ADMIN_DIR"
cd "$ADMIN_DIR"
npm install --silent
npm run build

sudo mkdir -p /etc/simpleBackendFrontend
sudo rm -rf /etc/simpleBackendFrontend/*
sudo cp -r dist/* /etc/simpleBackendFrontend/
rm -rf "$ADMIN_DIR"

echo -e "  ${GREEN}✓ 管理后台已部署${NC}"
echo ""

# ===== 5. 构建并部署展示网站 =====
echo -e "${YELLOW}[5/7] 构建展示网站...${NC}"

WEB_DIR=$(mktemp -d)
tar -xzf "$DEPLOY_DIR/runtime_api_frontend_src.tar.gz" -C "$WEB_DIR"
cd "$WEB_DIR"
npm install --silent

# 写入正确的 API 地址（不修改源码，通过 .env 文件控制）
echo "VITE_API_BASE_URL=http://${SERVER_IP}:8084" > .env.production
npm run build

sudo mkdir -p /etc/simpleWebsite
sudo rm -rf /etc/simpleWebsite/*
sudo cp -r dist/* /etc/simpleWebsite/
rm -rf "$WEB_DIR"

echo -e "  ${GREEN}✓ 展示网站已部署${NC}"
echo ""

# ===== 6. 配置 Nginx =====
echo -e "${YELLOW}[6/7] 配置 Nginx...${NC}"

sudo tee /etc/nginx/conf.d/simplewebsite.conf > /dev/null << NGINX
server {
    listen 80;
    server_name ${SERVER_IP};
    root /etc/simpleWebsite;
    index index.html;

    location /api/ {
        proxy_pass http://127.0.0.1:8084/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        client_max_body_size 500M;
    }

    location /upload/ {
        alias /etc/eastSouth/backend/upload/;
        expires 30d;
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}

server {
    listen 8080;
    server_name ${SERVER_IP};
    root /etc/simpleBackendFrontend;
    index index.html;

    location /api/ {
        proxy_pass http://127.0.0.1:8084/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        client_max_body_size 500M;
    }

    location /upload/ {
        alias /etc/eastSouth/backend/upload/;
        expires 30d;
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
NGINX

sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

echo -e "  ${GREEN}✓ Nginx 已配置${NC}"
echo ""

# ===== 7. 启动后端 =====
echo -e "${YELLOW}[7/7] 启动后端服务...${NC}"

JAR_NAME=$(basename /etc/eastSouth/backend/simple-website-backend-*.jar)

sudo tee /etc/systemd/system/simplewebsite-backend.service > /dev/null << SVC
[Unit]
Description=Simple Website Backend
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=/usr/bin/java -Xms512m -Xmx1024m -jar /etc/eastSouth/backend/${JAR_NAME} --spring.config.location=file:/etc/eastSouth/backend/application-prod.properties
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
SVC

sudo systemctl daemon-reload
sudo systemctl enable simplewebsite-backend
sudo systemctl start simplewebsite-backend

sleep 5

if sudo systemctl is-active --quiet simplewebsite-backend; then
    echo -e "  ${GREEN}✓ 后端服务已启动${NC}"
else
    echo -e "  ${RED}✗ 后端启动失败${NC}"
    sudo journalctl -u simplewebsite-backend -n 20 --no-pager
fi

echo ""
echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}部署完成！${NC}"
echo -e "${BLUE}==========================================${NC}"
echo ""
echo -e "  展示网站: ${YELLOW}http://${SERVER_IP}${NC}"
echo -e "  管理后台: ${YELLOW}http://${SERVER_IP}:8080${NC}"
echo ""
DEPLOY_SCRIPT

chmod +x "$PACKAGE_DIR/deploy.sh"
echo -e "${GREEN}✓ 完成${NC}"
echo ""

# ===== 打包 =====
echo -e "${YELLOW}打包...${NC}"
cd "$PROJECT_ROOT/backups"
rm -f deployment_package.tar.gz
tar -czf deployment_package.tar.gz -C "$(dirname "$PACKAGE_DIR")" "$(basename "$PACKAGE_DIR")"

PACKAGE_SIZE=$(du -h deployment_package.tar.gz | cut -f1)

echo ""
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}打包完成！${NC}"
echo -e "${GREEN}==========================================${NC}"
echo ""
echo -e "部署包: ${YELLOW}backups/deployment_package.tar.gz${NC}"
echo -e "大小:   ${YELLOW}${PACKAGE_SIZE}${NC}"
echo ""
echo -e "使用方法:"
echo -e "  1. 传到新服务器: ${YELLOW}scp deployment_package.tar.gz user@新IP:/${NC}"
echo -e "  2. 解压: ${YELLOW}tar -xzf deployment_package.tar.gz${NC}"
echo -e "  3. 部署: ${YELLOW}cd deployment_package && ./deploy.sh <数据库密码>${NC}"
echo ""
