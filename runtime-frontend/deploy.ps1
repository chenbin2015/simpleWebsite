# PowerShell 发布脚本：构建项目并上传到服务器
# 使用方法: .\deploy.ps1 [用户名]
# 例如: .\deploy.ps1 root

param(
    [string]$Username = "root"  # 默认使用 root 用户
)

$ErrorActionPreference = "Stop"

# 配置
$ServerHost = "116.62.13.27"
$ServerPath = "/etc/simpleWebsite"
$BuildDir = "dist"

Write-Host "开始构建项目..." -ForegroundColor Green
npm run build

if (-not (Test-Path $BuildDir)) {
    Write-Host "错误: 构建目录 $BuildDir 不存在" -ForegroundColor Red
    exit 1
}

Write-Host "构建完成，开始上传到服务器..." -ForegroundColor Green
Write-Host "服务器: ${Username}@${ServerHost}" -ForegroundColor Yellow
Write-Host "目标路径: ${ServerPath}" -ForegroundColor Yellow

# 使用 scp 上传 dist 目录下的所有内容
# 注意：Windows 上需要安装 OpenSSH 客户端或使用 Git Bash
$scpCommand = "scp -r ${BuildDir}\* ${Username}@${ServerHost}:${ServerPath}/"

try {
    Invoke-Expression $scpCommand
    Write-Host "✓ 上传成功！" -ForegroundColor Green
    Write-Host "文件已上传到: ${Username}@${ServerHost}:${ServerPath}" -ForegroundColor Green
} catch {
    Write-Host "✗ 上传失败！" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

