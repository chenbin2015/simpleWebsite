# 数据库初始化脚本

这个文件夹包含使用 Node.js 执行的数据库初始化脚本。

## 使用方法

### 1. 安装依赖

```bash
cd scripts
npm install
```

### 2. 执行初始化脚本

```bash
npm run init
```

或者直接运行：

```bash
node init.js
```

## 配置

数据库配置在 `init.js` 文件中：

- 主机: localhost
- 用户名: root
- 密码: root123456

如果需要修改配置，请编辑 `init.js` 文件中的 `dbConfig` 对象。

## 功能

- 自动创建数据库 `simple_website`
- 创建 `messages` 表
- 插入示例数据
- 验证数据是否成功插入

