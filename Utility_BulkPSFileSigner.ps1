$certFriendlyName = ""
$codeSigningCertificateThumbprint = ""
$cert = Get-ChildItem Cert:\CurrentUser\My\$codeSigningCertificateThumbprint -CodeSigningCert 
$timeStampURL = "http://timestamp.comodoca.com/authenticode"

function Sign_PowerShellFiles($pathToSign){
    $counter = 1
    $filestosignpath = Get-ChildItem $pathToSign -Recurse -Include *.ps1, *.psm1
    $filesCount = ($filestosignpath | Measure-Object).Count

    foreach($file in $filestosignpath){
        Write-Progress -Activity "Working on $counter of $filesCount" -status "Signing $file"  -PercentComplete (($counter / $filesCount)*100)

        if($cert) {
            Set-AuthenticodeSignature -filepath $file -cert $cert -IncludeChain All -TimeStampServer $timeStampURL
        }
        else {
            throw "Did not find certificate with friendly name of `"$certFriendlyName`""
        }
        if($filesCount -gt 1){
            Start-Sleep -Seconds 15 #To not blow up their time server
        }
        $counter++
    }
}

[string]$powershellFileLoc = Read-Host -Prompt 'Root of the PowerShell files?'
$powershellFileLoc = $powershellFileLoc.Replace('"',"")

if(Test-Path $powershellFileLoc){
    Sign_PowerShellFiles $powershellFileLoc
}

$pauser = Read-Host -Prompt 'Press any key to continue...'
