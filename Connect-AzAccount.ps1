#needs to be tested
#Takes a username and password and connects to an Azure Account and checks for available resources
param (
    [Parameter(Mandatory=$true)][string]$password,
    [Parameter(Mandatory=$true)][string]$username
)

$passwd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential($username,$passwd)
Connect-AzureAD -Credential $creds