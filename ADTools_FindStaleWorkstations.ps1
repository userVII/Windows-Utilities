$DaysInactive = 180
$OUtosearch = "" #Please enter the OU DN to search here
$PCNamesToIgnore = @("*SCCM*", "*HYPERV*")
$OldAgeDescription = "***This computer has been inactive for $DaysInactive or more days***"

$time = (Get-Date).Adddays(-($DaysInactive))
$pclist = Get-ADComputer -SearchBase $OUtosearch -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name

[System.Collections.ArrayList]$test = $pclist

#Remove computers on the ignore list from the array list
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
    Write-host "$($i.Name) description is being updated to reflect old age in AD`n"
    Set-ADComputer $pc.Name -Description $OldAgeDescription
    #Disable-ADAccount -Identity $pc.Name #If you want to disable as well
}
