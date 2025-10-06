$Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\MDMWinsOverGP"
$Name = "MDMWinsOverGP"
$Type = "DWORD"
$Value = 1

Set-Location -Path HKLM:

New-Item -Path HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\MDMWinsOverGP

New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType DWORD -Force