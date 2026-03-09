$ErrorActionPreference = "Continue"

$ProjectPath = "C:\Users\ASUS\Documents\trae_projects\tudo"
$GitHubToken = "YOUR_GITHUB_TOKEN_HERE"
$GitHubRepo = "wtq3383-beep/tudo"
$RemoteUrl = "https://$GitHubToken@github.com/$GitHubRepo.git"

Write-Host "正在准备上传项目到GitHub..." -ForegroundColor Green
Write-Host "项目路径: $ProjectPath" -ForegroundColor Cyan
Write-Host "GitHub仓库: $GitHubRepo" -ForegroundColor Cyan
Write-Host "注意: 需要先在GitHub创建访问令牌" -ForegroundColor Yellow

if (-not (Test-Path $ProjectPath)) {
    Write-Host "错误: 项目路径不存在！" -ForegroundColor Red
    exit 1
}

Write-Host "`n请先获取GitHub访问令牌：" -ForegroundColor Yellow
Write-Host "1. 访问 https://github.com/settings/tokens" -ForegroundColor White
Write-Host "2. 点击'Generate new token (classic)'" -ForegroundColor White
Write-Host "3. 设置token权限：repo (full control)" -ForegroundColor White
Write-Host "4. 生成token并复制" -ForegroundColor White
Write-Host "5. 将token粘贴到本脚本的$GitHubToken变量中" -ForegroundColor White
Write-Host "`n按任意键继续..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKeyAsString()

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

Write-Host "`n--- 步骤 5: 推送到GitHub ---" -ForegroundColor Yellow

Write-Host "开始推送到GitHub，这可能需要几分钟..." -ForegroundColor Cyan

try {
    git push -u origin master
    Write-Host "`n=== 上传成功！ ===" -ForegroundColor Green
    Write-Host "项目已成功推送到: https://github.com/$GitHubRepo" -ForegroundColor Green
    Write-Host "`n您可以在 https://github.com/$GitHubRepo 查看项目" -ForegroundColor Green
} catch {
    Write-Host "`n=== 上传失败 ===" -ForegroundColor Red
    Write-Host "错误信息: $_" -ForegroundColor Red
    Write-Host "`n请检查:" -ForegroundColor Yellow
    Write-Host "1. GitHub访问令牌是否正确" -ForegroundColor White
    Write-Host "2. 令牌是否有仓库访问权限" -ForegroundColor White
    Write-Host "3. 网络连接是否正常" -ForegroundColor White
    Write-Host "4. 远程仓库地址是否正确" -ForegroundColor White
    Write-Host "5. 是否需要配置Git用户信息" -ForegroundColor White
    Write-Host "`n配置Git用户信息命令：" -ForegroundColor Cyan
    Write-Host "git config --global user.name '您的用户名'" -ForegroundColor White
    Write-Host "git config --global user.email '您的邮箱'" -ForegroundColor White
    exit 1
}

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKeyAsString()
