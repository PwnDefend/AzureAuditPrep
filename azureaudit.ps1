#Prepare Azure AD Audit VM
#mRr3b00t 24/12/2020
# PwnDefend / Xservus Limited
# version 0.1
#Prep script for https://github.com/CrowdStrike/CRT

# Fork by sailingbikeruk 29.12.2020
# Added some (limited) error checking


#must be run with local admin rights
#Requires -RunAsAdministrator

# Store the current location so it can be set back at the end
$StartingLocation = get-location

#change to our current user desktop
$DesktopPath = [Environment]::GetFolderPath("Desktop")
set-location -Path $DesktopPath

# Set the ErrorAction for the Try Catch
$ErrorActionPreference = "Stop"

# set the powershell execution policy
Set-ExecutionPolicy RemoteSigned -Force

Try {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}
Catch {
    write-host "Unable to install Package Provider" -ForegroundColor Red
    write-warning " Error was $_" -ForegroundColor Red
    break
}

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Try {    
    if (get-Module -ListAvailable -Name PowershellGet) {
        write-host "PowershellGet is already installed" -ForegroundColor Green
    }
    else {        
        Install-Module -Name PowershellGet -MinimumVersion 2.2.5 -Confirm:$false -Force
    }
}
Catch {    
    write-host "Unable to install PowershellGet" -ForegroundColor Red
    write-host " Error was $_" -ForegroundColor Red
    break
}

Try {   
    if (get-Module -ListAvailable -Name ExchangeOnlineManagement) {
        write-host "ExchangeOnlineManagement module is already installed" -ForegroundColor Green
    }
    else {        
        Install-Module -Name ExchangeOnlineManagement -MinimumVersion 2.0.3 -Confirm:$false -Force
    } 
}
Catch {    
    write-host "Unable to install ExchangeOnlineManagement" -ForegroundColor Red   
    write-host " Error was $_" -ForegroundColor red
    break
}

if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
        'Az modules installed at the same time is not supported.')
} 
else {
    Try {    
        if (get-Module -ListAvailable -Name Az) {
            write-host "Az module is already installed" -ForegroundColor Green
        }
        else {        
            Install-Module -Name Az -Scope AllUsers -Verbose
        } 
    }
    Catch {    
        write-host "Unable to install Az Module" -ForegroundColor Red
        write-host "Error was $_" -ForegroundColor Red
        break
    }
}

#this is the actual module required for the audit tool but you likely will want both for more audit foo
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
        'Az modules installed at the same time is not supported.')
} 
else {
    Try {   
        if (get-Module -ListAvailable -Name AzureAD ) {
            write-host "AzureAD module is already installed" -ForegroundColor Green
        }
        else {        
            Install-Module -Name AzureAD -Scope AllUsers -Verbose -AllowClobber
        }  
    }
    Catch {    
        write-host "Unable to install AzureAD Module" -ForegroundColor Red
        write-host "Error was $_" -ForegroundColor Red
        break
    }
}

    # Manual Test if required uncomment
    # Connect to Azure with a browser sign in token
    #Connect-AzAccount
    #Connect-ExchangeOnline -UserPrincipalName user@domainname.example

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrowdStrike/CRT/main/Get-CRTReport.ps1" -OutFile "Get-CRTReport.ps1"
Unblock-File Get-CRTReport.ps1

.\Get-CRTReport.ps1

set-location $StartingLocation
