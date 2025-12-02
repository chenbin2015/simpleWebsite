@echo off
REM 打包所有备份脚本 (Windows)
REM 功能：将数据库备份和上传文件备份打包成一个 zip 文件

set SCRIPT_DIR=%~dp0
set BACKUP_ROOT=%SCRIPT_DIR%backup
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set PACKAGE_FILE=%BACKUP_ROOT%\backup_%TIMESTAMP%.zip

echo ==========================================
echo 开始打包所有备份文件
echo 时间: %date% %time%
echo ==========================================

REM 检查备份目录是否存在
if not exist "%BACKUP_ROOT%" (
    echo 错误: 备份目录不存在，请先执行备份脚本
    exit /b 1
)

REM 进入备份根目录
cd /d "%BACKUP_ROOT%"

REM 检查是否有备份文件
dir /b database\simple_website_*.sql* >nul 2>&1
set DB_EXISTS=%ERRORLEVEL%
dir /b uploads\uploads_*.zip >nul 2>&1
set UPLOAD_EXISTS=%ERRORLEVEL%

if %DB_EXISTS% NEQ 0 if %UPLOAD_EXISTS% NEQ 0 (
    echo 错误: 没有找到备份文件，请先执行备份脚本
    exit /b 1
)

REM 使用 PowerShell 打包
echo 正在打包...
powershell -Command "$files = @(); if (Test-Path 'database') { $files += Get-ChildItem -Path 'database' -Filter 'simple_website_*.sql*' -File | Select-Object -Last 1 }; if (Test-Path 'uploads') { $files += Get-ChildItem -Path 'uploads' -Filter 'uploads_*.zip' -File | Select-Object -Last 1 }; if ($files.Count -gt 0) { Compress-Archive -Path $files.FullName -DestinationPath '%PACKAGE_FILE%' -Force; Write-Host '打包完成！'; Write-Host '打包文件: %PACKAGE_FILE%' } else { Write-Host '错误: 没有找到备份文件'; exit 1 }"

if %ERRORLEVEL% EQU 0 (
    echo ==========================================
    echo 打包完成！
    echo 打包文件: %PACKAGE_FILE%
    echo ==========================================
    echo.
    echo 可以使用以下命令上传到服务器:
    echo   scp %PACKAGE_FILE% user@server:/path/to/backup/
    echo.
    exit /b 0
) else (
    echo ==========================================
    echo 打包失败！
    echo ==========================================
    exit /b 1
)

