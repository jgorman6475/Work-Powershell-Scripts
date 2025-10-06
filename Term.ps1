$credential = Get-Credential
$username = $credential.Username
$password = $credential.GetNetworkCredential().Password

import-Module ActiveDirectory

Write-Host "`n`t`t User Termination"
$first = Read-Host "First Name: "
$last = Read-Host "Last Name: "
$ticket = Read-Host "Ticket Number: "
$uname = $first + '.' + $last
$name = "$first $last"
$ugroup = $first + $last
$srticket = "SR-" + $ticket


Get-ADPrincipalGroupMembership $uname | select name | Out-File -FilePath "$($env:USERPROFILE)\Desktop\Terms\$ugroup.csv"
Disable-ADAccount -Identity $uname 
Set-ADUser -Identity "$uname" -Description "Disabled $(Get-Date -Format 'dd-MMM-yy') - $username - $srticket" -Clear Manager
Get-AdPrincipalGroupMembership -Identity $uname | Where-Object { $_.Name -notin @('Domain Users', 'UPSIS-M365-Backup') }  | Remove-AdGroupMember -Members $uname -Confirm:$False
Move-ADObject -Identity "CN=$name,OU=StagingUsers,OU=Global,DC=UPSIS,DC=COM" -TargetPath "OU=Terminated,OU=StagingUsers,OU=Global,DC=UPSIS,DC=COM"


$Length = 15
$NonAlphaChars = 10
$RandomPassword = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 20 | ForEach-Object {[char]$_})
$SecurePassword = ConvertTo-SecureString $RandomPassword -AsPlainText -Force
Set-ADAccountPassword -Identity $uname -NewPassword $SecurePassword -Reset


$ManagerSamAccountName = $first + '.' + $last
$CsvName = $first + $last

$DirectReportsDNs = Get-ADUser -Identity $ManagerSamAccountName -Properties DirectReports | Select-Object -ExpandProperty DirectReports

$ValidReports = @()

if ($DirectReportsDNs) {
    foreach ($reportDN in $DirectReportsDNs) {
        $user = Get-ADUser -Identity $reportDN -Properties DistinguishedName, SamAccountName, DisplayName, UserPrincipalName, Name
        if ($user.DistinguishedName -notlike "*OU=Terminated*") {
            $ValidReports += [PSCustomObject]@{
                Name = $user.Name
                UserPrincipalName  = $user.UserPrincipalName
            }
        }
    }

    if ($ValidReports.Count -gt 0) {
        $ValidReports | Format-Table -AutoSize
        $ValidReports | Export-Csv -Path "$($env:USERPROFILE)\Desktop\Reports\$CsvName.csv" -NoTypeInformation
    } else {
        Write-Host "No valid (non-Term OU) direct reports found for $first $last."
    }
} else {
    Write-Host "No direct reports found for $ManagerSamAccountName."
}


for ($i = 0; $i -le 100; $i++) {
Start-Sleep -Milliseconds 100
Write-Progress -Activity "Terminating User" -Status "$i% Complete" -PercentComplete $i
}

Write-Host "$first $last has been Terminated."