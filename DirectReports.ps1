$credential = Get-Credential
$username = $credential.Username
$password = $credential.GetNetworkCredential().Password

import-Module ActiveDirectory

$first = Read-Host "First Name: "
$last = Read-Host "Last Name: "
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
        Write-Host "No valid (non-Term OU) direct reports found for $ManagerSamAccountName."
    }
} else {
    Write-Host "No direct reports found for $ManagerSamAccountName."
}