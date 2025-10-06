$userName = "ISAdmin"
$userexist = (Get-LocalUser).Name -Contains $userName
$Password = ConvertTo-SecureString 'T3stPa$$word' -AsPlainText -Force


if($userexist -eq $false) {
  try{ 
     New-LocalUser -Name $username -Description "Local Admin Account" -AccountNeverExpires -Password $Password -PasswordNeverExpires -UserMayNotChangePassword
     Add-LocalGroupMember -Group Administrators -Member $userName
     Exit 0
   }   
  Catch {
     Write-error $_
     Exit 1
   }
}