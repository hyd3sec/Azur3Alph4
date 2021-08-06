param (
    [Parameter(Mandatory=$true)][string]$Endpoint
)

$envendpoint = ($Endpoint + "env.html")
Write-Host $envendpoint
$Request = (Invoke-WebRequest $envendpoint)
If ($Request.Content -Match "IDENTITY") {
    Write-Host "Endpoint belongs to a managed identity"
}
Else {
    Write-Host "Endpoint does not belong to a managed identity"
}