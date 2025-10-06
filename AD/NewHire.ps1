$credential = Get-Credential
$username = $credential.Username
$password = $credential.GetNetworkCredential().Password

import-Module ActiveDirectory

Write-Host "`n`t`t Creating new user"
$first = Read-Host "First Name: "
$last = Read-Host "Last Name: "
$name = "$first $last"
$uname = $first + '.' + $last
$pass = Read-Host -AsSecureString "Enter Password: "
Write-Host "Email Domain:"
Write-Host "`n 1: @upsindustrial.com"
Write-Host "`n 2: @upsieservices.com"
Write-Host "`n 3: @upsmtservices.com"
$Semail = Read-Host "`n Please make a selection: "
switch ($Semail)
     {
           '1' {$email = "$uname@upsindustrial.com"}
           '2' {$email = "$uname@upsieservices.com"}
           '3' {$email = "$uname@upsmtservices.com"}
     }
$mphone = Read-Host "Phone Number: "
$title = Read-Host "Title: "
$dept = Read-Host "Department: "
$comp = Read-Host "Company: "
$mgr = Read-Host "Manager(first.last): "
$Sloc = Read-Host "HQ or Field: "
switch ($Sloc)
     {
           'HQ' {$loc = "Headquarters"}
           'hq' {$loc = "Headquarters"}
           'Field' {$loc = "Field"}
           'field' {$loc = "Field"}
     }



New-ADUser -Name $name -AccountPassword $pass -Company $comp -Department $dept -DisplayName $name -EmailAddress $email -Enabled 1 -GivenName $first -Manager $mgr -MobilePhone $mphone -Office $loc -Path "OU=StagingUsers,OU=Global,DC=UPSIS,DC=COM" -SamAccountName $uname -Surname $last -Title $title -UserPrincipalName $email -OtherAttributes @{ProxyAddresses="SMTP:$email"}

for ($i = 0; $i -le 100; $i++) {
Start-Sleep -Milliseconds 100
Write-Progress -Activity "Creating User" -Status "$i% Complete" -PercentComplete $i
}