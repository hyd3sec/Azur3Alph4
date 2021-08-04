#Run GetManagedIdentityToken and GetSubscriptionID first
$token = $Identity_Token
If ($token = $null) {
    Write-Host "Run GetManagedIdentityToken.ps1 or manually store Managed Identity Token in `$token."
}
$URI = "https://management.azure.com/subscriptions/$subscriptionId/resources?api-version=2020-10-01"
$RequestParams = @{
    Method = 'GET'
    Uri = $URI
    Headers = @{
        'Authorization' = "Bearer $Token"
    }
}
(Invoke-RestMethod @RequestParams).value