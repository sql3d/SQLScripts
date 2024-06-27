

## MAIN ##
cls
##Variables for connections
$OLTPConnection = "fe4sql21"
$ArchiveConnection = "rpt3sql25"

$dsCustomers = Invoke-Sqlcmd -Query "SELECT pcpar.CustomerID, fc.email FROM Archive.dbo.PC_CustomerPurgeAudit_Repository AS pcpar INNER JOIN oltp.dbo.FL_Customer AS fc ON fc.customerID = pcpar.CustomerID WHERE pcpar.IsDeleted = 1 AND fc.email NOT LIKE '%_GDPR_XXX_OPTOUT%' AND NOT EXISTS (SELECT 1 FROM OLTP.dbo.PF_Orders AS po WHERE po.customerID = pcpar.customerID )" -ServerInstance "$ArchiveConnection" -As DataSet

 foreach ($dsCustomer in $dsCustomers.Tables[0].Rows){
    $CustomerId = $dsCustomer[0]
    $Email = $dsCustomer[1]

    Invoke-Sqlcmd -Query "EXEC OLTP.dbo.usp_AccMgmt_PurgeCustomer_GDPR_Data @Email = '$Email', @CustomerID = '$CustomerId', @RequestedBy = 'Archive PII Purge'" -Database 'OLTP' -ServerInstance "$OLTPConnection" 
 }