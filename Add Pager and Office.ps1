Import-Module ActiveDirectory
$names = Import-Csv C:\Users\professorgabe\scripts\pager.csv

ForEach ($Name in $Names)
{
   $FirstFilter  = $Name.givenName
    $SecondFilter = $Name.sn
    $pager=$name.Pager
    $found= Get-ADUser -Filter "GivenName -eq '$FirstFilter' -and Surname -eq '$SecondFilter'" 
    $userParams =@{
        office        = $pager
        pager         = $pager


    }

    if($found){

    #Script requires a hash so change values of "pager" and "physicalDeliveryOfficeName" for the AD attribute
    $found|Set-ADUser -Replace @{physicalDeliveryOfficeName = $pager} -Verbose
      }
      

      else
    {
    New-Object PSObject -Property @{
            GivenName      = $FirstFilter
            Surname        = $SecondFilter
            Status         = 'MISSING ACCOUNT'
            }
    
      }
      }