cls
## Copy and paste access key info here
$Env:AWS_ACCESS_KEY_ID="ASIAWYHSRTJWDMESFZNV"
$Env:AWS_SECRET_ACCESS_KEY="CzGvojlfGQoE/SusKaEVqrnRfJO3HA+Ej/sRWzqN"
$Env:AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEC4aCXVzLWVhc3QtMSJIMEYCIQDEIVHfTuB9VFCtASv1zPAZsnlKd5ortvtA6qHhq1b8jAIhAPsBP8Uu2Wn6M8vQa6hbvkYvcfLt290sdkkxExazo/d9KpQDCFcQABoMNDY0MzY1MTMyMzk2IgyqxlqitypW7cz/WdQq8QIuBdSdDFojpJXmxvDqZRDoKUo/ixy9B3BUEz75F/ouhlZvGOT7KbZ+CPO5+M84TTc9z75meMdfxkSiZ0cXfzB87bKrilfei8wHxKcSB1t5B6aSZSfX0WCHypB8vlO2UGjInd1izPem7atHwuuJPfvzA45ftZX26mwF10rVmmAor/i35nowPWvyStE990AgQocT2mYRXSymPnwrbUIeJFBO+eS9Mzo7u6AGPCE4U28DifN3MHoE2orUXpbNCTGnUDsMI8K/8GXbYYGNJLY4P/eZl9GcacfaWLTyM2hWIJxyDWPgXvDpCQsPPbubWFzb64aGbZfIT+DKrFYIkiw6vmgqRbeGG6ZWQa0sX1UnQMM5JVMY5BZn416S3XaVTygid6isAtk253IYbvlSBuhWdQkmzrxyIASduFANyOuquQmtUvZLGMsav9Ydh27WH3MsojxcsdfhxYTWi/vFDGlfaWILf8SWyYCAgzIHkGwUiqFCnMMwzPeWowY6pQEOglkZtGRJy0dT2dKJWrIWylnpNsdLQqFHattD0tprPARDFPWoOm4ghBQ/67mXhipYiZcYK44rIW5Lv6h+mWzmVSDMPbwgRa0ZecMZwejNjOUa7KuTrcZOfZQO6IOk9wRSYDfPtKoLtjlI0OCQGCg0KS/A3lZzIy8ANh0U/mJ/yazkPqSOcBxZCTm0+ulQbMqfLXJWeFkmZd0Xx6T6Qnw426WeQSc="

## Update access key info above


$NewEndpoint = "rds-shared-live-sqlserver-0001.cfxtpvtqarp5.us-east-1.rds.amazonaws.com"   ## !! Update Endpoint here !!

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