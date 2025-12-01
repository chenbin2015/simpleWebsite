# 管理员登录问题解决方案

## 问题
登录时提示"用户名或密码错误"

## 可能的原因
1. BCrypt哈希值不正确（初始化脚本中的哈希值可能不匹配）
2. 数据库中没有用户数据
3. 数据库未初始化

## 解决方案

### 方案1：通过后端API创建管理员用户（推荐）

1. 确保后端服务正在运行
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. 运行创建用户脚本
   ```bash
   node scripts/create_admin_user.js
   ```

3. 使用以下账户登录
   - 用户名: `admin`
   - 密码: `admin123`

### 方案2：手动通过API注册

使用curl命令：
```bash
curl -X POST http://localhost:8080/api/user/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "confirmPassword": "admin123",
    "email": "admin@example.com"
  }'
```

### 方案3：重新初始化数据库

如果数据库中有旧数据，先删除用户表，然后重新初始化：
```bash
node scripts/init.js
```

## 默认账户信息

- **用户名**: `admin`
- **密码**: `admin123`
- **邮箱**: `admin@example.com`

## 注意事项

- 密码在数据库中已使用BCrypt加密存储
- 每次生成的BCrypt哈希值都不同，但都能正确验证
- 如果用户已存在，创建脚本会提示，但仍可尝试登录

