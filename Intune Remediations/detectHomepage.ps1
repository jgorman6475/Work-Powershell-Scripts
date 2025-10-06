$Path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$Name = "HomepageLocation"
$Type = "REG_SZ"
$Value = "https://upsis.sharepoint.com/sites/UPS-Home"
 
Set-Location -Path HKLM:

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}