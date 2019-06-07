$filesRoot = ""
$filesToSignPaths = Get-ChildItem $filesRoot -Recurse -Include *.ps1, *.psm1

$certFriendlyName = ""
$codeSigningCertificateThumbprint = ""
$cert = Get-ChildItem Cert:\CurrentUser\My\$codeSigningCertificateThumbprint -CodeSigningCert 
$timeStampURL = "http://timestamp.comodoca.com/authenticode"

foreach($file in $filestosignpath){
    if($cert) {
        Set-AuthenticodeSignature -filepath "$filesRoot\$file" -cert $cert -IncludeChain All -TimeStampServer $timeStampURL
    }
    else {
        throw "Did not find certificate with friendly name of `"$certFriendlyName`""
    }
    Start-Sleep -Seconds 15 #To not blow up their time server
}
