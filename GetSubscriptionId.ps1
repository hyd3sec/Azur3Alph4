$token = $Identity_Token
If ($token = $null) {
    Write-Host "Run GetManagedIdentityToken.ps1 or manually store Managed Identity Token in `$token"
}
$URI = 'https://management.azure.com/subscriptions?api-version=2020-01-01'
$RequestParams = @{
    Method = 'GET'
    Uri = $URI
    Headers = @{
        'Authorization' = "Bearer $token"
    }
}
#Need to test this
$subscriptionID = (Invoke-RestMethod @RequestParams).value.subscriptionId