# Windows 10 Utilities
Collection of handy Windows 10 Scripts

# Scan-Win10Compliance
Scans an OU for Win 10 MDM Compliance
-Useful to compare against SCCM results

# Custom Event Trigger
This script is for filtered results based on a USB being plugged in. This version uses 
EventID 2003 in Microsoft-Windows-DriverFrameworks-UserMode/Operational. Another method is
to enable PNP logging in Computer Configuration -> Policies -> Windows Settings ->
Security Settings -> Advanced Audit Policy configuration -> Audit Policies -> Detailed Tracking.
The later method you can use EventID 6416 in a Scheduled Task to fire the script. This event will have 
the DeviceDescription built into the XML. You then can use Get-Volume -FileSystemLabel "LABEL" to get
the drive letter more easily.
