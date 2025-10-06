$UAdmin = Get-LocalGroupMember -Group Administrators | Where-Object { $_.Name -notlike "*\*admin*" } #detect all local admin right counts that doesn't have Admin in the name

if ($Uadmin) { 
  Write-Host "Local User isn't Admin" #Local User account doesn't have admin
  Exit 0
} 
Else {
  Write-Host "Local User is Admin" #this one pops the removeLadmin script to run
  Exit 1
}