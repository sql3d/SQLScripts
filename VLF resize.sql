declare @ExecuteFix Bit
set @ExecuteFix = 0
-- Set up temp tables. 
IF OBJECT_ID('tempdb..#stage') IS NOT NULL
    DROP TABLE #stage
    
CREATE TABLE #stage
(
    FileID          INT
  , FileSizeBytes   BIGINT
  , StartOffset     BIGINT
  , FSeqNo          BIGINT
  , [Status]        BIGINT
  , Parity          BIGINT
  , CreateLSN       NUMERIC(38)
)
 
IF OBJECT_ID('tempdb..#results') IS NOT NULL
    DROP TABLE #results

CREATE TABLE #results
(
    DatabaseName    sysname
  , LogFileName     sysname
  , VlfCount        INT
  , LogFileSizeMB   INT 
)
 
-- Gather the log file information into the temp tables. 
DECLARE @Sql NVARCHAR(4000)

SET @Sql = 'USE ? '
         + ''
         + 'INSERT INTO #stage '
         + '  EXEC sp_executesql N''DBCC LOGINFO (?)'' '
         + ''
         + 'INSERT INTO #results '
         + '    SELECT DB_NAME(), MIN(FILE_NAME(FileID)), COUNT(*), SUM(FileSizeBytes) / 1024 / 1024 '
         + '      FROM #stage '
         + ' '
         + 'TRUNCATE TABLE #stage '
         
EXEC sp_msforeachdb @Sql

-- Log the results. 
DECLARE @DatabaseName   sysname
DECLARE @LogFileName    sysname
DECLARE @VlfCount       INT 
DECLARE @LogFileSizeMB  INT

DECLARE cur CURSOR LOCAL FOR
    SELECT DatabaseName 
         , VlfCount
         , LogFileSizeMB
      FROM #results
  ORDER BY VlfCount DESC

OPEN cur
FETCH NEXT FROM cur INTO @DatabaseName, @VlfCount, @LogFileSizeMB

WHILE @@FETCH_STATUS = 0
BEGIN
    RAISERROR('Database: %25s  -  Virtual Log Files: %4d  -  Size: %5d MB', 10, 1, @DatabaseName, @VlfCount, @LogFileSizeMB) WITH NOWAIT, LOG
    FETCH NEXT FROM cur INTO @DatabaseName, @VlfCount, @LogFileSizeMB
END
      
CLOSE cur
DEALLOCATE cur

-- Display the results. 
RAISERROR(' ', 10, 1) WITH NOWAIT

SELECT *
  FROM #results
 ORDER BY VlfCount DESC

-- Fix the log files with too many VLFs.  We add two MB to the size because 
-- ALTER DATABASE requires that we make the log larger.  Adding one doesn't 
-- work, because of rounding issues when dividing, I think. 
DECLARE cur CURSOR LOCAL FOR
    SELECT DatabaseName 
         , LogFileName
         , VlfCount
         , LogFileSizeMB
      FROM #results
     WHERE VlfCount > 50
  ORDER BY VlfCount DESC

OPEN cur
FETCH NEXT FROM cur INTO @DatabaseName, @LogFileName, @VlfCount, @LogFileSizeMB

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Sql = 'USE ' + @DatabaseName                                          + CHAR(10)
             + ' '                                                             + CHAR(10)
             + 'CHECKPOINT '                                                   + CHAR(10)
             + ' '                                                             + CHAR(10)
             + 'DBCC SHRINKFILE (' + @LogFileName + ', 0, TRUNCATEONLY) '      + CHAR(10)
             + ' '                                                             + CHAR(10)
             + 'ALTER DATABASE ' + @DatabaseName                               + CHAR(10)
             + '   MODIFY FILE '                                               + CHAR(10)
             + '( '                                                            + CHAR(10)
             + '      NAME = ' + @LogFileName                                  + CHAR(10)
             + '    , SIZE = ' + CAST(@LogFileSizeMB + 2 AS NVARCHAR) + ' MB ' + CHAR(10)
             + ') '                                                            + CHAR(10)

    IF @ExecuteFix = 0
    BEGIN
        RAISERROR('-- Proposed T-SQL code for database %20s: Log File: %10s', 10, 1, @DatabaseName, @LogFilename) WITH NOWAIT, LOG
        RAISERROR('%s', 10, 1, @Sql) WITH NOWAIT, LOG
    END
    ELSE
    BEGIN
        RAISERROR('Processing database %20s: Log File: %10s', 10, 1, @DatabaseName, @LogFilename) WITH NOWAIT, LOG
        PRINT @sql
        --EXEC sp_executesql @Sql
    END
    
    FETCH NEXT FROM cur INTO @DatabaseName, @LogFileName, @VlfCount, @LogFileSizeMB
END
      
CLOSE cur
DEALLOCATE cur

-- Done. 
IF OBJECT_ID('tempdb..#stage') IS NOT NULL
    DROP TABLE #stage

IF OBJECT_ID('tempdb..#results') IS NOT NULL
    DROP TABLE #results


/* Testbed. 

EXEC [dbo].[dba_FixExcessiveLogFileVlfs] @ExecuteFix = 0 

*/

GO


select *
from #results