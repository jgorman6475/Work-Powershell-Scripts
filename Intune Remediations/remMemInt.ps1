$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
$Name = "Enabled"
$Type = "REG_DWORD"
$Value = 1

Set-Location -Path HKLM:
New-Item -Path $Path
New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType DWORD -Force