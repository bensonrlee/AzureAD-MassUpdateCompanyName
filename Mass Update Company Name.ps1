# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

function Update-CompanyName {
    param (
        [Parameter(Mandatory=$true)]
        [string]$UserPrincipalName,

        [Parameter(Mandatory=$true)]
        [string]$CompanyName
    )

    # Retrieve the user
    $user = Get-AzureADUser -ObjectId $UserPrincipalName

    if ($user) {
        # Update the CompanyName attribute
        Set-AzureADUser -ObjectId $user.ObjectId -CompanyName $CompanyName
        Write-Host "Updated $UserPrincipalName with CompanyName: $CompanyName" -ForegroundColor Green
    } else {
        Write-Host "User $UserPrincipalName not found." -ForegroundColor Red
    }
}

# Prompt for CompanyName once
$companyName = Read-Host "Enter CompanyName to be set for users"

# Build a list of UserPrincipalNames
$userList = @()

do {
    $userUPN = Read-Host "Enter UserPrincipalName (or 'exit' to finish)"
    
    if (-not [string]::IsNullOrWhiteSpace($userUPN) -and $userUPN -ne 'exit') {
        $userList += $userUPN
    }

} while ($userUPN -ne 'exit')

# Confirm before making changes
$confirmation = Read-Host "About to update CompanyName for $($userList.Count) users. Continue? (yes/no)"
if ($confirmation -eq 'yes') {
    foreach ($user in $userList) {
        Update-CompanyName -UserPrincipalName $user -CompanyName $companyName
    }
} else {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
}

# Disconnect from Azure AD
Disconnect-AzureAD
