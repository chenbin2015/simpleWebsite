# 部署说明

本项目提供了多种部署方式，用于将构建后的文件上传到服务器。

## 服务器信息

- **服务器地址**: 116.62.13.27
- **目标路径**: /etc/simpleWebsite
- **默认用户名**: root（可通过参数修改）

## 部署方式

### 方式一：使用 npm 脚本（推荐）

```bash
# 使用默认用户 root
npm run deploy

# 指定用户名
npm run deploy [用户名]
# 例如: npm run deploy myuser
```

### 方式二：使用 Shell 脚本（Linux/Mac/Git Bash）

```bash
# 给脚本添加执行权限（仅首次需要）
chmod +x deploy.sh

# 使用默认用户 root
./deploy.sh

# 指定用户名
./deploy.sh [用户名]
# 例如: ./deploy.sh myuser
```

### 方式三：使用 PowerShell 脚本（Windows）

```powershell
# 使用默认用户 root
.\deploy.ps1

# 指定用户名
.\deploy.ps1 -Username myuser
```

## 部署流程

1. **构建项目**: 执行 `npm run build`，生成 `dist` 目录
2. **上传文件**: 使用 `scp` 将 `dist` 目录下的所有内容上传到服务器

## 注意事项

1. **SSH 密钥配置**: 建议配置 SSH 密钥认证，避免每次输入密码
   ```bash
   ssh-copy-id root@116.62.13.27
   ```

2. **服务器权限**: 确保目标路径 `/etc/simpleWebsite` 存在且有写入权限
   ```bash
   ssh root@116.62.13.27 "mkdir -p /etc/simpleWebsite && chmod 755 /etc/simpleWebsite"
   ```

3. **Windows 用户**: 
   - 如果使用 PowerShell，需要确保已安装 OpenSSH 客户端
   - 或者使用 Git Bash 运行 `deploy.sh` 脚本

4. **防火墙**: 确保服务器开放了 SSH 端口（默认 22）

## 故障排查

### 问题：scp 命令未找到
- **Windows**: 安装 OpenSSH 客户端或使用 Git Bash
- **Linux/Mac**: 通常已预装，如未安装：`sudo apt-get install openssh-client` (Ubuntu/Debian)

### 问题：权限被拒绝
- 检查 SSH 密钥是否正确配置
- 确认用户名和密码是否正确
- 检查服务器路径权限

### 问题：连接超时
- 检查服务器 IP 地址是否正确
- 检查网络连接
- 检查防火墙设置

