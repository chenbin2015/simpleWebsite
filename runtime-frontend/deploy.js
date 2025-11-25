#!/usr/bin/env node

/**
 * 发布脚本：构建项目并上传到服务器
 * 使用方法: npm run deploy [用户名]
 * 例如: npm run deploy root
 * 
 * 注意：使用 CommonJS 格式以兼容 package.json 中的 type: "module"
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// 配置
const SERVER_HOST = '116.62.13.27';
const SERVER_PATH = '/etc/simpleWebsite';
const BUILD_DIR = 'dist';
const USERNAME = process.argv[2] || 'root'; // 默认使用 root 用户

console.log('\x1b[32m%s\x1b[0m', '开始构建项目...');
try {
  execSync('npm run build', { stdio: 'inherit' });
} catch (error) {
  console.error('\x1b[31m%s\x1b[0m', '构建失败！');
  process.exit(1);
}

if (!fs.existsSync(BUILD_DIR)) {
  console.error('\x1b[31m%s\x1b[0m', `错误: 构建目录 ${BUILD_DIR} 不存在`);
  process.exit(1);
}

console.log('\x1b[32m%s\x1b[0m', '构建完成，开始上传到服务器...');
console.log('\x1b[33m%s\x1b[0m', `服务器: ${USERNAME}@${SERVER_HOST}`);
console.log('\x1b[33m%s\x1b[0m', `目标路径: ${SERVER_PATH}`);

// 使用 scp 上传 dist 目录下的所有内容
const scpCommand = `scp -r ${BUILD_DIR}/* ${USERNAME}@${SERVER_HOST}:${SERVER_PATH}/`;

try {
  execSync(scpCommand, { stdio: 'inherit' });
  console.log('\x1b[32m%s\x1b[0m', '✓ 上传成功！');
  console.log('\x1b[32m%s\x1b[0m', `文件已上传到: ${USERNAME}@${SERVER_HOST}:${SERVER_PATH}`);
} catch (error) {
  console.error('\x1b[31m%s\x1b[0m', '✗ 上传失败！');
  console.error(error.message);
  process.exit(1);
}

