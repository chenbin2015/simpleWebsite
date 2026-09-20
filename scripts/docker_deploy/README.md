# Docker 部署包

## 环境要求

只需安装 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)，安装后重启电脑。

## 部署步骤

### 1. 启动 Docker Desktop

确保 Docker Desktop 已启动（系统托盘能看到鲸鱼图标）。

### 2. 打开终端

在此文件夹（docker_deploy）下打开 PowerShell 或 CMD。

### 3. 启动所有服务

```
docker-compose up -d
```

首次运行会自动下载镜像（MySQL、Nginx、Java），大约需要 5-10 分钟。
数据库会自动导入，无需手动操作。

### 4. 查看状态

```
docker-compose ps
```

三个服务都显示 `Up` 即为正常。

### 5. 访问

- 展示网站: http://localhost
- 管理后台: http://localhost:8080
- 后端 API: http://localhost:8084

管理后台默认账号: admin / admin123

## 常用命令

```bash
# 查看日志
docker-compose logs -f

# 停止所有服务
docker-compose down

# 停止并删除数据（清除数据库）
docker-compose down -v

# 重启某个服务
docker-compose restart backend
```

## 服务说明

| 容器 | 端口 | 说明 |
|------|------|------|
| sw_mysql | 3306 | MySQL 8.0 数据库 |
| sw_backend | 8084 | Java 后端服务 |
| sw_nginx | 80, 8080 | Nginx 反向代理 + 前端静态文件 |
