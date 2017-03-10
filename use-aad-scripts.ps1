# Clone the repository
git clone https://github.com/DivineOps/AADGraphPowerShell.git

# Allow the repository to run in powershell
Set-ExecutionPolicy RemoteSigned -Force

# Install the module
.\AADGraphPowerShell\Install-AADGraphModule.ps1

# List all the User commands in the module
Get-Help *-AADUser*

# Connect to the directory
# Sign in with a user that BELONGS TO THE DIRECTORY DOMAIN (admin@mydomain.onmicrosoft.com) , not any other type of microsoft/orgranizational account!!!
Connect-AAD 

$userEmail = "James.Bond@gmail.com"
$existingUserEmail = "comatsu@loo.com"
$newUserEmail = "007@mi6.uk"

#Check that the Get command works (replace with the admin username)
Get-AADUser -Id admin@mydomain.onmicrosoft.com
(Get-AADUser).SignInNames.value
Get-AADUser -SignInNames $existingUserEmail

#List possible inputs for New User command
Get-Help New-AADUser
#Create User
New-AADUser -accountEnabled $true -displayName "James Bond" -mailNickname "JamesBond" -userEmail $userEmail -password "SecretP@ssword!" -forceChangePasswordNextLogin $false -givenName "James" -surname "Bond"

#List possible parameters for Update User
Get-Help Set-AADUser
#Update User
$id = (Get-AADUser -SignInNames $userEmail).ObjectId
Set-AADUser -Id $id -displayName "Sean Connery" -userEmail $newUserEmail
Get-AADUser -SignInNames $newUserEmail

#Remove User
$id = (Get-AADUser -SignInNames $newUserEmail).ObjectId
Remove-AADUser -Id $id 


