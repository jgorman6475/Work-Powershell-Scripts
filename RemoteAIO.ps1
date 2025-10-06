cd C:\

#remove local admin
$LAdmin = @("Administrator")  # List of allowed accounts
$AdminGroup = Get-LocalGroupMember -Name "Administrators"

foreach ($member in $AdminGroup) {
    if ($member.ObjectClass -eq 'User') {
    Write-Host "$($member.Name) is admin."
        $normalizedMemberName = ($member.Name -split '\\')[-1]
        if ($LAdmin -notcontains $normalizedMemberName) {
            Write-Host "Removing $($member.Name) from local admin group."
            Remove-LocalGroupMember -Group "Administrators" -Member $member.Name
        }
    }
}

#set hompage for edge and chrome as sharepoint site
$PathG = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$NameG = "HomepageLocation"
$TypeG = "REG_SZ"
$ValueG = "https://upsis.sharepoint.com/sites/UPS-Home"

Set-Location -Path HKLM:
New-Item -Path HKLM:\SOFTWARE\Policies\Google\Chrome
New-ItemProperty -Path $PathG -Name $NameG -Value $ValueG -PropertyType String -Force

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

#Sets Intune MDM policy over AD Group Policy
$PathM = "HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\MDMWinsOverGP"
$NameM = "MDMWinsOverGP"
$TypeM = "DWORD"
$ValueM = 1

Set-Location -Path HKLM:
New-Item -Path HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\MDMWinsOverGP
New-ItemProperty -Path $PathM -Name $NameM -Value $ValueM -PropertyType DWORD -Force

cd C:\
#update policies
gpupdate /force

#Install Windows update
cd C:\
Set-ExecutionPolicy Unrestricted
Install-Module PSWindowsUpdate
Import-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate