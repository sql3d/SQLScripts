/*********************************************************************************
    Name:       dbo.usp_Update_Statistics
 
    Author:     Dan Denney
 
    Purpose:    This stored procedure will run UPDATE STATISTICS WITH FULLSCAN on 
				all tables/indexes that have not had statistics updated within the
				last 24 hours (to avoid statistics that have already been regenerated
				with INDEX REBUILDS.  Sorts Statistics by oldest updated and number of pages
				in table/index.
 
    Notes:      Paramter @RunTime will limit the amount of time this job will run for.  For 
				example, if 30 is entered, then the job will stop after 30 minutes even
				if all statistics are not updated.  NULL parameter will let the job run
				indefinitely.
					
				@RunTime - Limits run time of this procedure.  In minutes.				
 
    Date        Initials    Description
    ----------------------------------------------------------------------------
    2012-01-23	DDD         Initial Release
       
    ----------------------------------------------------------------------------
*********************************************************************************
	Usage: 		
		EXEC dbo.usp_Update_Statistics
			@RunTime = 30
 
*********************************************************************************/
ALTER PROC dbo.usp_Update_Statistics
	@RunTime INT = NULL
AS
	SET NOCOUNT ON;

	CREATE TABLE #tmpTableStats (DatabaseID INT, DatabaseName NVARCHAR(250), SchemaName NVARCHAR(250), TableName NVARCHAR(250), 
		ObjectID INT, IndexName NVARCHAR(250), NbrPages INT, StatsLastUpdated DATETIME);

	DECLARE @StartTime DATETIME;
	DECLARE @DBName VARCHAR(250);
	DECLARE @sql NVARCHAR(1000);

	SET @StartTime = GETDATE();

	EXEC master.sys.sp_MSforeachdb 'USE [?]; 
		INSERT INTO #tmpTableStats (DatabaseID, DatabaseName, ObjectID, IndexName, TableName, SchemaName, NbrPages, StatsLastUpdated)
		SELECT db_id(''?'') as DatabaseID,
				''?'' as DatabaseName,
				a.id AS ObjectID, 
				ISNULL(a.name,''Heap'') AS IndexName, 
				b.name AS TableName,
				sch.name as SchemaName,
				SUM(used_page_count) AS NbrPages,
				ISNULL(STATS_DATE (id,indid), ''1900-01-01'') AS StatsLastUpdated
			FROM sys.sysindexes AS a
				INNER JOIN sys.objects AS b ON a.id = b.object_id
				INNER JOIN SYS.schemas sch ON b.schema_id = sch.schema_id
				INNER JOIN sys.dm_db_partition_stats part ON b.object_id = part.object_id
			WHERE b.type = ''U''
				AND A.Name IS NOT NULL
			GROUP BY a.id, a.name, b.name, sch.name, ISNULL(STATS_DATE (id,indid), ''1900-01-01'');';
		

	DECLARE curStats CURSOR READ_ONLY FAST_FORWARD FOR 
		SELECT  N'UPDATE STATISTICS ' + QUOTENAME(DatabaseName) + N'.' + + QUOTENAME(SchemaName) + N'.' + QUOTENAME(TableName) + N' ' 
					+ QUOTENAME(IndexName) + N' WITH FULLSCAN;'
		FROM #tmpTableStats
		WHERE StatsLastUpdated < @StartTime - 1
			AND NbrPages > 0
			AND DatabaseID <> 2
		ORDER BY StatsLastUpdated ASC, NbrPages DESC;

	OPEN curStats

	FETCH NEXT FROM curStats INTO @SQL
	WHILE @@FETCH_STATUS <> -1
		BEGIN
			IF @RunTime IS NOT NULL
				BEGIN
					IF DATEDIFF(mi, @StartTime, GETDATE()) > @RunTime
						BEGIN
							BREAK;
						END;
				END;
					
			EXEC sp_executesql @sql;
			
			FETCH NEXT FROM curStats INTO @SQL;
		END;

	CLOSE curStats;
	DEALLOCATE curStats;

	DROP TABLE #tmpTableStats;	
GO



