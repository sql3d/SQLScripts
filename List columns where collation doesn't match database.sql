IF OBJECT_ID('tempdb..#res') IS NOT NULL DROP TABLE #res
GO

DECLARE
@db sysname
,@sql nvarchar(2000)

CREATE TABLE #res(server_name sysname, db_name sysname, db_collation sysname, table_name sysname, column_name sysname, column_collation sysname)

DECLARE c CURSOR FOR 
SELECT name FROM sys.databases WHERE NAME NOT IN('master', 'model', 'tempdb', 'msdb') AND state_desc = 'ONLINE'

OPEN c
WHILE 1 = 1
BEGIN
FETCH NEXT FROM c INTO @db
IF @@FETCH_STATUS <> 0
     BREAK
SET @sql = 
    'SELECT
   @@SERVERNAME AS server_name
  ,''' + @db + ''' AS db_name
  ,CAST(DATABASEPROPERTYEX(''' + @db + ''', ''Collation'') AS sysname) AS db_collation
  ,OBJECT_NAME(c.object_id, ' + CAST(DB_ID(@db) AS sysname) + ') AS table_name
  ,c.name AS column_name
  ,c.collation_name AS column_collation 
FROM ' + QUOTENAME(@db) + '.sys.columns AS c
  INNER JOIN ' + QUOTENAME(@db) + '.sys.tables AS t ON t.object_id = c.object_id
WHERE t.type = ''U''
  AND c.collation_name IS NOT NULL
  AND c.collation_name <> CAST(DATABASEPROPERTYEX(''' + @db + ''', ''Collation'') AS sysname)
'
--PRINT @sql
INSERT INTO #res
EXEC(@sql)
END
CLOSE c
DEALLOCATE c
SELECT * FROM #res
Published Wednesday, May 2