# Windows Utilities
Collection of handy Windows 10 Scripts

## [ADTools_Scan_StaleWorkstations](https://github.com/userVII/Windows-Utilities/blob/master/ADTools_Scan_StaleWorkstations.ps1)
Simple AD tool to find stale Workstation objects and do something with them. In this case, mark the description they are old.

## [ADTools_RemoveSCCMAndADPC](https://github.com/userVII/Windows-Utilities/blob/master/ADTools_RemoveSCCMAndADPC.ps1)
Use to remove both an AD PC and an SCCM workstation object if they exist

## [Scan_Win10Compliance](https://github.com/userVII/Windows-10-Utilities/blob/master/Scan_Win10Compliance.ps1)
Scans an OU for Win 10 MDM Compliance
-Useful to compare against SCCM results

## [TaskEvents_CustomTrigger](https://github.com/userVII/Windows-10-Utilities/blob/master/TaskEvents_CustomTrigger.ps1)
This script is for filtered results based on a USB being plugged in. This version uses 
EventID 2003 in Microsoft-Windows-DriverFrameworks-UserMode/Operational. Another method is
to enable PNP logging in Computer Configuration -> Policies -> Windows Settings ->
Security Settings -> Advanced Audit Policy configuration -> Audit Policies -> Detailed Tracking.
The later method you can use EventID 6416 in a Scheduled Task to fire the script. This event will have 
the DeviceDescription built into the XML. You then can use Get-Volume -FileSystemLabel "LABEL" to get
the drive letter more easily.

Example XML for PNP audit route:
```
<QueryList>
  <Query Id="0" Path="Security">
    \Select Path="Security">
        *[System[(EventID=6416)]] and *[EventData[(Data[@Name="DeviceDescription"]="DEVICENAME")]]
    </Select>
  </Query>
</QueryList>
```
## [Clean_Win10Apps](https://github.com/userVII/Windows-10-Utilities/blob/master/Clean_Win10Apps.ps1)
Easy way to manage bloatware on Win 10 Home and Professional. Enterprise doesn't need this and can use other Group Policy based solutions.

## Utility_PSFileSigners
### [Bulk Signer](https://github.com/userVII/Windows-10-Utilities/blob/master/Utility_BulkPSFileSigner.ps1)
### [Single File Signer](https://github.com/userVII/Windows-Utilities/blob/master/Utility_SinglePSFileSigner.ps1)
If you have a code Signing Certificate installed

Open up the Current User\Personal\Certificates

Get the Thumbprint Value and plug it into the script

###[RSAT Tools Installer](https://github.com/userVII/Windows-Utilities/blob/master/Utility_InstallRSATTools.ps1)
Console installer for RSAT Tools in case the Add/Remove feature doesn't work in your environment and you don't want to download the exe with an update
