USE ReportServer
GO

 
SELECT
    Path,
    Name
FROM Catalog
WHERE PolicyRoot = 1 
AND name <> 'My Reports'