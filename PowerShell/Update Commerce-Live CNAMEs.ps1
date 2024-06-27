cls




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