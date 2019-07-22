Set-StrictMode -Version 2.0
<#
# Updated for 1903
# - Added holographic first run, may have caused weird start menu bug without it
# - change to 3d viewer application name
# - added game bar removal
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
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Windows.HolographicFirstRun"
    "Microsoft.Messaging"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MixedReality.Portal"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"  
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"
    "Microsoft.YourPhone"    
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    #Candy Crush
    "*CandyCrush*"

    #Minecraft
    "Microsoft.MinecraftUWP"
    
    #XBox
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.Xbox.TCUI"     

    #Non-Microsoft
    "*Twitter*"
    "Flipboard.Flipboard"
    "ShazamEntertainmentLtd.Shazam"    
    "ClearChannelRadioDigital.iHeartRadio"
    "*Pandora*"
    "*Duolingo*"

    #Apps to keep
    #"Microsoft.BingWeather"
    #"Microsoft.DesktopAppInstaller"
    #"Microsoft.MicrosoftSolitaireCollection"
    #"Microsoft.ScreenSketch"
    #"Microsoft.StorePurchaseApp"
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
                     Write-Host "`tUnable to remove the online app $($appholder2.DisplayName)" -ForegroundColor DarkMagenta
                }
            }
        }
    }
}

$sw.Stop()
Write-Host "Script has finished in $($sw.Elapsed.ToString())"
