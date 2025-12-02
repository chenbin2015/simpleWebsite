@echo off
REM 完整备份脚本 (Windows)
REM 功能：依次执行数据库备份、上传文件备份，最后打包所有备份

set SCRIPT_DIR=%~dp0

echo ==========================================
echo 开始完整备份流程
echo 时间: %date% %time%
echo ==========================================
echo.

REM 1. 备份数据库
echo 步骤 1/3: 备份数据库...
call "%SCRIPT_DIR%backup_database.bat"
if %ERRORLEVEL% NEQ 0 (
    echo 数据库备份失败，终止备份流程
    exit /b 1
)
echo.

REM 2. 备份上传文件
echo 步骤 2/3: 备份上传文件...
call "%SCRIPT_DIR%backup_uploads.bat"
if %ERRORLEVEL% NEQ 0 (
    echo 上传文件备份失败，终止备份流程
    exit /b 1
)
echo.

REM 3. 打包所有备份
echo 步骤 3/3: 打包所有备份...
call "%SCRIPT_DIR%package_backup.bat"
if %ERRORLEVEL% NEQ 0 (
    echo 打包失败，但备份文件已保存在 backup\ 目录
    exit /b 1
)
echo.

echo ==========================================
echo 完整备份流程完成！
echo ==========================================

