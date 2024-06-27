cls
## Copy and paste access key info here
$Env:AWS_ACCESS_KEY_ID=
$Env:AWS_SECRET_ACCESS_KEY=
$Env:AWS_SESSION_TOKEN=
## Update access key info above


$NewEndpoint = "rds-foun-commerce-live.cfcjeohtmapi.us-west-2.rds.amazonaws.com"
$HostedZoneId = "ZHC4A6DG9G5YK"   ## cafepress.io
$CNAMEArray = @('rds-commerce-live.cafepress.io','rds-searchtag-live.cafepress.io')

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