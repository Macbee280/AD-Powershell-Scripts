Import-Module ActiveDirectory
$Attribcsv=Import-csv “c:\scripts\users_edits.csv”
ForEach ($User in $Attribcsv)
{
Get-ADUser -Identity $User.samAccountName | set-ADUser -Office $($User.office), -OtherAttributes @(pager=$User.pager)
}