const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
const bcrypt = require('bcrypt');

// 数据库配置
const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: 'root123456',
  multipleStatements: true // 允许执行多条SQL语句
};

async function initDatabase() {
  let connection;
  
  try {
    console.log('正在连接MySQL服务器...');
    // 先连接到MySQL服务器（不指定数据库）
    connection = await mysql.createConnection(dbConfig);
    console.log('MySQL连接成功！');

    // 定义5个SQL文件的执行顺序
    const sqlFiles = [
      '01_database_and_drops.sql',
      '02_base_tables.sql',
      '03_home_tables.sql',
      '04_center_overview_tables.sql',
      '05_other_tables.sql'
    ];

    // 依次执行每个SQL文件
    console.log(`正在执行 ${sqlFiles.length} 个SQL文件...\n`);
    
    for (let i = 0; i < sqlFiles.length; i++) {
      const sqlFile = path.join(__dirname, sqlFiles[i]);
      console.log(`[${i + 1}/${sqlFiles.length}] 正在执行: ${sqlFiles[i]}`);
      
      if (!fs.existsSync(sqlFile)) {
        throw new Error(`SQL文件不存在: ${sqlFile}`);
      }
      
      const sql = fs.readFileSync(sqlFile, 'utf8');
      await connection.query(sql);
      console.log(`✅ ${sqlFiles[i]} 执行完成\n`);
    }
    
    console.log('✅ 所有SQL文件执行完成！');
    
    // 验证数据
    console.log('正在验证数据...');
    await connection.changeUser({ database: 'simple_website' });
    
    // 验证messages数据
    const [rows] = await connection.query('SELECT * FROM messages');
    console.log(`成功插入 ${rows.length} 条messages数据:`);
    rows.forEach((row, index) => {
      console.log(`  ${index + 1}. ID: ${row.id}, Content: ${row.content}, Created: ${row.created_at}`);
    });
    
    console.log('\n✅ 数据库初始化成功！');
    
    // 创建管理员用户（使用bcrypt生成密码哈希）
    console.log('\n正在创建管理员用户...');
    await createAdminUser(connection);
    
  } catch (error) {
    console.error('❌ 数据库初始化失败:', error.message);
    if (error.code === 'ER_ACCESS_DENIED_ERROR') {
      console.error('提示: 请检查数据库用户名和密码是否正确');
    } else if (error.code === 'ECONNREFUSED') {
      console.error('提示: 请确保MySQL服务已启动');
    }
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
      console.log('数据库连接已关闭');
    }
  }
}

// 创建管理员用户（直接在数据库中插入，使用bcrypt生成密码哈希）
async function createAdminUser(connection) {
  try {
    const username = 'admin';
    const password = 'admin123';
    const email = 'admin@example.com';
    
    // 检查用户是否已存在
    const [existingUsers] = await connection.query(
      'SELECT id FROM users WHERE username = ? OR email = ?',
      [username, email]
    );
    
    if (existingUsers.length > 0) {
      // 用户已存在，更新密码
      console.log('ℹ️  管理员用户已存在，正在更新密码...');
      
      // 使用bcrypt生成密码哈希（cost factor 10，与Spring Boot默认一致）
      const saltRounds = 10;
      const passwordHash = await bcrypt.hash(password, saltRounds);
      
      await connection.query(
        'UPDATE users SET password = ?, email_verified = TRUE, updated_at = NOW() WHERE username = ?',
        [passwordHash, username]
      );
      
      console.log('✅ 管理员用户密码已更新！');
    } else {
      // 用户不存在，创建新用户
      // 使用bcrypt生成密码哈希（cost factor 10，与Spring Boot默认一致）
      const saltRounds = 10;
      const passwordHash = await bcrypt.hash(password, saltRounds);
      
      await connection.query(
        `INSERT INTO users (username, password, email, email_verified, created_at, updated_at, deleted, deleted_at)
         VALUES (?, ?, ?, TRUE, NOW(), NOW(), FALSE, NULL)`,
        [username, passwordHash, email]
      );
      
      console.log('✅ 管理员用户创建成功！');
    }
    
    console.log('\n📝 管理员账户信息:');
    console.log('  用户名: admin');
    console.log('  密码: admin123');
    console.log('  邮箱: admin@example.com');
    console.log('\n✅ 可以使用以上账户登录系统');
    
  } catch (error) {
    console.error('❌ 创建管理员用户失败:', error.message);
    console.error('提示: 请手动创建管理员用户');
    throw error;
  }
}

// 执行初始化
initDatabase();

