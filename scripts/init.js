const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
const bcrypt = require('bcrypt');

// 数据库配置
const dbConfig = {
  host: '116.62.13.27',  // 使用 IPv4 地址，避免 IPv6 连接问题
  user: 'root',
  port: 8024,
  password: 'k9#Qz$mR!pX2@L8',
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
    
    // 初始化系统配置
    console.log('\n正在初始化系统配置...');
    await initSystemConfig(connection);
    
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

// 初始化系统配置
async function initSystemConfig(connection) {
  try {
    const baseUrl = 'http://116.62.13.27:8084';
    
    // 检查配置是否已存在
    const [existingConfigs] = await connection.query(
      'SELECT id FROM system_config WHERE config_key = ?',
      ['base_url']
    );
    
    if (existingConfigs.length > 0) {
      // 配置已存在，更新
      console.log('ℹ️  系统配置已存在，正在更新...');
      await connection.query(
        'UPDATE system_config SET config_value = ?, updated_at = NOW() WHERE config_key = ?',
        [baseUrl, 'base_url']
      );
      console.log('✅ 系统配置已更新！');
    } else {
      // 配置不存在，创建
      await connection.query(
        `INSERT INTO system_config (config_key, config_value, description, created_at, updated_at)
         VALUES (?, ?, ?, NOW(), NOW())`,
        ['base_url', baseUrl, '系统基础URL，用于拼接文件访问的完整地址']
      );
      console.log('✅ 系统配置创建成功！');
    }
    
    console.log(`\n📝 系统配置信息:`);
    console.log(`  配置键: base_url`);
    console.log(`  配置值: ${baseUrl}`);
    console.log(`  说明: 系统基础URL，用于拼接文件访问的完整地址`);
    console.log(`\n✅ 可以通过修改数据库中的 system_config 表来更改基础URL`);
    
  } catch (error) {
    console.error('❌ 初始化系统配置失败:', error.message);
    console.error('提示: 请手动插入系统配置');
    throw error;
  }
}

// 执行初始化
initDatabase();

