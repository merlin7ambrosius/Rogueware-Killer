# check for permissions
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    $boundPara = ($MyInvocation.BoundParameters.Keys | foreach{
        '-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '
    $currentFile = (Resolve-Path  $MyInvocation.InvocationName).Path
    $fullPara = $boundPara + ' ' + $args -join ' '
    Start-Process "$psHome\powershell.exe"   -ArgumentList "$currentFile $fullPara" -verb runas
    return
}

$PSScriptRoot
$program = "C:\Program Files"
$programx86 = "C:\Program Files (x86)"
$appdata = Get-Childitem env:APPDATA | %{ $_.Value } 

# set directory permissions
# unblock Baidu
Write-Host "`n"
Write-Host "正在解除malware系列软件的目录权限..." -ForegroundColor Yellow
cacls "$program\Baidu\BaiduAn" /E /G Everyone:F
cacls "$program\Baidu\BaiduSd" /E /G Everyone:F
cacls "$appdata\Baidu" /E /G Everyone:F
cacls "$programx86\Baidu\BaiduAn" /E /G Everyone
cacls "$programx86\Baidu\BaiduSd" /E /G Everyone
for($i = 1;$i -le 9;$i++ ){
     for($j = 0;$j -le 9; $j++ ){
         cacls "$program\BaiduSd$i.$j" /E /G Everyone:F
         attrib -s -h "$program\BaiduSd$i.$j"
         Remove-Item "$program\BaiduSd$i.$j" -ItemType Directory
     }
}
for($i = 1;$i -le 9;$i++ ){
     for($j = 0;$j -le 9; $j++ ){
         cacls "$programx86\BaiduSd$i.$j" /E /G Everyone:F
         attrib -s -h "$programx86\BaiduSd$i.$j" 
         Remove-Item "$programx86\BaiduSd$i.$j" -ItemType Directory 
     }
}
Remove-Item "$program\Baidu\BaiduAn" -ItemType Directory
Remove-Item "$program\Baidu\BaiduSd" -ItemType Directory
Remove-Item "$appdata\Baidu" -ItemType Directory
Remove-Item "$programx86\Baidu\BaiduAn" -ItemType Directory
Remove-Item "$programx86\Baidu\BaiduSd" -ItemType Directory

# unblock QiHoo 360
cacls "$program\360\360safe" /E /G Everyone:F
cacls "$program\360\360sd" /E /G Everyone:F
cacls "%ProgramFiles(x86)%\360\360safe" /E /G Everyone:F
cacls "%ProgramFiles(x86)%\360\360sd" /E /G Everyone:F
Remove-Item "$program\360\360safe" -ItemType Directory
Remove-Item "$program\360\360sd" -ItemType Directory
Remove-Item "$programx86\360\360safe" -ItemType Directory
Remove-Item "$programx86\360\360sd" -ItemType Directory

# Kingsoft
cacls "$program\ksafe" /E /G Everyone:F
cacls "$program\kingsoft\kingsoft antivirus" /E /G Everyone:F
cacls "$programx86\ksafe" /E /G Everyone:F
cacls "$programx86\kingsoft\kingsoft antivirus" /E /G Everyone:F
Remove-Item "$program\ksafe" -ItemType Directory
Remove-Item "$program\kingsoft\kingsoft antivirus" -ItemType Directory
Remove-Item "$programx86\ksafe" -ItemType Directory
Remove-Item "$programx86\kingsoft\kingsoft antivirus" -ItemType Directory

# Tencent
cacls "$program\Tencent\QQPCMgr" /E /G Everyone:F
cacls "$appdata\Tencent\QQPCMgr" /E /G Everyone:F
cacls "$programx86\Tencent\QQPCMgr" /E /G Everyone:F
Remove-Item "$program\Tencent\QQPCMgr" -ItemType Directory
Remove-Item "$appdata\Tencent\QQPCMgr" -ItemType Directory
Remove-Item "$programx86\Tencent\QQPCMgr"  -ItemType Directory

# Rising
cacls "$program\Rising\Rav" /E /G Everyone:F
cacls "$program\Rising" /E /G Everyone:F
cacls "$programx86\Rising\Rav" /E /G Everyone:F
cacls "$programx86\Rising" /E /G Everyone:F
Remove-Item "$program\Rising" -ItemType Directory
Remove-Item "$program\Rising\Rav" -ItemType Directory
Remove-Item "$programx86\Rising" -ItemType Directory
Remove-Item "$programx86\Rising\Rav" -ItemType Directory
Write-Host "`n"
Write-Host "已解除" -ForegroundColor Green

# unblock IP and URLs
Write-Host "`n"
Write-Host "正在恢复hosts" -ForegroundColor Yellow
"127.0.0.1 localhost" | Out-File "C:\Windows\System32\drivers\etc\hosts" -Force
Write-Host "`n"
Write-Host "已恢复" -ForegroundColor Green

# clear untrusted certificates
Write-Host "`n"
Write-Host "正在解除证书限制" -ForegroundColor Yellow
Remove-Item  "HKCU:Software\Microsoft\SystemCertificates\Disallowed\Certificates" -Recurse
Write-Host "`n"
Write-Host "已解除" -ForegroundColor Green

Write-Host "`n"
Write-Host "全部恢复! 按下任意键退出" -ForegroundColor Green
[Console]::Readkey() | Out-Null ;