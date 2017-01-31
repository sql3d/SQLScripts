CREATE PROCEDURE dbo.UpdateStatistics
  (

    @timeLimit smallint = 60
    ,@debug bit = 0
    ,@executeSQL bit = 1
    ,@samplePercent tinyint = 25
    ,@printSQL bit = 1
    ,@minDays tinyint = 30
  )
AS
/*****************************************************************
*
* Copyright Bill Graziano 2010
*
******************************************************************/

SET NOCOUNT ON;

PRINT '[ ' + CAST(GETDATE() AS VARCHAR(100)) + ' ] ' + 'Launching...'


IF OBJECT_ID('tempdb..#status') IS NOT NULL
    DROP TABLE #status;

CREATE TABLE #status
(
      databaseID        INT
    , databaseName      NVARCHAR(128)
    , objectID          INT
    , page_count        INT
    , schemaName        NVARCHAR(128)   Null
    , objectName        NVARCHAR(128)   Null
    , lastUpdateDate    DATETIME
    , scanDate          DATETIME        
 
    CONSTRAINT PK_status_tmp
        PRIMARY KEY CLUSTERED(databaseID, objectID)
);

DECLARE @SQL NVARCHAR(MAX);
DECLARE @dbName nvarchar(128);


DECLARE @databaseID INT;
DECLARE @objectID INT;
DECLARE @schemaName NVARCHAR(128);
DECLARE @objectName NVARCHAR(128);

DECLARE @lastUpdateDate DATETIME;
DECLARE @startTime DATETIME;

SELECT @startTime = GETDATE();

DECLARE cDB CURSOR
READ_ONLY
FOR select [name] from master.sys.databases where database_id > 4


OPEN cDB

FETCH NEXT FROM cDB INTO @dbName
WHILE (@@fetch_status <> -1)
BEGIN
    IF (@@fetch_status <> -2)
    BEGIN

        SELECT @SQL = '
            use ' + QUOTENAME(@dbName) + '

            select
                DB_ID() as databaseID 
                , DB_NAME() as databaseName
                ,t.object_id
                ,sum(used_page_count) as page_count
                ,s.[name] as schemaName
                ,t.[name] AS objectName
                , COALESCE(d.stats_date, ''1900-01-01'')
                , GETDATE() as scanDate
            from sys.dm_db_partition_stats ps
            join sys.tables t on t.object_id = ps.object_id
            join sys.schemas s on s.schema_id = t.schema_id
            join (
                    SELECT
                        object_id,
                        MIN(stats_date) as stats_date
                    FROM (
                        select
                            object_id,
                            stats_date(object_id, stats_id) as stats_date
                        from
                            sys.stats) as d
                    GROUP BY object_id
                        ) as d ON d.object_id = t.object_id
            where ps.row_count > 0
            group by s.[name], t.[name], t.object_id, 
                COALESCE(d.stats_date, ''1900-01-01'')
            '
            
            SET ANSI_WARNINGS OFF;

            Insert #status
            EXEC ( @SQL);
            
            SET ANSI_WARNINGS ON; 


    END
    FETCH NEXT FROM cDB INTO @dbName
END

CLOSE cDB
DEALLOCATE cDB




DECLARE cStats CURSOR
READ_ONLY
FOR SELECT 
          databaseID       
        , databaseName     
        , objectID         
        , schemaName       
        , objectName  
        , lastUpdateDate     
    FROM #status
    WHERE DATEDIFF(dd, lastUpdateDate, GETDATE()) >= @minDays
    ORDER BY lastUpdateDate ASC, page_count desc, [objectName] ASC
    

OPEN cStats

FETCH NEXT FROM cStats INTO @databaseID, @dbName, @objectID, 
    @schemaName, @objectName, @lastUpdateDate

WHILE (@@fetch_status <> -1)
BEGIN
    IF (@@fetch_status <> -2)
    BEGIN

        IF DATEDIFF(mi, @startTime, GETDATE()) > @timeLimit
          BEGIN
            PRINT '[ ' + CAST(GETDATE() AS VARCHAR(100)) + ' ] ' +
                 '*** Time Limit Reached ***';
            GOTO __DONE;
          END

        SELECT @SQL = 'UPDATE STATISTICS ' +
            QUOTENAME(@dBName) + '.' +
            QUOTENAME(@schemaName) + '.' +
            QUOTENAME(@ObjectName) +
            ' WITH SAMPLE ' + CAST(@samplePercent AS NVARCHAR(100)) + ' PERCENT;';
        
        IF @printSQL = 1
            PRINT '[ ' + CAST(GETDATE() AS VARCHAR(100)) + ' ] ' + 
                @SQL + 
                '  (Last Updated: ' + CAST(@lastUpdateDate AS VARCHAR(100)) + ')'
            
        IF @executeSQL = 1
          BEGIN
            EXEC (@SQL);
          END
        
        
    END
    FETCH NEXT FROM cStats INTO @databaseID, @dbName, @objectID, 
        @schemaName, @objectName, @lastUpdateDate
END

__DONE:

CLOSE cStats
DEALLOCATE cStats

PRINT '[ ' + CAST(GETDATE() AS VARCHAR(100)) + ' ] ' + 'Completed.'
GO