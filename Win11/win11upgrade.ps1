$url = "https://go.microsoft.com/fwlink/?linkid=2171764"
$workingDir = "C:\Temp"
$file = "$workingDir\Win11Upgrade.exe"

if (!(Test-Path $workingDir)) {
    New-Item -ItemType Directory -Force -Path $workingDir
}
Invoke-WebRequest -Uri $url -OutFile $file
cd C:\Temp
Start-Process Win11Upgrade.exe