# Prompt for user details
$firstName = Read-Host "Enter user's first name"
$lastName = Read-Host "Enter user's last name"
$department = Read-Host "Enter user's department"
$jobTitle = Read-Host "Enter user's job title"

# Generate username based on first name and last name
$username = ($firstName.Substring(0, 1) + $lastName).ToLower()

# Generate temporary password
$tempPassword = "TempPass123"

# Create user account in the Users OU
$ouPath = "OU=Users,DC=domain,DC=com"
$userParams = @{
    SamAccountName = $username
    UserPrincipalName = "$username@domain.com"
    GivenName = $firstName
    Surname = $lastName
    Enabled = $true
    AccountPassword = (ConvertTo-SecureString -AsPlainText $tempPassword -Force)
    PassThru = $true
    Department = $department
    Title = $jobTitle
    Path = $ouPath
}
$newUser = New-ADUser @userParams

# Set group memberships based on user's role
$groupMemberships = "Sales Team", "Marketing Team"
foreach ($group in $groupMemberships) {
    Add-ADGroupMember -Identity $group -Members $newUser
}

# Display the created user account details
Write-Host "User account created:"
Write-Host "Username: $username"
Write-Host "Name: $($newUser.Name)"
Write-Host "UserPrincipalName: $($newUser.UserPrincipalName)"
Write-Host "Department: $($newUser.Department)"
Write-Host "Title: $($newUser.Title)"