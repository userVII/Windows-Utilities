#Edit me
$csvSaveLocation = ""
$searchBase = ""
##
$computers = Get-ADComputer -Filter * -SearchBase $searchBase | Select-Object -ExpandProperty Name
$PCCompliance = @()

$initcounter = 1
foreach ($pc in $computers){
    Write-Progress -Activity "Scanning PC Compliance" -status "Scanning $pc. $initcounter of $($computers.Count)"  -percentComplete (($initcounter / $computers.Count)*100)
    Write-Host "Working on $pc"
    if (Test-Connection -ComputerName $pc -BufferSize 16 -Count 1 -Quiet){
        $resultCompliance
        $Compliance = Get-WmiObject -Class "MDM_WindowsLicensing" -List -Namespace "root\cimv2\mdm\dmmap" -ComputerName $pc
        if($Compliance -eq $null){
            $resultCompliance = "Not compliant"
        }else{
            $resultCompliance = "Compliant"
        }
        Write-Host $Compliance -ForegroundColor Yellow
        $PCObject = New-Object System.Object
        $PCObject | Add-Member -MemberType NoteProperty -Name "PC Name" -Value $PC
        $PCObject | Add-Member -MemberType NoteProperty -Name "Compliance" -Value $resultCompliance
        $PCCompliance += $PCObject
    }else{
        $PCObject = New-Object System.Object
        $PCObject | Add-Member -MemberType NoteProperty -Name "PC Name" -Value $PC
        $PCObject | Add-Member -MemberType NoteProperty -Name "Compliance" -Value "Could not ping device"
        $PCCompliance += $PCObject
    }
    $initcounter++
}

$PCCompliance | Export-Csv -NoTypeInformation -Path $csvSaveLocation
