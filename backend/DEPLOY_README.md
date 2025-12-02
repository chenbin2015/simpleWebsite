# 后端部署说明

## 脚本说明

### 1. deploy_to_server.sh
用于将 `target` 目录下的 jar 文件上传到服务器的 `/etc/eastSouth/backend` 目录，同时也会上传启动脚本。

**使用方法：**
```bash
# 在 backend 目录下执行
./deploy_to_server.sh
```

**功能：**
- 检查本地 target 目录下的 jar 文件是否存在
- 创建服务器目录（如果不存在）
- 停止旧服务（如果正在运行）
- 备份旧 jar 文件
- 上传新的 jar 文件
- 上传启动脚本 `start.sh`
- 设置启动脚本的执行权限

### 2. start.sh
用于在服务器上启动、停止、重启或查看服务状态。

**使用方法：**
```bash
# 在服务器上的 /etc/eastSouth/backend 目录下执行

# 启动服务
./start.sh start

# 停止服务
./start.sh stop

# 重启服务（默认）
./start.sh restart
# 或直接
./start.sh

# 查看服务状态
./start.sh status
```

**功能：**
- `start`: 启动服务
- `stop`: 停止服务
- `restart`: 重启服务（默认操作）
- `status`: 查看服务状态和日志

## 部署流程

### 1. 构建项目
```bash
cd backend
mvn clean package -DskipTests
```

### 2. 部署到服务器
```bash
./deploy_to_server.sh
```

### 3. 在服务器上启动服务
```bash
# SSH 连接到服务器
ssh root@116.62.13.27

# 进入部署目录
cd /etc/eastSouth/backend

# 启动服务
./start.sh start

# 或重启服务
./start.sh restart
```

## 服务器信息

- **服务器IP**: 116.62.13.27
- **用户名**: root
- **部署目录**: /etc/eastSouth/backend
- **JAR文件名**: simple-website-backend-1.0.0.jar

## 注意事项

1. **首次使用前**，需要确保：
   - 本地已安装 Maven 并配置好环境变量
   - 已配置 SSH 免密登录到服务器（或准备好密码）
   - 服务器上已安装 Java 17 或更高版本

2. **SSH 免密登录配置**（推荐）：
   ```bash
   # 生成 SSH 密钥（如果还没有）
   ssh-keygen -t rsa
   
   # 将公钥复制到服务器
   ssh-copy-id root@116.62.13.27
   ```

3. **服务器环境要求**：
   - Java 17+
   - 足够的磁盘空间
   - 端口 8080 未被占用（或修改应用配置）

4. **日志查看**：
   ```bash
   # 实时查看日志
   tail -f /etc/eastSouth/backend/app.log
   
   # 查看最近100行日志
   tail -n 100 /etc/eastSouth/backend/app.log
   ```

5. **服务管理**：
   - 服务启动后会在后台运行
   - PID 保存在 `app.pid` 文件中
   - 日志保存在 `app.log` 文件中

## 故障排查

### 1. 上传失败
- 检查网络连接
- 确认 SSH 连接正常：`ssh root@116.62.13.27`
- 检查服务器磁盘空间

### 2. 服务启动失败
- 查看日志：`tail -50 /etc/eastSouth/backend/app.log`
- 检查 Java 版本：`java -version`
- 检查端口占用：`netstat -tlnp | grep 8080`
- 检查 JAR 文件是否存在：`ls -lh /etc/eastSouth/backend/simple-website-backend-1.0.0.jar`

### 3. 服务无法停止
- 手动查找进程：`ps aux | grep simple-website-backend`
- 强制终止：`kill -9 <PID>`
- 删除 PID 文件：`rm /etc/eastSouth/backend/app.pid`

