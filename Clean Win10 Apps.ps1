Set-StrictMode -Version 2.0
<#
# Used for Win 10 Professional app management. Enterprise doesn't need this
#>

$sw = [System.Diagnostics.Stopwatch]::StartNew()

$InstalledApps = Get-AppxPackage -AllUsers | Select-Object Name

$AppList = @(
    #Default Windows 10 apps
    "Microsoft.3DBuilder"    
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "*CortanaListenUIApp*"
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.DesktopAppInstaller"
    "Microsoft.Getstarted"
    "Microsoft.Windows.Holographic.*"
    "Microsoft.Messaging"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet*"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"  
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    #Candy Crush
    "*CandyCrushSodaSaga*"
    "*CandyCrush*"
    "*CandyCrushSaga*" 

    #Minecraft
    "Microsoft.MinecraftUWP"
    
    #XBox
    "Microsoft.XboxApp"
    "*xbox*"
    "*XboxOneSmartGlass*"      

    #Non-Microsoft
    "*Twitter*"
    "9E2F88E3.Twitter"
    "Flipboard.Flipboard"
    "ShazamEntertainmentLtd.Shazam"    
    "ClearChannelRadioDigital.iHeartRadio"
    "*Pandora*"
    "*Duolingo*"

    # apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"
)

foreach($appfound in $InstalledApps){
    Write-Host "$($appfound.Name) was found in Installed Apps" -ForegroundColor Yellow

    foreach($possibleapp in $AppList){
        if ($appfound.Name -like $possibleapp){
            Write-Host "`t$($appfound.Name) matched $possibleapp" -ForegroundColor green
            
            $appholder = Get-AppxPackage -Name $possibleapp -AllUsers 
            try{
                Remove-AppxPackage $appholder -ErrorAction SilentlyContinue
            }catch{
                Write-Host "`t$appholder couldn't be removed" -ForegroundColor Red 
            }
            
            $appholder2 = Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $possibleapp
            if($null -ne $appholder2){
                try{
                    Remove-AppxProvisionedPackage $appholder2 -Online
                }catch{                    
                     Write-Host "`tUnable to remove the online app $appholder2" -ForegroundColor DarkMagenta
                }
            }
        }
    }
}

$sw.Stop()
Write-Host "Script has finished in $($sw.Elapsed.ToString())"
