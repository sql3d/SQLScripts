IF EXISTS (SELECT * FROM msdb.sys.objects WHERE [name] = 'SQLskillsPaulsIndexCounts')
    DROP TABLE msdb.dbo.SQLskillsPaulsIndexCounts;
GO
CREATE TABLE msdb.dbo.SQLskillsPaulsIndexCounts (
    BaseType CHAR (10),
    IndexCount SMALLINT);
GO

EXEC sp_MSforeachdb 
    N'IF EXISTS (SELECT 1 FROM (SELECT DISTINCT [name] 
    FROM sys.databases WHERE [state_desc] = ''ONLINE''
        AND [database_id] > 4
        AND [name] != ''pubs''
        AND [name] != ''Northwind''
        AND [name] != ''distribution''
        AND [name] NOT LIKE ''ReportServer%''
        AND [name] NOT LIKE ''Adventure%'') AS names WHERE [name] = ''?'')
BEGIN
USE [?]
INSERT INTO msdb.dbo.SQLskillsPaulsIndexCounts
SELECT ''Heap'', COUNT (*)-1
FROM sys.objects o
JOIN sys.indexes i
    ON o.[object_id] = i.[object_id]
WHERE o.[type_desc] IN (''USER_TABLE'', ''VIEW'')
    AND o.[is_ms_shipped] = 0
    AND EXISTS (
        SELECT *
        FROM sys.indexes
        WHERE [index_id] = 0
            AND [object_id] = o.[object_id])
GROUP BY i.[object_id];

INSERT INTO msdb.dbo.SQLskillsPaulsIndexCounts
SELECT ''Clustered'', COUNT (*)-1
FROM sys.objects o
JOIN sys.indexes i
    ON o.[object_id] = i.[object_id]
WHERE o.[type_desc] IN (''USER_TABLE'', ''VIEW'')
    AND o.[is_ms_shipped] = 0
    AND EXISTS (
        SELECT *
        FROM sys.indexes
        WHERE [index_id] = 1
            AND [object_id] = o.[object_id])
GROUP BY i.[object_id];
END';
GO

SELECT DISTINCT [BaseType], [IndexCount] AS [NCIndexes], COUNT (*) AS [TableCount]
FROM msdb.dbo.SQLskillsPaulsIndexCounts
GROUP BY [BaseType], [IndexCount]
ORDER BY [BaseType], [IndexCount];
GO

DROP TABLE msdb.dbo.SQLskillsPaulsIndexCounts;
GO