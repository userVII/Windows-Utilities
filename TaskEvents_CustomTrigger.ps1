#Get very recent USB trigger
$Query = @"
    <QueryList>
        <Query Id="0" Path="Microsoft-Windows-DriverFrameworks-UserMode/Operational">
            <Select Path="Microsoft-Windows-DriverFrameworks-UserMode/Operational">
                *[System[(EventID=2003) and TimeCreated[timediff(@SystemTime) &lt;= 3000]]]
            </Select>
        </Query>
    </QueryList>
"@

$productID = "*SOMEID*"
$Events = Get-WinEvent -FilterXml $Query
$eventHolder = $Events | Select Message
$eventObjectHolder = @()

foreach($event in $eventHolder){
    if($event.Message -like "$productID"){
        $eventObject = New-Object System.Object
        $eventObject | Add-Member -MemberType NoteProperty -Name "InstanceID" -Value $event.Message
        $eventObjectHolder += $eventObject
    }    
}

if($eventObjectHolder.Count -gt 0){
    $eventObjectHolder | Out-GridView -PassThru -Title "Found $($eventObjectHolder.Count) events"
}
