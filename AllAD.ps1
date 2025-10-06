$credential = Get-Credential
$username = $credential.Username
$password = $credential.GetNetworkCredential().Password

import-Module ActiveDirectory

function Show-Menu
{
    param(
        [string]$Title = "AD Group Scripts"
    )
    Write-Host "============ $Title ==========="
    Write-Host "`n"
    Write-Host "1: Copy Groups"
    Write-Host "2: Get AD Groups"
    Write-Host "3: Terminate User"
    Write-Host "Q: Quit"
}

do
{   
     Clear-Host
     Show-Menu
     Write-Host "`n"
     $userinput = Read-Host "Please make a selection"
     switch ($userinput)
     {
           '1' {
                Write-Host "`n"
                Write-Host "=============================================================="
                Write-host "This will allow you to copy AD groups from one user to another"
                Write-Host "=============================================================="
                Write-Host "`n"
                $copy = Read-host "Enter username to copy from"
                $paste  = Read-host "Enter username to copy to"
                get-ADuser -identity $copy -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $paste
           } 


           '2' {
                Write-Host "`n"
                Write-Host "==============================================="
                Write-Host "This will create a CSV to view a user's groups."
                Write-Host "==============================================="
                Write-Host "`n"
                $firstlast = Read-host "Enter username"
                Get-ADPrincipalGroupMembership $firstlast | Select-Object name | Out-File -FilePath C:\Users\james.gorman\ADGroups\$firstlast.csv
           } 


           '3' {
                Write-Host "`n"
                Write-Host "==============================================="
                Write-Host "This will go through Terminating a user."
                Write-Host "==============================================="
                Write-Host "`n"
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
                Set-ADUser -Identity "$uname" -Description "Disabled $(Get-Date -Format 'dd-MM-yy') - $username - $srticket"
                Move-ADObject -Identity "CN=$name,OU=StagingUsers,OU=Global,DC=UPSIS,DC=COM" -TargetPath "OU=Terminated,OU=StagingUsers,OU=Global,DC=UPSIS,DC=COM"
                Get-AdPrincipalGroupMembership -Identity $uname | Where-Object { $_.Name -notin @('Domain Users', 'UPSIS-M365-Backup') }  | Remove-AdGroupMember -Members $uname -Confirm:$False
                          
                          
                $Length = 25
                $NonAlphaChars = 10
                $RandomPassword = [System.Web.Security.Membership]::GeneratePassword($Length, $NonAlphaChars)
                $SecurePassword = ConvertTo-SecureString $RandomPassword -AsPlainText -Force
                Set-ADAccountPassword -Identity $uname -NewPassword $SecurePassword -Reset
                          
                          
                for ($i = 0; $i -le 100; $i++) {
                Start-Sleep -Milliseconds 100
                Write-Progress -Activity "Terminating User" -Status "$i% Complete" -PercentComplete $i
                }
           } 
           
           'r' {
                return
           }

           'q' {
                exit
           }
     }
     pause
}
until ($userinput -eq 'q')