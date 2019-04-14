 $ADGROUPS= @('Admin',
'Customer',
'Finance',
'Leadership',
'Marketing',
'Merchandising',
'Sales')
 $outarray =@()

ForEach ($ADGROUP in $ADGROUPS)
{

 $User_infos = Get-AdGroupMember -Identity $ADGROUP | where objectclass -eq 'user' | Get-ADUser -Properties * 
 foreach ($User_info in $User_infos)
 {
    $manager_info = $User_info|Select-Object -ExpandProperty manager
 
    # $manager_info

        #$pos1 = $manager_info.indexof('=')

        #$pos2 = $manager_info.indexof(',')

        #$pos1
        #$pos2
    try {
        $pos1 = $manager_info.indexof('=')

        $pos2 = $manager_info.indexof(',')
        $manager = get-aduser $manager_info.substring($pos1+1,$pos2-$pos1-1) 

        #$manager

        $manager_surname = $manager | select -ExpandProperty surname
        $manager_givenname = $manager | select -ExpandProperty givenname

        $manager_name = "$manager_surname, $manager_givenname" }

   catch {
   
   if ([string]::IsNullOrEmpty($manager_info))
   {$manager_name =$manager_info}
   else 
   {$manager_name = $manager_info.substring($pos1+1,$pos2-$pos1-1).trim("\")} 
   
   
   }
 
        #$manager_name  

        #fill object with value
        $myobj = "" | Select "ADGroup", "Name", "Email", "Title", "Department", "Office", "Manager", "ManagerString"
        $myobj.ADgroup = $ADGROUP
        $myobj.Name = $User_info.DisplayName  
        $myobj.Email = $User_info.mail
        $myobj.Title = $User_info.Title
        $myobj.Department = $User_info.Department
        $myobj.Office = $User_info.Office
        $myobj.Manager = $manager_name
        $myobj.ManagerString = $manager_info 
        
        
        # Add the object to the out-array
        $outarray += $myobj

        # Wipe the object just to be sure
        $myobj = $null

        
 }
 }

$OutArray|export-csv C:\TEMP\powershell\test.csv