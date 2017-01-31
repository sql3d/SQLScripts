/**************************************************************************************************
**
**  author: Daniel Denney (based on Richard Ding's previous work)
**  date:   4/15/2010
**  usage:  database file size and grow databases at certain threshold
**
**	This modifies Richard Ding's sp_SDS stored procedure to get database file usage stats
**	then uses those stats to determine whether to grow database.
**   
**************************************************************************************************/
CREATE PROCEDURE dbo.usp_Grow_Databases
	@TargetDatabase SYSNAME = NULL,     --  NULL: all dbs
	@UpdateUsage BIT = 0,               --  default no update
	@Unit CHAR(2) = 'MB',               --  Megabytes, Kilobytes or Gigabytes
	@Growth_Threshold DEC(12,2) = 90,	-- Used Percent at which to grow database
	@Growth_Size INT = 100				-- size in MB to grow database
AS	
	SET NOCOUNT ON;

	IF @TargetDatabase IS NOT NULL
	   AND DB_ID(@TargetDatabase) IS NULL
		BEGIN
			RAISERROR(15010,-1,-1,@TargetDatabase);

			RETURN (-1)
		END

	IF OBJECT_ID('tempdb.dbo.##Tbl_CombinedInfo', 'U') IS NOT NULL
		DROP TABLE dbo.##Tbl_CombinedInfo;

	IF OBJECT_ID('tempdb.dbo.##Tbl_DbFileStats', 'U') IS NOT NULL
		DROP TABLE dbo.##Tbl_DbFileStats;

	IF OBJECT_ID('tempdb.dbo.##Tbl_ValidDbs', 'U') IS NOT NULL
		DROP TABLE dbo.##Tbl_ValidDbs;

	IF OBJECT_ID('tempdb.dbo.##Tbl_Logs', 'U') IS NOT NULL
		DROP TABLE dbo.##Tbl_Logs;

	CREATE TABLE dbo.##Tbl_CombinedInfo
		(
			 DatabaseName SYSNAME NULL,
			 [TYPE]       VARCHAR(10) NULL,
			 LogicalName  SYSNAME NULL,
			 T            DEC(10, 2) NULL,
			 U            DEC(10, 2) NULL,
			 [U_pct]      DEC(5, 2) NULL,
			 F            DEC(10, 2) NULL,
			 [F_pct]      DEC(5, 2) NULL,
			 PhysicalName SYSNAME NULL
		);

	CREATE TABLE dbo.##Tbl_DbFileStats
		(
			 Id           INT IDENTITY,
			 DatabaseName SYSNAME NULL,
			 FileId       INT NULL,
			 FileGroup    INT NULL,
			 TotalExtents BIGINT NULL,
			 UsedExtents  BIGINT NULL,
			 name         SYSNAME NULL,
			 FileName     VARCHAR(255) NULL
		);

	CREATE TABLE dbo.##Tbl_ValidDbs
		(
			 Id     INT IDENTITY,
			 Dbname SYSNAME NULL
		);

	CREATE TABLE dbo.##Tbl_Logs
		(
			 DatabaseName        SYSNAME NULL,
			 LogSize             DEC (10, 2) NULL,
			 LogSpaceUsedPercent DEC (5, 2) NULL,
			 Status              INT NULL
		);

	DECLARE @Ver          VARCHAR(10),
			@DatabaseName SYSNAME,
			@Ident_last   INT,
			@String       VARCHAR(2000),
			@BaseString   VARCHAR(2000);

	SELECT @DatabaseName = '',
		   @Ident_last = 0,
		   @String = '',
		   @Ver = CASE
					  WHEN @@version LIKE '%9.0%' THEN 'SQL 2005'
					  WHEN @@version LIKE '%8.0%' THEN 'SQL 2000'
					  WHEN @@version LIKE '%10.0%' THEN 'SQL 2008'
				  END;

	SELECT @BaseString = ' SELECT DB_NAME(), ' + CASE
													 WHEN @Ver = 'SQL 2000' THEN 'CASE WHEN status & 0x40 = 0x40 THEN ''Log''  ELSE ''Data'' END'
													 ELSE ' CASE type WHEN 0 THEN ''Data'' WHEN 1 THEN ''Log'' WHEN 4 THEN ''Full-text'' ELSE ''reserved'' END'
												 END + ', name, ' + CASE
																		WHEN @Ver = 'SQL 2000' THEN 'filename'
																		ELSE 'physical_name'
																	END + ', size*8.0/1024.0 FROM ' + CASE
																										  WHEN @Ver = 'SQL 2000' THEN 'sysfiles'
																										  ELSE 'sys.database_files'
																									  END + ' WHERE ' + CASE
																															WHEN @Ver = 'SQL 2000' THEN ' HAS_DBACCESS(DB_NAME()) = 1'
																															ELSE 'state_desc = ''ONLINE'''
																														END + '';

	SELECT @String = 'INSERT INTO dbo.##Tbl_ValidDbs SELECT name FROM ' + CASE
																			  WHEN @Ver = 'SQL 2000' THEN 'master.dbo.sysdatabases'
																			  WHEN @Ver IN ('SQL 2005', 'SQL 2008') THEN 'master.sys.databases'
																		  END + ' WHERE HAS_DBACCESS(name) = 1 ORDER BY name ASC';

	EXEC (@String);

	INSERT INTO dbo.##Tbl_Logs
	EXEC ('DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS');

	WHILE 1 = 1
		BEGIN
			SELECT TOP 1 @DatabaseName = Dbname
			FROM   dbo.##Tbl_ValidDbs
			WHERE  Dbname > @DatabaseName
			ORDER  BY Dbname ASC;

			IF @@ROWCOUNT = 0
				BREAK;

			IF @UpdateUsage <> 0
			   AND DATABASEPROPERTYEX (@DatabaseName, 'Status') = 'ONLINE'
			   AND DATABASEPROPERTYEX (@DatabaseName, 'Updateability') <> 'READ_ONLY'
				BEGIN
					SELECT @String = 'DBCC UPDATEUSAGE (''' + @DatabaseName + ''') ';

					PRINT '*** ' + @String + '*** ';

					EXEC (@String);

					PRINT '';
				END

			SELECT @Ident_last = ISNULL(MAX(Id), 0)
			FROM   dbo.##Tbl_DbFileStats;

			SELECT @String = 'INSERT INTO dbo.##Tbl_CombinedInfo (DatabaseName, type, LogicalName, PhysicalName, T) ' + @BaseString;

			EXEC ('USE [' + @DatabaseName + '] ' + @String);

			INSERT INTO dbo.##Tbl_DbFileStats
						(FileId,FileGroup,TotalExtents,UsedExtents,name,FileName)
			EXEC ('USE [' + @DatabaseName + '] DBCC SHOWFILESTATS WITH NO_INFOMSGS');

			UPDATE dbo.##Tbl_DbFileStats
			SET    DatabaseName = @DatabaseName
			WHERE  Id BETWEEN @Ident_last + 1 AND @@IDENTITY;
		END

	--  set used size for data files, do not change total obtained from sys.database_files as it has for log files
	UPDATE dbo.##Tbl_CombinedInfo
	SET    U = s.UsedExtents * 8 * 8 / 1024.0
	FROM   dbo.##Tbl_CombinedInfo t
		   JOIN dbo.##Tbl_DbFileStats s ON t.LogicalName = s.Name
										   AND s.DatabaseName = t.DatabaseName;

	--  set used size and % values for log files:
	UPDATE dbo.##Tbl_CombinedInfo
	SET    [U_pct] = LogSpaceUsedPercent,
		   U = T * LogSpaceUsedPercent / 100.0
	FROM   dbo.##Tbl_CombinedInfo t
		   JOIN dbo.##Tbl_Logs l ON l.DatabaseName = t.DatabaseName
	WHERE  t.type = 'Log';

	UPDATE dbo.##Tbl_CombinedInfo
	SET    F = T - U,
		   [U_pct] = U * 100.0 / T;

	UPDATE dbo.##Tbl_CombinedInfo
	SET    [F_pct] = F * 100.0 / T;

	IF @Unit = 'KB'
	  UPDATE dbo.##Tbl_CombinedInfo
		
	SET T = T * 1024, 
		U = U * 1024, 
		F = F * 1024;

	IF @Unit = 'GB'
	  UPDATE dbo.##Tbl_CombinedInfo
		
	SET T = T / 1024, 
		U = U / 1024, 
		F = F / 1024;

	DECLARE @DbName NVARCHAR(100)
	DECLARE @LogicalName VARCHAR(250)
	DECLARE @File_Size DEC(12, 2)
	DECLARE @Used_Pct DEC(12, 2)
	DECLARE @alter_sql NVARCHAR(1000)
	DECLARE @new_size NVARCHAR(20)

	SET @LogicalName = ''

	WHILE 1 = 1
		BEGIN
			SELECT TOP 1 @DbName = DatabaseName,
						 @LogicalName = LogicalName,
						 @File_Size = T,
						 @Used_Pct = [U_pct]
			FROM   dbo.##Tbl_CombinedInfo
			WHERE  DatabaseName LIKE ISNULL(@TargetDatabase, '%')
			   AND LogicalName > @LogicalName
			ORDER  BY LogicalName ASC,TYPE ASC;

			IF @@ROWCOUNT = 0
				BREAK;

			IF @Used_Pct > @Growth_Threshold
				BEGIN
					SET @new_size = CEILING(@File_Size) + @Growth_Size
					SET @alter_sql = 'alter database [' + @DbName + '] MODIFY FILE (NAME = N''' + @LogicalName + ''', SIZE = ' + @new_size + 'MB)'

					EXEC Sp_executesql @alter_sql
				END
		END

GO 
