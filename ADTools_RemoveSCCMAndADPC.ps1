#Can be installed from here https://www.microsoft.com/en-us/download/details.aspx?id=46681
#If the signature isn't trusted you can self sign here C:\Program Files (x86)\ConfigurationManager\Console\bin\ConfigurationManager\ConfigurationManager.psd1
Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)

# Site configuration
$SiteCode = ""
$ProviderMachineName = "" # SMS Provider machine name
$CollectionID = "" # All PC's collection

# Customizations
$initParams = @{}
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

if($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

function List_AllSCCMComputer(){
    $pclist = Get-CMDevice -CollectionID $CollectionID | Select-Object Name

    foreach($pc in $pclist){
        Write-host $pc.Name
    }
}

$Get_PCName = Read-Host -Prompt 'Please input the PC Name. Ex. PC-1234'
Write-Host""

#Set location to SCCM console
Set-Location "$($SiteCode):\" @initParams

#Check for ConfigurationManager module
if (Get-Module -Name "ConfigurationManager") {
    Write-Host "ConfigurationManager module found" -ForegroundColor Green
    #Remove an SCCM pc
    try{
        Get-CMDevice -Name $Get_PCName -CollectionId $CollectionID | Remove-CMDevice #-whatif
    }catch{Write-Host "An error occurred deleting the SCCM object. It may not exist."}
}else{
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("SCCM Module not installed - you will not be able to use this program fully.",0,"Error in PowerShell ConfigurationManager module",0x0)
}

#Set location back to default
Set-Location "C:\Windows\System32"

#Check for AD module
if (Get-Module -ListAvailable -Name "ActiveDirectory") {
    Write-Host "ActiveDirectory module found" -ForegroundColor Green
    #Try to remove AD computer by name
    try{
        Remove-ADComputer -Identity $Get_PCName #-whatif
    }catch{Write-Host "An error occurred deleting the AD object. It may not exist."}
}else{
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("AD Module not installed - you will not be able to use this program fully.",0,"Error in PowerShell AD module",0x0)
}

$Get_PCName = Read-Host -Prompt 'Press any button to exit...'
