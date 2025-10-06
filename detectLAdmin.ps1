$userName = "ISAdmin"
$Userexist = (Get-LocalUser).Name -Contains $userName
if ($userexist) { 
  Write-Host "Compliant" 
  Exit 0
} 
Else {
  Write-Host "Not Compliant"
  Exit 1
}