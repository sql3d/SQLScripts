cls
## Copy and paste access key info here

## Update access key info above


$NewEndpoint = "rds-shared-live-sqlserver-0001.cfcjeohtmapi.us-west-2.rds.amazonaws.com"   ## !! Update Endpoint here !!

$HostedZoneId = "ZHC4A6DG9G5YK"   ## cafepress.io
$CNAMEArray = @('rds-cpcom-content-live.cafepress.io','rds-email-live.cafepress.io','rds-errorlog-live.cafepress.io','rds-partnerintegration-live.cafepress.io','rds-productmapping-live.cafepress.io','rds-simpleorder-live.cafepress.io','rds-transit-live.cafepress.io')

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