$Path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$Name = "HomepageLocation"
$Type = "REG_SZ"
$Value = "https://upsis.sharepoint.com/sites/UPS-Home"

Set-Location -Path HKLM:

New-Item -Path HKLM:\SOFTWARE\Policies\Google\Chrome

New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType String -Force

$Path1 = "HKLM:\SOFTWARE\Policies\Google\Chrome\RestoreOnStartupURLs"
$Name1 = "1"
$Type1 = "REG_SZ"
$Value1 = "https://upsis.sharepoint.com/sites/UPS-Home"

Set-Location -Path HKLM:

New-Item -Path HKLM:\SOFTWARE\Policies\Google\Chrome\RestoreOnStartupURLs

New-ItemProperty -Path $Path1 -Name $Name1 -Value $Value1 -PropertyType String -Force

$Path2 = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
$Name2 = "HomepageLocation"
$Type2 = "REG_SZ"
$Value2 = "https://upsis.sharepoint.com/sites/UPS-Home"

Set-Location -Path HKLM:

New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Edge

New-ItemProperty -Path $Path2 -Name $Name2 -Value $Value2 -PropertyType String -Force

$Path3 = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\RestoreOnStartupURLs"
$Name3 = "1"
$Type3 = "REG_SZ"
$Value3 = "https://upsis.sharepoint.com/sites/UPS-Home"

Set-Location -Path HKLM:

New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Edge\RestoreOnStartupURLs

New-ItemProperty -Path $Path3 -Name $Name3 -Value $Value3 -PropertyType String -Force