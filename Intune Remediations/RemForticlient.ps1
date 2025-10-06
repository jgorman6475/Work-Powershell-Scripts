$Path = "HKLM:\SOFTWARE\Fortinet\FortiClient\FA_ESNAC"
$Name = "invitation"
$Type = "REG_SZ"
$Value = 3PKTSO18Y7AKS53JG6Q68OEGTCZ86BEW

Set-Location -Path HKLM:

New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType REG_SZ -Force