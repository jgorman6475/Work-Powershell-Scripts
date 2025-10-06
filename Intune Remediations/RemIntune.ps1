cd C:\

Start-Transcript "C:\temp\transcript.log"

# Set MDM Enrollment URL's
$key = 'SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\*'

try{
    $keyinfo = Get-Item "HKLM:\$key"
}
catch{
    Write-Host "Tenant ID is not found!"
    exit 1001
}

$url = $keyinfo.Name
$url = $url.Split("\")[-1]
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$url"

if(!(Test-Path $path)){
    Write-Host "KEY $path not found!"
    exit 1001
}else{
    try{
        Write-Host "MDM Enrollment registry keys not found. Registering now..."
        New-ItemProperty -LiteralPath $path -Name 'MdmEnrollmentUrl' -Value 'https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc' -PropertyType String -Force -ea SilentlyContinue;
        New-ItemProperty -LiteralPath $path -Name 'MdmTermsOfUseUrl' -Value 'https://portal.manage.microsoft.com/TermsofUse.aspx' -PropertyType String -Force -ea SilentlyContinue;
        New-ItemProperty -LiteralPath $path -Name 'MdmComplianceUrl' -Value 'https://portal.manage.microsoft.com/?portalAction=Compliance' -PropertyType String -Force -ea SilentlyContinue;
    }
    catch{
        Write-Host "Keys unable to be changed."
    }
    finally{
    # Trigger AutoEnroll
        try{
            C:\Windows\system32\deviceenroller.exe /c /AutoEnrollMDM
            Write-Host "Device is performing the MDM enrollment!"
           exit 0
        }
        catch{
            Write-Host "Something went wrong (C:\Windows\system32\deviceenroller.exe)"
           exit 1001
        }

    }
}
exit 0

Stop-Transcript

Try { $enrollment = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger CurrentEnrollmentId -ErrorAction Stop }
Catch {}

If ($enrollment) {
  $enrollmentId = $enrollment.CurrentEnrollmentId

  # Get Tasks and delete
  $scheduleObject = New-Object -ComObject Schedule.Service
  $scheduleObject.Connect()
  $TaskFolder = $scheduleObject.GetFolder("\Microsoft\Windows\EnterpriseMgmt\"+$enrollmentId)
  $Tasks = $TaskFolder.GetTasks(1)
  ForEach($Task in $Tasks){ $TaskFolder.DeleteTask($Task.Name,0) }
  $rootFolder = $scheduleObject.GetFolder("\Microsoft\Windows\EnterpriseMgmt")
  $rootFolder.DeleteFolder($enrollmentId,0)

  # Remove old registry keys
  Remove-Item HKLM:\SOFTWARE\Microsoft\Enrollments\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item HKLM:\SOFTWARE\Microsoft\Enrollments\Status\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Sessions\$enrollmentId -Recurse -Force -ErrorAction SilentlyContinue
  Remove-ItemProperty HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger\ -Name CurrentEnrollmentId -Force -ErrorAction SilentlyContinue

  # Remove old Intune certificates
  $certNew = Get-ChildItem Cert:\LocalMachine\My\ | Where-Object { $_.Issuer -Match "CN=Microsoft Intune MDM Device CA" }
  $certOld = Get-ChildItem Cert:\LocalMachine\My\ | Where-Object { $_.Issuer -Match "CN=SC_Online_Issuing" }
  If ($certNew) { $certNew | Remove-Item -Force -ErrorAction SilentlyContinue }
  If ($certOld) { $certOld | Remove-Item -Force -ErrorAction SilentlyContinue }
}