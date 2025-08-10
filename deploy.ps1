# ------------- 配置区 -------------
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null  # 设置控制台代码页为 UTF-8

# GitHub 仓库地址
$repoUrl = "https://github.com/moxuan-plus/moxuan-plus.github.io.git"

# 本地博客源文件目录
$sourceDir = "C:\Users\26973\Desktop\python-tutorial"

# 仓库本地临时目录
$tempDir = "$env:TEMP\moxuan-plus-github"
# ------------- 配置区 -------------

Write-Host "开始部署到 GitHub Pages..." -ForegroundColor Green

# 如果临时目录存在，删除
if (Test-Path $tempDir) {
    Write-Host "清空临时目录..." -ForegroundColor Yellow
    Remove-Item -r -fo $tempDir
}

# 克隆仓库
Write-Host "克隆仓库到临时目录..." -ForegroundColor Yellow
git clone $repoUrl $tempDir

# 进入仓库目录
Set-Location $tempDir

# 删除旧文件（保留 .git）
Write-Host "删除旧文件..." -ForegroundColor Yellow
Get-ChildItem -Force | Where-Object { $_.Name -notmatch "^\.git$" } | Remove-Item -Recurse -Force

# 复制新文件
Write-Host " 复制新文件到仓库..." -ForegroundColor Yellow
Copy-Item -Path "$sourceDir\*" -Destination $tempDir -Recurse -Force

# 提交更改
git add .
$commitMsg = "Update blog: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg
git push origin main

Write-Host "部署完成！访问：https://moxuan-plus.github.io" -ForegroundColor Green
