<#
    .SYNOPSIS
        SCCM and AD PC remover
    .DESCRIPTION
        Scans and removes PC's from SCCM and AD
    .NOTES
        Version:  1
        Author:  userVII
        Creation Date:  02-06-2023
        Last Update:  02-06-2023
    .EXAMPLE
        N/A
#>

function TestForGroup(){
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $Group   
    )

    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $user = $user -replace '.*\\'
    $members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SamAccountName
    if ($members -contains $user){
        return $true
    }else{
        return $false
    }
}

function TestForModule(){
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $ModuleName   
    )

    if (Get-Module -ListAvailable -Name $ModuleName) {
        return $true
    }else{
        return $false
    }
}

function ImportSCCMModule(){
    Write-Host "Attempting to load Configuration Manager from" (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)
    Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)

    if (TestForModule -ModuleName ConfigurationManager) {
        return $true
    }else{
        return $false
    }
}

function DisplayPopup(){
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $PopupText,   
        [Parameter(Position=1,mandatory=$true)]
        [string] $PopupTitle
    )

    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup($PopupText,0,$PopupTitle,0x0)
}

function ManipulateADComputerObject(){
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $ComputerName   
    )

}

function GetADComputerObjectInformation(){
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $ComputerName   
    )
    try{
        return (Get-ADComputer -Identity $ComputerName -Properties CN,Description -ErrorAction SilentlyContinue)
    }catch{
        return $null
    }
}

function SCCMInitializer(){
    Param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $ComputerName,
        [switch]$DebugMode   
    )

    $SiteCode = "" # TODO Site code 
    $ProviderMachineName = "" # TODO SMS Provider machine name
    $CollectionID = "" # TODO All PC's coolection
    # Customizations
    $initParams = @{}

    Write-Host "Connecting to the SCCM coonsole..." -ForegroundColor green
    Write-Host "SiteCode: $SiteCode"
    Write-Host "Provider Machine Name: $ProviderMachineName"
    Write-Host "Collection ID: $CollectionID"
    Write-Host ""

    if($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
    }

    Set-Location "$($SiteCode):\" @initParams

    try{
        Write-Host "SCCM Data found:" -ForegroundColor Green
        $SCCMPCData = Get-CMDevice -Name $ComputerName -CollectionId $CollectionID | Select-Object -Property Name, LastLogonUser,MACAddress
    }catch{
        Write-Host "An error occurred getting the SCCM object. It may not exist."
        return
    }

    if($SCCMPCData -ne $null){
        $SCCMPCData
        $userADResponse= Read-Host "Would you like to remove this PC from SCCM? y/n"

        if($userADResponse.ToUpper() -eq "Y"){
            if($DebugMode){
                Get-CMDevice -Name $ComputerName -CollectionId $CollectionID | Remove-CMDevice -WhatIf
            }else{
                try{
                    Get-CMDevice -Name $ComputerName -CollectionId $CollectionID | Remove-CMDevice -Confirm:$false #TODO do you want a confirmation before deletion?
                    Write-Host "Device has been removed from SCCM" -ForegroundColor Green
                }catch{
                    Write-Host "Device could not be removed" -ForegroundColor Red
                }
            }
        }else{
            Write-Host "PC will not be removed" -ForegroundColor Yellow
        }
    }else{
        Write-Host "No device found in SCCM"
    }
}

function main(){
    Param(
        [Parameter(Position=0)]
        [switch] $DebugMode   
    )

    #Test to make sure user is in your admin group
    #TODO Needs handler for testing for AD module
    $groupMembership = TestForGroup -Group "" #TODO put in your AD admin group name for access
    if($groupMembership){
        Write-Information "Access granted" -InformationAction Continue
    }else{
        DisplayPopup -PopupText "You do not have access to this program" -PopupTitle "Access denied"
        Write-Information "Access denied" -InformationAction Continue
        return
    }

    #Test for ActiveDirectory Module
    $testForActiveDirectoryModule = TestForModule -ModuleName ActiveDirectory
    if($testForActiveDirectoryModule){
        Write-Information "AD module is installed" -InformationAction Continue
    }else{
        Write-Information "AD module not installed. You will not be able to modify AD computer objects" -InformationAction Continue
    }

    #Test for SCCM module import success
    $attemptSCCMImport = ImportSCCMModule
    if($attemptSCCMImport){
        Write-Information "SCCM module imported successfully" -InformationAction Continue
    }else{
        Write-Information "SCCM module could not be imported. SCCM functionality is disabled." -InformationAction Continue
    }

    Write-Host ""

    $looping = $true
    Do{
        #Pattern matching for PC name conventions
        $pattern = "" #TODO regex naming pattern

        #Ask for PC name from user
        $GetPCName = Read-Host -Prompt 'Please input the PC Name. Ex. XX-123456 or exit to stop.' #TODO update text
        if($GetPCName.ToUpper() -eq "EXIT"){
            $looping = $false
            break
        } 

        #Match our PC naming conventions to avoid whoopsies
        while($GetPCName -notmatch $pattern){
            $GetPCName = Read-Host -Prompt 'Please input the PC Name. Ex. XX-123456 or exit to stop.' #TODO update text
        }

        #AD PC Object Worker
        if($testForActiveDirectoryModule){
            #TODO we store pc info in AD description. If you do not you can remove some of this if you want
            $PCObjectInfo = GetADComputerObjectInformation -ComputerName $GetPCName
            if($PCObjectInfo){
                Write-Host "Computer Object Properties:" -ForegroundColor Green
                $PCObjectInfo
                $userADResponse= Read-Host "Would you like to remove this PC from AD? y/n"
                if($userADResponse.ToUpper() -eq "Y"){
                    if($DebugMode){
                        Get-ADComputer $GetPCName | Remove-ADObject -Recursive -Confirm:$false -WhatIf
                    }else{
                        Get-ADComputer $GetPCName | Remove-ADObject -Recursive -Confirm:$false #TODO do you want confirmations?
                    }
                }else{
                    Write-Host "PC will not be removed" -ForegroundColor Yellow
                }
            }else{
                Write-Host "AD PC Object not found" -ForegroundColor Red
            }
        }

        Write-Host ""

        #SCCM PC Object Worker
        if($attemptSCCMImport){
            SCCMInitializer -ComputerName $GetPCName -DebugMode:$DebugMode
        }

        #Set location back to default
        Set-Location "C:\Windows\System32"
    }while($looping)

    #unmount psdrive
    try{
        Get-PSDrive -Name "" -ErrorAction SilentlyContinue | Remove-PSDrive -Force #TODO update your drive name, probably your site code
    }catch{
        Write-Information "Not connected to SCCM" -InformationAction Continue
    }
}

main -DebugMode:$false
