# 本地 HTTP 服务，避开 GitHub Pages 的 HTTPS 混合内容拦截。
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 6869
$lanIp = (Get-NetIPAddress -AddressFamily IPv4 |
  Where-Object { $_.IPAddress -like '192.168.*' -or $_.IPAddress -like '10.*' -or $_.IPAddress -like '172.16.*' } |
  Select-Object -First 1 -ExpandProperty IPAddress)

# 用 Python 内置静态服务托管当前目录，并允许手机通过局域网访问。
Set-Location $root
Start-Process powershell -ArgumentList @(
  '-NoExit',
  '-Command',
  "cd `"$root`"; python -m http.server $port --bind 0.0.0.0"
)

# 打开本地页面，页面通过 HTTP 请求后端 HTTP 接口。
Start-Process "http://localhost:$port/"

if ($lanIp) {
  Write-Host "手机访问地址：http://$lanIp`:$port/"
}
