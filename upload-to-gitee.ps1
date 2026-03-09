$ErrorActionPreference = "Continue"

$ProjectPath = "C:\Users\ASUS\Documents\trae_projects\tudo"
$AccessToken = "fcab09c624d626d8fd6c313340a8650e"
$RemoteUrl = "https://oauth2:fcab09c624d626d8fd6c313340a8650e@gitee.com/wtq77/tudu2.git"

Write-Host "正在准备上传项目到Gitee..." -ForegroundColor Green
Write-Host "项目路径: $ProjectPath" -ForegroundColor Cyan
Write-Host "使用访问令牌进行认证" -ForegroundColor Cyan

if (-not (Test-Path $ProjectPath)) {
    Write-Host "错误: 项目路径不存在！" -ForegroundColor Red
    exit 1
}

Set-Location $ProjectPath

Write-Host "`n--- 步骤 1: 初始化Git仓库 ---" -ForegroundColor Yellow

if (-not (Test-Path ".git")) {
    git init
    Write-Host "✓ Git仓库已初始化" -ForegroundColor Green
} else {
    Write-Host "✓ Git仓库已存在" -ForegroundColor Green
}

Write-Host "`n--- 步骤 2: 添加文件到暂存区 ---" -ForegroundColor Yellow

git add .
Write-Host "✓ 文件已添加到暂存区" -ForegroundColor Green

Write-Host "`n--- 步骤 3: 创建提交 ---" -ForegroundColor Yellow

$commitMessage = "初始提交: Todo网站项目 - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMessage
Write-Host "✓ 提交已创建: $commitMessage" -ForegroundColor Green

Write-Host "`n--- 步骤 4: 添加远程仓库 ---" -ForegroundColor Yellow

$existingRemotes = git remote
if ($existingRemotes -match "origin") {
    git remote set-url origin $RemoteUrl
    Write-Host "✓ 远程仓库已更新" -ForegroundColor Green
} else {
    git remote add origin $RemoteUrl
    Write-Host "✓ 远程仓库已添加" -ForegroundColor Green
}

Write-Host "`n--- 步骤 5: 推送到Gitee ---" -ForegroundColor Yellow

Write-Host "开始推送到Gitee，这可能需要几分钟..." -ForegroundColor Cyan

try {
    git push -u origin master
    Write-Host "`n=== 上传成功！ ===" -ForegroundColor Green
    Write-Host "项目已成功推送到: https://gitee.com/wtq77/tudu2" -ForegroundColor Green
    Write-Host "`n您可以在 https://gitee.com/wtq77/tudu2 查看项目" -ForegroundColor Green
} catch {
    Write-Host "`n=== 上传失败 ===" -ForegroundColor Red
    Write-Host "错误信息: $_" -ForegroundColor Red
    Write-Host "`n请检查:" -ForegroundColor Yellow
    Write-Host "1. 网络连接是否正常" -ForegroundColor White
    Write-Host "2. 访问令牌是否有效" -ForegroundColor White
    Write-Host "3. 远程仓库地址是否正确" -ForegroundColor White
    Write-Host "4. 是否有足够的仓库权限" -ForegroundColor White
    exit 1
}

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKeyAsString()
