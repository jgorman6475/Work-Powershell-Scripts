#InFortiESNAC.exevitation Key remove and add

Stop-Process -Name FortiClient

cd "c:\Program Files\Fortinet\FortiClient\"

# Remove Invitation Key
.\FortiESNAC.exe -u

#Add Invitation Key 
.\FortiESNAC.exe  -r "3PKTSO18Y7AKS53JG6Q68OEGTCZ86BEW"

Start-Process -FilePath "FortiClient.exe"

cd "C:\Users\james.gorman\OneDrive - universalplant.onmicrosoft.com\Desktop"

Exit