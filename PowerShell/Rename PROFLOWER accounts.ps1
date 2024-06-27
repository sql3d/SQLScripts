


cls
$DB = "Archive"
$Path = "C:\Temp\Users"

$users=get-dbadbuser -SqlInstance dev1sqlop01.ad.pquadnt.com -database $DB | ? {$_.Name -like "PROFLOWERS\svc_prod*"} | select -expandproperty Name


foreach ($user in $users) {
    $userarray=$user -split '\\'
    $username=$userarray[1]
    $user
   ## Write-Output $username
   Export-DbaUser -SqlInstance dev1sqlop01.ad.pquadnt.com -database $DB -User $user -FilePath $Path\$DB-$username.sql

    (cat $Path\$DB-$username.sql) | % {$_ -replace "\\svc_prod","\svc_dev"} | sc $Path\$DB-$username.sql
}


$PFusers=get-dbadbuser -SqlInstance dev1sqlop01.ad.pquadnt.com -database $DB | ? {$_.Name -like "PROFLOWERS\svc_prod*"} | select -expandproperty Name
foreach ($PFuser in $PFusers) {
    $PFuserarray=$PFuser -split '\\'
    $PFusername=$PFuserarray[1]
    
    Export-DbaUser -SqlInstance dev1sqlop01.ad.pquadnt.com -database $DB -User $PFuser -FilePath T:\DBUSERS\$DB-$PFusername.sql

    (cat T:\DBUSERS\$DB-$PFusername.sql) | % {$_ -replace "\\svc_prod","\svc_dev"} | sc T:\DBUSERS\$DB-$PFusername.sql
    invoke-sqlcmd -ServerInstance devsqlclean01 -inputfile T:\DBUSERS\$DB-$username.sql
    $dbuseradd=get-ssmparameter /sqlclean/dbuser-add |select -expandproperty Value
    invoke-sqlcmd -ServerInstance devsqlclean01 $ExecutionContext.InvokeCommand.ExpandString($dbuseradd)
}