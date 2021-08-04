#README.md

## Project Info
PowerShell scripts that will be developed into an entire module named "Azur3Alph4". Currently in development. Modules are being worked on and updated.

#### EnumEndpoint.ps1
Enumerates an Azure endpoint to verify whether or not it belongs to a managed identity.

#### GetManagedIdentityToken.ps1
Grabs the Managed Identity Token from the endpoint using the extracted secret. Stores the value in a given variable.

### Connect-AzAccount.ps1
Takes a username and password variable and automates SecureString conversion and connects to an Azure account.

### GetSubscriptionId.ps1
Gets the subscription ID using the REST API for Azure.

### GetManagedIdentityResources.ps1
Uses the subscription ID to enumerate all resources that are accessible.


