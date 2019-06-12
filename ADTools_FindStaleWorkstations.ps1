$DaysInactive = 180
$OUtosearch = ""

$time = (Get-Date).Adddays(-($DaysInactive))
$pclist = Get-ADComputer -SearchBase $OUtosearch -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName
$pccount = $pclist.Count
$counter = 1

foreach ($pc in $pclist){
    Write-Progress -Activity "Updating PC description $counter / $pccount" -status "Working on $($pc.Name)"  -percentComplete (($counter / $pccount)*100)
    Write-Host "$($pc.Name) is being updated"
    Set-ADComputer $pc.Name -Description "***This computer has been inactive for $DaysInactive or more days***"
    $counter++
}

