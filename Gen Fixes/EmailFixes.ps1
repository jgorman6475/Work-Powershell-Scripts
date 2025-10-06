# Define the path where the script run marker will be placed
$markerFilePath = "$env:LOCALAPPDATA\IntuneScriptRunMarker.txt"

# Check if the marker file exists, which indicates the script has already run
if (Test-Path $markerFilePath) {
    Write-Host "Script has already run. Exiting..."
    exit 0
}

# Define the directories to be renamed
$directories = @(
    "$env:LOCALAPPDATA\Microsoft\OneAuth",
    "$env:LOCALAPPDATA\Microsoft\IdentityCache"
)

# Function to rename the folder
function Rename-Folder {
    param (
        [string]$FolderPath
    )

    # Check if the folder exists and doesn't already have additional characters in the name
    if (Test-Path -Path $FolderPath) {
        try {
            # Create a new name by appending "_backup" and adding a unique identifier if needed
            $newFolderName = $FolderPath + "_backup"
            $suffix = 1

            # Check if the folder with the new name already exists, and if so, increment the suffix to make it unique
            while (Test-Path ($newFolderName)) {
                $newFolderName = $FolderPath + "_backup_$suffix"
                $suffix++
            }

            # Rename the folder with the unique name
            Rename-Item -Path $FolderPath -NewName $newFolderName
            Write-Host "Renamed $FolderPath to $newFolderName"
        } catch {
            Write-Host "Failed to rename $FolderPath. Error: $_"
        }
    } else {
        Write-Host "Folder $FolderPath does not exist"
    }
}

# Perform Registry Modifications
function Update-Registry {
    param (
        [string]$KeyPath,
        [string]$ValueName,
        [string]$Type,
        [int]$Value
    )

    try {
        # Add or update the registry value
        reg add $KeyPath /v $ValueName /t $Type /d $Value /f
        Write-Host "Successfully updated $KeyPath\$ValueName"
    } catch {
        Write-Host "Failed to update $KeyPath\$ValueName. Error: $_"
    }
}

# Apply each folder renaming and registry update only if the script has not already run

# Loop through each folder and attempt to rename
foreach ($directory in $directories) {
    Rename-Folder -FolderPath $directory
}

# Define the registry updates
$registryUpdates = @(
    @{ KeyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"; ValueName = "SystemDefaultTlsVersions"; Type = "REG_DWORD"; Value = 1 },
    @{ KeyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"; ValueName = "SchUseStrongCrypto"; Type = "REG_DWORD"; Value = 1 },
    @{ KeyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319"; ValueName = "SchUseStrongCrypto"; Type = "REG_DWORD"; Value = 1 },
    @{ KeyPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319"; ValueName = "SystemDefaultTlsVersions"; Type = "REG_DWORD"; Value = 1 },
    @{ KeyPath = "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Outlook\Autodiscover"; ValueName = "ExcludeLastKnownGoodUrl"; Type = "REG_DWORD"; Value = 1 },
    @{ KeyPath = "HKEY_CURRENT_USER\Software\Policies\Microsoft\Office\16.0\Outlook\Autodiscover"; ValueName = "ExcludeLastKnownGoodUrl"; Type = "REG_DWORD"; Value = 1 },
    @{ KeyPath = "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\Autodiscover"; ValueName = "ExcludeLastKnownGoodUrl"; Type = "REG_DWORD"; Value = 1 },
    @{ KeyPath = "HKEY_CURRENT_USER\Software\Policies\Microsoft\Office\15.0\Outlook\Autodiscover"; ValueName = "ExcludeLastKnownGoodUrl"; Type = "REG_DWORD"; Value = 1 }
)

# Apply each registry update
foreach ($update in $registryUpdates) {
    Update-Registry -KeyPath $update.KeyPath -ValueName $update.ValueName -Type $update.Type -Value $update.Value
}

# Create a marker file to indicate that the script has successfully run
New-Item -ItemType File -Path $markerFilePath -Force | Out-Null
Write-Host "Script completed successfully. Marker file created at $markerFilePath"
