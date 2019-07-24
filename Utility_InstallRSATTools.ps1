#Get the current WSUS registry setting
$currentWU = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" | select -ExpandProperty UseWUServer

#Show user the current install status
Write-Host "You currently have the following RSAT Tools installed:"
$installed = Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State
foreach($tool in $installed){
    Write-Host $tool.DisplayName "is currently" $tool.State
}
Write-Host ""

Write-Host "Please choose which RSAT Tools to install:"
Write-Host "
    1.) All available tools
    2.) All not installed tools
    3.) RSAT: Active Directory Domain Services and Lightweight Directory Services Tools
    4.) RSAT: BitLocker Drive Encryption Administration Utilities
    5.) RSAT: Active Directory Certificate Services Tools
    6.) RSAT: DHCP Server Tools
    7.) RSAT: DNS Server Tools
    8.) RSAT: Failover Clustering Tools
    9.) RSAT: File Services Tools
    10.) RSAT: Group Policy Management Tools
    11.) RSAT: IP Address Management (IPAM) Client
    12.) RSAT: Data Center Bridging LLDP Tools
    13.) RSAT: Network Controller Management Tools
    14.) RSAT: Network Load Balancing Tools
    15.) RSAT: Remote Access Management Tools
    16.) RSAT: Remote Desktop Services Tools
    17.) RSAT: Server Manager
    18.) RSAT: Shielded VM Tools
    19.) RSAT: Storage Migration Service Management Tools
    20.) RSAT: Storage Replica Module for Windows PowerShell
    21.) RSAT: System Insights Module for Windows PowerShell
    22.) RSAT: Volume Activation Tools
    23.) RSAT: Windows Server Update Services Tools
    24.) Exit"

$userChoice = Read-Host -Prompt "Which do ya want?"

#Let the following PS commands work
Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -value 0
Get-Service wuauserv | Restart-Service

switch ($userChoice) {
    "1"{
       Get-WindowsCapability -Online -Name RSAT*  | Add-WindowsCapability -Online;       
       break
    }
    "2"{
       Get-WindowsCapability -Online |? {$_.Name -like "*RSAT*" -and $_.State -eq "NotPresent"} | Add-WindowsCapability -Online 
       break
    }
    "3"{
        Add-WindowsCapability –online –Name “Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0”
        break
    }
    "4"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0”
        break
    }
    "5"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.CertificateServices.Tools~~~~0.0.1.0”
        break
    }
    "6"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.DHCP.Tools~~~~0.0.1.0”
        break
    }
    "7"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability –online –Name Rsat.Dns.Tools~~~~0.0.1.0”
        break
    }
    "8"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0”
        break
    }
    "9"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.FileServices.Tools~~~~0.0.1.0”
        break
    }
    "10"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0”
        break
    }
    "11"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.IPAM.Client.Tools~~~~0.0.1.0”
        break
    }
    "12"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.LLDP.Tools~~~~0.0.1.0”
        break
    }
    "13"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.NetworkController.Tools~~~~0.0.1.0”
        break
    }
    "14"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0”
        break
    }
    "15"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0”
        break
    }
    "16"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0”
        break
    }
    "17"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.ServerManager.Tools~~~~0.0.1.0”
        break
    }
    "18"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.Shielded.VM.Tools~~~~0.0.1.0”
        break
    }
    "19"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0”
        break
    }
    "20"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.StorageReplica.Tools~~~~0.0.1.0”
        break
    }
    "21"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.SystemInsights.Management.Tools~~~~0.0.1.0”
        break
    }
    "22"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.VolumeActivation.Tools~~~~0.0.1.0”
        break
    }
    "23"{
        Add-WindowsCapability –online –Name “Add-WindowsCapability -Online -Name Rsat.WSUS.Tools~~~~0.0.1.0”
        break
    }
    "24"{
        "Exiting"
        break
    }   
    default{
        "I didn't recognize that choice"; 
        break
    }
}

#Revert WSUS settings
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value $currentWU
Get-Service wuauserv | Restart-Service

$exitpause = Read-Host -Prompt "Press any button to exit..."
