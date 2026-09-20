@echo off
REM 从远程服务器备份数据库和上传文件 (Windows)
REM 使用方法: backup_from_server.bat

setlocal enabledelayedexpansion

REM 服务器配置
set SERVER_HOST=116.62.13.27
set SERVER_USER=root
set SERVER_UPLOAD_PATH=/etc/eastSouth/backend/upload

REM 数据库配置（服务器上的）
set DB_NAME=simple_website
set DB_USER=root
set DB_PASSWORD=k9#Qz$mR!pX2@L8
set DB_PORT=8024

REM 本地备份目录
set SCRIPT_DIR=%~dp0
for /f "tokens=1-6 delims=/-_ " %%a in ("%date% %time%") do (
    set TIMESTAMP=%%a%%b%%c_%%d%%e%%f
)
set TIMESTAMP=%TIMESTAMP: =0%
set BACKUP_DIR=%SCRIPT_DIR%backup\server_%TIMESTAMP%
set DB_BACKUP_DIR=%BACKUP_DIR%\database
set UPLOAD_BACKUP_DIR=%BACKUP_DIR%\uploads

mkdir "%DB_BACKUP_DIR%" 2>nul
mkdir "%UPLOAD_BACKUP_DIR%" 2>nul

echo ==========================================
echo 开始从服务器备份
echo 服务器: %SERVER_USER%@%SERVER_HOST%
echo 时间: %date% %time%
echo ==========================================
echo.

REM 1. 备份数据库
echo 步骤 1/2: 备份服务器数据库...
set REMOTE_DUMP=/tmp/%DB_NAME%_%TIMESTAMP%.sql

ssh %SERVER_USER%@%SERVER_HOST% "mysqldump -h127.0.0.1 -P%DB_PORT% -u%DB_USER% -p'%DB_PASSWORD%' --single-transaction --routines --triggers --events --hex-blob --default-character-set=utf8mb4 %DB_NAME% > %REMOTE_DUMP% && gzip -f %REMOTE_DUMP%"

if %ERRORLEVEL% NEQ 0 (
    echo 数据库备份失败！
    exit /b 1
)

echo 下载数据库备份文件...
scp %SERVER_USER%@%SERVER_HOST%:%REMOTE_DUMP%.gz "%DB_BACKUP_DIR%\%DB_NAME%_%TIMESTAMP%.sql.gz"

ssh %SERVER_USER%@%SERVER_HOST% "rm -f %REMOTE_DUMP%.gz"

echo 数据库备份完成
echo.

REM 2. 备份上传文件
echo 步骤 2/2: 下载服务器上传文件...
scp -r %SERVER_USER%@%SERVER_HOST%:%SERVER_UPLOAD_PATH "%UPLOAD_BACKUP_DIR%\upload"

if %ERRORLEVEL% EQU 0 (
    echo 上传文件备份完成
) else (
    echo 警告: 上传文件下载失败，可能目录不存在
)

echo.

REM 3. 打包
echo 打包所有备份...
cd /d "%SCRIPT_DIR%backup"
powershell -Command "Compress-Archive -Path 'server_%TIMESTAMP%' -DestinationPath 'server_backup_%TIMESTAMP%.zip' -Force"

if %ERRORLEVEL% EQU 0 (
    echo 打包完成！
    echo 备份文件: %SCRIPT_DIR%backup\server_backup_%TIMESTAMP%.zip
    rmdir /s /q "server_%TIMESTAMP%"
) else (
    echo 打包失败，备份文件保留在: %BACKUP_DIR%
)

echo.
echo ==========================================
echo 服务器备份全部完成！
echo ==========================================

endlocal
