const { Client } = require('ssh2');
const fs = require('fs');
const path = require('path');

const SERVER_HOST = '116.62.13.27';
const SERVER_USER = 'root';
const SERVER_PASSWORD = '1qaz_2wsx';
const DB_NAME = 'simple_website';
const DB_USER = 'root';
const DB_PASSWORD = 'k9#Qz$mR!pX2@L8';
const DB_PORT = 8024;
const SERVER_UPLOAD_PATH = '/etc/eastSouth/backend/upload';

const BACKUP_DIR = path.join(__dirname, 'backup');
const TIMESTAMP = new Date().toISOString().replace(/[-:T]/g, '').slice(0, 15);
const DB_BACKUP_DIR = path.join(BACKUP_DIR, `server_${TIMESTAMP}`, 'database');
const UPLOAD_BACKUP_DIR = path.join(BACKUP_DIR, `server_${TIMESTAMP}`, 'uploads');

fs.mkdirSync(DB_BACKUP_DIR, { recursive: true });
fs.mkdirSync(UPLOAD_BACKUP_DIR, { recursive: true });

const conn = new Client();

conn.on('ready', () => {
    console.log('SSH 连接成功');
    console.log('');

    const remoteDump = `/tmp/${DB_NAME}_${TIMESTAMP}.sql`;

    console.log('步骤 1/2: 备份服务器数据库...');
    const dumpCmd = `echo -n '${DB_PASSWORD}' > /tmp/.dbpw && MYSQL_PWD=$(cat /tmp/.dbpw) mysqldump -h127.0.0.1 -P${DB_PORT} -u${DB_USER} --single-transaction --routines --triggers --events --hex-blob --default-character-set=utf8mb4 ${DB_NAME} > ${remoteDump} && rm -f /tmp/.dbpw && gzip -f ${remoteDump}`;

    conn.exec(dumpCmd, (err, stream) => {
        if (err) {
            console.error('数据库备份命令执行失败:', err);
            conn.end();
            process.exit(1);
        }

        stream.on('close', (code) => {
            if (code !== 0) {
                console.error('数据库备份失败，退出码:', code);
                conn.end();
                process.exit(1);
            }

            console.log('数据库备份完成，下载中...');
            const localDbFile = path.join(DB_BACKUP_DIR, `${DB_NAME}_${TIMESTAMP}.sql.gz`);

            conn.sftp((err, sftp) => {
                if (err) {
                    console.error('SFTP 连接失败:', err);
                    conn.end();
                    process.exit(1);
                }

                sftp.fastDownload(`${remoteDump}.gz`, localDbFile, (err) => {
                    if (err) {
                        console.error('下载数据库备份失败:', err);
                        conn.end();
                        process.exit(1);
                    }

                    console.log('数据库备份已下载到:', localDbFile);
                    conn.exec(`rm -f ${remoteDump}.gz`, () => {
                        console.log('');
                        downloadUploads(conn, sftp);
                    });
                });
            });
        });
    });
}).on('error', (err) => {
    console.error('SSH 连接失败:', err.message);
    process.exit(1);
}).connect({
    host: SERVER_HOST,
    port: 22,
    username: SERVER_USER,
    password: SERVER_PASSWORD,
    readyTimeout: 30000
});

function downloadUploads(conn, sftp) {
    console.log('步骤 2/2: 下载服务器上传文件...');

    sftp.readdir(SERVER_UPLOAD_PATH, (err, list) => {
        if (err) {
            console.log('警告: 上传目录不存在或为空，跳过');
            console.log('');
            finishBackup(conn);
            return;
        }

        let downloadCount = 0;
        const totalFiles = countFiles(list);

        const downloadDir = (remotePath, localPath, callback) => {
            sftp.readdir(remotePath, (err, entries) => {
                if (err) {
                    callback(err);
                    return;
                }

                let pending = entries.length;
                if (pending === 0) {
                    callback(null);
                    return;
                }

                entries.forEach(entry => {
                    const remoteFilePath = `${remotePath}/${entry.filename}`;
                    const localFilePath = `${localPath}/${entry.filename}`;

                    if (entry.attrs.isDirectory()) {
                        fs.mkdirSync(localFilePath, { recursive: true });
                        downloadDir(remoteFilePath, localFilePath, (err) => {
                            if (!err) downloadCount++;
                            if (--pending === 0) callback(null);
                        });
                    } else {
                        sftp.fastDownload(remoteFilePath, localFilePath, (err) => {
                            if (!err) {
                                downloadCount++;
                                process.stdout.write(`\r已下载 ${downloadCount} 个文件...`);
                            }
                            if (--pending === 0) callback(null);
                        });
                    }
                });
            });
        };

        const localUploadDir = path.join(UPLOAD_BACKUP_DIR, 'upload');
        fs.mkdirSync(localUploadDir, { recursive: true });

        console.log(`共 ${totalFiles} 个文件需要下载`);
        downloadDir(SERVER_UPLOAD_PATH, localUploadDir, (err) => {
            console.log('');
            console.log('上传文件备份完成');
            console.log('');
            finishBackup(conn);
        });
    });
}

function countFiles(entries) {
    let count = 0;
    entries.forEach(entry => {
        if (entry.attrs.isDirectory()) {
            count++;
        } else {
            count++;
        }
    });
    return count;
}

function finishBackup(conn) {
    conn.end();

    const serverBackupDir = path.join(BACKUP_DIR, `server_${TIMESTAMP}`);
    const zipFile = path.join(BACKUP_DIR, `server_backup_${TIMESTAMP}.zip`);

    console.log('打包所有备份...');

    const { execSync } = require('child_process');
    try {
        execSync(`cd "${BACKUP_DIR}" && tar -czf "server_backup_${TIMESTAMP}.tar.gz" "server_${TIMESTAMP}/"`, { stdio: 'inherit' });
        const stats = fs.statSync(path.join(BACKUP_DIR, `server_backup_${TIMESTAMP}.tar.gz`));
        const sizeMB = (stats.size / 1024 / 1024).toFixed(2);

        console.log('');
        console.log('==========================================');
        console.log('服务器备份全部完成！');
        console.log(`备份文件: ${path.join(BACKUP_DIR, `server_backup_${TIMESTAMP}.tar.gz`)}`);
        console.log(`文件大小: ${sizeMB} MB`);
        console.log('==========================================');

        fs.rmSync(serverBackupDir, { recursive: true, force: true });
    } catch (err) {
        console.error('打包失败:', err.message);
        console.log(`备份文件保留在: ${serverBackupDir}`);
    }
}
