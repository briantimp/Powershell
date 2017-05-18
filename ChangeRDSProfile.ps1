 $ObjFilter = “(&(objectCategory=person)(objectCategory=User))”
$objSearch = New-Object System.DirectoryServices.DirectorySearcher
 $objSearch.PageSize = 15000
 $objSearch.Filter = $ObjFilter
 $objSearch.SearchRoot = “LDAP://{OU PATH HERE OU=Users,DC=acme,DC=local}”
$objSearch.SearchScope = “OneLevel”
$AllObj = $objSearch.FindAll()
 foreach ($Obj in $AllObj)
 {
 $objItemS = $Obj.Properties
 $UserDN = $objItemS.distinguishedname
 $userSAM = $objItems.samaccountname
 $user = [ADSI] “LDAP://$userDN”
$user.psbase.invokeSet(“TerminalServicesProfilePath”,"")
