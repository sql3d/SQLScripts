cls


$DBConnection = "dev2sqlop01.ad.pquadnt.com"

$dsCNAMES = Invoke-Sqlcmd -Query "SELECT [Dev3 Server] AS DevServer, [Dev3 CName] AS DevCName FROM DAN_TEST.dbo.PC_CNames WHERE [Dev3 Server] <> ''" -ServerInstance $DBConnection 

foreach ($rowCName in $dsCNAMES){
    $ServerName = $rowCName.DevServer
    $CName = $rowCName.DevCName


    $change1 = New-Object Amazon.Route53.Model.Change
    $change1.Action = "CREATE"
    $change1.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
    $change1.ResourceRecordSet.Type = "CNAME"
    $change1.ResourceRecordSet.TTL = 300
    $change1.ResourceRecordSet.Name = "$CName"    
    $change1.ResourceRecordSet.ResourceRecords.Add(@{Value="$ServerName"})
    
    $params = @{
        HostedZoneId=""
	    ChangeBatch_Change=$change1
    }

    Edit-R53ResourceRecordSet @params
}
