PSCredential-Tools
==================

Powershell Tool for Credential Storage

## what's that?

It's a simple credential store for powershell, that helps you organize your logins for different contextes. 

The credentialstore has multiple items, each of which can hold a pair of Username/Password information, and the credentials can be retrieved as NetworkCredential Object. 

The credentials are stored in the "user.cred" file in the personal directory ([[Environment]::GetFolderPath("Personal")]). Passwords are encrypted by windows.

## Getting started

After pulling it, register the file in your UserProfile to have the credential store available in your console

    . YOURPATH\CredentialStore-Tools.ps1

## Usage

### Adding new credentials to the store

    > Add-CredentialsToStore("my-credentials")
    Insert UserName: 
    my user
    Insert Password: 
    ******
    
### Updating credentials

    > Set-CredentialsInStore("my-credentials")
    Insert UserName: 
    other user
    Insert Password: 
    ******

### Usage in your functions
You should always check that the credentialstore is available. 

    if (Get-Command In-CredentialStore -errorAction SilentlyContinue) {
      if (In-CredentialStore($for)) { return Get-CredentialStore($for); }
    }
    
