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
