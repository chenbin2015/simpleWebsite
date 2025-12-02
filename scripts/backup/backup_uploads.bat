@echo off
REM 上传文件备份脚本 (Windows)
REM 功能：打包 backend\upload\ 目录下的所有上传文件

REM 获取脚本所在目录的父目录（项目根目录）
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..\..
cd /d "%PROJECT_ROOT%"
set UPLOAD_DIR=%CD%\backend\upload

REM 备份目录
set BACKUP_DIR=%SCRIPT_DIR%backup\uploads
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set BACKUP_FILE=%BACKUP_DIR%\uploads_%TIMESTAMP%.zip

REM 创建备份目录
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo ==========================================
echo 开始备份上传文件
echo 时间: %date% %time%
echo 源目录: %UPLOAD_DIR%
echo ==========================================

REM 检查源目录是否存在
if not exist "%UPLOAD_DIR%" (
    echo 错误: 上传目录不存在: %UPLOAD_DIR%
    exit /b 1
)

REM 检查源目录是否为空
dir /b "%UPLOAD_DIR%" >nul 2>&1
if errorlevel 1 (
    echo 警告: 上传目录为空，跳过备份
    exit /b 0
)

REM 使用 PowerShell 压缩文件夹（Windows 10+）
powershell -Command "Compress-Archive -Path '%UPLOAD_DIR%\*' -DestinationPath '%BACKUP_FILE%' -Force"

REM 检查打包是否成功
if %ERRORLEVEL% EQU 0 (
    echo ==========================================
    echo 上传文件备份完成！
    echo 备份文件: %BACKUP_FILE%
    echo ==========================================
    
    REM 删除7天前的备份文件（可选）
    REM forfiles /p "%BACKUP_DIR%" /m uploads_*.zip /d -7 /c "cmd /c del @path" 2>nul
    
    exit /b 0
) else (
    echo ==========================================
    echo 上传文件备份失败！
    echo 请检查目录权限和磁盘空间
    echo ==========================================
    exit /b 1
)

