# **Azur3Alph4**

![alt text](https://github.com/hyd3sec/Azur3Alph4/blob/main/resources/azur3alph4.png?raw=true)

## **About**

Azur3Alph4 is a PowerShell module that automates red-team tasks for ops on objective. This module situates in a post-breach (RCE achieved) position. Token extraction and many other tools will not execute successfully without starting in this position.
This module should be used for further enumeration and movement in a compromised app that is part of a managed identity.  
Azur3Alph4 is currently in development. Modules are being worked on and updated. Most of this is still untested.

Scripts are in repo for individual use and easy identification, but the .psm1 file is what will be consistently updated.

## **Installation**
`Import-Module Azur3Alph4`

## **Updates - 8/5/2021**

- Made Azur3Alph4 modular
- Added Get-SubscriptionId function


## **Why This Was Built**

- I built this because I wanted to learn more about both PowerShell and Azure, two things I'd definitely like to get better at.
- To help automate and eliminate a lot of repetitive PS commands.
- To build off my current knowledge of Azure red teaming


## **Function List**

#### **Get-Endpoint**

Enumerates an Azure endpoint to verify whether or not it belongs to a managed identity.

#### **Get-ManagedIdentityToken**

Grabs the Managed Identity Token from the endpoint using the extracted secret. Stores the value in a given variable.

#### **Connect-AzAccount**

Takes a username and password variable and automates SecureString conversion and connects to an Azure account.

#### **Get-SubscriptionId**

Gets the subscription ID using the REST API for Azure.

#### **Get-ManagedIdentityResources**

Uses the subscription ID to enumerate all resources that are accessible.

## **Credits**

- Big shout out to @nikhil_mitt for the CARTP course that got me started in Azure.


