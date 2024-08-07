﻿cls
## Copy and paste access key info here

## Update access key info above


$NewEndpoint = ""   ## !! Update Endpoint here !!

$HostedZoneId = ""   ## cafepress.io
$CNAMEArray = @('')

foreach ($CName in $CNAMEArray){

    $change1 = New-Object Amazon.Route53.Model.Change
    $change1.Action = "UPSERT"
    $change1.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
    $change1.ResourceRecordSet.Type = "CNAME"
    $change1.ResourceRecordSet.TTL = 300
    $change1.ResourceRecordSet.Name = "$CName"    
    $change1.ResourceRecordSet.ResourceRecords.Add(@{Value="$NewEndpoint"})

    $params = @{
        HostedZoneId="$HostedZoneId"
	    ChangeBatch_Change=$change1
    }

     Edit-R53ResourceRecordSet @params
     $change1.ResourceRecordSet.Name
}
