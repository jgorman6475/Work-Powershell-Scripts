$Path = "HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\MDMWinsOverGP"
$Name = "MDMWinsOverGP"
$Type = "REG_DWORD"
$Value = 1
 
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