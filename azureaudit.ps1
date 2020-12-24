#Prepare Azure AD Audit VM
#mRr3b00t 24/12/2020
# PwnDefend / Xservus Limited
# version 0.1
#Prep script for https://github.com/CrowdStrike/CRT

#run this with local admin rights


#change to our current user desktop
$DesktopPath = [Environment]::GetFolderPath("Desktop")
cd $DesktopPath

Set-ExecutionPolicy RemoteSigned -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module -Name PowershellGet -MinimumVersion 2.2.5 -Confirm:$false -Force
Install-Module -Name ExchangeOnlineManagement -MinimumVersion 2.0.3 -Confirm:$false -Force

if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
      'Az modules installed at the same time is not supported.')
} else {
    Install-Module -Name Az -AllowClobber -Scope AllUsers -Verbose
}

#this is the actual module required for the audit tool but you likely will want both for more audit foo
Install-Module -Name AzureAD

# Manual Test if required uncomment
# Connect to Azure with a browser sign in token
#Connect-AzAccount
#Connect-ExchangeOnline -UserPrincipalName user@domainname.example



Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrowdStrike/CRT/main/Get-CRTReport.ps1" -OutFile "Get-CRTReport.ps1"
Unblock-File Get-CRTReport.ps1

.\Get-CRTReport.ps1
