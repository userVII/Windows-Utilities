$DaysInactive = 180
$OUtosearch = ""
$PCNamesToIgnore = @("*SCCM*", "*HYPERV*")

$time = (Get-Date).Adddays(-($DaysInactive))
$pclist = Get-ADComputer -SearchBase $OUtosearch -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name
$pccount = $pclist.Count
$counter = 1

[System.Collections.ArrayList]$test = $pclist

#Add items not on the ignore list to an array list to process
foreach($nameToIgnore in $PCNamesToIgnore){
    foreach ($pc in $pclist){
        $pcName = $pc.Name
        if($pcName -like $nameToIgnore){
            Write-Host "$pcName is on the ignore list" -ForegroundColor Yellow
            $test.Remove($pc)
        }else{
            #do something else
        }
    }
}

#Set PC Desciption for leftover old PCs
foreach($i in $test){
    Write-host "$($i.Name) is being updated" 
    Set-ADComputer $pc.Name -Description "***This computer has been inactive for $DaysInactive or more days***"
    #Disable-ADAccount -Identity $pc.Name #If you want to disable as well
    $counter++
}
