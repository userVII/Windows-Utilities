$filestosignpath = ""
$certFriendlyName = ""
$codeSigningCertificateThumbprint = ""
$certSubject = ""

if(($null -eq $codeSigningCertificateThumbprint) -or ($codeSigningCertificateThumbprint -eq "")){
    $retrievedthumbprint = Get-ChildItem cert: -Recurse | Where-Object{ $_.Subject –like $certSubject } | Select-Object Thumbprint -Unique
    $codeSigningCertificateThumbprint = $retrievedthumbprint.Thumbprint
}

$cert = Get-ChildItem Cert:\CurrentUser\My\$codeSigningCertificateThumbprint -CodeSigningCert 
$timeStampURL = "http://timestamp.comodoca.com/authenticode"

if($cert) {
	Set-AuthenticodeSignature -filepath $filestosignpath -cert $cert -IncludeChain All -TimeStampServer $timeStampURL
}
else {
	throw "Did not find certificate with friendly name of `"$certFriendlyName`""
}
