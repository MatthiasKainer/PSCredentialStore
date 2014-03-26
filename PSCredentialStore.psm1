$credentialPath = [Environment]::GetFolderPath("Personal") + '\user.cred';
$credentialStore;

function In-CredentialStore($for) {
  return $script:credentialStore.ContainsKey($for);
}

function NotIn-CredentialStore($for) {
	return -not $script:credentialStore.ContainsKey($for);
}

function Get-CredentialStore($for) { 
	$cred = $script:credentialStore.Get_Item($for);
		
	[Security.SecureString]$password = ($cred.Password | ConvertTo-SecureString);
	return New-Object System.Management.Automation.PsCredential($cred.User, $password);
}

function Copy-Password($for) {
	$cred = $script:credentialStore.Get_Item($for);
	$cred.Password | clip;
}

function Add-CredentialsToStore($for) {
	if (In-CredentialStore($for))
	{
		Write-Host "CredentialStore already contains an entry for this store name";
		return;
	}
	
	$credentials = Get-CredentialItem;	
	$script:credentialStore.Add($for, $credentials);
	Save-CredentialStore;
}

function Set-CredentialsInStore($for) {
	if (NotIn-CredentialStore($for))
	{
		Write-Host "CredentialStore does not contain an entry for this store name";
		return;
	}
	
	$credentials = Get-CredentialItem;	
	$script:credentialStore[$for] = $credentials;
	Save-CredentialStore;
}

function Remove-CredentialsInStore($for) {
	if (NotIn-CredentialStore($for))
	{
		Write-Host "CredentialStore does not contain an entry for this store name";
		return;
	}
	
	$script:credentialStore.Remove($for);
	Save-CredentialStore;
}

function Get-CredentialItem {
	Write-Host "Insert UserName: ";
	$user = Read-Host;
	Write-Host "Insert Password: ";
	$password = Get-SecurePassword;
	
	return @{
		"User" = $user;
		"Password" = $password;
	};
}

function Load-CredentialStore() {
	return Import-Clixml -Path $credentialPath;
}

function Save-CredentialStore() {
	$script:credentialStore | Export-Clixml -Path $credentialPath;
}

function Get-SecurePassword() {
	$password = Read-Host -AsSecureString;
	return $password | convertfrom-securestring;
}

$credentialStoreExists =  Test-Path $credentialPath;
if (-not $credentialStoreExists) {
	@{} | Export-Clixml -Path $credentialPath;
}

$credentialStore = Load-CredentialStore;