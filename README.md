# Simple Website Demo

这是一个全栈项目demo，包含Vue3前端和Spring Boot后端。

## 项目结构

```
.
├── frontend/          # Vue3前端项目
│   ├── src/
│   │   ├── views/    # 页面组件
│   │   ├── App.vue   # 根组件
│   │   └── main.js   # 入口文件
│   ├── package.json
│   └── vite.config.js
├── backend/          # Spring Boot后端项目
│   ├── src/main/java/com/example/
│   │   ├── controller/  # 控制器
│   │   ├── service/     # 服务层
│   │   ├── repository/  # 数据访问层
│   │   ├── entity/      # 实体类
│   │   ├── config/      # 配置类
│   │   └── SimpleWebsiteApplication.java
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
├── scripts/          # 数据库初始化脚本（Node.js）
│   ├── init.js       # 初始化脚本
│   ├── init.sql      # SQL初始化脚本文件
│   ├── package.json  # 脚本依赖
│   └── README.md     # 脚本说明
└── README.md
```

## 技术栈

### 前端
- Vue 3
- Vue Router
- Vue I18n
- Element Plus
- Vite
- Axios

### 后端
- Spring Boot 3.2.0
- Spring Data JPA
- MySQL

## 环境要求

- Node.js (推荐 v18+)
- Java 17+
- Maven 3.6+
- MySQL 8.0+

## 数据库设置

### 使用 Node.js 初始化脚本（推荐）

1. 确保MySQL服务已启动

2. 进入 scripts 文件夹并安装依赖：
```bash
cd scripts
npm install
```

3. 执行初始化脚本：
```bash
npm run init
```

或者直接运行：
```bash
node init.js
```

脚本会自动：
- 创建数据库 `simple_website`
- 创建 `messages` 表
- 插入示例数据
- 验证数据是否成功插入

### 方法二：手动执行 SQL（备选）

如果需要手动执行SQL脚本：

```bash
# 在项目根目录执行
mysql -u root -proot123456 < scripts/init.sql
```

或者在MySQL客户端中执行：
```sql
source scripts/init.sql
```

### 方法二：手动创建

1. 登录MySQL：
```bash
mysql -u root -p
# 输入密码: root123456
```

2. 创建数据库：
```sql
CREATE DATABASE simple_website DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE simple_website;
```

3. 应用启动时会自动创建表结构（通过JPA）

### 数据库配置

数据库配置已在 `backend/src/main/resources/application.properties` 中设置：
   - 用户名: root
   - 密码: root123456
   - 数据库名: simple_website
   - 连接URL已包含 `allowPublicKeyRetrieval=true` 参数

**注意**：如果数据库不存在，请先使用方法一或方法二创建数据库。应用启动时会自动执行 `schema.sql` 和 `data.sql` 脚本（如果配置了的话）。

## 启动步骤

### 1. 启动后端

```bash
cd backend
mvn spring-boot:run
```

后端将在 http://localhost:8080 启动

### 2. 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端将在 http://localhost:3000 启动

## 测试

1. 打开浏览器访问 http://localhost:3000
2. 点击"获取数据"按钮
3. 应该能看到从数据库返回的JSON数据，包括：
   - 最新的消息内容
   - 消息总数
   - 所有消息列表

## API端点

- GET `/hello` - 从数据库获取消息数据并返回JSON响应

## 数据库表结构

### messages 表
- `id` (BIGINT, PRIMARY KEY, AUTO_INCREMENT)
- `content` (VARCHAR, NOT NULL) - 消息内容
- `created_at` (DATETIME) - 创建时间

## 数据库初始化脚本

项目提供了 Node.js 脚本来初始化数据库：

- `scripts/init.js` - Node.js 初始化脚本（推荐使用）
- `scripts/init.sql` - SQL 脚本文件（由 Node.js 脚本读取）

**推荐使用方法**：
```bash
cd scripts
npm install
npm run init
```

脚本会自动执行以下操作：
- 创建数据库 `simple_website`
- 创建 `messages` 表
- 插入3条示例数据
- 验证数据并显示结果

详细说明请查看 `scripts/README.md`。

