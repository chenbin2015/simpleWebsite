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

// 先确保服务器目录存在
console.log('\x1b[36m%s\x1b[0m', '检查并创建服务器目录...');
const mkdirCommand = `ssh ${USERNAME}@${SERVER_HOST} "mkdir -p ${SERVER_PATH} && chmod 755 ${SERVER_PATH}"`;
try {
  execSync(mkdirCommand, { stdio: 'inherit' });
  console.log('\x1b[32m%s\x1b[0m', '✓ 服务器目录准备完成');
} catch (error) {
  console.error('\x1b[31m%s\x1b[0m', '✗ 创建服务器目录失败！');
  console.error(error.message);
  process.exit(1);
}

// 使用 tar 压缩上传，更可靠
console.log('\x1b[36m%s\x1b[0m', '开始上传文件...');
const tempPath = `${SERVER_PATH}_tmp`;
const localTempFile = path.join(process.cwd(), 'deploy_temp.tar.gz'); // 本地临时文件
const remoteTempFile = `${tempPath}.tar.gz`; // 服务器临时文件

// 步骤1: 清理并准备服务器目录
console.log('\x1b[36m%s\x1b[0m', '步骤1: 准备服务器目录...');
try {
  execSync(`ssh ${USERNAME}@${SERVER_HOST} "mkdir -p ${tempPath} && chmod 755 ${tempPath}; rm -rf ${SERVER_PATH}/* ${SERVER_PATH}/.[^.]* 2>/dev/null; rm -f ${remoteTempFile}"`, { stdio: 'inherit' });
  console.log('\x1b[32m%s\x1b[0m', '✓ 服务器目录准备完成');
} catch (error) {
  console.error('\x1b[31m%s\x1b[0m', '✗ 准备服务器目录失败！');
  console.error(error.message);
  process.exit(1);
}

// 步骤2: 在本地打包 dist 目录
console.log('\x1b[36m%s\x1b[0m', '步骤2: 打包文件...');
// 清理本地临时文件（如果存在）
try {
  if (fs.existsSync(localTempFile)) {
    fs.unlinkSync(localTempFile);
  }
} catch (e) {
  // 忽略清理错误
}

const tarCommand = `tar -czf "${localTempFile}" -C ${BUILD_DIR} .`;
try {
  execSync(tarCommand, { stdio: 'inherit', cwd: process.cwd() });
  console.log('\x1b[32m%s\x1b[0m', '✓ 打包完成');
} catch (error) {
  console.error('\x1b[31m%s\x1b[0m', '✗ 打包失败！');
  console.error(error.message);
  // 清理本地临时文件
  try {
    if (fs.existsSync(localTempFile)) {
      fs.unlinkSync(localTempFile);
    }
  } catch (e) {
    // 忽略清理错误
  }
  process.exit(1);
}

// 步骤3: 上传压缩包
console.log('\x1b[36m%s\x1b[0m', '步骤3: 上传文件到服务器...');
try {
  execSync(`scp "${localTempFile}" ${USERNAME}@${SERVER_HOST}:${remoteTempFile}`, { stdio: 'inherit' });
  console.log('\x1b[32m%s\x1b[0m', '✓ 上传完成');
} catch (error) {
  console.error('\x1b[31m%s\x1b[0m', '✗ 上传失败！');
  console.error(error.message);
  // 清理本地和远程临时文件
  try {
    if (fs.existsSync(localTempFile)) {
      fs.unlinkSync(localTempFile);
    }
    execSync(`ssh ${USERNAME}@${SERVER_HOST} "rm -f ${remoteTempFile}; rm -rf ${tempPath}"`, { stdio: 'ignore' });
  } catch (e) {
    // 忽略清理错误
  }
  process.exit(1);
}

// 步骤4: 在服务器上解压并移动到目标位置
console.log('\x1b[36m%s\x1b[0m', '步骤4: 解压文件到目标目录...');
const extractCommand = `ssh ${USERNAME}@${SERVER_HOST} "cd ${tempPath} && tar -xzf ${remoteTempFile} && cp -r . ${SERVER_PATH}/ && cd / && rm -rf ${tempPath} ${remoteTempFile}"`;
try {
  execSync(extractCommand, { stdio: 'inherit' });
  console.log('\x1b[32m%s\x1b[0m', '✓ 上传成功！');
  console.log('\x1b[32m%s\x1b[0m', `文件已上传到: ${USERNAME}@${SERVER_HOST}:${SERVER_PATH}`);
} catch (error) {
  console.error('\x1b[31m%s\x1b[0m', '✗ 解压文件失败！');
  console.error(error.message);
  // 清理临时文件
  try {
    if (fs.existsSync(localTempFile)) {
      fs.unlinkSync(localTempFile);
    }
    execSync(`ssh ${USERNAME}@${SERVER_HOST} "rm -rf ${tempPath} ${remoteTempFile}"`, { stdio: 'ignore' });
  } catch (e) {
    // 忽略清理错误
  }
  process.exit(1);
}

// 清理本地临时文件
try {
  if (fs.existsSync(localTempFile)) {
    fs.unlinkSync(localTempFile);
    console.log('\x1b[32m%s\x1b[0m', '✓ 清理完成');
  }
} catch (e) {
  // 忽略清理错误
}

