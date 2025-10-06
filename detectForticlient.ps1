$Path = "HKLM:\SOFTWARE\Fortinet\FortiClient\FA_ESNAC"
$Name = "invitation"
$Type = "REG_SZ"
$Value = 3PKTSO18Y7AKS53JG6Q68OEGTCZ86BEW
 
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