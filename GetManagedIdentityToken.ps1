param (
    [Parameter(Mandatory=$true)][string]$Endpoint
)

$envendpoint = ($Endpoint + "env.html")
$Request = (Invoke-WebRequest $envendpoint)
$Response = $Request.Content
If ($Response -Match "IDENTITY") {
    Write-Host "Endpoint belongs to a managed identity"
    Write-Host "Extracting Endpoint..."
    $regex = '(?<=POINT=)[\w:/.-]+'
    $Identity_Endpoint = (Select-String -inputObject $Response -Pattern $regex | foreach {$_.Matches.Value})
    Write-Host "Endpoint found @"$Identity_Endpoint + "& stored in `$Identity_Endpoint variable!"
}
Else {
    Write-Host "Endpoint does not belong to a managed identity"
}