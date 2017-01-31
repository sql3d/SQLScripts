USE DBA;
GO

/*********************************************************************************
    Name:       dbo.usp_GrowDatabases
 
    Author:     Dan Denney
 
    Purpose:    This stored procedure will loop through all databases (except TempDB) 
				and compare the used space percentage against the GrowthThreshold 
				parameter.  If the used space meets or exceeds the GrowthThreshold 
				then it will grow the database file by its default growth size.
 
    Notes:      @GrowthThreshold - Percentage of database used space at which 
				to grow the database (default is 80%).			
 
    Date        Initials    Description
    ----------------------------------------------------------------------------
    2012-01-30	DDD         Initial Release
       
    ----------------------------------------------------------------------------
*********************************************************************************
	Usage: 		
		EXEC dbo.usp_GrowDatabases
			@GrowthThreshold = 75
 
*********************************************************************************/
CREATE PROC dbo.usp_GrowDatabases
	@GrowthThreshold INT = 80
AS	
	SET NOCOUNT ON;

	CREATE TABLE dbo.#Tbl_Logs
		(
			 DatabaseName			SYSNAME NULL,
			 LogSize				DEC (10, 2) NULL,
			 LogSpaceUsedPercent	DEC (5, 2) NULL,
			 [status]				INT NULL,
			 Growth					BIGINT NULL,
			 Is_Percent_Growth		BIT NULL
		);
		
	CREATE TABLE dbo.#Tbl_DbFileStats
		(
			 [ID]				INT IDENTITY,
			 DatabaseName		SYSNAME NULL,
			 FileId				INT NULL,
			 [FileGroup]		INT NULL,
			 TotalExtents		BIGINT NULL,
			 UsedExtents		BIGINT NULL,
			 LogicalName		SYSNAME NULL,
			 [FileName]			VARCHAR(255) NULL,
			 Growth				BIGINT NULL,
			 IS_Percent_Growth	BIT NULL		 
		);
		
	CREATE TABLE #tmp_DBFiles
		(
			DatabaseName		SYSNAME NULL,
			FileType			BIT NULL,
			LogicalName			SYSNAME NULL,
			Growth				BIGINT NULL,
			Is_Percent_Growth	BIT NULL,
			SIZE				BIGINT NULL		
		);
		
			
	INSERT INTO dbo.#Tbl_Logs (DatabaseName, LogSize, LogSpaceUsedPercent, [status])
		EXEC ('DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS');
		

	EXEC master.sys.sp_MSforeachdb 'USE [?]; 
		DECLARE @NEWID INT;
		
		SELECT @NEWID = ISNULL(MAX([ID]),0)  FROM #Tbl_DbFileStats;
		
		INSERT INTO #Tbl_DbFileStats (FileId, FileGroup, TotalExtents, UsedExtents, LogicalName, FileName)
		EXEC (''DBCC SHOWFILESTATS WITH NO_INFOMSGS'');
		
		UPDATE #Tbl_DbFileStats
			SET DatabaseName = ''[?]''
			WHERE id between @NEWID + 1 and scope_identity();
			
		UPDATE #Tbl_DbFileStats
			SET Growth = sdb.Growth,
				Is_Percent_Growth = sdb.Is_Percent_Growth
			FROM #Tbl_DbFileStats dbfs
				INNER JOIN sys.database_files sdb on dbfs.LogicalName = sdb.Name;
					
		INSERT INTO #tmp_DBFiles (DatabaseName, FileType, LogicalName, Growth, Is_Percent_Growth, Size)
		SELECT ''?'', [Type], Name, Growth, Is_Percent_Growth, Size
			FROM sys.database_files;
	';


	DECLARE @DBName			NVARCHAR(100),
			@LogicalName	NVARCHAR(200),
			@FileSize		BIGINT,
			@UsedPCT		DEC(12,8),
			@Growth			BIGINT,
			@Grwth_PCT		BIT,
			@NewSize		NVARCHAR(20),
			@SQL			NVARCHAR(1000);
			
	SET @LogicalName = '';

	WHILE 1=1
		BEGIN
			SELECT TOP 1 
				@DBName			= a.DatabaseName,
				@LogicalName	= a.LogicalName,
				@FileSize		= a.Size,
				@UsedPCT		= a.PCT_Used,
				@Growth			= a.Growth,
				@Grwth_PCT		= a.Is_Percent_Growth
			FROM 
				(
					SELECT dbf.*,
						((UsedExtents * 1.0) / TotalExtents) * 100 AS PCT_Used
					FROM #tmp_DBFiles dbf
						INNER JOIN #Tbl_DbFileStats dbfs ON dbf.LogicalName = dbfs.LogicalName
					WHERE dbf.FileType = 0
					UNION ALL
					SELECT dbf.*,
						LogSpaceUsedPercent AS PCT_Used
					FROM #tmp_DBFiles dbf
						INNER JOIN #Tbl_Logs l ON dbf.DatabaseName = l.DatabaseName
					WHERE dbf.FileType = 1
				) a
			WHERE LogicalName > @LogicalName
			ORDER BY LogicalName ASC, FileType ASC;

			IF @@ROWCOUNT = 0
				BREAK;
			
			IF @UsedPCT > @GrowthThreshold
				BEGIN
					IF @Grwth_PCT = 0
						SET @NewSize = ((@FileSize + @Growth) * 8) / 1024;
					ELSE
						SET @NewSize = @FileSize + (@FileSize * (@Growth *.10));
					
					SET @SQL =  'ALTER DATABASE [' + @DbName + '] MODIFY FILE (name = N''' + @LogicalName + ''', SIZE = ' + @NewSize + 'MB);'
					
					PRINT @SQL;
				END;
			
		END;  -- WHILE 1=1

	DROP TABLE #Tbl_Logs;

	DROP TABLE #Tbl_DbFileStats;

	DROP TABLE #tmp_DBFiles;
GO