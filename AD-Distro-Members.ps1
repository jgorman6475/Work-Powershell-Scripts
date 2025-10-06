$credential = Get-Credential
$username = $credential.Username
$password = $credential.GetNetworkCredential().Password

import-Module ActiveDirectory

$groupname = Read-host "Enter Group Name: "

Get-ADGroupMember $groupname | select name | Out-File -FilePath C:\Users\james.gorman\ADGroups\$groupname.csv