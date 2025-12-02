@echo off
REM 数据库备份脚本 (Windows)
REM 功能：导出 MySQL 数据库的完整数据（结构和数据）

REM 配置信息
set DB_NAME=simple_website
set DB_USER=root
set DB_PASSWORD=root123456
set DB_HOST=localhost
set DB_PORT=3306

REM 备份目录
set SCRIPT_DIR=%~dp0
set BACKUP_DIR=%SCRIPT_DIR%backup\database
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set BACKUP_FILE=%BACKUP_DIR%\simple_website_%TIMESTAMP%.sql

REM 创建备份目录
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo ==========================================
echo 开始备份数据库: %DB_NAME%
echo 时间: %date% %time%
echo ==========================================

REM 执行备份
mysqldump -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% ^
  --single-transaction ^
  --routines ^
  --triggers ^
  --events ^
  --hex-blob ^
  --default-character-set=utf8mb4 ^
  %DB_NAME% > "%BACKUP_FILE%"

REM 检查备份是否成功
if %ERRORLEVEL% EQU 0 (
    echo ==========================================
    echo 数据库备份完成！
    echo 备份文件: %BACKUP_FILE%
    echo ==========================================
    
    REM 删除7天前的备份文件（可选，Windows需要forfiles命令）
    REM forfiles /p "%BACKUP_DIR%" /m simple_website_*.sql /d -7 /c "cmd /c del @path" 2>nul
    
    exit /b 0
) else (
    echo ==========================================
    echo 数据库备份失败！
    echo 请检查数据库连接信息和权限
    echo ==========================================
    exit /b 1
)

