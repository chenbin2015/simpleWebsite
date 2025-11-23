const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

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

    // 读取SQL文件
    const sqlFile = path.join(__dirname, 'init.sql');
    console.log(`正在读取SQL文件: ${sqlFile}`);
    
    if (!fs.existsSync(sqlFile)) {
      throw new Error(`SQL文件不存在: ${sqlFile}`);
    }
    
    const sql = fs.readFileSync(sqlFile, 'utf8');
    console.log('SQL文件读取成功！');

    // 执行SQL语句
    console.log('正在执行数据库初始化脚本...');
    await connection.query(sql);
    console.log('数据库初始化完成！');
    
    // 验证数据
    console.log('正在验证数据...');
    await connection.changeUser({ database: 'simple_website' });
    const [rows] = await connection.query('SELECT * FROM messages');
    console.log(`成功插入 ${rows.length} 条数据:`);
    rows.forEach((row, index) => {
      console.log(`  ${index + 1}. ID: ${row.id}, Content: ${row.content}, Created: ${row.created_at}`);
    });
    
    console.log('\n✅ 数据库初始化成功！');
    
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

// 执行初始化
initDatabase();

