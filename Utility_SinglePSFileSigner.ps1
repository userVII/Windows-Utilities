$filestosignpath = ""
$certFriendlyName = ""
$codeSigningCertificateThumbprint = ""

$cert = Get-ChildItem Cert:\CurrentUser\My\$codeSigningCertificateThumbprint -CodeSigningCert 
$timeStampURL = "http://timestamp.comodoca.com/authenticode"

if($cert) {
	Set-AuthenticodeSignature -filepath $filestosignpath -cert $cert -IncludeChain All -TimeStampServer $timeStampURL
}
else {
	throw "Did not find certificate with friendly name of `"$certFriendlyName`""
}
