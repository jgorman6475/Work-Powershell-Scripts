$Path = "HKLM:SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps"
$UserObjectID = "3275fee9-7e1c-4e56-9cfa-1dcb26353155"
$AppID = "195d321e-e875-416e-a89e-67e287e950e8"

function GetAppGRSHash {
    param (
        [Parameter(Mandatory = $true)]
        [string] $appId
    )

    $intuneLogList = Get-ChildItem -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs" -Filter "IntuneManagementExtension*.log" -File | Sort-Object LastWriteTime -Descending | Select-Object -ExpandProperty FullName

    if (!$intuneLogList) {
        Write-Error "Unable to find any Intune log files. Redeploy will probably not work as expected."
        return
    }

    foreach ($intuneLog in $intuneLogList) {
        $appMatch = Select-String -Path $intuneLog -Pattern "\[Win32App\]\[GRSManager\] App with id: $appId is not expired." -Context 0, 1
        if ($appMatch) {
            foreach ($match in $appMatch) {
                $Hash = ""
                $LineNumber = 0
                $LineNumber = $match.LineNumber
                $Hash = ((Get-Content $intuneLog | Select-Object -Skip $LineNumber -First 1) -split " = ")[1]
                if ($hash) {
                    $hash = $hash.Replace('+','\+')
                    return $hash
                }
            }
        }
    }

    Write-Error "Unable to find App '$appId' GRS hash in any of the Intune log files. Redeploy will probably not work as expected"
}

$GRSHash = GetAppGRSHash -appId $AppID

(Get-ChildItem -Path $Path\$UserObjectID) -match $AppID | Remove-Item -Recurse -Force

(Get-ChildItem -Path $Path\$UserObjectID\GRS) -match $GRSHash | Remove-Item -Recurse -Force

# Restart the IME Service
Get-Service -DisplayName "Microsoft Intune Management Extension" | Restart-Service 