if (!(test-path T:\DBUSERS)) { mkdir T:\DBUSERS }

$users=get-dbadbuser -SqlInstance devsqlclean01 -database $DB | ? {$_.Name -like "*\p_*" -or $_.Name -like "*\h_*"} | select -expandproperty Name
foreach ($user in $users) {
    $userarray=$user -split '\\'
    $username=$userarray[1]
    Export-DbaUser -SqlInstance devsqlclean01 -database $DB -User $user -FilePath T:\DBUSERS\$DB-$username.sql

    if ($username -eq "p_notification$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_notification","\d_notifications"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "p_efsruleeng$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_efsruleeng","\d_efsruleengine"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "h_paymentapi$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\h_paymentapi","\d_hspaymentapi"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "p_paymentsvc$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_paymentsvc","\d_payment"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "p_loggingsvc$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_loggingsvc","\d_loggingservic"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "h_orderad$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\h_orderad","\d_orderadmin"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "p_contentpost$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_contentpost","\d_contentpostmg"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "p_generalsvc$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_generalsvc","\d_general"} | sc T:\DBUSERS\$DB-$username.sql
    } elseif ($username -eq "p_monitorsvc$") {
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_monitorsvc","\d_monitor"} | sc T:\DBUSERS\$DB-$username.sql
    }else{
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\p_","\d_"} | sc T:\DBUSERS\$DB-$username.sql
        (cat T:\DBUSERS\$DB-$username.sql) | % {$_ -replace "\\h_","\d_"} | sc T:\DBUSERS\$DB-$username.sql
    }
    invoke-sqlcmd -ServerInstance devsqlclean01 -inputfile T:\DBUSERS\$DB-$username.sql
    $dbuseradd=get-ssmparameter /sqlclean/dbuser-add |select -expandproperty Value
    invoke-sqlcmd -ServerInstance devsqlclean01 $ExecutionContext.InvokeCommand.ExpandString($dbuseradd)
}

$PFusers=get-dbadbuser -SqlInstance dev1sqlop01.ad.pquadnt.com -database $DB | ? {$_.Name -like "PROFLOWERS\svc_prod*"} | select -expandproperty Name
foreach ($PFuser in $PFusers) {
    $PFuserarray=$PFuser -split '\\'
    $PFusername=$PFuserarray[1]
    
    Export-DbaUser -SqlInstance dev1sqlop01.ad.pquadnt.com -database $DB -User $PFuser -FilePath T:\DBUSERS\$DB-$PFusername.sql

    (cat T:\DBUSERS\$DB-$PFusername.sql) | % {$_ -replace "\\svc_prod","\svc_dev"} | sc T:\DBUSERS\$DB-$PFusername.sql

    invoke-sqlcmd -ServerInstance devsqlclean01 -inputfile T:\DBUSERS\$DB-$PFusername.sql
    $PFdbuseradd=get-ssmparameter /sqlclean/dbuser-add |select -expandproperty Value
    invoke-sqlcmd -ServerInstance devsqlclean01 $ExecutionContext.InvokeCommand.ExpandString($PFdbuseradd)
}