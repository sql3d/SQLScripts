USE coxDSS
GO

--SELECT * 
--FROM sys.views AS v
--ORDER BY name

SELECT * 
FROM sys.tables AS t
ORDER BY name


select name, definition, SUBSTRING(definition, CHARINDEX('FROM', definition) + 4, LEN(definition))
    ,CHARINDEX('FROM ', definition)
    ,LEN(definition)
from sys.objects     o
    join sys.sql_modules m on m.object_id = o.object_id
where 1=1
   -- AND o.object_id = object_id( 'dbo.MyView')
  and o.type      = 'V'
    AND definition NOT LIKE '%UNION%'
    AND definition NOT LIKE '% JOIN%'
ORDER BY name

SELECT * 
FROM sys.sql_modules AS sm

SELECT OBJECT_SCHEMA_NAME(p.object_id) AS [Schema]
    , OBJECT_NAME(p.object_id) AS [Table]
    --, i.name AS [Index]
    , p.partition_number
    , p.rows AS [Row Count]
    --, i.type_desc AS [Index Type]
FROM sys.partitions p
    
WHERE OBJECT_SCHEMA_NAME(p.object_id) != 'sys'
ORDER BY [Schema], [Table]--, [Index]

SELECT * 
FROM sys.partitions AS p

SELECT --a.*
    a.tablename
    ,o.name AS ViewName
    ,a.TotalSpaceMB
    ,'PSTAGE'
FROM
(
SELECT
      t.NAME AS TableName
	  ,s.Name AS SchemaName
	  ,p.rows AS RowCounts
	  ,(SUM(a.total_pages) * 8) / 1024.0  AS TotalSpaceMB
	  --,SUM(a.used_pages) * 8 AS UsedSpaceKB
	 -- ,(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB	   
    
FROM	   sys.tables t
    INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID
	   AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
    LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id
    
WHERE   t.NAME NOT LIKE 'dt%'
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255
GROUP BY t.Name
	  ,s.Name
	  ,p.Rows
) a
    LEFT JOIN sys.sql_modules AS sm ON sm.definition LIKE '%' + a.TableName + '%' 	  
    INNER JOIN sys.objects AS o ON o.object_id = sm.object_id
	   AND o.type = 'V'
	   AND o.name LIKE LEFT(a.TableName,3) + '%'
ORDER BY o.Name



