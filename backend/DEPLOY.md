# 后端部署说明

本项目是 Spring Boot 应用，使用 Maven 构建，部署为可执行的 JAR 文件。

## 服务器信息

- **服务器地址**: 116.62.13.27
- **目标路径**: /etc/simpleBackend
- **默认用户名**: root（可通过参数修改）
- **服务端口**: 8080（可在 application.properties 中配置）

## 前置要求

1. **Java 17+**: 服务器需要安装 Java 17 或更高版本
   ```bash
   # 检查Java版本
   java -version
   
   # 如果没有安装，Ubuntu/Debian系统：
   sudo apt-get update
   sudo apt-get install openjdk-17-jdk
   ```

2. **MySQL数据库**: 确保服务器上MySQL已安装并运行
   ```bash
   # 检查MySQL状态
   sudo systemctl status mysql
   ```

3. **Maven**: 本地开发环境需要安装Maven（用于构建）
   ```bash
   # 检查Maven版本
   mvn -version
   ```

## 部署方式

### 方式一：使用 Shell 脚本（推荐）

```bash
# 给脚本添加执行权限（仅首次需要）
chmod +x deploy.sh

# 使用默认用户 root
./deploy.sh

# 指定用户名
./deploy.sh [用户名]
# 例如: ./deploy.sh myuser
```

### 方式二：手动部署

#### 1. 构建项目

```bash
cd backend
mvn clean package -DskipTests
```

构建完成后，会在 `target/` 目录下生成 `simple-website-backend-1.0.0.jar` 文件。

#### 2. 上传到服务器

```bash
# 创建服务器目录
ssh root@116.62.13.27 "mkdir -p /etc/simpleBackend"

# 停止旧服务（如果存在）
ssh root@116.62.13.27 "cd /etc/simpleBackend && pkill -f simple-website-backend-1.0.0.jar || true"

# 备份旧JAR（如果存在）
ssh root@116.62.13.27 "cd /etc/simpleBackend && if [ -f simple-website-backend-1.0.0.jar ]; then cp simple-website-backend-1.0.0.jar simple-website-backend-1.0.0.jar.backup.\$(date +%Y%m%d_%H%M%S); fi"

# 上传新JAR
scp target/simple-website-backend-1.0.0.jar root@116.62.13.27:/etc/simpleBackend/

# 上传配置文件（可选）
ssh root@116.62.13.27 "mkdir -p /etc/simpleBackend/config"
scp src/main/resources/application.properties root@116.62.13.27:/etc/simpleBackend/config/
```

#### 3. 启动服务

```bash
# 方式1：使用nohup后台运行
ssh root@116.62.13.27 "cd /etc/simpleBackend && nohup java -jar -Dspring.config.location=file:./config/application.properties simple-website-backend-1.0.0.jar > app.log 2>&1 &"

# 方式2：使用systemd服务（推荐生产环境）
# 见下方"使用Systemd服务管理"部分
```

## 使用Systemd服务管理（推荐生产环境）

### 1. 创建systemd服务文件

在服务器上创建 `/etc/systemd/system/simple-website-backend.service`:

```ini
[Unit]
Description=Simple Website Backend Service
After=network.target mysql.service

[Service]
Type=simple
User=root
WorkingDirectory=/etc/simpleBackend
ExecStart=/usr/bin/java -jar -Dspring.config.location=file:/etc/simpleBackend/config/application.properties /etc/simpleBackend/simple-website-backend-1.0.0.jar
Restart=always
RestartSec=10
StandardOutput=append:/etc/simpleBackend/app.log
StandardError=append:/etc/simpleBackend/app.log

[Install]
WantedBy=multi-user.target
```

### 2. 启用并启动服务

```bash
# 重新加载systemd配置
sudo systemctl daemon-reload

# 启用服务（开机自启）
sudo systemctl enable simple-website-backend

# 启动服务
sudo systemctl start simple-website-backend

# 查看服务状态
sudo systemctl status simple-website-backend

# 查看日志
sudo journalctl -u simple-website-backend -f
```

### 3. 服务管理命令

```bash
# 启动服务
sudo systemctl start simple-website-backend

# 停止服务
sudo systemctl stop simple-website-backend

# 重启服务
sudo systemctl restart simple-website-backend

# 查看状态
sudo systemctl status simple-website-backend

# 查看日志
sudo journalctl -u simple-website-backend -f
```

## 配置文件

### 生产环境配置

建议在服务器上创建独立的配置文件 `/etc/simpleBackend/config/application.properties`:

```properties
# Server配置
server.port=8080

# MySQL数据库配置（生产环境）
spring.datasource.url=jdbc:mysql://localhost:3306/simple_website?useSSL=false&serverTimezone=UTC&characterEncoding=utf8&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=你的数据库密码

# JPA配置
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false  # 生产环境建议关闭SQL日志
spring.jpa.properties.hibernate.format_sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect

# 文件上传配置
spring.servlet.multipart.max-file-size=500MB
spring.servlet.multipart.max-request-size=500MB
```

## 日志管理

### 查看日志

```bash
# 如果使用nohup启动
ssh root@116.62.13.27 "tail -f /etc/simpleBackend/app.log"

# 如果使用systemd
ssh root@116.62.13.27 "sudo journalctl -u simple-website-backend -f"
```

### 日志轮转

创建 `/etc/logrotate.d/simple-website-backend`:

```
/etc/simpleBackend/app.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0644 root root
}
```

## 故障排查

### 问题：服务无法启动

1. **检查Java版本**
   ```bash
   ssh root@116.62.13.27 "java -version"
   ```

2. **检查端口占用**
   ```bash
   ssh root@116.62.13.27 "netstat -tlnp | grep 8080"
   ```

3. **查看日志**
   ```bash
   ssh root@116.62.13.27 "tail -50 /etc/simpleBackend/app.log"
   ```

### 问题：数据库连接失败

1. **检查MySQL服务**
   ```bash
   ssh root@116.62.13.27 "sudo systemctl status mysql"
   ```

2. **检查数据库配置**
   - 确认数据库名称、用户名、密码正确
   - 确认数据库已创建
   - 检查MySQL是否允许远程连接（如果需要）

### 问题：权限被拒绝

1. **检查SSH密钥配置**
   ```bash
   ssh-copy-id root@116.62.13.27
   ```

2. **检查目录权限**
   ```bash
   ssh root@116.62.13.27 "ls -la /etc/simpleBackend"
   ```

## 性能优化建议

1. **JVM参数调优**
   ```bash
   java -Xms512m -Xmx1024m -jar simple-website-backend-1.0.0.jar
   ```

2. **使用Nginx反向代理**
   - 配置Nginx作为反向代理
   - 处理静态资源
   - 负载均衡（如果需要）

3. **数据库优化**
   - 配置数据库连接池
   - 添加适当的索引
   - 定期优化数据库

## 安全建议

1. **不要使用root用户运行服务**（生产环境）
   - 创建专用用户运行服务
   - 限制文件权限

2. **配置防火墙**
   ```bash
   # 只开放必要端口
   sudo ufw allow 8080/tcp
   ```

3. **使用HTTPS**（生产环境）
   - 配置SSL证书
   - 在Nginx中配置HTTPS

4. **定期备份**
   - 数据库备份
   - 上传文件备份
   - 配置文件备份





