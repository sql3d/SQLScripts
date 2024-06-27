cls
#### Copy and paste access key info here
##$Env:AWS_ACCESS_KEY_ID="ASIAWYHSRTJWDMESFZNV"
##$Env:AWS_SECRET_ACCESS_KEY="CzGvojlfGQoE/SusKaEVqrnRfJO3HA+Ej/sRWzqN"
##$Env:AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEC4aCXVzLWVhc3QtMSJIMEYCIQDEIVHfTuB9VFCtASv1zPAZsnlKd5ortvtA6qHhq1b8jAIhAPsBP8Uu2Wn6M8vQa6hbvkYvcfLt290sdkkxExazo/d9KpQDCFcQABoMNDY0MzY1MTMyMzk2IgyqxlqitypW7cz/WdQq8QIuBdSdDFojpJXmxvDqZRDoKUo/ixy9B3BUEz75F/ouhlZvGOT7KbZ+CPO5+M84TTc9z75meMdfxkSiZ0cXfzB87bKrilfei8wHxKcSB1t5B6aSZSfX0WCHypB8vlO2UGjInd1izPem7atHwuuJPfvzA45ftZX26mwF10rVmmAor/i35nowPWvyStE990AgQocT2mYRXSymPnwrbUIeJFBO+eS9Mzo7u6AGPCE4U28DifN3MHoE2orUXpbNCTGnUDsMI8K/8GXbYYGNJLY4P/eZl9GcacfaWLTyM2hWIJxyDWPgXvDpCQsPPbubWFzb64aGbZfIT+DKrFYIkiw6vmgqRbeGG6ZWQa0sX1UnQMM5JVMY5BZn416S3XaVTygid6isAtk253IYbvlSBuhWdQkmzrxyIASduFANyOuquQmtUvZLGMsav9Ydh27WH3MsojxcsdfhxYTWi/vFDGlfaWILf8SWyYCAgzIHkGwUiqFCnMMwzPeWowY6pQEOglkZtGRJy0dT2dKJWrIWylnpNsdLQqFHattD0tprPARDFPWoOm4ghBQ/67mXhipYiZcYK44rIW5Lv6h+mWzmVSDMPbwgRa0ZecMZwejNjOUa7KuTrcZOfZQO6IOk9wRSYDfPtKoLtjlI0OCQGCg0KS/A3lZzIy8ANh0U/mJ/yazkPqSOcBxZCTm0+ulQbMqfLXJWeFkmZd0Xx6T6Qnw426WeQSc="
#### Update access key info above



$HostedZoneId = "ZHC4A6DG9G5YK"   ## cafepress.io
$CNAMEArray = @('db-ecomm-fe01.prod.pquadnt.com','db-ecomm-fe02.prod.pquadnt.com','db-ecomm-fe03.prod.pquadnt.com','db-ecomm-hs01.prod.pquadnt.com','db-ecomm-be01.prod.pquadnt.com','db-ecomm-be01-logging.prod.pquadnt.com','db-ecomm-rpt.prod.pquadnt.com','db-ecomm-rpt-user.prod.pquadnt.com')



foreach ($CName in $CNAMEArray){

    $NewEndpoint = Switch($CName){
        'db-ecomm-fe01.prod.pquadnt.com' {'ecommfe1-ls.ad.pquadnt.com'}
        'db-ecomm-fe02.prod.pquadnt.com' {'ecommfe2-ls.ad.pquadnt.com'}
        'db-ecomm-fe03.prod.pquadnt.com' {'ecommfe3-ls.ad.pquadnt.com'}
        'db-ecomm-hs01.prod.pquadnt.com' {'ecommhs1-ls.ad.pquadnt.com'}
        'db-ecomm-be01.prod.pquadnt.com' {'ecommbe1-ls.ad.pquadnt.com'}
        'db-ecomm-be01-logging.prod.pquadnt.com' {'ecommbeLog-ls.ad.pquadnt.com'}
        'db-ecomm-rpt.prod.pquadnt.com' {'ecommrptprod-ls.ad.pquadnt.com'}
        'db-ecomm-rpt-user.prod.pquadnt.com' {'ecommrptuser-ls.ad.pquadnt.com'}
    }
    $CName
    $NewEndpoint
    ##$change1 = New-Object Amazon.Route53.Model.Change
    ##$change1.Action = "UPSERT"
    ##$change1.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
    ##$change1.ResourceRecordSet.Type = "CNAME"
    ##$change1.ResourceRecordSet.TTL = 300
    ##$change1.ResourceRecordSet.Name = "$CName"    
    ##$change1.ResourceRecordSet.ResourceRecords.Add(@{Value="$NewEndpoint"})
    ##
    ##$params = @{
    ##    HostedZoneId="$HostedZoneId"
	##    ChangeBatch_Change=$change1
    ##}
    ##
    ## Edit-R53ResourceRecordSet @params
    ## $change1.ResourceRecordSet.Name
}