# Prerequisits:

# Export users from Windows AD (run in PowerShell on Windows AD DC)
# Specify the correct domain and organizational unit
# Note: some cleanup of the CSV might be needed if not all accounts need to be migrated
# Get-ADUser -Filter * -SearchBase "ou=Ou,dc=contoso,dc=com" -Properties * | Export-Csv  "c:\users.csv"

# Sign In to the Azure AD
# Important: the user needs to be a global administrator in the AAD, and belong to the AAD domain (or the custom domain that has been assigned)! 
# For instance johndoe@contoso.onmicrosoft.com and NOT johndoe@contoso.com

# Important: Set variables!
# Default password that will be assigned to all new users created in AAD
$defaultPassword = "changeme@123"

# Pass to the CSV with users exported from Windows AD
$usersCsvPath = ".\users.csv"


# Import the csv with users data exported from Windows AD
# Specify path to eported file
$users = Import-Csv $usersCsvPath

# Migrate

Write-Output "Adding all users from Windows AD to AAD B2C"
Write-Output "----------------------------------------------------------------`n`n"
# Iterate over all users
foreach($user in $users){   

	#Skip disabled accounts
	if($user.Enabled -eq "True") {
	
		# Check if user exists in B2C 
		$upn = $user.UserPrincipalName
		$exists = Get-AADUser -SignInNames $upn

		if(!$exists.ObjectId) { 
			Write-Output ([string]::Format("Adding user {0}, email {1}`n", $user.DisplayName, $upn))

			New-AADUser -accountEnabled $true -displayName $user.DisplayName -mailNickname $user.SamAccountName -userEmail $upn `
			-password $defaultPassword -forceChangePasswordNextLogin $true -givenName $user.GivenName -surname $user.Surname 
			
		
		} else { 
		
			Write-Output ([string]::Format("The user with email {0} already exists, skipping user creation`n", $upn))
		}
	}
}

# List all B2C users
Write-Output "`nListing all users in B2C"
Write-Output "----------------------------------------------------------------`n"
(Get-AADUser).SignInNames.value
Write-Output "----------------------------------------------------------------`n`n"


