##
## This script will process GDPR Delete requests by finding the CustomerId and FL_CustomerID as well as any orders by an Email address
## Developed: 2022-04-18
##


## $EmailToPurgeArray can be a comma delimited list (i.e. "dan@planetart.com","igor@planetart.com")
$EmailsToPurgeArray = "bribaysara@yahoo.com"



## MAIN ##
cls
##Variables for connections
$OLTPConnection = "FE4SQL21.proflowers.com"
$PaymentVaultConnection = "FE4SQL23.proflowers.com"


## Loop through each Email in the array 
foreach ($Email in $EmailsToPurgeArray) {
    Write-Output "Processing $Email"
    ## Get FL_CustomerID
    $dsCustomers = Invoke-Sqlcmd -Query "SELECT fc.FL_CustomerID, CustomerID FROM OLTP.dbo.FL_Customer AS fc WHERE fc.email = '$Email'" -ServerInstance "$OLTPConnection" -As DataSet

    $dsCustomers.Count
    ## check to see if any customers where found, and if so proceed with purge
    if ($dsCustomers.Count -gt 0) {
        $FL_CustomerID = $dsCustomers.Tables[0].Rows | %{ echo "$($_['FL_CustomerID'])" }
        $CustomerId = $dsCustomers.Tables[0].Rows | %{ echo "$($_['CustomerID'])" }

        ## Get list of OrderIDs
        $dsOrders = Invoke-Sqlcmd -Query "SELECT po.orderID FROM OLTP.dbo.PF_Orders AS po WHERE po.email = '$Email'" -ServerInstance "$OLTPConnection" -As DataSet

        ## Loop through OrderIDs (if they exist) and execute usp_iu_OrderCreditCard procs in Payment Vault
        if ($dsOrders.Count -gt 0) {
            $dsOrders.Tables[0] | foreach {
                $orderID = $_.orderId

                Invoke-Sqlcmd -Query "EXEC  PaymentVault.dbo.usp_iu_OrderCreditCard  @OrderID = N'$orderID', @CardHolderName = N'GDPR_PURGE',@CreditCardNumber = N'PURGE_GDPR', 
                                    @CreditCardLastFour = N'GDPR', @CreditCardExpiration = N'12/12',@CreditCardType = NULL,@UserName = N'arief', 
                                    @FL_CustomerID = NULL, @SaveCard = 0,		@PF_OrdersID = NULL, @CryptoDescriptorName = NULL,	@CalyxCustomerID = NULL, @EnableCustomerFeed = 0;" `
                    -Database 'PaymentVault' -ServerInstance "$PaymentVaultConnection"
            }
        }

        ## Exec usp_del_CustomerByFL_CustomerID proc in PaymentVault 
        Invoke-Sqlcmd -Query "EXEC PaymentVault.dbo.usp_del_CustomerByFL_CustomerID @FL_CustomerID = '$FL_CustomerID'" -Database 'PaymentVault' -ServerInstance "$PaymentVaultConnection"      
    
        ## Exec usp_AccMgmt_PurgeCustomer_GDPR_Data proc in OLTP
        Invoke-Sqlcmd -Query "EXEC OLTP.dbo.usp_AccMgmt_PurgeCustomer_GDPR_Data @Email = '$Email', @CustomerID = '$CustomerId'" -Database 'OLTP' -ServerInstance "$OLTPConnection"      
    }
    else {
        Write-Output "   Could not find CustomerId for $Email"
    }
}