USE CALReportServer
GO


SELECT DISTINCT 
    c1.Path AS ReportPath
   -- ds.NAME, 
    ,dsc.path AS SharedDataSource
FROM dbo.Catalog AS c1  
    INNER JOIN dbo.DataSource AS ds ON c1.ItemID = ds.ItemID
    INNER JOIN dbo.Catalog AS dsc ON ds.Link = dsc.ItemID
WHERE dsc.name LIKE '%dw_prod%'
    AND c1.Path NOT LIKE '/IT/Report Graveyard%'
ORDER BY c1.path
