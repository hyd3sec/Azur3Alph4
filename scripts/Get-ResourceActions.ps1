#Enumerates all resources available with a token and lists permissions of each resource right below it
#Beta as of 8/10 (untested)
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
$Resources = (Invoke-RestMethod @RequestParams).value
Write-Host "Resources: $Resources"

#For each resource list permissions right below it
Foreach ($resource in $Resources.Split("`n")) {
    Write-Host "Checking resource: $resource"
    Write-Host "Permissions:"
    $token = $Identity_Token
    $URI = "https://management.azure.com/subscriptions$resource/providers/Micrsoft.Authorization/permissions?api-version=2015-07-01"
    $RequestParams = @{
        Method = 'GET'
        Uri = $URI
        Headers = @{
        'Authorization' = "Bearer $token"
            }
        }
        (Invoke-RestMethod @RequestParams).value
}