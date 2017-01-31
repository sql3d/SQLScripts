
USE CALReportServer
go


SELECT  c.Name AS Subscription_Name
       ,c.[Path] AS Subscription_Path
       ,s.LastStatus AS Subscription_Status
       ,s.LastRunTime AS Subscription_DT
       ,u.UserName
FROM    dbo.Subscriptions s
    INNER JOIN dbo.[Catalog] c ON s.Report_OID = c.ItemID
    INNER JOIN dbo.Users u ON s.OwnerID = u.UserID
WHERE   s.LastStatus LIKE '%Fail%'
    AND s.LastRunTime >= DATEADD(DAY, -1, SYSDATETIME());


print DATEADD(dd,0, DATEDIFF(dd,0, GETDATE()-1)) 
print DATEADD(dd,0, DATEDIFF(dd,0, GETDATE())) 