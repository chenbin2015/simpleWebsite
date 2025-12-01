// 通过后端API创建管理员用户
const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api/user';

async function createAdminUser() {
  try {
    console.log('正在创建管理员用户...');
    
    // 先尝试删除旧用户（如果存在）
    // 注意：这里需要先通过API删除，或者手动删除数据库中的用户
    
    // 通过注册接口创建管理员用户
    const response = await axios.post(`${API_BASE_URL}/register`, {
      username: 'admin',
      password: 'admin123',
      confirmPassword: 'admin123',
      email: 'admin@example.com'
    });
    
    if (response.data.success) {
      console.log('✅ 管理员用户创建成功！');
      console.log('用户名: admin');
      console.log('密码: admin123');
      console.log('邮箱: admin@example.com');
    } else {
      console.error('❌ 创建失败:', response.data.message);
      
      if (response.data.message.includes('已存在') || response.data.message.includes('已被注册')) {
        console.log('\n用户已存在，请直接使用以下账户登录：');
        console.log('用户名: admin');
        console.log('密码: admin123');
        console.log('\n如果无法登录，可能是密码不正确，请手动更新数据库中的密码。');
      }
    }
  } catch (error) {
    if (error.response) {
      console.error('❌ 创建失败:', error.response.data.message || error.response.data.error);
      
      if (error.response.data.message && error.response.data.message.includes('已被注册')) {
        console.log('\n用户已存在，请直接使用以下账户登录：');
        console.log('用户名: admin');
        console.log('密码: admin123');
        console.log('\n如果无法登录，请尝试：');
        console.log('1. 检查后端服务是否正在运行 (http://localhost:8080)');
        console.log('2. 重新初始化数据库: node scripts/init.js');
      }
    } else if (error.code === 'ECONNREFUSED') {
      console.error('❌ 无法连接到后端服务，请确保后端服务正在运行');
      console.log('后端服务地址: http://localhost:8080');
    } else {
      console.error('❌ 错误:', error.message);
    }
  }
}

createAdminUser();

