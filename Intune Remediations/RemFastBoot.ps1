$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$Name = "HiberbootEnabled"
$Type = "DWORD"
$Value = 0

Set-Location -Path HKLM:

New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType DWORD -Force