Import-Module ActiveDirectory

# this defaults to csv fields delimited by a comma. If your CSV file uses a different 
# character, then add parameter '-Delimiter' followed by the actual character

$ADUsers = Import-Csv -Path C:\path\to\file\KennedyADUsers.csv

# the Where-Object clause is just a precaution to omit records that have no username value
$ADUsers | Where-Object { $_.username -match '\S'} | ForEach-Object {
    $Username = $_.username
    if (Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue) {
        Write-Warning "A user account with SamAccountName '$Username' already exist in Active Directory."
    }
    else {
        $Firstname  = $_.firstname
        $Lastname   = $_.lastname
        $Description= $_.Description
        $Department = $_.Department
        $Company    = $_.Company
        $Displayname= 
        $pager      = $_.pager


        # use splatting on cmdlets that use a lot of parameters
        $userParams = @{
            SamAccountName        = $Username
            UserPrincipalName     = "$Username@kennedyhs.org"
            Name                  = "$Firstname $Lastname"
            GivenName             = $Firstname
            Surname               = $Lastname
            Enabled               = $true
            DisplayName           = "$Firstname $Lastname"
            Path                  = $_.ou
            AccountPassword       = (ConvertTo-SecureString "PASSWORD" -AsPlainText -Force)
            ChangePasswordAtLogon = $false
            Company               = $Company
            Department            = $Department
            Description           = $Description
	    physicalDeliveryOfficeName = $pager
	    pager                 = $pager
		

        }
        # create the user and report back
        New-ADUser @userParams

        Write-Host "Created new user '$Username' with initial password: PASSWORD!"
    }
}

#script to add bulk user to multiple security group
#change OU dependent on year
Get-ADUser -SearchBase 'OU=2026,OU=Students,DC=jfk,DC=local' -Filter * | ForEach-Object {Add-ADGroupMember -Identity 'students2026' -Members $_ }
Get-ADUser -SearchBase 'OU=2026,OU=Students,DC=jfk,DC=local' -Filter * | ForEach-Object {Add-ADGroupMember -Identity 'O365 A5 Students' -Members $_ }
Get-ADUser -SearchBase 'OU=2026,OU=Students,DC=jfk,DC=local' -Filter * | ForEach-Object {Add-ADGroupMember -Identity 'ZoomBasic' -Members $_ }
Get-ADUser -SearchBase 'OU=2026,OU=Students,DC=jfk,DC=local' -Filter * | ForEach-Object {Add-ADGroupMember -Identity 'Students' -Members $_ }

#script to add bulk email
Import-Module ActiveDirectory

Get-ADUser -SearchBase 'OU=2026,OU=Students,DC=jfk,DC=local' -Filter * |
	Foreach-object { Set-ADuser -EmailAddress ($_.samaccountname + '@kennedyhs.org') -Identity $_ }

#script to add bulk proxyaddress
Import-Module ActiveDirectory

$proxy = "@kennedyhs.org"
$userou = 'OU=2026,OU=Students,DC=jfk,DC=local'
$Students = Get-ADUser -Filter '*' -SearchBase $userou -properties sAMAccountName, ProxyAddresses

Foreach ($user in $Students) {
	Set-ADUser -server 10.10.0.7 -Identity $user.samaccountname -Add @{Proxyaddresses="SMTP:"+$user.samaccountname+$proxy}
}
