$credential = Get-Credential
$username = $credential.Username
$password = $credential.GetNetworkCredential().Password

import-Module ActiveDirectory

$firstlast = Read-host "Enter username: "

Get-ADPrincipalGroupMembership $firstlast | select name | Out-File -FilePath C:\Users\james.gorman\ADGroups\$firstlast.csv