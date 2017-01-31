USE ReportServer
go


-- List connection strings of all SSRS Shared Datasources 
;WITH XMLNAMESPACES  -- XML namespace def must be the first in with clause. 
    (DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2006/03/reportdatasource' 
            ,'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' 
     AS rd) 
,SDS AS 
    (SELECT SDS.ItemID
		 ,SDS.name AS SharedDsName 
           ,SDS.[Path] 
           ,CONVERT(xml, CONVERT(varbinary(max), content)) AS DEF 
     FROM dbo.[Catalog] AS SDS 
     WHERE SDS.Type = 5)     -- 5 = Shared Datasource 
 
SELECT CON.SharedDsName AS [Datasource Name]
	 ,c.Name AS [Dependent Item]
	 ,c.Path AS [Dependent Item Path]
	 --,CON.ItemID
	 ,CON.[Path] 
     --,CON.SharedDsName 
      ,CON.ConnString AS [Connection String]
FROM 
    (SELECT SDS.ItemID
		 ,SDS.[Path] 
           ,SDS.SharedDsName 
           ,DSN.value('ConnectString[1]', 'varchar(150)') AS ConnString 
     FROM SDS 
          CROSS APPLY  
          SDS.DEF.nodes('/DataSourceDefinition') AS R(DSN) 
     ) AS CON 
    INNER JOIN dbo.DataSource AS ds ON CON.ItemID = ds.Link
    INNER JOIN dbo.Catalog AS c ON ds.ItemID = c.ItemID
-- Optional filter: 
 --WHERE CON.ConnString LIKE '%PSTAGE%' 
ORDER BY c.Path, CON.SharedDsName

;WITH XMLNAMESPACES  -- XML namespace def must be the first in with clause. 
    (DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2006/03/reportdatasource' 
            ,'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' 
     AS rd) 
,SDS AS 
    (SELECT SDS.ItemID
		 ,SDS.name AS SharedDsName 
           ,SDS.[Path] 
           ,CONVERT(xml, CONVERT(varbinary(max), content)) AS DEF 
     FROM dbo.[Catalog] AS SDS 
     WHERE SDS.Type = 5)     -- 5 = Shared Datasource 
SELECT * 
FROM sds
WHERE path LIKE '%dsan%'