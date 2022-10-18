# Split path
$Path = Split-Path -Parent "C:\Users\professorgabe\scripts\*.*"

# Create variable for the date stamp in log file
$LogDate = Get-Date -f yyyyMMddhhmm

# Define CSV and log file location variables
# They have to be on the same location as the script
$Csvfile = $Path + "\AllADUsers_$logDate.csv"

# Import Active Directory module
Import-Module ActiveDirectory

# Set distinguishedName as searchbase, you can use one OU or multiple OUs
#choose who from what OU you want to pull from
# Or use the root domain like DC=exoip,DC=local
$DNs = @(
    "OU=2026,OU=Students,DC=jfk,DC=local"

)

# Create empty array
$AllADUsers = @()

# Loop through every DN
foreach ($DN in $DNs) {
    $Users = Get-ADUser -SearchBase $DN -Filter * -Properties * 

    # Add users to array
    $AllADUsers += $Users
}

# Create list, add whatever field you want either email, ID number etc.
$AllADUsers | Sort-Object Name | Select-Object `
@{Label = "First name"; Expression = { $_.GivenName } },
@{Label = "Last name"; Expression = { $_.Surname } },
@{Label = "Display Name"; Expression = { $_.displayName } },
@{Label = "Description"; Expression = { $_.Description } },
@{Label = "Pager"; Expression = { $_.pager } },
@{Label = "E-mail"; Expression = { $_.Mail } }|

# Export report to CSV file
Export-Csv -Encoding UTF8 -Path $Csvfile -NoTypeInformation #-Delimiter ";"