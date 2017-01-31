
/**************************************************************************************************
**
**  author: Daniel Denney 
**  date:   5/6/2010
**  usage:  runs DBCC CHECKDB WITH NO_INFOMSG on all databases except TempDB
**
**		exec DBA.dbo.spDBCC_CheckDB
**
**************************************************************************************************/
CREATE PROC dbo.usp_DBCC_CheckDB

AS
	SET NOCOUNT ON	
	
	DECLARE @db VARCHAR(100),
			@dbid INT,
			@hidb INT

	SELECT	@hidb = MAX(dbid),
			@dbid = 0
		FROM master..sysdatabases
		WHERE name <> 'tempdb'
		
	WHILE @dbid <= @hidb
	BEGIN
		SET @db = NULL
		
		SELECT @db = name
			FROM master..sysdatabases
			WHERE dbid = @dbid
				AND name <> 'tempdb'

		IF @db IS NOT NULL
			DBCC CheckDB( @db ) WITH NO_INFOMSGS 

		SET @dbid = @dbid + 1
	END
GO