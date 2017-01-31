USE [master]
GO
/****** Object:  Database [DBA]    Script Date: 03/27/2012 09:28:00 ******/
CREATE DATABASE [DBA] ON  PRIMARY 
( NAME = N'DBA', FILENAME = N'E:\SQLData\DBA.mdf' , SIZE = 1048576KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB )
 LOG ON 
( NAME = N'DBA_log', FILENAME = N'F:\SQLLogs\DBA_log.ldf' , SIZE = 524288KB , MAXSIZE = 2048GB , FILEGROWTH = 524288KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DBA] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [DBA] SET ANSI_NULLS OFF
GO
ALTER DATABASE [DBA] SET ANSI_PADDING OFF
GO
ALTER DATABASE [DBA] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [DBA] SET ARITHABORT OFF
GO
ALTER DATABASE [DBA] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [DBA] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [DBA] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [DBA] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [DBA] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [DBA] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [DBA] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [DBA] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [DBA] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [DBA] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [DBA] SET  DISABLE_BROKER
GO
ALTER DATABASE [DBA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [DBA] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [DBA] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [DBA] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [DBA] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [DBA] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [DBA] SET  READ_WRITE
GO
ALTER DATABASE [DBA] SET RECOVERY SIMPLE
GO
ALTER DATABASE [DBA] SET  MULTI_USER
GO
ALTER DATABASE [DBA] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [DBA] SET DB_CHAINING OFF
GO
/****** Object:  Login [NT SERVICE\SQLSERVERAGENT]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [NT SERVICE\SQLSERVERAGENT] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\MSSQLSERVER]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [NT SERVICE\MSSQLSERVER] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\ClusSvc]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [NT SERVICE\ClusSvc] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT AUTHORITY\SYSTEM]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\CSAN0DBA]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\CSAN0DBA] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\CSAN0AS085$]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\CSAN0AS085$] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\a1CAReportSrvs]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\a1CAReportSrvs] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\_san0SSPSAMOSS]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\_san0SSPSAMOSS] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\_san0SPSearchAcctMOS]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\_san0SPSearchAcctMOS] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\_san0SPFarmMOSS]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\_san0SPFarmMOSS] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\_san0SPAppPoolMOSS]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\_san0SPAppPoolMOSS] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\_san0SPAdminMOSS]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\_san0SPAdminMOSS] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [CORP\_A1CCAL0BISQL]    Script Date: 03/27/2012 09:28:00 ******/
CREATE LOGIN [CORP\_A1CCAL0BISQL] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [##MS_PolicyTsqlExecutionLogin##]    Script Date: 03/27/2012 09:28:00 ******/
/* For security reasons the login is created disabled and with a random password. */
CREATE LOGIN [##MS_PolicyTsqlExecutionLogin##] WITH PASSWORD=N'YN?_?DäV¡H~¼AÇ*(Hz¼iÆi^ÚB.7á', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER LOGIN [##MS_PolicyTsqlExecutionLogin##] DISABLE
GO
/****** Object:  Login [##MS_PolicyEventProcessingLogin##]    Script Date: 03/27/2012 09:28:00 ******/
/* For security reasons the login is created disabled and with a random password. */
CREATE LOGIN [##MS_PolicyEventProcessingLogin##] WITH PASSWORD=N'?
ñª+?þè`K2YãVØwk;·Æ0V(/pøZ©$', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER LOGIN [##MS_PolicyEventProcessingLogin##] DISABLE
GO
USE [DBA]
GO
/****** Object:  StoredProcedure [dbo].[usp_RestoreSharePointDBs]    Script Date: 03/27/2012 09:28:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_RestoreSharePointDBs]

as
set nocount on


RESTORE DATABASE [SharedServices_DB]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\SharedServices_DB_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [SharedServices_Search_DB]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\SharedServices_Search_DB_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [SharePoint_AdminContent_e850a7d1-8b9f-45aa-b063-d805b5a7622d]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\SharePoint_AdminContent_e850a7d1-8b9f-45aa-b063-d805b5a7622d_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [SharePoint_Config]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\SharePoint_Config_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [SharePoint_CustomObjects]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\SharePoint_CustomObjects_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_BusInnov]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_BusInnov_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_CONTENT_CB]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_CONTENT_CB_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_CSO]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_CSO_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_CustomerSolutions]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_CustomerSolutions_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_FS]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_FS_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_IT]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_IT_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_KB]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_KB_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_KM]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_KM_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_OPS]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_OPS_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_PublicRelations]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_PublicRelations_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_SM]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_SM_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_Top]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_Top_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Content_Training]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Content_Training_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Credit]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Credit_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Engineering]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Engineering_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Finance]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Finance_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Marketing]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Marketing_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_MySites_Content]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_MySites_Content_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_PplSvcs]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_PplSvcs_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Search_CSAN0AS085]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Search_CSAN0AS085_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Search_CSAN0AS086]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Search_CSAN0AS086_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Search_CSAN0AS087_2]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Search_CSAN0AS087_2_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_SSP_Content]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_SSP_Content_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_Test]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_Test_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
	

RESTORE DATABASE [WSS_WHSE]
	FROM DISK = N'\\10.47.59.245\Fed_SQL\CSAN0DB070\WSS_WHSE_Final.bak'
	WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10;
GO
/****** Object:  StoredProcedure [dbo].[usp_GrowDatabases]    Script Date: 03/27/2012 09:28:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    2012-02-07	DDD			Updated query to include Default Database Collation
    ----------------------------------------------------------------------------
*********************************************************************************
	Usage: 		
		EXEC dbo.usp_GrowDatabases
			@GrowthThreshold = 75
 
*********************************************************************************/
CREATE PROC [dbo].[usp_GrowDatabases]
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
				INNER JOIN sys.database_files sdb 
					on dbfs.LogicalName COLLATE DATABASE_DEFAULT = sdb.Name COLLATE DATABASE_DEFAULT;
					
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
						SET @NewSize = CAST(ROUND(((@FileSize + @Growth) * 8) / 1024, 0) AS INT);
					ELSE
						SET @NewSize = CAST(ROUND( @FileSize + (@FileSize * (@Growth *.10)),0) AS INT);
					
					SET @SQL =  'ALTER DATABASE [' + @DbName + '] MODIFY FILE (name = ' + @LogicalName + ', SIZE = ' + @NewSize + 'MB);'
					
					PRINT @SQL;
					
					EXEC sp_executesql @SQL;
				END;
			
		END;  -- WHILE 1=1

	DROP TABLE #Tbl_Logs;

	DROP TABLE #Tbl_DbFileStats;

	DROP TABLE #tmp_DBFiles;
GO
/****** Object:  Table [dbo].[WaitTypeCategory]    Script Date: 03/27/2012 09:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WaitTypeCategory](
	[WaitType] [nvarchar](60) NOT NULL,
	[Category] [varchar](50) NULL,
	[Resource] [varchar](50) NULL,
	[Version] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[Action] [varchar](max) NULL,
 CONSTRAINT [PK_WaitTypeCategory] PRIMARY KEY CLUSTERED 
(
	[WaitType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WaitStatSnapshot]    Script Date: 03/27/2012 09:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaitStatSnapshot](
	[CreateDate] [datetime] NOT NULL,
	[WaitType] [nvarchar](60) NOT NULL,
	[WaitingTasksCount] [bigint] NOT NULL,
	[WaitTimeMs] [bigint] NOT NULL,
	[MaxWaitTimeMs] [bigint] NOT NULL,
	[SignalWaitTimeMs] [bigint] NOT NULL,
 CONSTRAINT [PK_Monitor_WaitStatSnapshot_CreateDateWaitType] PRIMARY KEY CLUSTERED 
(
	[CreateDate] ASC,
	[WaitType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WaitStatHistory]    Script Date: 03/27/2012 09:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaitStatHistory](
	[CreateDate] [datetime] NOT NULL,
	[WaitType] [nvarchar](60) NOT NULL,
	[WaitingTasksCount] [bigint] NOT NULL,
	[WaitTimeMs] [bigint] NOT NULL,
	[MaxWaitTimeMs] [bigint] NOT NULL,
	[SignalWaitTimeMs] [bigint] NOT NULL,
 CONSTRAINT [PK_Monitor_WaitStatHistory_CreateDateWaitType] PRIMARY KEY CLUSTERED 
(
	[CreateDate] ASC,
	[WaitType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_BlitzUpdate]    Script Date: 03/27/2012 09:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BlitzUpdate]
AS 
    SET NOCOUNT ON
    CREATE TABLE #Scripts ( ScriptDDL VARCHAR(MAX) ) ;
    DECLARE @ScriptDDL VARCHAR(MAX) ,
        @ScriptOpenRowset VARCHAR(MAX) ;


    IF EXISTS ( SELECT  *
                FROM    sys.configurations
                WHERE   name = 'Ad Hoc Distributed Queries'
                        AND value_in_use = 0 ) 
        BEGIN
            PRINT 'sp_BlitzUpdate requires Ad Hoc Distributed Queries to be turned on.'
            PRINT 'For more information, see http://www.BrentOzar.com/blitz/update'
            PRINT 'If you feel adventurous, you can turn it on by running these commands: '
            PRINT 'EXECUTE SP_CONFIGURE ''show advanced options'', 1;'
            PRINT 'RECONFIGURE WITH OVERRIDE;'
            PRINT 'GO'
            PRINT 'EXECUTE SP_CONFIGURE ''Ad Hoc Distributed Queries'', ''1'';'
            PRINT 'RECONFIGURE WITH OVERRIDE;'
            PRINT 'GO'
        END
    ELSE 
        BEGIN

            SET @ScriptOpenRowset = 'INSERT INTO #Scripts SELECT a.ScriptDDL FROM OPENROWSET(''SQLNCLI'', ''Server=publicsql.brentozar.com;UID=ReadOnly;PWD=PainRelief;'',
     ''SELECT TOP 1 ScriptDDL FROM dbo.Scripts WHERE ScriptName = ''''sp_Blitz'''' ORDER BY ScriptID DESC'') AS a;' ;
            EXEC(@ScriptOpenRowset) ;
            SELECT  @ScriptDDL = ScriptDDL
            FROM    #Scripts ;

			/* Drop the existing Blitz script if it already exists */
            IF OBJECT_ID('dba.dbo.sp_Blitz') IS NOT NULL 
                DROP PROC dbo.sp_Blitz ;

            EXEC(@ScriptDDL) ;

        END

    SET NOCOUNT OFF
GO
/****** Object:  UserDefinedFunction [dbo].[dba_parseString_udf]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[dba_parseString_udf]
(
          @stringToParse VARCHAR(8000)  
        , @delimiter     CHAR(1)
)
RETURNS @parsedString TABLE (stringValue VARCHAR(128))
AS
/*********************************************************************************
    Name:       dba_parseString_udf
 
    Author:     Michelle Ufford, http://sqlfool.com
 
    Purpose:    This function parses string input using a variable delimiter.
 
    Notes:      Two common delimiter values are space (' ') and comma (',')
 
    Date        Initials    Description
    ----------------------------------------------------------------------------
    2011-05-20  MFU         Initial Release
*********************************************************************************
Usage: 		
    SELECT *
    FROM dba_parseString_udf(<string>, <delimiter>);
 
Test Cases:
 
    1.  multiple strings separated by space
        SELECT * FROM dbo.dba_parseString_udf('  aaa  bbb  ccc ', ' ');
 
    2.  multiple strings separated by comma
        SELECT * FROM dbo.dba_parseString_udf(',aaa,bbb,,,ccc,', ',');
*********************************************************************************/
BEGIN
 
    /* Declare variables */
    DECLARE @trimmedString  VARCHAR(8000);
 
    /* We need to trim our string input in case the user entered extra spaces */
    SET @trimmedString = LTRIM(RTRIM(@stringToParse));
 
    /* Let's create a recursive CTE to break down our string for us */
    WITH parseCTE (StartPos, EndPos)
    AS
    (
        SELECT 1 AS StartPos
            , CHARINDEX(@delimiter, @trimmedString + @delimiter) AS EndPos
        UNION ALL
        SELECT EndPos + 1 AS StartPos
            , CHARINDEX(@delimiter, @trimmedString + @delimiter , EndPos + 1) AS EndPos
        FROM parseCTE
        WHERE CHARINDEX(@delimiter, @trimmedString + @delimiter, EndPos + 1) <> 0
    )
 
    /* Let's take the results and stick it in a table */  
    INSERT INTO @parsedString
    SELECT SUBSTRING(@trimmedString, StartPos, EndPos - StartPos)
    FROM parseCTE
    WHERE LEN(LTRIM(RTRIM(SUBSTRING(@trimmedString, StartPos, EndPos - StartPos)))) > 0
    OPTION (MaxRecursion 8000);
 
    RETURN;   
END
GO
/****** Object:  UserDefinedFunction [dbo].[DatabaseSelect]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DatabaseSelect] (@DatabaseList nvarchar(max))

RETURNS @Database TABLE (DatabaseName nvarchar(max) NOT NULL)

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: http://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  DECLARE @DatabaseItem nvarchar(max)
  DECLARE @Position int

  DECLARE @CurrentID int
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentDatabaseStatus bit

  DECLARE @Database01 TABLE (DatabaseName nvarchar(max))

  DECLARE @Database02 TABLE (ID int IDENTITY PRIMARY KEY,
                             DatabaseName nvarchar(max),
                             DatabaseStatus bit,
                             Completed bit)

  DECLARE @Database03 TABLE (DatabaseName nvarchar(max),
                             DatabaseStatus bit)

  DECLARE @Sysdatabases TABLE (DatabaseName nvarchar(max))

  ----------------------------------------------------------------------------------------------------
  --// Split input string into elements                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE CHARINDEX(', ',@DatabaseList) > 0 SET @DatabaseList = REPLACE(@DatabaseList,', ',',')
  WHILE CHARINDEX(' ,',@DatabaseList) > 0 SET @DatabaseList = REPLACE(@DatabaseList,' ,',',')
  WHILE CHARINDEX(',,',@DatabaseList) > 0 SET @DatabaseList = REPLACE(@DatabaseList,',,',',')

  IF RIGHT(@DatabaseList,1) = ',' SET @DatabaseList = LEFT(@DatabaseList,LEN(@DatabaseList) - 1)
  IF LEFT(@DatabaseList,1) = ','  SET @DatabaseList = RIGHT(@DatabaseList,LEN(@DatabaseList) - 1)

  SET @DatabaseList = LTRIM(RTRIM(@DatabaseList))

  WHILE LEN(@DatabaseList) > 0
  BEGIN
    SET @Position = CHARINDEX(',', @DatabaseList)
    IF @Position = 0
    BEGIN
      SET @DatabaseItem = @DatabaseList
      SET @DatabaseList = ''
    END
    ELSE
    BEGIN
      SET @DatabaseItem = LEFT(@DatabaseList, @Position - 1)
      SET @DatabaseList = RIGHT(@DatabaseList, LEN(@DatabaseList) - @Position)
    END
    IF @DatabaseItem <> '-' INSERT INTO @Database01 (DatabaseName) VALUES(@DatabaseItem)
  END

  ----------------------------------------------------------------------------------------------------
  --// Handle database exclusions                                                                 //--
  ----------------------------------------------------------------------------------------------------

  INSERT INTO @Database02 (DatabaseName, DatabaseStatus, Completed)
  SELECT DISTINCT DatabaseName = CASE WHEN DatabaseName LIKE '-%' THEN RIGHT(DatabaseName,LEN(DatabaseName) - 1) ELSE DatabaseName END,
                  DatabaseStatus = CASE WHEN DatabaseName LIKE '-%' THEN 0 ELSE 1 END,
                  0 AS Completed
  FROM @Database01

  ----------------------------------------------------------------------------------------------------
  --// Resolve elements                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE EXISTS (SELECT * FROM @Database02 WHERE Completed = 0)
  BEGIN

    SELECT TOP 1 @CurrentID = ID,
                 @CurrentDatabaseName = DatabaseName,
                 @CurrentDatabaseStatus = DatabaseStatus
    FROM @Database02
    WHERE Completed = 0
    ORDER BY ID ASC

    IF @CurrentDatabaseName = 'SYSTEM_DATABASES'
    BEGIN
      INSERT INTO @Database03 (DatabaseName, DatabaseStatus)
      SELECT [name], @CurrentDatabaseStatus
      FROM sys.databases
      WHERE [name] IN('master','model','msdb','tempdb')
    END
    ELSE IF @CurrentDatabaseName = 'USER_DATABASES'
    BEGIN
      INSERT INTO @Database03 (DatabaseName, DatabaseStatus)
      SELECT [name], @CurrentDatabaseStatus
      FROM sys.databases
      WHERE [name] NOT IN('master','model','msdb','tempdb')
    END
    ELSE IF @CurrentDatabaseName = 'ALL_DATABASES'
    BEGIN
      INSERT INTO @Database03 (DatabaseName, DatabaseStatus)
      SELECT [name], @CurrentDatabaseStatus
      FROM sys.databases
    END
    ELSE IF CHARINDEX('%',@CurrentDatabaseName) > 0
    BEGIN
      INSERT INTO @Database03 (DatabaseName, DatabaseStatus)
      SELECT [name], @CurrentDatabaseStatus
      FROM sys.databases
      WHERE [name] LIKE REPLACE(PARSENAME(@CurrentDatabaseName,1),'_','[_]')
    END
    ELSE
    BEGIN
      INSERT INTO @Database03 (DatabaseName, DatabaseStatus)
      SELECT [name], @CurrentDatabaseStatus
      FROM sys.databases
      WHERE [name] = PARSENAME(@CurrentDatabaseName,1)
    END

    UPDATE @Database02
    SET Completed = 1
    WHERE ID = @CurrentID

    SET @CurrentID = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentDatabaseStatus = NULL

  END

  ----------------------------------------------------------------------------------------------------
  --// Handle tempdb and database snapshots                                                       //--
  ----------------------------------------------------------------------------------------------------

  INSERT INTO @Sysdatabases (DatabaseName)
  SELECT [name]
  FROM sys.databases
  WHERE [name] <> 'tempdb'
  AND source_database_id IS NULL

  ----------------------------------------------------------------------------------------------------
  --// Return results                                                                             //--
  ----------------------------------------------------------------------------------------------------

  INSERT INTO @Database (DatabaseName)
  SELECT DatabaseName
  FROM @Sysdatabases
  INTERSECT
  SELECT DatabaseName
  FROM @Database03
  WHERE DatabaseStatus = 1
  EXCEPT
  SELECT DatabaseName
  FROM @Database03
  WHERE DatabaseStatus = 0

  RETURN

  ----------------------------------------------------------------------------------------------------

END
GO
/****** Object:  Table [dbo].[CommandLog]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CommandLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [sysname] NULL,
	[SchemaName] [sysname] NULL,
	[ObjectName] [sysname] NULL,
	[ObjectType] [char](2) NULL,
	[IndexName] [sysname] NULL,
	[IndexType] [tinyint] NULL,
	[StatisticsName] [sysname] NULL,
	[PartitionNumber] [int] NULL,
	[ExtendedInfo] [xml] NULL,
	[Command] [nvarchar](max) NOT NULL,
	[CommandType] [nvarchar](60) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[ErrorNumber] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [PK_CommandLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[CommandExecute]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CommandExecute]

@Command nvarchar(max),
@CommandType nvarchar(max),
@Mode int,
@Comment nvarchar(max) = NULL,
@DatabaseName nvarchar(max) = NULL,
@SchemaName nvarchar(max) = NULL,
@ObjectName nvarchar(max) = NULL,
@ObjectType nvarchar(max) = NULL,
@IndexName nvarchar(max) = NULL,
@IndexType int = NULL,
@StatisticsName nvarchar(max) = NULL,
@PartitionNumber int = NULL,
@ExtendedInfo xml = NULL,
@LogToTable nvarchar(max),
@Execute nvarchar(max)

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: http://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  SET LOCK_TIMEOUT 3600000

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @ErrorMessageOriginal nvarchar(max)

  DECLARE @StartTime datetime
  DECLARE @EndTime datetime

  DECLARE @StartTimeSec datetime
  DECLARE @EndTimeSec datetime

  DECLARE @ID int

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    SET @ErrorMessage = 'SQL Azure is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO ReturnCode
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download http://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO ReturnCode
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @Command IS NULL OR @Command = ''
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Command is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CommandType IS NULL OR @CommandType = '' OR LEN(@CommandType) > 60
  BEGIN
    SET @ErrorMessage = 'The value for parameter @CommandType is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Mode NOT IN(1,2) OR @Mode IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Mode is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO ReturnCode
  END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartTime = GETDATE()
  SET @StartTimeSec = CONVERT(datetime,CONVERT(nvarchar,@StartTime,120),120)

  SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,@StartTimeSec,120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Command: ' + @Command
  IF @Comment IS NOT NULL SET @StartMessage = @StartMessage + CHAR(13) + CHAR(10) + 'Comment: ' + @Comment
  SET @StartMessage = REPLACE(@StartMessage,'%','%%')
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  IF @LogToTable = 'Y'
  BEGIN
    INSERT INTO dbo.CommandLog (DatabaseName, SchemaName, ObjectName, ObjectType, IndexName, IndexType, StatisticsName, PartitionNumber, ExtendedInfo, CommandType, Command, StartTime)
    VALUES (@DatabaseName, @SchemaName, @ObjectName, @ObjectType, @IndexName, @IndexType, @StatisticsName, @PartitionNumber, @ExtendedInfo, @CommandType, @Command, @StartTime)
  END

  SET @ID = SCOPE_IDENTITY()

  ----------------------------------------------------------------------------------------------------
  --// Execute command                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF @Mode = 1 AND @Execute = 'Y'
  BEGIN
    EXECUTE(@Command)
    SET @Error = @@ERROR
    SET @ReturnCode = @Error
  END

  IF @Mode = 2 AND @Execute = 'Y'
  BEGIN
    BEGIN TRY
      EXECUTE(@Command)
    END TRY
    BEGIN CATCH
      SET @Error = ERROR_NUMBER()
      SET @ReturnCode = @Error
      SET @ErrorMessageOriginal = ERROR_MESSAGE()
      SET @ErrorMessage = 'Msg ' + CAST(@Error AS nvarchar) + ', ' + ISNULL(@ErrorMessageOriginal,'')
      RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    END CATCH
  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  SET @EndTime = GETDATE()
  SET @EndTimeSec = CONVERT(datetime,CONVERT(varchar,@EndTime,120),120)

  SET @EndMessage = 'Outcome: ' + CASE WHEN @Execute = 'N' THEN 'Not Executed' WHEN @Error = 0 THEN 'Succeeded' ELSE 'Failed' END + CHAR(13) + CHAR(10)
  SET @EndMessage = @EndMessage + 'Duration: ' + CASE WHEN DATEDIFF(ss,@StartTimeSec, @EndTimeSec)/(24*3600) > 0 THEN CAST(DATEDIFF(ss,@StartTimeSec, @EndTimeSec)/(24*3600) AS nvarchar) + '.' ELSE '' END + CONVERT(nvarchar,@EndTimeSec - @StartTimeSec,108) + CHAR(13) + CHAR(10)
  SET @EndMessage = @EndMessage + 'DateTime: ' + CONVERT(nvarchar,@EndTimeSec,120) + CHAR(13) + CHAR(10) + ' '
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @LogToTable = 'Y'
  BEGIN
    UPDATE dbo.CommandLog
    SET EndTime = @EndTime,
        ErrorNumber = CASE WHEN @Execute = 'N' THEN NULL ELSE @Error END,
        ErrorMessage = @ErrorMessageOriginal
    WHERE ID = @ID
  END

  ReturnCode:
  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END
GO
/****** Object:  StoredProcedure [dbo].[usp_SuspectPages]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_SuspectPages]
AS
	SET NOCOUNT ON
	
	IF (SELECT COUNT(*) FROM msdb.dbo.suspect_pages WHERE event_type IN (1,2,3)) > 0
		BEGIN
			EXEC msdb.dbo.sp_send_dbmail 
				@recipients = 'CCISAN-ITBIOnCall@cox.com'
				,@subject = 'Suspect Pages found in Database'
				,@body = 'One or more suspect pages were found in a database on server.  Please review the msdb.dbo.suspect_pages table for details.'
				,@importance = 'High'
		END;
GO
/****** Object:  StoredProcedure [dbo].[upReport_WaitStatSnapshot]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================
	Procedure:	dbo.upReport_WaitStatSnapshot
	Author:		Jason Strate
	Date:		April 1, 2010

	Synopsis:
	This procedure aggregates wait stats for the selected date range.  Data is
	joined with category information to provide description and action
	guidance if available.

	Parameters
	@StartDate  : Begin date for aggregating wait stats.  Begins from the start
	of the date.
	@EndDate    : End date for aggregating wait stats.  Includes all data for the
	end date.

	============================================================
	Revision History:
	Date:		By			Description
	4/15/2011   Dan Denney	Added parameter to ignore system Wait Stats
	------------------------------------------------------------

============================================================*/
CREATE PROCEDURE [dbo].[upReport_WaitStatSnapshot]
(
	@StartDate datetime,
	@EndDate datetime,
	@IgnoreSystemWaits bit = 0
)
As
	set nocount on
	
	if @IgnoreSystemWaits = 0
		begin
			;WITH WaitStatCTE
			AS (
				SELECT COALESCE(wtc.Category, 'UNKNOWN') AS Category
					,COALESCE(wtc.Resource, 'UNKNOWN') AS Resource
					,wtc.Description
					,wtc.Action
					,wsh.WaitType
					,SUM(wsh.WaitingTasksCount) AS WaitingTasksCount
					,SUM(wsh.WaitTimeMs) AS WaitTimeMs
					,SUM(wsh.SignalWaitTimeMs) AS SignalWaitTimeMs
				FROM dbo.WaitStatHistory wsh
					INNER JOIN dbo.WaitTypeCategory wtc ON wsh.WaitType = wtc.WaitType
				WHERE wsh.WaitingTasksCount <> 0
					AND	wsh.CreateDate BETWEEN @StartDate AND DATEADD(ms, -3, DATEADD(d, 1, @EndDate))
				GROUP BY COALESCE(wtc.Category, 'UNKNOWN')
					,COALESCE(wtc.Resource, 'UNKNOWN')
					,wsh.WaitType
					,wtc.Description
					,wtc.Action
			)
			SELECT Category
				,Resource
				,[Description]
				,[Action]
				,WaitType
				,WaitTimeMs
				,WaitingTasksCount
				,SUM(WaitTimeMs) OVER() AS TotalWaitTimeMS
				,SignalWaitTimeMs
				,CAST((1.*WaitTimeMs)/SUM(WaitTimeMs) OVER() AS decimal(8,6)) AS PercentWaitTimeMS
			FROM WaitStatCTE
			ORDER BY WaitTimeMs DESC
		end
	else
		begin
			;WITH WaitStatCTE
			AS (
				SELECT COALESCE(wtc.Category, 'UNKNOWN') AS Category
					,COALESCE(wtc.Resource, 'UNKNOWN') AS Resource
					,wtc.Description
					,wtc.Action
					,wsh.WaitType
					,SUM(wsh.WaitingTasksCount) AS WaitingTasksCount
					,SUM(wsh.WaitTimeMs) AS WaitTimeMs
					,SUM(wsh.SignalWaitTimeMs) AS SignalWaitTimeMs
				FROM dbo.WaitStatHistory wsh
					INNER JOIN dbo.WaitTypeCategory wtc ON wsh.WaitType = wtc.WaitType
				WHERE wsh.WaitingTasksCount <> 0
					AND	wsh.CreateDate BETWEEN @StartDate AND DATEADD(ms, -3, DATEADD(d, 1, @EndDate))
					AND wsh.WaitType NOT IN (
						'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
						'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',
						'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BROKER_TO_FLUSH',
						'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE',
						'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'BROKER_EVENTHANDLER',
						'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP')						
				GROUP BY COALESCE(wtc.Category, 'UNKNOWN')
					,COALESCE(wtc.Resource, 'UNKNOWN')
					,wsh.WaitType
					,wtc.Description
					,wtc.Action
			)
			SELECT Category
				,Resource
				,[Description]
				,[Action]
				,WaitType
				,WaitTimeMs
				,WaitingTasksCount
				,SUM(WaitTimeMs) OVER() AS TotalWaitTimeMS
				,SignalWaitTimeMs
				,CAST((1.*WaitTimeMs)/SUM(WaitTimeMs) OVER() AS decimal(8,6)) AS PercentWaitTimeMS
			FROM WaitStatCTE
			ORDER BY WaitTimeMs DESC
		end
GO
/****** Object:  StoredProcedure [dbo].[upLoad_TrackWaitStats]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*============================================================
	Procedure: dbo.upLoad_TrackWaitStats
	Author: Jason Strate
	Date: October 26, 2009

	Synopsis:
	This procedure takes snapshots of wait stats and compares them with previous
	snapshots to determine a delta of changes over time. Raw snapshot information
	is deleted on a short time span, while the delta information in the history
	table is deleted over a longer time span.

	============================================================
	Revision History:
	Date: By Description
	------------------------------------------------------------

============================================================*/
CREATE PROCEDURE [dbo].[upLoad_TrackWaitStats]
(
	@SnapshotDays tinyint = 1,
	@HistoryDays smallint = 90
)
AS
	set nocount on
		
	INSERT INTO dbo.WaitStatSnapshot
	SELECT GETDATE()
		, CASE wait_type 
				WHEN 'MISCELLANEOUS' THEN 'MISCELLANEOUS' 
				ELSE wait_type 
		  END
		, SUM(waiting_tasks_count)
		, SUM(wait_time_ms)
		, SUM(max_wait_time_ms)
		, SUM(signal_wait_time_ms)
	FROM sys.dm_os_wait_stats
	GROUP BY CASE wait_type WHEN 'MISCELLANEOUS' THEN 'MISCELLANEOUS' ELSE wait_type END

	;WITH WaitStatCTE
	AS (
	SELECT CreateDate
		, DENSE_RANK() OVER (ORDER BY CreateDate DESC) AS HistoryID
		, WaitType
		, WaitingTasksCount
		, WaitTimeMs
		, MaxWaitTimeMs
		, SignalWaitTimeMs
	FROM Monitor.WaitStatSnapshot
	)
	INSERT INTO dbo.WaitStatHistory
	SELECT w1.CreateDate
		, w1.WaitType
		, w1.WaitingTasksCount - COALESCE(w2.WaitingTasksCount,0)
		, w1.WaitTimeMs - COALESCE(w2.WaitTimeMs,0)
		, w1.MaxWaitTimeMs - COALESCE(w2.MaxWaitTimeMs,0)
		, w1.SignalWaitTimeMs - COALESCE(w2.SignalWaitTimeMs,0)
	FROM WaitStatCTE w1
		LEFT OUTER JOIN WaitStatCTE w2 ON w1.WaitType = w2.WaitType
			AND w1.WaitingTasksCount >= COALESCE(w2.WaitingTasksCount,0)
			AND w2.HistoryID = 2
	WHERE w1.HistoryID = 1

	DELETE FROM dbo.WaitStatSnapshot
	WHERE CreateDate < DATEADD(d, -@SnapshotDays, GETDATE())

	DELETE FROM dbo.WaitStatHistory
	WHERE CreateDate < DATEADD(d, -@HistoryDays, GETDATE())
GO
/****** Object:  StoredProcedure [dbo].[IndexOptimize]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IndexOptimize]

@Databases nvarchar(max),
@FragmentationLow nvarchar(max) = NULL,
@FragmentationMedium nvarchar(max) = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh nvarchar(max) = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 int = 5,
@FragmentationLevel2 int = 30,
@PageCountLevel int = 1000,
@SortInTempdb nvarchar(max) = 'N',
@MaxDOP int = NULL,
@FillFactor int = NULL,
@PadIndex nvarchar(max) = NULL,
@LOBCompaction nvarchar(max) = 'Y',
@UpdateStatistics nvarchar(max) = NULL,
@OnlyModifiedStatistics nvarchar(max) = 'N',
@StatisticsSample int = NULL,
@StatisticsResample nvarchar(max) = 'N',
@PartitionLevel nvarchar(max) = 'N',
@TimeLimit int = NULL,
@Indexes nvarchar(max) = NULL,
@Delay int = NULL,
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: http://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  SET ARITHABORT ON

  SET LOCK_TIMEOUT 3600000

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @Version numeric(18,10)

  DECLARE @StartTime datetime

  DECLARE @CurrentIndexList nvarchar(max)
  DECLARE @CurrentIndexItem nvarchar(max)
  DECLARE @CurrentIndexPosition int

  DECLARE @CurrentID int
  DECLARE @CurrentDatabaseID int
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentMirroringRole nvarchar(max)

  DECLARE @CurrentCommand01 nvarchar(max)
  DECLARE @CurrentCommand02 nvarchar(max)
  DECLARE @CurrentCommand03 nvarchar(max)
  DECLARE @CurrentCommand04 nvarchar(max)
  DECLARE @CurrentCommand05 nvarchar(max)
  DECLARE @CurrentCommand06 nvarchar(max)
  DECLARE @CurrentCommand07 nvarchar(max)
  DECLARE @CurrentCommand08 nvarchar(max)
  DECLARE @CurrentCommand09 nvarchar(max)
  DECLARE @CurrentCommand10 nvarchar(max)
  DECLARE @CurrentCommand11 nvarchar(max)
  DECLARE @CurrentCommand12 nvarchar(max)

  DECLARE @CurrentCommandOutput09 int
  DECLARE @CurrentCommandOutput10 int

  DECLARE @CurrentCommandType09 nvarchar(max)
  DECLARE @CurrentCommandType10 nvarchar(max)

  DECLARE @CurrentIxID int
  DECLARE @CurrentSchemaID int
  DECLARE @CurrentSchemaName nvarchar(max)
  DECLARE @CurrentObjectID int
  DECLARE @CurrentObjectName nvarchar(max)
  DECLARE @CurrentObjectType nvarchar(max)
  DECLARE @CurrentIndexID int
  DECLARE @CurrentIndexName nvarchar(max)
  DECLARE @CurrentIndexType int
  DECLARE @CurrentStatisticsID int
  DECLARE @CurrentStatisticsName nvarchar(max)
  DECLARE @CurrentPartitionID bigint
  DECLARE @CurrentPartitionNumber int
  DECLARE @CurrentPartitionCount int
  DECLARE @CurrentIsPartition bit
  DECLARE @CurrentIndexExists bit
  DECLARE @CurrentStatisticsExists bit
  DECLARE @CurrentIsImageText bit
  DECLARE @CurrentIsNewLOB bit
  DECLARE @CurrentIsFileStream bit
  DECLARE @CurrentAllowPageLocks bit
  DECLARE @CurrentNoRecompute bit
  DECLARE @CurrentStatisticsModified bit
  DECLARE @CurrentOnReadOnlyFileGroup bit
  DECLARE @CurrentFragmentationLevel float
  DECLARE @CurrentPageCount bigint
  DECLARE @CurrentFragmentationGroup nvarchar(max)
  DECLARE @CurrentAction nvarchar(max)
  DECLARE @CurrentMaxDOP int
  DECLARE @CurrentUpdateStatistics nvarchar(max)
  DECLARE @CurrentComment nvarchar(max)
  DECLARE @CurrentExtendedInfo xml
  DECLARE @CurrentDelay datetime

  DECLARE @tmpDatabases TABLE (ID int IDENTITY PRIMARY KEY,
                               DatabaseName nvarchar(max),
                               Completed bit)

  DECLARE @tmpIndexesStatistics TABLE (IxID int IDENTITY,
                                       SchemaID int,
                                       SchemaName nvarchar(max),
                                       ObjectID int,
                                       ObjectName nvarchar(max),
                                       ObjectType nvarchar(max),
                                       IndexID int,
                                       IndexName nvarchar(max),
                                       IndexType int,
                                       StatisticsID int,
                                       StatisticsName nvarchar(max),
                                       PartitionID bigint,
                                       PartitionNumber int,
                                       PartitionCount int,
                                       Selected bit,
                                       Completed bit,
                                       PRIMARY KEY(Selected, Completed, IxID))

  DECLARE @SelectedIndexes TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  IndexName nvarchar(max),
                                  Selected bit)

  DECLARE @Actions TABLE ([Action] nvarchar(max))

  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_ONLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_OFFLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REORGANIZE')

  DECLARE @ActionsPreferred TABLE (FragmentationGroup nvarchar(max),
                                   [Priority] int,
                                   [Action] nvarchar(max))

  DECLARE @CurrentActionsAllowed TABLE ([Action] nvarchar(max))

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartTime = CONVERT(datetime,CONVERT(nvarchar,GETDATE(),120),120)

  SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,@StartTime,120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + (SELECT QUOTENAME(schemas.name) FROM sys.schemas schemas INNER JOIN sys.objects objects ON schemas.[schema_id] = objects.[schema_id] WHERE [object_id] = @@PROCID) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationLow = ' + ISNULL('''' + REPLACE(@FragmentationLow,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationMedium = ' + ISNULL('''' + REPLACE(@FragmentationMedium,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationHigh = ' + ISNULL('''' + REPLACE(@FragmentationHigh,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationLevel1 = ' + ISNULL(CAST(@FragmentationLevel1 AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @FragmentationLevel2 = ' + ISNULL(CAST(@FragmentationLevel2 AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @PageCountLevel = ' + ISNULL(CAST(@PageCountLevel AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @SortInTempdb = ' + ISNULL('''' + REPLACE(@SortInTempdb,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @FillFactor = ' + ISNULL(CAST(@FillFactor AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @PadIndex = ' + ISNULL('''' + REPLACE(@PadIndex,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @LOBCompaction = ' + ISNULL('''' + REPLACE(@LOBCompaction,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @UpdateStatistics = ' + ISNULL('''' + REPLACE(@UpdateStatistics,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @OnlyModifiedStatistics = ' + ISNULL('''' + REPLACE(@OnlyModifiedStatistics,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @StatisticsSample = ' + ISNULL(CAST(@StatisticsSample AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @StatisticsResample = ' + ISNULL('''' + REPLACE(@StatisticsResample,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @PartitionLevel = ' + ISNULL('''' + REPLACE(@PartitionLevel,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @TimeLimit = ' + ISNULL(CAST(@TimeLimit AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Indexes = ' + ISNULL('''' + REPLACE(@Indexes,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Delay = ' + ISNULL(CAST(@Delay AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL') + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Source: http://ola.hallengren.com' + CHAR(13) + CHAR(10) + ' '
  SET @StartMessage = REPLACE(@StartMessage,'%','%%')
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    SET @ErrorMessage = 'SQL Azure is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute is missing. Download http://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@LogToTable%')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute needs to be updated. Download http://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'TF' AND schemas.[name] = 'dbo' AND objects.[name] = 'DatabaseSelect')
  BEGIN
    SET @ErrorMessage = 'The function DatabaseSelect is missing. Download http://ola.hallengren.com/scripts/DatabaseSelect.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download http://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @Databases IS NULL OR @Databases = ''
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Databases is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  INSERT INTO @tmpDatabases (DatabaseName, Completed)
  SELECT DatabaseName AS DatabaseName,
         0 AS Completed
  FROM dbo.DatabaseSelect (@Databases)
  ORDER BY DatabaseName ASC

  IF @@ERROR <> 0
  BEGIN
    SET @ErrorMessage = 'Error selecting databases.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Select indexes                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @CurrentIndexList = @Indexes

  WHILE CHARINDEX(', ',@CurrentIndexList) > 0 SET @CurrentIndexList = REPLACE(@CurrentIndexList,', ',',')
  WHILE CHARINDEX(' ,',@CurrentIndexList) > 0 SET @CurrentIndexList = REPLACE(@CurrentIndexList,' ,',',')
  WHILE CHARINDEX(',,',@CurrentIndexList) > 0 SET @CurrentIndexList = REPLACE(@CurrentIndexList,',,',',')

  IF RIGHT(@CurrentIndexList,1) = ',' SET @CurrentIndexList = LEFT(@CurrentIndexList,LEN(@CurrentIndexList) - 1)
  IF LEFT(@CurrentIndexList,1) = ',' SET @CurrentIndexList = RIGHT(@CurrentIndexList,LEN(@CurrentIndexList) - 1)

  SET @CurrentIndexList = LTRIM(RTRIM(@CurrentIndexList))

  WHILE LEN(@CurrentIndexList) > 0
  BEGIN
    SET @CurrentIndexPosition = CHARINDEX(',', @CurrentIndexList)
    IF @CurrentIndexPosition = 0
    BEGIN
      SET @CurrentIndexItem = @CurrentIndexList
      SET @CurrentIndexList = ''
    END
    ELSE
    BEGIN
      SET @CurrentIndexItem = LEFT(@CurrentIndexList, @CurrentIndexPosition - 1)
      SET @CurrentIndexList = RIGHT(@CurrentIndexList, LEN(@CurrentIndexList) - @CurrentIndexPosition)
    END;

    WITH IndexItem01 (IndexItem, Selected) AS (
    SELECT CASE WHEN @CurrentIndexItem LIKE '-%' THEN RIGHT(@CurrentIndexItem,LEN(@CurrentIndexItem) - 1) ELSE @CurrentIndexItem END AS IndexItem,
           CASE WHEN @CurrentIndexItem LIKE '-%' THEN 0 ELSE 1 END AS Selected),
    IndexItem02 (IndexItem, Selected) AS (
    SELECT CASE WHEN IndexItem = 'ALL_INDEXES' THEN '%.%.%.%' ELSE IndexItem END AS IndexItem,
           Selected
    FROM IndexItem01)
    INSERT INTO @SelectedIndexes (DatabaseName, SchemaName, ObjectName, IndexName, Selected)
    SELECT DatabaseName = CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,3) ELSE PARSENAME(IndexItem,4) END,
           SchemaName = CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,2) ELSE PARSENAME(IndexItem,3) END,
           ObjectName = CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,1) ELSE PARSENAME(IndexItem,2) END,
           IndexName = CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN '%' ELSE PARSENAME(IndexItem,1) END,
           Selected
    FROM IndexItem02
  END

  IF EXISTS(SELECT * FROM @SelectedIndexes WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL OR IndexName IS NULL) OR (@Indexes IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedIndexes))
  BEGIN
    SET @ErrorMessage = 'Error selecting indexes.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END;

  ----------------------------------------------------------------------------------------------------
  --// Select actions                                                                             //--
  ----------------------------------------------------------------------------------------------------

  WITH FragmentationLow AS
  (
  SELECT CASE WHEN CHARINDEX(',', @FragmentationLow) = 0 THEN @FragmentationLow ELSE SUBSTRING(@FragmentationLow, 1, CHARINDEX(',', @FragmentationLow) - 1) END AS [Action],
         CASE WHEN CHARINDEX(',', @FragmentationLow) = 0 THEN '' ELSE SUBSTRING(@FragmentationLow, CHARINDEX(',', @FragmentationLow) + 1, LEN(@FragmentationLow)) END AS String,
         1 AS [Priority],
         CASE WHEN CHARINDEX(',', @FragmentationLow) = 0 THEN 0 ELSE 1 END [Continue]
  WHERE @FragmentationLow IS NOT NULL
  UNION ALL
  SELECT CASE WHEN CHARINDEX(',', String) = 0 THEN String ELSE SUBSTRING(String, 1, CHARINDEX(',', String) - 1) END AS [Action],
         CASE WHEN CHARINDEX(',', String) = 0 THEN '' ELSE SUBSTRING(String, CHARINDEX(',', String) + 1, LEN(String)) END AS String,
         [Priority] + 1  AS [Priority],
         CASE WHEN CHARINDEX(',', String) = 0 THEN 0 ELSE 1 END [Continue]
  FROM FragmentationLow
  WHERE [Continue] = 1
  ),
  FragmentationMedium AS
  (
  SELECT CASE WHEN CHARINDEX(',', @FragmentationMedium) = 0 THEN @FragmentationMedium ELSE SUBSTRING(@FragmentationMedium, 1, CHARINDEX(',', @FragmentationMedium) - 1) END AS [Action],
         CASE WHEN CHARINDEX(',', @FragmentationMedium) = 0 THEN '' ELSE SUBSTRING(@FragmentationMedium, CHARINDEX(',', @FragmentationMedium) + 1, LEN(@FragmentationMedium)) END AS String,
         1 AS [Priority],
         CASE WHEN CHARINDEX(',', @FragmentationMedium) = 0 THEN 0 ELSE 1 END [Continue]
  WHERE @FragmentationMedium IS NOT NULL
  UNION ALL
  SELECT CASE WHEN CHARINDEX(',', String) = 0 THEN String ELSE SUBSTRING(String, 1, CHARINDEX(',', String) - 1) END AS [Action],
         CASE WHEN CHARINDEX(',', String) = 0 THEN '' ELSE SUBSTRING(String, CHARINDEX(',', String) + 1, LEN(String)) END AS String,
         [Priority] + 1  AS [Priority],
         CASE WHEN CHARINDEX(',', String) = 0 THEN 0 ELSE 1 END [Continue]
  FROM FragmentationMedium
  WHERE [Continue] = 1
  ),
  FragmentationHigh AS
  (
  SELECT CASE WHEN CHARINDEX(',', @FragmentationHigh) = 0 THEN @FragmentationHigh ELSE SUBSTRING(@FragmentationHigh, 1, CHARINDEX(',', @FragmentationHigh) - 1) END AS [Action],
         CASE WHEN CHARINDEX(',', @FragmentationHigh) = 0 THEN '' ELSE SUBSTRING(@FragmentationHigh, CHARINDEX(',', @FragmentationHigh) + 1, LEN(@FragmentationHigh)) END AS String,
         1 AS [Priority],
         CASE WHEN CHARINDEX(',', @FragmentationHigh) = 0 THEN 0 ELSE 1 END [Continue]
  WHERE @FragmentationHigh IS NOT NULL
  UNION ALL
  SELECT CASE WHEN CHARINDEX(',', String) = 0 THEN String ELSE SUBSTRING(String, 1, CHARINDEX(',', String) - 1) END AS [Action],
         CASE WHEN CHARINDEX(',', String) = 0 THEN '' ELSE SUBSTRING(String, CHARINDEX(',', String) + 1, LEN(String)) END AS String,
         [Priority] + 1  AS [Priority],
         CASE WHEN CHARINDEX(',', String) = 0 THEN 0 ELSE 1 END [Continue]
  FROM FragmentationHigh
  WHERE [Continue] = 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Low' AS FragmentationGroup, [Priority], [Action]
  FROM FragmentationLow
  UNION
  SELECT 'Medium' AS FragmentationGroup, [Priority], [Action]
  FROM FragmentationMedium
  UNION
  SELECT 'High' AS FragmentationGroup, [Priority], [Action]
  FROM FragmentationHigh

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' AND [Action] NOT IN(SELECT * FROM @Actions))
  OR EXISTS(SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @FragmentationLow is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' AND [Action] NOT IN(SELECT * FROM @Actions))
  OR EXISTS(SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @FragmentationMedium is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'High' AND [Action] NOT IN(SELECT * FROM @Actions))
  OR EXISTS(SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'High' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @FragmentationHigh is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @FragmentationLevel1 <= 0 OR @FragmentationLevel1 >= 100 OR @FragmentationLevel1 >= @FragmentationLevel2 OR @FragmentationLevel1 IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @FragmentationLevel1 is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @FragmentationLevel2 <= 0 OR @FragmentationLevel2 >= 100 OR @FragmentationLevel2 <= @FragmentationLevel1 OR @FragmentationLevel2 IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @FragmentationLevel2 is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PageCountLevel < 0 OR @PageCountLevel IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @PageCountLevel is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @SortInTempdb NOT IN('Y','N') OR @SortInTempdb IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @SortInTempdb is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MaxDOP < 0 OR @MaxDOP > 64 OR @MaxDOP > (SELECT cpu_count FROM sys.dm_os_sys_info) OR (@MaxDOP > 1 AND SERVERPROPERTY('EngineEdition') <> 3)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @MaxDOP is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MaxDOP > 1 AND SERVERPROPERTY('EngineEdition') <> 3
  BEGIN
    SET @ErrorMessage = 'Parallel index operations are only supported in Enterprise, Developer and Datacenter Edition.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @FillFactor <= 0 OR @FillFactor > 100
  BEGIN
    SET @ErrorMessage = 'The value for parameter @FillFactor is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PadIndex NOT IN('Y','N')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @PadIndex is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LOBCompaction NOT IN('Y','N') OR @LOBCompaction IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @LOBCompaction is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @UpdateStatistics NOT IN('ALL','COLUMNS','INDEX')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @UpdateStatistics is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @OnlyModifiedStatistics NOT IN('Y','N') OR @OnlyModifiedStatistics IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @OnlyModifiedStatistics is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @StatisticsSample <= 0 OR @StatisticsSample  > 100
  BEGIN
    SET @ErrorMessage = 'The value for parameter @StatisticsSample is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @StatisticsResample NOT IN('Y','N') OR @StatisticsResample IS NULL OR (@StatisticsResample = 'Y' AND @StatisticsSample IS NOT NULL)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @StatisticsResample is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PartitionLevel NOT IN('Y','N') OR @PartitionLevel IS NULL OR (@PartitionLevel = 'Y' AND SERVERPROPERTY('EngineEdition') <> 3)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @PartitionLevel is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PartitionLevel = 'Y' AND SERVERPROPERTY('EngineEdition') <> 3
  BEGIN
    SET @ErrorMessage = 'Table partitioning is only supported in Enterprise, Developer and Datacenter Edition.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @TimeLimit < 0
  BEGIN
    SET @ErrorMessage = 'The value for parameter @TimeLimit is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Delay < 0
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Delay is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ErrorMessage = 'The documentation is available on http://ola.hallengren.com/Documentation.html.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
  BEGIN

    SELECT TOP 1 @CurrentID = ID,
                 @CurrentDatabaseName = DatabaseName
    FROM @tmpDatabases
    WHERE Completed = 0
    ORDER BY ID ASC

    SET @CurrentDatabaseID = DB_ID(@CurrentDatabaseName)

    IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = @CurrentDatabaseID AND database_guid IS NOT NULL)
    BEGIN
      SET @CurrentIsDatabaseAccessible = 1
    END
    ELSE
    BEGIN
      SET @CurrentIsDatabaseAccessible = 0
    END

    SELECT @CurrentMirroringRole = mirroring_role_desc
    FROM sys.database_mirroring
    WHERE database_id = @CurrentDatabaseID

    -- Set database message
    SET @DatabaseMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabaseName) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Mirroring role: ' + ISNULL(@CurrentMirroringRole,'N/A') + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Standby: ' + CASE WHEN DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Updateability: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'User access: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Recovery model: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') AS nvarchar) + CHAR(13) + CHAR(10) + ' '
    SET @DatabaseMessage = REPLACE(@DatabaseMessage,'%','%%')
    RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    AND NOT (DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') = 'READ_WRITE'
    BEGIN

      -- Select indexes in the current database
      IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IS NOT NULL
      BEGIN
        SET @CurrentCommand01 = 'SELECT SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IndexID, IndexName, IndexType, StatisticsID, StatisticsName, PartitionID, PartitionNumber, PartitionCount, Selected, Completed FROM ('

        IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IN('ALL','INDEX')
        BEGIN
          SET @CurrentCommand01 = @CurrentCommand01 + 'SELECT schemas.[schema_id] AS SchemaID, schemas.[name] AS SchemaName, objects.[object_id] AS ObjectID, objects.[name] AS ObjectName, RTRIM(objects.[type]) AS ObjectType, indexes.index_id AS IndexID, indexes.[name] AS IndexName, indexes.[type] AS IndexType, stats.stats_id AS StatisticsID, stats.name AS StatisticsName'
          IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', partitions.partition_id AS PartitionID, partitions.partition_number AS PartitionNumber, IndexPartitions.partition_count AS PartitionCount'
          IF @PartitionLevel = 'N' SET @CurrentCommand01 = @CurrentCommand01 + ', NULL AS PartitionID, NULL AS PartitionNumber, NULL AS PartitionCount'
          SET @CurrentCommand01 = @CurrentCommand01 + ', 0 AS Selected, 0 AS Completed FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats ON indexes.[object_id] = stats.[object_id] AND indexes.[index_id] = stats.[stats_id]'
          IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ' LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id LEFT OUTER JOIN (SELECT partitions.[object_id], partitions.index_id, COUNT(*) AS partition_count FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.partitions partitions GROUP BY partitions.[object_id], partitions.index_id) IndexPartitions ON partitions.[object_id] = IndexPartitions.[object_id] AND partitions.[index_id] = IndexPartitions.[index_id]'
          IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ' LEFT OUTER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.dm_db_partition_stats dm_db_partition_stats ON indexes.[object_id] = dm_db_partition_stats.[object_id] AND indexes.[index_id] = dm_db_partition_stats.[index_id] AND partitions.partition_id = dm_db_partition_stats.partition_id'
          IF @PartitionLevel = 'N' SET @CurrentCommand01 = @CurrentCommand01 + ' LEFT OUTER JOIN (SELECT dm_db_partition_stats.[object_id], dm_db_partition_stats.[index_id], SUM(dm_db_partition_stats.in_row_data_page_count) AS in_row_data_page_count FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.dm_db_partition_stats dm_db_partition_stats GROUP BY dm_db_partition_stats.[object_id], dm_db_partition_stats.[index_id]) dm_db_partition_stats ON indexes.[object_id] = dm_db_partition_stats.[object_id] AND indexes.[index_id] = dm_db_partition_stats.[index_id]'
          SET @CurrentCommand01 = @CurrentCommand01 + ' WHERE objects.[type] IN(''U'',''V'') AND objects.is_ms_shipped = 0 AND indexes.[type] IN(1,2,3,4) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0'
          IF (@UpdateStatistics NOT IN('ALL','INDEX') OR @UpdateStatistics IS NULL) AND @PageCountLevel > 0 SET @CurrentCommand01 = @CurrentCommand01 + ' AND (dm_db_partition_stats.in_row_data_page_count >= @ParamPageCountLevel OR dm_db_partition_stats.in_row_data_page_count IS NULL)'
          IF NOT EXISTS(SELECT * FROM @ActionsPreferred) SET @CurrentCommand01 = @CurrentCommand01 + ' AND stats.stats_id IS NOT NULL'
        END

        IF (EXISTS(SELECT * FROM @ActionsPreferred) AND @UpdateStatistics = 'COLUMNS') OR @UpdateStatistics = 'ALL' SET @CurrentCommand01 = @CurrentCommand01 + ' UNION '

        IF @UpdateStatistics IN('ALL','COLUMNS') SET @CurrentCommand01 = @CurrentCommand01 + 'SELECT schemas.[schema_id] AS SchemaID, schemas.[name] AS SchemaName, objects.[object_id] AS ObjectID, objects.[name] AS ObjectName, RTRIM(objects.[type]) AS ObjectType, NULL AS IndexID, NULL AS IndexName, NULL AS IndexType, stats.stats_id AS StatisticsID, stats.name AS StatisticsName, NULL AS PartitionID, NULL AS PartitionNumber, NULL AS PartitionCount, 0 AS Selected, 0 AS Completed FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON stats.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'') AND objects.is_ms_shipped = 0 AND NOT EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes WHERE indexes.[object_id] = stats.[object_id] AND indexes.index_id = stats.stats_id)'

        SET @CurrentCommand01 = @CurrentCommand01 + ') IndexesStatistics ORDER BY SchemaName ASC, ObjectName ASC'
        IF (EXISTS(SELECT * FROM @ActionsPreferred) AND @UpdateStatistics = 'COLUMNS') OR @UpdateStatistics = 'ALL' SET @CurrentCommand01 = @CurrentCommand01 + ', CASE WHEN IndexType IS NULL THEN 1 ELSE 0 END ASC'
        IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IN('ALL','INDEX') SET @CurrentCommand01 = @CurrentCommand01 + ', IndexType ASC, IndexName ASC'
        IF @UpdateStatistics IN('ALL','COLUMNS') SET @CurrentCommand01 = @CurrentCommand01 + ', StatisticsName ASC'
        IF @PartitionLevel = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', PartitionNumber ASC'

        INSERT INTO @tmpIndexesStatistics (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IndexID, IndexName, IndexType, StatisticsID, StatisticsName, PartitionID, PartitionNumber, PartitionCount, Selected, Completed)
        EXECUTE sp_executesql @statement = @CurrentCommand01, @params = N'@ParamPageCountLevel int', @ParamPageCountLevel = @PageCountLevel
        SET @Error = @@ERROR
        IF @Error <> 0 SET @ReturnCode = @Error
        IF @Error = 1222
        BEGIN
          SET @ErrorMessage = 'The system tables are locked in the database ' + QUOTENAME(@CurrentDatabaseName) + '.' + CHAR(13) + CHAR(10) + ' '
          SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
          RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
        END
      END

      IF @Indexes IS NULL
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = 1
        FROM @tmpIndexesStatistics tmpIndexesStatistics
      END
      ELSE
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 1

        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 0
      END

      WHILE EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE Selected = 1 AND Completed = 0)
      BEGIN

        SELECT TOP 1 @CurrentIxID = IxID,
                     @CurrentSchemaID = SchemaID,
                     @CurrentSchemaName = SchemaName,
                     @CurrentObjectID = ObjectID,
                     @CurrentObjectName = ObjectName,
                     @CurrentObjectType = ObjectType,
                     @CurrentIndexID = IndexID,
                     @CurrentIndexName = IndexName,
                     @CurrentIndexType = IndexType,
                     @CurrentStatisticsID = StatisticsID,
                     @CurrentStatisticsName = StatisticsName,
                     @CurrentPartitionID = PartitionID,
                     @CurrentPartitionNumber = PartitionNumber,
                     @CurrentPartitionCount = PartitionCount
        FROM @tmpIndexesStatistics
        WHERE Selected = 1
        AND Completed = 0
        ORDER BY IxID ASC

        -- Is the index a partition?
        IF @CurrentPartitionNumber IS NULL OR @CurrentPartitionCount = 1 BEGIN SET @CurrentIsPartition = 0 END ELSE BEGIN SET @CurrentIsPartition = 1 END

        -- Does the index exist?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentIsPartition = 0 SET @CurrentCommand02 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'') AND objects.is_ms_shipped = 0 AND indexes.[type] IN(1,2,3,4) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType) BEGIN SET @ParamIndexExists = 1 END'
          IF @CurrentIsPartition = 1 SET @CurrentCommand02 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id WHERE objects.[type] IN(''U'',''V'') AND objects.is_ms_shipped = 0 AND indexes.[type] IN(1,2,3,4) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType AND partitions.partition_id = @ParamPartitionID AND partitions.partition_number = @ParamPartitionNumber) BEGIN SET @ParamIndexExists = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand02, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamIndexID int, @ParamIndexName sysname, @ParamIndexType int, @ParamPartitionID bigint, @ParamPartitionNumber int, @ParamIndexExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamIndexID = @CurrentIndexID, @ParamIndexName = @CurrentIndexName, @ParamIndexType = @CurrentIndexType, @ParamPartitionID = @CurrentPartitionID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamIndexExists = @CurrentIndexExists OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIndexExists IS NULL SET @CurrentIndexExists = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
          IF @CurrentIndexExists = 0 GOTO NoAction
        END

        -- Does the statistics exist?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand03 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.objects objects ON stats.[object_id] = objects.[object_id] INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'') AND objects.is_ms_shipped = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND stats.stats_id = @ParamStatisticsID AND stats.[name] = @ParamStatisticsName) BEGIN SET @ParamStatisticsExists = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand03, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamStatisticsID int, @ParamStatisticsName sysname, @ParamStatisticsExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamStatisticsID = @CurrentStatisticsID, @ParamStatisticsName = @CurrentStatisticsName, @ParamStatisticsExists = @CurrentStatisticsExists OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentStatisticsExists IS NULL SET @CurrentStatisticsExists = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
          IF @CurrentStatisticsExists = 0 GOTO NoAction
        END

        -- Is one of the columns in the index an image, text or ntext data type?
        IF @CurrentIndexID IS NOT NULL AND @CurrentIndexType IN(1) AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentIndexType = 1 SET @CurrentCommand11 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.types types ON columns.system_type_id = types.user_type_id WHERE columns.[object_id] = @ParamObjectID AND types.name IN(''image'',''text'',''ntext'')) BEGIN SET @ParamIsImageText = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand11, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamIsImageText bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamIsImageText = @CurrentIsImageText OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIsImageText IS NULL SET @CurrentIsImageText = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is one of the columns in the index an xml, varchar(max), nvarchar(max), varbinary(max) or large CLR data type?
        IF @CurrentIndexID IS NOT NULL AND @CurrentIndexType IN(1,2) AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentIndexType = 1 SET @CurrentCommand04 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE columns.[object_id] = @ParamObjectID AND (types.name IN(''xml'') OR (types.name IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) BEGIN SET @ParamIsNewLOB = 1 END'
          IF @CurrentIndexType = 2 SET @CurrentCommand04 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.index_columns index_columns INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE index_columns.[object_id] = @ParamObjectID AND index_columns.index_id = @ParamIndexID AND (types.[name] IN(''xml'') OR (types.[name] IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) BEGIN SET @ParamIsNewLOB = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand04, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamIsNewLOB bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamIsNewLOB = @CurrentIsNewLOB OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIsNewLOB IS NULL SET @CurrentIsNewLOB = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is one of the columns in the index a file stream column?
        IF @CurrentIndexID IS NOT NULL AND @CurrentIndexType IN(1) AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentIndexType = 1 SET @CurrentCommand12 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.columns columns WHERE columns.[object_id] = @ParamObjectID  AND columns.is_filestream = 1) BEGIN SET @ParamIsFileStream = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand12, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamIsFileStream bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamIsFileStream = @CurrentIsFileStream OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentIsFileStream IS NULL SET @CurrentIsFileStream = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is Allow_Page_Locks set to On?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand05 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes WHERE indexes.[object_id] = @ParamObjectID AND indexes.[index_id] = @ParamIndexID AND indexes.[allow_page_locks] = 1) BEGIN SET @ParamAllowPageLocks = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand05, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamAllowPageLocks bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamAllowPageLocks = @CurrentAllowPageLocks OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentAllowPageLocks IS NULL SET @CurrentAllowPageLocks = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is No_Recompute set to On?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand06 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.stats stats WHERE stats.[object_id] = @ParamObjectID AND stats.[stats_id] = @ParamStatisticsID AND stats.[no_recompute] = 1) BEGIN SET @ParamNoRecompute = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand06, @params = N'@ParamObjectID int, @ParamStatisticsID int, @ParamNoRecompute bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamStatisticsID = @CurrentStatisticsID, @ParamNoRecompute = @CurrentNoRecompute OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentNoRecompute IS NULL SET @CurrentNoRecompute = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Has the data in the statistics been modified since the statistics was last updated?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL AND @OnlyModifiedStatistics = 'Y'
        BEGIN
          SET @CurrentCommand07 = 'IF EXISTS(SELECT * FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.sysindexes sysindexes WHERE sysindexes.[id] = @ParamObjectID AND sysindexes.[indid] = @ParamStatisticsID AND sysindexes.[rowmodctr] <> 0) BEGIN SET @ParamStatisticsModified = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand07, @params = N'@ParamObjectID int, @ParamStatisticsID int, @ParamStatisticsModified bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamStatisticsID = @CurrentStatisticsID, @ParamStatisticsModified = @CurrentStatisticsModified OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentStatisticsModified IS NULL SET @CurrentStatisticsModified = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is the index on a read-only filegroup?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand08 = 'IF EXISTS(SELECT * FROM (SELECT filegroups.data_space_id FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.destination_data_spaces destination_data_spaces ON indexes.data_space_id = destination_data_spaces.partition_scheme_id INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups ON destination_data_spaces.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes.[object_id] = @ParamObjectID AND indexes.[index_id] = @ParamIndexID'
          IF @CurrentIsPartition = 1 SET @CurrentCommand08 = @CurrentCommand08 + ' AND destination_data_spaces.destination_id = @ParamPartitionNumber'
          SET @CurrentCommand08 = @CurrentCommand08 + ' UNION SELECT filegroups.data_space_id FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.indexes indexes INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups ON indexes.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes.[object_id] = @ParamObjectID AND indexes.[index_id] = @ParamIndexID'
          IF @CurrentIndexType = 1 SET @CurrentCommand08 = @CurrentCommand08 + ' UNION SELECT filegroups.data_space_id FROM ' + QUOTENAME(@CurrentDatabaseName) + '.sys.tables tables INNER JOIN ' + QUOTENAME(@CurrentDatabaseName) + '.sys.filegroups filegroups ON tables.lob_data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND tables.[object_id] = @ParamObjectID'
          SET @CurrentCommand08 = @CurrentCommand08 + ') ReadOnlyFileGroups) BEGIN SET @ParamOnReadOnlyFileGroup = 1 END'

          EXECUTE sp_executesql @statement = @CurrentCommand08, @params = N'@ParamObjectID int, @ParamIndexID int, @ParamPartitionNumber int, @ParamOnReadOnlyFileGroup bit OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamOnReadOnlyFileGroup = @CurrentOnReadOnlyFileGroup OUTPUT
          SET @Error = @@ERROR
          IF @Error = 0 AND @CurrentOnReadOnlyFileGroup IS NULL SET @CurrentOnReadOnlyFileGroup = 0
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Is the index fragmented?
        IF @CurrentIndexID IS NOT NULL
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3) OR @PageCountLevel > 0)
        BEGIN
          SELECT @CurrentFragmentationLevel = MAX(avg_fragmentation_in_percent),
                 @CurrentPageCount = SUM(page_count)
          FROM sys.dm_db_index_physical_stats(@CurrentDatabaseID, @CurrentObjectID, @CurrentIndexID, @CurrentPartitionNumber, 'LIMITED')
          WHERE alloc_unit_type_desc = 'IN_ROW_DATA'
          AND index_level = 0
          SET @Error = @@ERROR
          IF @Error = 1222
          BEGIN
            SET @ErrorMessage = 'The dynamic management view sys.dm_db_index_physical_stats is locked on the index ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + '.' + QUOTENAME(@CurrentIndexName) + '.' + CHAR(13) + CHAR(10) + ' '
            SET @ErrorMessage = REPLACE(@ErrorMessage,'%','%%')
            RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
            END
          IF @Error <> 0
          BEGIN
            SET @ReturnCode = @Error
            GOTO NoAction
          END
        END

        -- Select fragmentation group
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentFragmentationGroup = CASE
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel2 THEN 'High'
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel1 AND @CurrentFragmentationLevel < @FragmentationLevel2 THEN 'Medium'
          WHEN @CurrentFragmentationLevel < @FragmentationLevel1 THEN 'Low'
          END
        END

        -- Which actions are allowed?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentOnReadOnlyFileGroup = 0 AND @CurrentAllowPageLocks = 1
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REORGANIZE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_OFFLINE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0
          AND @CurrentIsPartition = 0
          AND ((@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 2 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsFileStream = 0 AND @Version >= 11)
          OR (@CurrentIndexType = 2 AND @Version >= 11))
          AND SERVERPROPERTY('EngineEdition') = 3
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_ONLINE')
          END
        END

        -- Decide action
        IF @CurrentIndexID IS NOT NULL
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (@CurrentPageCount >= @PageCountLevel OR @PageCountLevel = 0)
        BEGIN
          IF EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3)
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE FragmentationGroup = @CurrentFragmentationGroup
            AND [Priority] = (SELECT MIN([Priority])
                              FROM @ActionsPreferred
                              WHERE FragmentationGroup = @CurrentFragmentationGroup
                              AND [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
          ELSE
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE [Priority] = (SELECT MIN([Priority])
                                FROM @ActionsPreferred
                                WHERE [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
        END

        -- Workaround for a bug in SQL Server 2005, SQL Server 2008 and SQL Server 2008 R2, http://support.microsoft.com/kb/2292737
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentMaxDOP = @MaxDOP
          IF @Version < 11 AND @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentAllowPageLocks = 0
          BEGIN
            SET @CurrentMaxDOP = 1
          END
        END

        -- Update statistics?
        IF @CurrentStatisticsID IS NOT NULL
        AND (@UpdateStatistics = 'ALL' OR (@UpdateStatistics = 'INDEX' AND @CurrentIndexID IS NOT NULL) OR (@UpdateStatistics = 'COLUMNS' AND @CurrentIndexID IS NULL))
        AND (@CurrentStatisticsModified = 1 OR @OnlyModifiedStatistics = 'N')
        AND ((@CurrentIsPartition = 0 AND (@CurrentAction NOT IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') OR @CurrentAction IS NULL)) OR (@CurrentIsPartition = 1 AND @CurrentPartitionNumber = @CurrentPartitionCount))
        BEGIN
          SET @CurrentUpdateStatistics = 'Y'
        END
        ELSE
        BEGIN
          SET @CurrentUpdateStatistics = 'N'
        END

        -- Create comment
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'ImageText: ' + CASE WHEN @CurrentIsImageText = 1 THEN 'Yes' WHEN @CurrentIsImageText = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'NewLOB: ' + CASE WHEN @CurrentIsNewLOB = 1 THEN 'Yes' WHEN @CurrentIsNewLOB = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'FileStream: ' + CASE WHEN @CurrentIsFileStream = 1 THEN 'Yes' WHEN @CurrentIsFileStream = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'AllowPageLocks: ' + CASE WHEN @CurrentAllowPageLocks = 1 THEN 'Yes' WHEN @CurrentAllowPageLocks = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment = @CurrentComment + 'PageCount: ' + ISNULL(CAST(@CurrentPageCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment = @CurrentComment + 'Fragmentation: ' + ISNULL(CAST(@CurrentFragmentationLevel AS nvarchar),'N/A')
        END

        IF @CurrentIndexID IS NOT NULL AND (@CurrentPageCount IS NOT NULL OR @CurrentFragmentationLevel IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentPageCount AS nvarchar) AS [PageCount],
                                                 CAST(@CurrentFragmentationLevel AS nvarchar) AS Fragmentation
                                    ) ExtendedInfo FOR XML AUTO, ELEMENTS)
        END

        -- Check time limit
        IF GETDATE() >= DATEADD(ss,@TimeLimit,@StartTime)
        BEGIN
          SET @Execute = 'N'
        END

        IF @CurrentIndexID IS NOT NULL AND @CurrentAction IS NOT NULL
        BEGIN
          SET @CurrentCommandType09 = 'ALTER_INDEX'

          SET @CurrentCommand09 = 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName)

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE')
          BEGIN
            SET @CurrentCommand09 = @CurrentCommand09 + ' REBUILD'
            IF @CurrentIsPartition = 1 SET @CurrentCommand09 = @CurrentCommand09 + ' PARTITION = ' + CAST(@CurrentPartitionNumber AS nvarchar)
            SET @CurrentCommand09 = @CurrentCommand09 + ' WITH ('
            IF @SortInTempdb = 'Y' SET @CurrentCommand09 = @CurrentCommand09 + 'SORT_IN_TEMPDB = ON'
            IF @SortInTempdb = 'N' SET @CurrentCommand09 = @CurrentCommand09 + 'SORT_IN_TEMPDB = OFF'
            IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentIsPartition = 0 SET @CurrentCommand09 = @CurrentCommand09 + ', ONLINE = ON'
            IF @CurrentAction = 'INDEX_REBUILD_OFFLINE' AND @CurrentIsPartition = 0 SET @CurrentCommand09 = @CurrentCommand09 + ', ONLINE = OFF'
            IF @CurrentMaxDOP IS NOT NULL SET @CurrentCommand09 = @CurrentCommand09 + ', MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
            IF @FillFactor IS NOT NULL AND @CurrentIsPartition = 0 SET @CurrentCommand09 = @CurrentCommand09 + ', FILLFACTOR = ' + CAST(@FillFactor AS nvarchar)
            IF @PadIndex = 'Y' AND @CurrentIsPartition = 0 SET @CurrentCommand09 = @CurrentCommand09 + ', PAD_INDEX = ON'
            IF @PadIndex = 'N' AND @CurrentIsPartition = 0 SET @CurrentCommand09 = @CurrentCommand09 + ', PAD_INDEX = OFF'
            SET @CurrentCommand09 = @CurrentCommand09 + ')'
          END

          IF @CurrentAction IN('INDEX_REORGANIZE')
          BEGIN
            SET @CurrentCommand09 = @CurrentCommand09 + ' REORGANIZE'
            IF @CurrentIsPartition = 1 SET @CurrentCommand09 = @CurrentCommand09 + ' PARTITION = ' + CAST(@CurrentPartitionNumber AS nvarchar)
            SET @CurrentCommand09 = @CurrentCommand09 + ' WITH ('
            IF @LOBCompaction = 'Y' SET @CurrentCommand09 = @CurrentCommand09 + 'LOB_COMPACTION = ON'
            IF @LOBCompaction = 'N' SET @CurrentCommand09 = @CurrentCommand09 + 'LOB_COMPACTION = OFF'
            SET @CurrentCommand09 = @CurrentCommand09 + ')'
          END

          EXECUTE @CurrentCommandOutput09 = [dbo].[CommandExecute] @Command = @CurrentCommand09, @CommandType = @CurrentCommandType09, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @PartitionNumber = @CurrentPartitionNumber, @ExtendedInfo = @CurrentExtendedInfo, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput09 = @Error
          IF @CurrentCommandOutput09 <> 0 SET @ReturnCode = @CurrentCommandOutput09

          IF @Delay > 0
          BEGIN
            SET @CurrentDelay = DATEADD(ss,@Delay,'1900-01-01')
            WAITFOR DELAY @CurrentDelay
          END
        END

        IF @CurrentStatisticsID IS NOT NULL AND @CurrentUpdateStatistics = 'Y'
        BEGIN
          SET @CurrentCommandType10 = 'UPDATE_STATISTICS'

          SET @CurrentCommand10 = 'UPDATE STATISTICS ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' ' + QUOTENAME(@CurrentStatisticsName)
          IF @StatisticsSample IS NOT NULL OR @StatisticsResample = 'Y' OR @CurrentNoRecompute = 1 SET @CurrentCommand10 = @CurrentCommand10 + ' WITH'
          IF @StatisticsSample = 100 SET @CurrentCommand10 = @CurrentCommand10 + ' FULLSCAN'
          IF @StatisticsSample IS NOT NULL AND @StatisticsSample <> 100 SET @CurrentCommand10 = @CurrentCommand10 + ' SAMPLE ' + CAST(@StatisticsSample AS nvarchar) + ' PERCENT'
          IF @StatisticsResample = 'Y' SET @CurrentCommand10 = @CurrentCommand10 + ' RESAMPLE'
          IF (@StatisticsSample IS NOT NULL OR @StatisticsResample = 'Y') AND @CurrentNoRecompute = 1 SET @CurrentCommand10 = @CurrentCommand10 + ','
          IF @CurrentNoRecompute = 1 SET @CurrentCommand10 = @CurrentCommand10 + ' NORECOMPUTE'

          EXECUTE @CurrentCommandOutput10 = [dbo].[CommandExecute] @Command = @CurrentCommand10, @CommandType = @CurrentCommandType10, @Mode = 2, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @StatisticsName = @CurrentStatisticsName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput10 = @Error
          IF @CurrentCommandOutput10 <> 0 SET @ReturnCode = @CurrentCommandOutput10
        END

        NoAction:

        -- Update that the index is completed
        UPDATE @tmpIndexesStatistics
        SET Completed = 1
        WHERE Selected = 1
        AND Completed = 0
        AND IxID = @CurrentIxID

        -- Clear variables
        SET @CurrentCommand02 = NULL
        SET @CurrentCommand03 = NULL
        SET @CurrentCommand04 = NULL
        SET @CurrentCommand05 = NULL
        SET @CurrentCommand06 = NULL
        SET @CurrentCommand07 = NULL
        SET @CurrentCommand08 = NULL
        SET @CurrentCommand09 = NULL
        SET @CurrentCommand10 = NULL

        SET @CurrentCommandOutput09 = NULL
        SET @CurrentCommandOutput10 = NULL

        SET @CurrentCommandType09 = NULL
        SET @CurrentCommandType10 = NULL

        SET @CurrentIxID = NULL
        SET @CurrentSchemaID = NULL
        SET @CurrentSchemaName = NULL
        SET @CurrentObjectID = NULL
        SET @CurrentObjectName = NULL
        SET @CurrentObjectType = NULL
        SET @CurrentIndexID = NULL
        SET @CurrentIndexName = NULL
        SET @CurrentIndexType = NULL
        SET @CurrentStatisticsID = NULL
        SET @CurrentStatisticsName = NULL
        SET @CurrentPartitionID = NULL
        SET @CurrentPartitionNumber = NULL
        SET @CurrentPartitionCount = NULL
        SET @CurrentIsPartition = NULL
        SET @CurrentIndexExists = NULL
        SET @CurrentStatisticsExists = NULL
        SET @CurrentIsImageText = NULL
        SET @CurrentIsNewLOB = NULL
        SET @CurrentIsFileStream = NULL
        SET @CurrentAllowPageLocks = NULL
        SET @CurrentNoRecompute = NULL
        SET @CurrentStatisticsModified = NULL
        SET @CurrentOnReadOnlyFileGroup = NULL
        SET @CurrentFragmentationLevel = NULL
        SET @CurrentPageCount = NULL
        SET @CurrentFragmentationGroup = NULL
        SET @CurrentAction = NULL
        SET @CurrentMaxDOP = NULL
        SET @CurrentUpdateStatistics = NULL
        SET @CurrentComment = NULL
        SET @CurrentExtendedInfo = NULL

        DELETE FROM @CurrentActionsAllowed

      END

    END

    -- Update that the database is completed
    UPDATE @tmpDatabases
    SET Completed = 1
    WHERE ID = @CurrentID

    -- Clear variables
    SET @CurrentID = NULL
    SET @CurrentDatabaseID = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentMirroringRole = NULL

    SET @CurrentCommand01 = NULL

    DELETE FROM @tmpIndexesStatistics

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120)
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END
GO
/****** Object:  StoredProcedure [dbo].[DatabaseIntegrityCheck]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DatabaseIntegrityCheck]

@Databases nvarchar(max),
@PhysicalOnly nvarchar(max) = 'N',
@NoIndex nvarchar(max) = 'N',
@ExtendedLogicalChecks nvarchar(max) = 'N',
@TabLock nvarchar(max) = 'N',
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: http://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @Version numeric(18,10)

  DECLARE @CurrentID int
  DECLARE @CurrentDatabaseID int
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentMirroringRole nvarchar(max)

  DECLARE @CurrentCommand01 nvarchar(max)

  DECLARE @CurrentCommandOutput01 int

  DECLARE @CurrentCommandType01 nvarchar(max)

  DECLARE @tmpDatabases TABLE (ID int IDENTITY PRIMARY KEY,
                               DatabaseName nvarchar(max),
                               Completed bit)

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + (SELECT QUOTENAME(schemas.name) FROM sys.schemas schemas INNER JOIN sys.objects objects ON schemas.[schema_id] = objects.[schema_id] WHERE [object_id] = @@PROCID) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @PhysicalOnly = ' + ISNULL('''' + REPLACE(@PhysicalOnly,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @NoIndex = ' + ISNULL('''' + REPLACE(@NoIndex,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @ExtendedLogicalChecks = ' + ISNULL('''' + REPLACE(@ExtendedLogicalChecks,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @TabLock = ' + ISNULL('''' + REPLACE(@TabLock,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL') + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Source: http://ola.hallengren.com' + CHAR(13) + CHAR(10) + ' '
  SET @StartMessage = REPLACE(@StartMessage,'%','%%')
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    SET @ErrorMessage = 'SQL Azure is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute is missing. Download http://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@LogToTable%')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute needs to be updated. Download http://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'TF' AND schemas.[name] = 'dbo' AND objects.[name] = 'DatabaseSelect')
  BEGIN
    SET @ErrorMessage = 'The function DatabaseSelect is missing. Download http://ola.hallengren.com/scripts/DatabaseSelect.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download http://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @Databases IS NULL OR @Databases = ''
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Databases is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  INSERT INTO @tmpDatabases (DatabaseName, Completed)
  SELECT DatabaseName AS DatabaseName,
         0 AS Completed
  FROM dbo.DatabaseSelect (@Databases)
  ORDER BY DatabaseName ASC

  IF @@ERROR <> 0
  BEGIN
    SET @ErrorMessage = 'Error selecting databases.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @PhysicalOnly NOT IN ('Y','N') OR @PhysicalOnly IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @PhysicalOnly is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @NoIndex NOT IN ('Y','N') OR @NoIndex IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @NoIndex is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @ExtendedLogicalChecks NOT IN ('Y','N') OR @ExtendedLogicalChecks IS NULL OR (@ExtendedLogicalChecks = 'Y' AND NOT @Version >= 10)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @ExtendedLogicalChecks is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @PhysicalOnly = 'Y' AND @ExtendedLogicalChecks = 'Y'
  BEGIN
    SET @ErrorMessage = 'Extended Logical Checks and Physical Only cannot be used together.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@ExtendedLogicalChecks = 'Y' AND NOT (@Version >= 10))
  BEGIN
    SET @ErrorMessage = 'Extended Logical Checks are only supported in SQL Server 2008 and SQL Server 2008 R2.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @TabLock NOT IN ('Y','N') OR @TabLock IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @TabLock is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ErrorMessage = 'The documentation is available on http://ola.hallengren.com/Documentation.html.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
  BEGIN

    SELECT TOP 1 @CurrentID = ID,
                 @CurrentDatabaseName = DatabaseName
    FROM @tmpDatabases
    WHERE Completed = 0
    ORDER BY ID ASC

    SET @CurrentDatabaseID = DB_ID(@CurrentDatabaseName)

    IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = @CurrentDatabaseID AND database_guid IS NOT NULL)
    BEGIN
      SET @CurrentIsDatabaseAccessible = 1
    END
    ELSE
    BEGIN
      SET @CurrentIsDatabaseAccessible = 0
    END

    SELECT @CurrentMirroringRole = mirroring_role_desc
    FROM sys.database_mirroring
    WHERE database_id = @CurrentDatabaseID

    -- Set database message
    SET @DatabaseMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabaseName) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Mirroring role: ' + ISNULL(@CurrentMirroringRole,'N/A') + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Standby: ' + CASE WHEN DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Updateability: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'User access: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Recovery model: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') AS nvarchar) + CHAR(13) + CHAR(10) + ' '
    SET @DatabaseMessage = REPLACE(@DatabaseMessage,'%','%%')
    RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    AND NOT (DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    BEGIN
      SET @CurrentCommandType01 = 'DBCC_CHECKDB'

      SET @CurrentCommand01 = 'DBCC CHECKDB (' + QUOTENAME(@CurrentDatabaseName)
      IF @NoIndex = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', NOINDEX'
      SET @CurrentCommand01 = @CurrentCommand01 + ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
      IF @PhysicalOnly = 'N' SET @CurrentCommand01 = @CurrentCommand01 + ', DATA_PURITY'
      IF @PhysicalOnly = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', PHYSICAL_ONLY'
      IF @ExtendedLogicalChecks = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', EXTENDED_LOGICAL_CHECKS'
      IF @TabLock = 'Y' SET @CurrentCommand01 = @CurrentCommand01 + ', TABLOCK'

      EXECUTE @CurrentCommandOutput01 = [dbo].[CommandExecute] @Command = @CurrentCommand01, @CommandType = @CurrentCommandType01, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
      SET @Error = @@ERROR
      IF @Error <> 0 SET @CurrentCommandOutput01 = @Error
      IF @CurrentCommandOutput01 <> 0 SET @ReturnCode = @CurrentCommandOutput01
    END

    -- Update that the database is completed
    UPDATE @tmpDatabases
    SET Completed = 1
    WHERE ID = @CurrentID

    -- Clear variables
    SET @CurrentID = NULL
    SET @CurrentDatabaseID = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentMirroringRole = NULL

    SET @CurrentCommand01 = NULL

    SET @CurrentCommandOutput01 = NULL

    SET @CurrentCommandType01 = NULL

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120)
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END
GO
/****** Object:  StoredProcedure [dbo].[DatabaseBackup]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DatabaseBackup]

@Databases nvarchar(max),
@Directory nvarchar(max) = NULL,
@BackupType nvarchar(max),
@Verify nvarchar(max) = 'N',
@CleanupTime int = NULL,
@Compress nvarchar(max) = NULL,
@CopyOnly nvarchar(max) = 'N',
@ChangeBackupType nvarchar(max) = 'N',
@BackupSoftware nvarchar(max) = NULL,
@CheckSum nvarchar(max) = 'N',
@BlockSize int = NULL,
@BufferCount int = NULL,
@MaxTransferSize int = NULL,
@NumberOfFiles int = 1,
@CompressionLevel int = NULL,
@Description nvarchar(max) = NULL,
@Threads int = NULL,
@Throttle int = NULL,
@Encrypt nvarchar(max) = 'N',
@EncryptionType nvarchar(max) = NULL,
@EncryptionKey nvarchar(max) = NULL,
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source: http://ola.hallengren.com                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @Version numeric(18,10)

  DECLARE @DefaultDirectory nvarchar(4000)
  DECLARE @CheckDirectory nvarchar(4000)

  DECLARE @CurrentID int
  DECLARE @CurrentDatabaseID int
  DECLARE @CurrentDatabaseName nvarchar(max)
  DECLARE @CurrentBackupType nvarchar(max)
  DECLARE @CurrentFileExtension nvarchar(max)
  DECLARE @CurrentFileNumber int
  DECLARE @CurrentDifferentialLSN numeric(25,0)
  DECLARE @CurrentLogLSN numeric(25,0)
  DECLARE @CurrentLatestBackup datetime
  DECLARE @CurrentDatabaseNameFS nvarchar(max)
  DECLARE @CurrentDirectory nvarchar(max)
  DECLARE @CurrentFilePath nvarchar(max)
  DECLARE @CurrentDate datetime
  DECLARE @CurrentCleanupDate datetime
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentMirroringRole nvarchar(max)

  DECLARE @CurrentCommand01 nvarchar(max)
  DECLARE @CurrentCommand02 nvarchar(max)
  DECLARE @CurrentCommand03 nvarchar(max)
  DECLARE @CurrentCommand04 nvarchar(max)

  DECLARE @CurrentCommandOutput01 int
  DECLARE @CurrentCommandOutput02 int
  DECLARE @CurrentCommandOutput03 int
  DECLARE @CurrentCommandOutput04 int

  DECLARE @CurrentCommandType01 nvarchar(max)
  DECLARE @CurrentCommandType02 nvarchar(max)
  DECLARE @CurrentCommandType03 nvarchar(max)
  DECLARE @CurrentCommandType04 nvarchar(max)

  DECLARE @DirectoryInfo TABLE (FileExists bit,
                                FileIsADirectory bit,
                                ParentDirectoryExists bit)

  DECLARE @tmpDatabases TABLE (ID int IDENTITY PRIMARY KEY,
                               DatabaseName nvarchar(max),
                               Completed bit)

  DECLARE @CurrentFiles TABLE (CurrentFilePath nvarchar(max))

  DECLARE @Error int
  DECLARE @ReturnCode int

  SET @Error = 0
  SET @ReturnCode = 0

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + (SELECT QUOTENAME(schemas.name) FROM sys.schemas schemas INNER JOIN sys.objects objects ON schemas.[schema_id] = objects.[schema_id] WHERE [object_id] = @@PROCID) + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Parameters: @Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Directory = ' + ISNULL('''' + REPLACE(@Directory,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @BackupType = ' + ISNULL('''' + REPLACE(@BackupType,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Verify = ' + ISNULL('''' + REPLACE(@Verify,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Compress = ' + ISNULL('''' + REPLACE(@Compress,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @CopyOnly = ' + ISNULL('''' + REPLACE(@CopyOnly,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @ChangeBackupType = ' + ISNULL('''' + REPLACE(@ChangeBackupType,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @BackupSoftware = ' + ISNULL('''' + REPLACE(@BackupSoftware,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @CheckSum = ' + ISNULL('''' + REPLACE(@CheckSum,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @BlockSize = ' + ISNULL(CAST(@BlockSize AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @BufferCount = ' + ISNULL(CAST(@BufferCount AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @MaxTransferSize = ' + ISNULL(CAST(@MaxTransferSize AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @NumberOfFiles = ' + ISNULL(CAST(@NumberOfFiles AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @CompressionLevel = ' + ISNULL(CAST(@CompressionLevel AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Description = ' + ISNULL('''' + REPLACE(@Description,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Threads = ' + ISNULL(CAST(@Threads AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Throttle = ' + ISNULL(CAST(@Throttle AS nvarchar),'NULL')
  SET @StartMessage = @StartMessage + ', @Encrypt = ' + ISNULL('''' + REPLACE(@Encrypt,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @EncryptionType = ' + ISNULL('''' + REPLACE(@EncryptionType,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @EncryptionKey = ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @StartMessage = @StartMessage + ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL') + CHAR(13) + CHAR(10)
  SET @StartMessage = @StartMessage + 'Source: http://ola.hallengren.com' + CHAR(13) + CHAR(10) + ' '
  SET @StartMessage = REPLACE(@StartMessage,'%','%%')
  RAISERROR(@StartMessage,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    SET @ErrorMessage = 'SQL Azure is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute is missing. Download http://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@LogToTable%')
  BEGIN
    SET @ErrorMessage = 'The stored procedure CommandExecute needs to be updated. Download http://ola.hallengren.com/scripts/CommandExecute.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'TF' AND schemas.[name] = 'dbo' AND objects.[name] = 'DatabaseSelect')
  BEGIN
    SET @ErrorMessage = 'The function DatabaseSelect is missing. Download http://ola.hallengren.com/scripts/DatabaseSelect.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    SET @ErrorMessage = 'The table CommandLog is missing. Download http://ola.hallengren.com/scripts/CommandLog.sql.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @Databases IS NULL OR @Databases = ''
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Databases is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  INSERT INTO @tmpDatabases (DatabaseName, Completed)
  SELECT DatabaseName AS DatabaseName,
         0 AS Completed
  FROM dbo.DatabaseSelect (@Databases)
  ORDER BY DatabaseName ASC

  IF @@ERROR <> 0
  BEGIN
    SET @ErrorMessage = 'Error selecting databases.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @tmpDatabases
  WHERE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DatabaseName,'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''),' ','') = ''
  ORDER BY DatabaseName ASC
  IF @@ROWCOUNT > 0
  BEGIN
    SET @ErrorMessage = 'The names of the following databases are not supported; ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  SET @ErrorMessage = '';
  WITH tmpDatabasesCTE
  AS
  (
  SELECT name AS DatabaseName,
         UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name,'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''),' ','')) AS DatabaseNameFS
  FROM sys.databases
  )
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM tmpDatabasesCTE
  WHERE DatabaseNameFS IN(SELECT DatabaseNameFS FROM tmpDatabasesCTE GROUP BY DatabaseNameFS HAVING COUNT(*) > 1)
  AND DatabaseNameFS IN(SELECT UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DatabaseName COLLATE DATABASE_DEFAULT,'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''),' ','')) FROM @tmpDatabases)
  AND DatabaseNameFS <> ''
  ORDER BY DatabaseNameFS ASC, DatabaseName ASC
  IF @@ROWCOUNT > 0
  BEGIN
    SET @ErrorMessage = 'The names of the following databases are not unique in the file system; ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Get default backup directory                                                               //--
  ----------------------------------------------------------------------------------------------------

  IF @Directory IS NULL
  BEGIN
    EXECUTE [master].dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', @DefaultDirectory OUTPUT
    SET @Directory = @DefaultDirectory
  END

  ----------------------------------------------------------------------------------------------------
  --// Get default compression                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF @Compress IS NULL
  BEGIN
    SELECT @Compress = CASE
    WHEN @BackupSoftware IS NULL AND EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'Y'
    WHEN @BackupSoftware IS NULL AND NOT EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'N'
    WHEN @BackupSoftware IS NOT NULL AND (@CompressionLevel IS NULL OR @CompressionLevel > 0)  THEN 'Y'
    WHEN @BackupSoftware IS NOT NULL AND @CompressionLevel = 0  THEN 'N'
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Check directory                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (@Directory LIKE '_:' OR @Directory LIKE '_:\%' OR @Directory LIKE '\\%\%') OR @Directory IS NULL OR LEFT(@Directory,1) = ' ' OR RIGHT(@Directory,1) = ' '
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Directory is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  SET @CheckDirectory = @Directory

  INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
  EXECUTE [master].dbo.xp_fileexist @CheckDirectory

  IF NOT EXISTS (SELECT * FROM @DirectoryInfo WHERE FileExists = 0 AND FileIsADirectory = 1 AND ParentDirectoryExists = 1)
  BEGIN
    SET @ErrorMessage = 'The directory does not exist.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @BackupType NOT IN ('FULL','DIFF','LOG') OR @BackupType IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @BackupType is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Verify NOT IN ('Y','N') OR @Verify IS NULL OR (@BackupSoftware = 'SQLSAFE' AND @Encrypt = 'Y' AND @Verify = 'Y')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Verify is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CleanupTime < 0
  BEGIN
    SET @ErrorMessage = 'The value for parameter @CleanupTime is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Compress NOT IN ('Y','N') OR @Compress IS NULL OR (@Compress = 'Y' AND @BackupSoftware IS NULL AND NOT ((@Version >= 10 AND @Version < 10.5 AND SERVERPROPERTY('EngineEdition') = 3) OR (@Version >= 10.5 AND (SERVERPROPERTY('EngineEdition') = 3 OR SERVERPROPERTY('EditionID') = -1534726760)))) OR (@Compress = 'N' AND @BackupSoftware IS NOT NULL AND (@CompressionLevel IS NULL OR @CompressionLevel >= 1)) OR (@Compress = 'Y' AND @BackupSoftware IS NOT NULL AND @CompressionLevel = 0)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Compress is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Compress = 'Y' AND @BackupSoftware IS NULL AND NOT ((@Version >= 10 AND @Version < 10.5 AND SERVERPROPERTY('EngineEdition') = 3) OR (@Version >= 10.5 AND (SERVERPROPERTY('EngineEdition') = 3 OR SERVERPROPERTY('EditionID') = -1534726760)))
  BEGIN
    SET @ErrorMessage = 'Backup compression is only supported in SQL Server 2008 Enterprise and Developer Edition and in SQL Server 2008 R2 Standard, Enterprise, Developer and Datacenter Edition.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CopyOnly NOT IN ('Y','N') OR @CopyOnly IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @CopyOnly is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @ChangeBackupType NOT IN ('Y','N') OR @ChangeBackupType IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @ChangeBackupType is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware NOT IN ('LITESPEED','SQLBACKUP','HYPERBAC','SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @BackupSoftware is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware = 'LITESPEED' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_backup_database')
  BEGIN
    SET @ErrorMessage = 'LiteSpeed is not installed. Download http://www.quest.com/litespeed-for-sql-server/.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware = 'SQLBACKUP' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'sqlbackup')
  BEGIN
    SET @ErrorMessage = 'SQLBackup is not installed. Download http://www.red-gate.com/products/dba/sql-backup/.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BackupSoftware = 'SQLSAFE' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_ss_backup')
  BEGIN
    SET @ErrorMessage = 'SQLsafe is not installed. Download http://www.idera.com/Products/SQL-Server/SQL-safe-backup/.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @CheckSum NOT IN ('Y','N') OR @CheckSum IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @CheckSum is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BlockSize NOT IN (512,1024,2048,4096,8192,16384,32768,65536) OR (@BlockSize IS NOT NULL AND @BackupSoftware = 'SQLBACKUP') OR (@BlockSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @BlockSize is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @BufferCount <= 0 OR @BufferCount > 2147483647 OR (@BufferCount IS NOT NULL AND @BackupSoftware = 'SQLBACKUP') OR (@BufferCount IS NOT NULL AND @BackupSoftware = 'SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @BufferCount is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @MaxTransferSize < 65536 OR @MaxTransferSize > 4194304 OR @MaxTransferSize % 65536 > 0 OR (@MaxTransferSize IS NOT NULL AND @BackupSoftware = 'SQLBACKUP') OR (@MaxTransferSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @MaxTransferSize is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @NumberOfFiles < 1 OR @NumberOfFiles > 64 OR (@NumberOfFiles > 32 AND @BackupSoftware = 'SQLBACKUP') OR @NumberOfFiles IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @NumberOfFiles is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@BackupSoftware IS NULL AND @CompressionLevel IS NOT NULL) OR (@BackupSoftware = 'HYPERBAC' AND @CompressionLevel IS NOT NULL) OR (@BackupSoftware = 'LITESPEED' AND (@CompressionLevel < 0 OR @CompressionLevel > 10)) OR (@BackupSoftware = 'SQLBACKUP' AND (@CompressionLevel < 0 OR @CompressionLevel > 4)) OR (@BackupSoftware = 'SQLSAFE' AND (@CompressionLevel < 1 OR @CompressionLevel > 4))
  BEGIN
    SET @ErrorMessage = 'The value for parameter @CompressionLevel is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF LEN(@Description) > 255 OR (@BackupSoftware = 'LITESPEED' AND LEN(@Description) > 128)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Description is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Threads IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED','SQLBACKUP','SQLSAFE') OR @BackupSoftware IS NULL) OR @Threads < 2 OR @Threads > 32
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Threads is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Throttle IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED') OR @BackupSoftware IS NULL) OR @Throttle < 1 OR @Throttle > 100
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Throttle is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Encrypt NOT IN('Y','N') OR @Encrypt IS NULL OR (@Encrypt = 'Y' AND @BackupSoftware IS NULL)
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Encrypt is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@EncryptionType IS NOT NULL AND @BackupSoftware IS NULL) OR (@EncryptionType IS NOT NULL AND @BackupSoftware = 'HYPERBAC') OR (@EncryptionType IS NOT NULL AND @Encrypt = 'N') OR ((@EncryptionType NOT IN('RC2-40','RC2-56','RC2-112','RC2-128','3DES-168','RC4-128','AES-128','AES-192','AES-256') OR @EncryptionType IS NULL) AND @Encrypt = 'Y' AND @BackupSoftware = 'LITESPEED') OR ((@EncryptionType NOT IN('AES-128','AES-256') OR @EncryptionType IS NULL) AND @Encrypt = 'Y' AND @BackupSoftware = 'SQLBACKUP') OR ((@EncryptionType NOT IN('AES-128','AES-256') OR @EncryptionType IS NULL) AND @Encrypt = 'Y' AND @BackupSoftware = 'SQLSAFE')
  BEGIN
    SET @ErrorMessage = 'The value for parameter @EncryptionType is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF (@EncryptionKey IS NOT NULL AND @BackupSoftware IS NULL) OR (@EncryptionKey IS NOT NULL AND @BackupSoftware = 'HYPERBAC') OR (@EncryptionKey IS NOT NULL AND @Encrypt = 'N') OR (@EncryptionKey IS NULL AND @Encrypt = 'Y' AND @BackupSoftware IN('LITESPEED','SQLBACKUP','SQLSAFE'))
  BEGIN
    SET @ErrorMessage = 'The value for parameter @EncryptionKey is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @LogToTable is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    SET @ErrorMessage = 'The value for parameter @Execute is not supported.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @Error = @@ERROR
  END

  IF @Error <> 0
  BEGIN
    SET @ErrorMessage = 'The documentation is available on http://ola.hallengren.com/Documentation.html.' + CHAR(13) + CHAR(10) + ' '
    RAISERROR(@ErrorMessage,16,1) WITH NOWAIT
    SET @ReturnCode = @Error
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute backup commands                                                                    //--
  ----------------------------------------------------------------------------------------------------

  WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
  BEGIN

    SELECT TOP 1 @CurrentID = ID,
                 @CurrentDatabaseName = DatabaseName
    FROM @tmpDatabases
    WHERE Completed = 0
    ORDER BY ID ASC

    SET @CurrentDatabaseID = DB_ID(@CurrentDatabaseName)

    IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = @CurrentDatabaseID AND database_guid IS NOT NULL)
    BEGIN
      SET @CurrentIsDatabaseAccessible = 1
    END
    ELSE
    BEGIN
      SET @CurrentIsDatabaseAccessible = 0
    END

    SELECT @CurrentMirroringRole = mirroring_role_desc
    FROM sys.database_mirroring
    WHERE database_id = @CurrentDatabaseID

    SELECT @CurrentDifferentialLSN = differential_base_lsn
    FROM sys.master_files
    WHERE database_id = @CurrentDatabaseID
    AND [type] = 0
    AND [file_id] = 1

    -- Workaround for a bug in SQL Server 2005
    IF @Version >= 9 AND @Version < 10
    AND (SELECT differential_base_lsn FROM sys.master_files WHERE database_id = @CurrentDatabaseID AND [type] = 0 AND [file_id] = 1) = (SELECT differential_base_lsn FROM sys.master_files WHERE database_id = DB_ID('model') AND [type] = 0 AND [file_id] = 1)
    AND (SELECT differential_base_guid FROM sys.master_files WHERE database_id = @CurrentDatabaseID AND [type] = 0 AND [file_id] = 1) = (SELECT differential_base_guid FROM sys.master_files WHERE database_id = DB_ID('model') AND [type] = 0 AND [file_id] = 1)
    AND (SELECT differential_base_time FROM sys.master_files WHERE database_id = @CurrentDatabaseID AND [type] = 0 AND [file_id] = 1) IS NULL
    BEGIN
      SET @CurrentDifferentialLSN = NULL
    END

    -- If a VSS snapshot has been taken since the last full backup, a differential backup cannot be performed
    IF EXISTS (SELECT * FROM msdb.dbo.backupset WHERE database_name = @CurrentDatabaseName AND [type] = 'D' AND is_snapshot = 1 AND checkpoint_lsn = @CurrentDifferentialLSN)
    BEGIN
      SET @CurrentDifferentialLSN = NULL
    END

    SELECT @CurrentLogLSN = last_log_backup_lsn
    FROM sys.database_recovery_status
    WHERE database_id = @CurrentDatabaseID

    SET @CurrentBackupType = @BackupType

    IF @ChangeBackupType = 'Y'
    BEGIN
      IF @CurrentBackupType = 'LOG' AND DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') <> 'SIMPLE' AND @CurrentLogLSN IS NULL AND @CurrentDatabaseName <> 'master'
      BEGIN
        SET @CurrentBackupType = 'DIFF'
      END
      IF @CurrentBackupType = 'DIFF' AND @CurrentDifferentialLSN IS NULL AND @CurrentDatabaseName <> 'master'
      BEGIN
        SET @CurrentBackupType = 'FULL'
      END
    END

    IF @CurrentBackupType = 'LOG'
    BEGIN
      SELECT @CurrentLatestBackup = MAX(backup_finish_date)
      FROM msdb.dbo.backupset
      WHERE [type] IN('D','I')
      AND is_copy_only = 0
      AND is_snapshot = 0
      AND is_damaged = 0
      AND database_name = @CurrentDatabaseName
    END

    -- Set database message
    SET @DatabaseMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Database: ' + QUOTENAME(@CurrentDatabaseName) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Status: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Mirroring role: ' + ISNULL(@CurrentMirroringRole,'N/A') + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Standby: ' + CASE WHEN DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Updateability: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'User access: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Recovery model: ' + CAST(DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') AS nvarchar) + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Differential base LSN: ' + ISNULL(CAST(@CurrentDifferentialLSN AS nvarchar),'N/A') + CHAR(13) + CHAR(10)
    SET @DatabaseMessage = @DatabaseMessage + 'Last log backup LSN: ' + ISNULL(CAST(@CurrentLogLSN AS nvarchar),'N/A') + CHAR(13) + CHAR(10) + ' '
    SET @DatabaseMessage = REPLACE(@DatabaseMessage,'%','%%')
    RAISERROR(@DatabaseMessage,10,1) WITH NOWAIT

    IF DATABASEPROPERTYEX(@CurrentDatabaseName,'Status') = 'ONLINE'
    AND NOT (DATABASEPROPERTYEX(@CurrentDatabaseName,'UserAccess') = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND DATABASEPROPERTYEX(@CurrentDatabaseName,'IsInStandBy') = 0
    AND NOT (@CurrentBackupType = 'LOG' AND (DATABASEPROPERTYEX(@CurrentDatabaseName,'Recovery') = 'SIMPLE' OR @CurrentLogLSN IS NULL))
    AND NOT (@CurrentBackupType = 'DIFF' AND @CurrentDifferentialLSN IS NULL)
    AND NOT (@CurrentBackupType IN('DIFF','LOG') AND @CurrentDatabaseName = 'master')
    BEGIN

      -- Set variables
      SET @CurrentDate = GETDATE()

      IF @CleanupTime IS NULL OR (@CurrentBackupType = 'LOG' AND @CurrentLatestBackup IS NULL)
      BEGIN
        SET @CurrentCleanupDate = NULL
      END
      ELSE
      IF @CurrentBackupType = 'LOG'
      BEGIN
        SET @CurrentCleanupDate = (SELECT MIN([Date]) FROM(SELECT DATEADD(hh,-(@CleanupTime),@CurrentDate) AS [Date] UNION SELECT @CurrentLatestBackup AS [Date]) Dates)
      END
      ELSE
      BEGIN
        SET @CurrentCleanupDate = DATEADD(hh,-(@CleanupTime),@CurrentDate)
      END

      SET @CurrentDatabaseNameFS = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@CurrentDatabaseName,'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''),' ','')

      SELECT @CurrentFileExtension = CASE
      WHEN @BackupSoftware IS NULL AND @CurrentBackupType = 'FULL' THEN 'bak'
      WHEN @BackupSoftware IS NULL AND @CurrentBackupType = 'DIFF' THEN 'bak'
      WHEN @BackupSoftware IS NULL AND @CurrentBackupType = 'LOG' THEN 'trn'
      WHEN @BackupSoftware = 'LITESPEED' AND @CurrentBackupType = 'FULL' THEN 'bak'
      WHEN @BackupSoftware = 'LITESPEED' AND @CurrentBackupType = 'DIFF' THEN 'bak'
      WHEN @BackupSoftware = 'LITESPEED' AND @CurrentBackupType = 'LOG' THEN 'trn'
      WHEN @BackupSoftware = 'SQLBACKUP' AND @CurrentBackupType = 'FULL' THEN 'sqb'
      WHEN @BackupSoftware = 'SQLBACKUP' AND @CurrentBackupType = 'DIFF' THEN 'sqb'
      WHEN @BackupSoftware = 'SQLBACKUP' AND @CurrentBackupType = 'LOG' THEN 'sqb'
      WHEN @BackupSoftware = 'HYPERBAC' AND @CurrentBackupType = 'FULL' AND @Encrypt = 'N' THEN 'hbc'
      WHEN @BackupSoftware = 'HYPERBAC' AND @CurrentBackupType = 'DIFF' AND @Encrypt = 'N' THEN 'hbc'
      WHEN @BackupSoftware = 'HYPERBAC' AND @CurrentBackupType = 'LOG' AND @Encrypt = 'N' THEN 'hbc'
      WHEN @BackupSoftware = 'HYPERBAC' AND @CurrentBackupType = 'FULL' AND @Encrypt = 'Y' THEN 'hbe'
      WHEN @BackupSoftware = 'HYPERBAC' AND @CurrentBackupType = 'DIFF' AND @Encrypt = 'Y' THEN 'hbe'
      WHEN @BackupSoftware = 'HYPERBAC' AND @CurrentBackupType = 'LOG' AND @Encrypt = 'Y' THEN 'hbe'
      WHEN @BackupSoftware = 'SQLSAFE' AND @CurrentBackupType = 'FULL' THEN 'safe'
      WHEN @BackupSoftware = 'SQLSAFE' AND @CurrentBackupType = 'DIFF' THEN 'safe'
      WHEN @BackupSoftware = 'SQLSAFE' AND @CurrentBackupType = 'LOG' THEN 'safe'
      END

      SET @CurrentDirectory = @Directory + CASE WHEN RIGHT(@Directory,1) = '\' THEN '' ELSE '\' END + REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar),'\','$') + '\' + @CurrentDatabaseNameFS + '\' + UPPER(@CurrentBackupType) + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END

      SET @CurrentFileNumber = 0

      WHILE @CurrentFileNumber < @NumberOfFiles
      BEGIN
        SET @CurrentFileNumber = @CurrentFileNumber + 1

        SET @CurrentFilePath = @CurrentDirectory + '\' + REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar),'\','$') + '_' + @CurrentDatabaseNameFS + '_' + UPPER(@CurrentBackupType) + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension

        IF LEN(@CurrentFilePath) > 259
        BEGIN
          SET @CurrentFilePath = @CurrentDirectory + '\' + REPLACE(CAST(SERVERPROPERTY('servername') AS nvarchar),'\','$') + '_' + LEFT(@CurrentDatabaseNameFS,CASE WHEN (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) < 20 THEN 20 ELSE (LEN(@CurrentDatabaseNameFS) + 259 - LEN(@CurrentFilePath) - 3) END) + '...' + '_' + UPPER(@CurrentBackupType) + CASE WHEN @CopyOnly = 'Y' THEN '_COPY_ONLY' ELSE '' END + '_' + REPLACE(REPLACE(REPLACE((CONVERT(nvarchar,@CurrentDate,120)),'-',''),' ','_'),':','') + CASE WHEN @NumberOfFiles > 1 AND @NumberOfFiles <= 9 THEN '_' + CAST(@CurrentFileNumber AS nvarchar) WHEN @NumberOfFiles >= 10 THEN '_' + RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END + '.' + @CurrentFileExtension
        END

        INSERT INTO @CurrentFiles (CurrentFilePath)
        SELECT @CurrentFilePath
      END

      -- Create directory
      SET @CurrentCommandType01 = 'xp_create_subdir'
      SET @CurrentCommand01 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_create_subdir N''' + REPLACE(@CurrentDirectory,'''','''''') + ''' IF @ReturnCode <> 0 RAISERROR(''Error creating directory.'', 16, 1)'
      EXECUTE @CurrentCommandOutput01 = [dbo].[CommandExecute] @Command = @CurrentCommand01, @CommandType = @CurrentCommandType01, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
      SET @Error = @@ERROR
      IF @Error <> 0 SET @CurrentCommandOutput01 = @Error
      IF @CurrentCommandOutput01 <> 0 SET @ReturnCode = @CurrentCommandOutput01

      -- Perform a backup
      IF @CurrentCommandOutput01 = 0
      BEGIN
        IF @BackupSoftware IS NULL
        BEGIN
          SELECT @CurrentCommandType02 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP_DATABASE'
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP_LOG'
          END

          SELECT @CurrentCommand02 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName) + ' TO'
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName) + ' TO'
          END

          SELECT @CurrentCommand02 = @CurrentCommand02 + ' DISK = N''' + REPLACE(CurrentFilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          SET @CurrentCommand02 = @CurrentCommand02 + ' WITH '
          IF @CheckSum = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand02 = @CurrentCommand02 + 'NO_CHECKSUM'
          IF @Compress = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + ', COMPRESSION'
          IF @Compress = 'N' AND @Version >= 10 SET @CurrentCommand02 = @CurrentCommand02 + ', NO_COMPRESSION'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand02 = @CurrentCommand02 + ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + ', COPY_ONLY'
          IF @BlockSize IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          IF @BufferCount IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', BUFFERCOUNT = ' + CAST(@BufferCount AS nvarchar)
          IF @MaxTransferSize IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', MAXTRANSFERSIZE = ' + CAST(@MaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''
        END

        IF @BackupSoftware = 'LITESPEED'
        BEGIN
          SELECT @CurrentCommandType02 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'xp_backup_database'
          WHEN @CurrentBackupType = 'LOG' THEN 'xp_backup_log'
          END

          SELECT @CurrentCommand02 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_backup_database @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          WHEN @CurrentBackupType = 'LOG' THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_backup_log @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          END

          SELECT @CurrentCommand02 = @CurrentCommand02 + ', @filename = N''' + REPLACE(CurrentFilePath,'''','''''') + ''''
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          SET @CurrentCommand02 = @CurrentCommand02 + ', @with = '''
          IF @CheckSum = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand02 = @CurrentCommand02 + 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand02 = @CurrentCommand02 + ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + ', COPY_ONLY'
          IF @BlockSize IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          IF @BufferCount IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', BUFFERCOUNT = ' + CAST(@BufferCount AS nvarchar)
          IF @MaxTransferSize IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', MAXTRANSFERSIZE = ' + CAST(@MaxTransferSize AS nvarchar)
          SET @CurrentCommand02 = @CurrentCommand02 + ''''
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Throttle IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @throttle = ' + CAST(@Throttle AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionType IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @cryptlevel = ' + CASE
          WHEN @EncryptionType = 'RC2-40' THEN '0'
          WHEN @EncryptionType = 'RC2-56' THEN '1'
          WHEN @EncryptionType = 'RC2-112' THEN '2'
          WHEN @EncryptionType = 'RC2-128' THEN '3'
          WHEN @EncryptionType = '3DES-168' THEN '4'
          WHEN @EncryptionType = 'RC4-128' THEN '5'
          WHEN @EncryptionType = 'AES-128' THEN '6'
          WHEN @EncryptionType = 'AES-192' THEN '7'
          WHEN @EncryptionType = 'AES-256' THEN '8'
          END

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand02 = @CurrentCommand02 + ' IF @ReturnCode <> 0 RAISERROR(''Error performing LiteSpeed backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLBACKUP'
        BEGIN
          SET @CurrentCommandType02 = 'sqlbackup'

          SELECT @CurrentCommand02 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName) + ' TO'
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName) + ' TO'
          END

          SELECT @CurrentCommand02 = @CurrentCommand02 + ' DISK = N''' + REPLACE(CurrentFilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          SET @CurrentCommand02 = @CurrentCommand02 + ' WITH '
          IF @CheckSum = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand02 = @CurrentCommand02 + 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand02 = @CurrentCommand02 + ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + ', COPY_ONLY'
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', COMPRESSION = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', THREADCOUNT = ' + CAST(@Threads AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionType IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', KEYSIZE = ' + CASE
          WHEN @EncryptionType = 'AES-128' THEN '128'
          WHEN @EncryptionType = 'AES-256' THEN '256'
          END

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand02 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand02,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLBackup backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'HYPERBAC'
        BEGIN
          SET @CurrentCommandType02 = 'BACKUP_DATABASE'

          SELECT @CurrentCommand02 = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName) + ' TO'
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName) + ' TO'
          END

          SELECT @CurrentCommand02 = @CurrentCommand02 + ' DISK = N''' + REPLACE(CurrentFilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          SET @CurrentCommand02 = @CurrentCommand02 + ' WITH '
          IF @CheckSum = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand02 = @CurrentCommand02 + 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand02 = @CurrentCommand02 + ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand02 = @CurrentCommand02 + ', COPY_ONLY'
          IF @BlockSize IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          IF @BufferCount IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', BUFFERCOUNT = ' + CAST(@BufferCount AS nvarchar)
          IF @MaxTransferSize IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', MAXTRANSFERSIZE = ' + CAST(@MaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''
        END

        IF @BackupSoftware = 'SQLSAFE'
        BEGIN
          SET @CurrentCommandType02 = 'xp_ss_backup'

          SET @CurrentCommand02 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_ss_backup @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

          SELECT @CurrentCommand02 = @CurrentCommand02 + ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(CurrentFilePath,'''','''''') + ''''
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          SET @CurrentCommand02 = @CurrentCommand02 + ', @backuptype = ' + CASE WHEN @CurrentBackupType = 'FULL' THEN '''Full''' WHEN @CurrentBackupType = 'DIFF' THEN '''Differential''' WHEN @CurrentBackupType = 'LOG' THEN '''Log''' END
          SET @CurrentCommand02 = @CurrentCommand02 + ', @checksum = ' + CASE WHEN @CheckSum = 'Y' THEN '1' WHEN @CheckSum = 'N' THEN '0' END
          SET @CurrentCommand02 = @CurrentCommand02 + ', @copyonly = ' + CASE WHEN @CopyOnly = 'Y' THEN '1' WHEN @CopyOnly = 'N' THEN '0' END
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionType IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @encryptiontype = N''' + CASE
          WHEN @EncryptionType = 'AES-128' THEN 'AES128'
          WHEN @EncryptionType = 'AES-256' THEN 'AES256'
          END + ''''

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand02 = @CurrentCommand02 + ', @encryptedbackuppassword = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand02 = @CurrentCommand02 + ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLsafe backup.'', 16, 1)'
        END

        EXECUTE @CurrentCommandOutput02 = [dbo].[CommandExecute] @Command = @CurrentCommand02, @CommandType = @CurrentCommandType02, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput02 = @Error
        IF @CurrentCommandOutput02 <> 0 SET @ReturnCode = @CurrentCommandOutput02
      END

      -- Verify the backup
      IF @CurrentCommandOutput02 = 0 AND @Verify = 'Y'
      BEGIN
        IF @BackupSoftware IS NULL
        BEGIN
          SET @CurrentCommandType03 = 'RESTORE_VERIFYONLY'

          SET @CurrentCommand03 = 'RESTORE VERIFYONLY FROM'

          SELECT @CurrentCommand03 = @CurrentCommand03 + ' DISK = N''' + REPLACE(CurrentFilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC
        END

        IF @BackupSoftware = 'LITESPEED'
        BEGIN
          SET @CurrentCommandType03 = 'xp_restore_verifyonly'

          SET @CurrentCommand03 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_restore_verifyonly'

          SELECT @CurrentCommand03 = @CurrentCommand03 + ' @filename = N''' + REPLACE(CurrentFilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

          SET @CurrentCommand03 = @CurrentCommand03 + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying LiteSpeed backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLBACKUP'
        BEGIN
          SET @CurrentCommandType03 = 'sqlbackup'

          SET @CurrentCommand03 = 'RESTORE VERIFYONLY FROM'

          SELECT @CurrentCommand03 = @CurrentCommand03 + ' DISK = N''' + REPLACE(CurrentFilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand03 = @CurrentCommand03 + ' WITH PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

          SET @CurrentCommand03 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand03,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLBackup backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'HYPERBAC'
        BEGIN
          SET @CurrentCommandType03 = 'RESTORE_VERIFYONLY'

          SET @CurrentCommand03 = 'RESTORE VERIFYONLY FROM'

          SELECT @CurrentCommand03 = @CurrentCommand03 + ' DISK = N''' + REPLACE(CurrentFilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) <> @NumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC
        END

        IF @BackupSoftware = 'SQLSAFE'
        BEGIN
          SET @CurrentCommandType03 = 'xp_ss_verify'

          SET @CurrentCommand03 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_ss_verify @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

          SELECT @CurrentCommand03 = @CurrentCommand03 + ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY CurrentFilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(CurrentFilePath,'''','''''') + ''''
          FROM @CurrentFiles
          ORDER BY CurrentFilePath ASC

          SET @CurrentCommand03 = @CurrentCommand03 + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLsafe backup.'', 16, 1)'
        END

        EXECUTE @CurrentCommandOutput03 = [dbo].[CommandExecute] @Command = @CurrentCommand03, @CommandType = @CurrentCommandType03, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput03 = @Error
        IF @CurrentCommandOutput03 <> 0 SET @ReturnCode = @CurrentCommandOutput03
      END

      -- Delete old backup files
      IF (@CurrentCommandOutput02 = 0 AND @Verify = 'N' AND @CurrentCleanupDate IS NOT NULL)
      OR (@CurrentCommandOutput02 = 0 AND @Verify = 'Y' AND @CurrentCommandOutput03 = 0 AND @CurrentCleanupDate IS NOT NULL)
      BEGIN
        IF @BackupSoftware IS NULL
        BEGIN
          SET @CurrentCommandType04 = 'xp_delete_file'

          SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectory,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
        END

        IF @BackupSoftware = 'LITESPEED'
        BEGIN
          SET @CurrentCommandType04 = 'xp_slssqlmaint'

          SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_slssqlmaint N''-MAINTDEL -DELFOLDER "' + REPLACE(@CurrentDirectory,'''','''''') + '" -DELEXTENSION "' + @CurrentFileExtension + '" -DELUNIT "' + CAST(DATEDIFF(mi,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + '" -DELUNITTYPE "minutes" -DELUSEAGE'' IF @ReturnCode <> 0 RAISERROR(''Error deleting LiteSpeed backup files.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLBACKUP'
        BEGIN
          SET @CurrentCommandType04 = 'sqbutility'

          SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.sqbutility 1032, N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''', N''' + REPLACE(@CurrentDirectory,'''','''''') + ''', ''' + CASE WHEN @CurrentBackupType = 'FULL' THEN 'D' WHEN @CurrentBackupType = 'DIFF' THEN 'I' WHEN @CurrentBackupType = 'LOG' THEN 'L' END + ''', ''' + CAST(DATEDIFF(hh,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + 'h'', ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL') + ' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLBackup backup files.'', 16, 1)'
        END

        IF @BackupSoftware = 'HYPERBAC'
        BEGIN
          SET @CurrentCommandType04 = 'xp_delete_file'

          SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectory,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLSAFE'
        BEGIN
          SET @CurrentCommandType04 = 'xp_ss_delete'

          SET @CurrentCommand04 = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = [master].dbo.xp_ss_delete @filename = N''' + REPLACE(@CurrentDirectory,'''','''''') + '\*.' + @CurrentFileExtension + ''', @age = ''' + CAST(DATEDIFF(mi,@CurrentCleanupDate,GETDATE()) + 1 AS nvarchar) + 'Minutes'' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLsafe backup files.'', 16, 1)'
        END

        EXECUTE @CurrentCommandOutput04 = [dbo].[CommandExecute] @Command = @CurrentCommand04, @CommandType = @CurrentCommandType04, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput04 = @Error
        IF @CurrentCommandOutput04 <> 0 SET @ReturnCode = @CurrentCommandOutput04
      END

    END

    -- Update that the database is completed
    UPDATE @tmpDatabases
    SET Completed = 1
    WHERE ID = @CurrentID

    -- Clear variables
    SET @CurrentID = NULL
    SET @CurrentDatabaseID = NULL
    SET @CurrentDatabaseName = NULL
    SET @CurrentBackupType = NULL
    SET @CurrentFileExtension = NULL
    SET @CurrentFileNumber = NULL
    SET @CurrentDifferentialLSN = NULL
    SET @CurrentLogLSN = NULL
    SET @CurrentLatestBackup = NULL
    SET @CurrentDatabaseNameFS = NULL
    SET @CurrentDirectory = NULL
    SET @CurrentFilePath = NULL
    SET @CurrentDate = NULL
    SET @CurrentCleanupDate = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentMirroringRole = NULL

    SET @CurrentCommand01 = NULL
    SET @CurrentCommand02 = NULL
    SET @CurrentCommand03 = NULL
    SET @CurrentCommand04 = NULL

    SET @CurrentCommandOutput01 = NULL
    SET @CurrentCommandOutput02 = NULL
    SET @CurrentCommandOutput03 = NULL
    SET @CurrentCommandOutput04 = NULL

    SET @CurrentCommandType01 = NULL
    SET @CurrentCommandType02 = NULL
    SET @CurrentCommandType03 = NULL
    SET @CurrentCommandType04 = NULL

    DELETE FROM @CurrentFiles

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'DateTime: ' + CONVERT(nvarchar,GETDATE(),120)
  SET @EndMessage = REPLACE(@EndMessage,'%','%%')
  RAISERROR(@EndMessage,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END
GO
/****** Object:  StoredProcedure [dbo].[sp_Blitz]    Script Date: 03/27/2012 09:28:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Blitz]
    @CheckUserDatabaseObjects TINYINT = 1,
	@CheckProcedureCache TINYINT = 0
AS 
    SET NOCOUNT ON ;
	/*
			sp_Blitz v5 - December 18, 2011
			
			(C) 2011, Brent Ozar PLF, LLC

	To learn more, visit http://www.BrentOzar.com/go/blitz where you can download
	new versions for free, watch training videos on how it works, get more info on
	the findings, and more.

	Known limitations of this version:
	 - No support for offline databases. If you can't query some of your databases,
	   this script will fail.  That's fairly high on our list of things to improve
	   since we like mirroring too.
	 - SQL Server 2000 not quite supported (yet, but we're coding it in).

	Unknown limitations of this version:
	 - None.  (If we knew them, they'd be known.  Duh.)

	Changes in v5 Dec 18 2011:
	 - John Miner suggested tweaking checkid 48 and 56, the untrusted constraints
			and keys, to look for is_not_for_replication = 0 too.  This filters out
			constraints/keys that are only used for replication and don't need to
			be trusted.
	 - Ned Otter caught a bug in the URL for check 7, startup stored procs.
	 - Scott (Anon) recommended using SUSER_SNAME(0x01) instead of 'sa' when
			checking for job ownership, database ownership, etc.
	 - Martin Schmidt http://www.geniiius.com/blog/ caught a bug in checkid 1 and
			contributed code to catch databases that had never been backed up.
	 - Added parameter for @CheckProcedureCache.  When set to 0, we skip the checks
			that are typically the slowest on servers with lots of memory.  I'm
			defaulting this to 0 so more users can get results back faster.

	Changes in v4 Nov 1 2011:
	 - Andreas Schubert caught a typo in the explanations for checks 15-17.
	 - K. Brian Kelley @kbriankelley added checkid 57 for SQL Agent jobs set to
   			start automatically on startup.
	 - Added parameter for @CheckUserDatabaseObjects.  When set to 0, we skip the
			checks that are typically the slowest on large servers, the user
			database schema checks for things like triggers, hypothetical
			indexes, untrusted constraints, etc.

	Changes in v3 Oct 16 2011:
	 - David Tolbert caught a bug in checkid 2.  If some backups had failed or
			been aborted, we raised a false alarm about no transaction log backups.
	 - Fixed more bugs in checking for SQL Server 2005. (I need more 2005 VMs!)

	Changes in v2 Oct 14 2011:
	 - Ali Razeghi http://www.alirazeghi.com added checkid 55 looking for
	   databases owned by <> SA.
	 - Fixed bugs in checking for SQL Server 2005 (leading % signs)


	Explanation of priority levels:
	  1 - Critical risk of data loss.  Fix this ASAP.
	 10 - Security risk.
	 20 - Security risk due to unusual configuration, but requires more research.
	 50 - Reliability risk.
	 60 - Reliability risk due to unusual configuration, but requires more research.
	100 - Performance risk.
	110 - Performance risk due to unusual configuration, but requires more research.
	200 - Informational.

	*/

    IF OBJECT_ID('tempdb..#BlitzResults') IS NOT NULL 
        DROP TABLE #BlitzResults ;
    CREATE TABLE #BlitzResults
        (
          ID INT IDENTITY(1, 1) ,
          CheckID INT ,
          Priority TINYINT ,
          FindingsGroup VARCHAR(50) ,
          Finding VARCHAR(200) ,
          URL VARCHAR(200) ,
          Details NVARCHAR(4000)
        ) ;

    IF OBJECT_ID('tempdb..#ConfigurationDefaults') IS NOT NULL 
        DROP TABLE #ConfigurationDefaults ;
    CREATE TABLE #ConfigurationDefaults
        (
          name NVARCHAR(128) ,
          DefaultValue BIGINT
        ) ;

    DECLARE @VersionNumber VARCHAR(10) ,
        @StringToExecute NVARCHAR(4000) ;
    SET @VersionNumber = '1' ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  1 AS CheckID ,
                    1 AS Priority ,
                    'Backup' AS FindingsGroup ,
                    'Backups Not Performed Recently' AS Finding ,
                    'http://www.BrentOzar.com/blitz/backups-not-performed-recently/' AS URL ,
                    'Database ' + d.Name + ' last backed up: '
                    + CAST(COALESCE(MAX(b.backup_finish_date), ' never ') AS VARCHAR(200)) AS Details
            FROM    master.sys.databases d
                    LEFT OUTER JOIN msdb.dbo.backupset b ON d.name = b.database_name
                                                            AND b.type = 'D'
            WHERE   d.database_id NOT IN ( 2, 3 )  /* Bonus points if you know what that means */
            GROUP BY d.name
            HAVING  MAX(b.backup_finish_date) <= DATEADD(dd, -7, GETDATE()) ;


	    INSERT  INTO #BlitzResults
	            ( CheckID ,
	              Priority ,
	              FindingsGroup ,
	              Finding ,
	              URL ,
	              Details
	            )
            SELECT  1 AS CheckID ,
                    1 AS Priority ,
                    'Backup' AS FindingsGroup ,
                    'Backups Not Performed Recently' AS Finding ,
                    'http://www.BrentOzar.com/blitz/backups-not-performed-recently/' AS URL ,
                    ('Database ' + d.Name + ' never backed up.')  AS Details
            FROM    master.sys.databases d
            WHERE   d.database_id NOT IN ( 2, 3 )  /* Bonus points if you know what that means */
			AND NOT EXISTS (SELECT * FROM msdb.dbo.backupset b WHERE d.name = b.database_name AND b.type = 'D')

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  2 AS CheckID ,
                    1 AS Priority ,
                    'Backup' AS FindingsGroup ,
                    'Full Recovery Mode w/o Log Backups' AS Finding ,
                    'http://www.BrentOzar.com/blitz/full-recovery-mode-without-log-backups/' AS URL ,
                    ( 'Database ' + d.Name + ' is in ' + d.recovery_model_desc
                      + ' recovery mode but has not had a log backup in the last week.' ) AS Details
            FROM    master.sys.databases d
                    LEFT OUTER JOIN msdb.dbo.backupset b ON d.name = b.database_name
                                                            AND b.type = 'L'
                                                            AND b.backup_finish_date <= DATEADD(dd,
                                                              -7, GETDATE())
            WHERE   d.recovery_model IN ( 1, 2 )
                    AND b.type IS NULL
                    AND b.backup_finish_date IS NOT NULL
                    AND d.database_id NOT IN ( 2, 3 ) ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT TOP 1
                    3 AS CheckID ,
                    200 AS Priority ,
                    'Backup' AS FindingsGroup ,
                    'MSDB Backup History Not Purged' AS Finding ,
                    'http://www.BrentOzar.com/blitz/msdb-history-not-purged/' AS URL ,
                    ( 'Database backup history retained back to '
                      + CAST(bs.backup_start_date AS VARCHAR(20)) ) AS Details
            FROM    msdb.dbo.backupset bs
            WHERE   bs.backup_start_date <= DATEADD(dd, -60, GETDATE())
            ORDER BY backup_set_id ASC ;


    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  4 AS CheckID ,
                    10 AS Priority ,
                    'Security' AS FindingsGroup ,
                    'Sysadmins' AS Finding ,
                    'http://www.BrentOzar.com/blitz/security-sysadmins/' AS URL ,
                    ( 'Login [' + l.name
                      + '] is a sysadmin - meaning they can do absolutely anything in SQL Server, including dropping databases or hiding their tracks.' ) AS Details
            FROM    master.sys.syslogins l
            WHERE   l.sysadmin = 1
                    AND l.name <> SUSER_SNAME(0x01)
                    AND l.denylogin = 0 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  5 AS CheckID ,
                    10 AS Priority ,
                    'Security' AS FindingsGroup ,
                    'Security Admins' AS Finding ,
                    'http://www.BrentOzar.com/blitz/security-admins/' AS URL ,
                    ( 'Login [' + l.name
                      + '] is a security admin - meaning they can give themselves permission to do absolutely anything in SQL Server, including dropping databases or hiding their tracks.' ) AS Details
            FROM    master.sys.syslogins l
            WHERE   l.securityadmin = 1
                    AND l.name <> SUSER_SNAME(0x01)
                    AND l.denylogin = 0 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  6 AS CheckID ,
                    200 AS Priority ,
                    'Security' AS FindingsGroup ,
                    'Jobs Owned By Users' AS Finding ,
                    'http://www.BrentOzar.com/blitz/jobs-owned-by-user-accounts/' AS URL ,
                    ( 'Job [' + j.name + '] is owned by [' + sl.name
                      + '] - meaning if their login is disabled or not available due to Active Directory problems, the job will stop working.' ) AS Details
            FROM    msdb.dbo.sysjobs j
                    LEFT OUTER JOIN sys.syslogins sl ON j.owner_sid = sl.sid
            WHERE   j.enabled = 1
                    AND sl.name <> SUSER_SNAME(0x01) ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  7 AS CheckID ,
                    10 AS Priority ,
                    'Security' AS FindingsGroup ,
                    'Stored Procedure Runs at Startup' AS Finding ,
                    'http://www.brentozar.com/blitz/startup-stored-procedure/' AS URL ,
                    ( 'Stored procedure [master].[' + r.SPECIFIC_SCHEMA
                      + '].[' + r.SPECIFIC_NAME
                      + '] runs automatically when SQL Server starts up.  Make sure you know exactly what this stored procedure is doing, because it could pose a security risk.' ) AS Details
            FROM    master.INFORMATION_SCHEMA.ROUTINES r
            WHERE   OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME), 'ExecIsStartup') = 1 ;

    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT 8 AS CheckID, 150 AS Priority, ''Security'' AS FindingsGroup, ''Server Audits Running'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/security/server-audits-running/'' AS URL,
    (''SQL Server built-in audit functionality is being used by server audit: '' + [name]) AS Details FROM sys.dm_server_audit_status'
            EXECUTE(@StringToExecute)
        END ;

    IF @@version NOT LIKE '%Microsoft SQL Server 2000%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT 9 AS CheckID, 200 AS Priority, ''Surface Area'' AS FindingsGroup, ''Endpoints Configured'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/surface-area-endpoints/'' AS URL,
    (''SQL Server endpoints are configured.  These can be used for database mirroring or Service Broker, but if you do not need them, avoid leaving them enabled.  Endpoint name: '' + [name]) AS Details FROM sys.endpoints WHERE type <> 2'
            EXECUTE(@StringToExecute)
        END ;

    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT 10 AS CheckID, 100 AS Priority, ''Performance'' AS FindingsGroup, ''Resource Governor Enabled'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/resource-governor-enabled/'' AS URL,
    (''Resource Governor is enabled.  Queries may be throttled.  Make sure you understand how the Classifier Function is configured.'') AS Details FROM sys.resource_governor_configuration WHERE is_enabled = 1'
            EXECUTE(@StringToExecute)
        END ;


    IF @@version NOT LIKE '%Microsoft SQL Server 2000%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT 11 AS CheckID, 100 AS Priority, ''Performance'' AS FindingsGroup, ''Server Triggers Enabled'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/server-logon-triggers-enabled/'' AS URL,
    (''Server Trigger ['' + [name] ++ ''] is enabled, so it runs every time someone logs in.  Make sure you understand what that trigger is doing - the less work it does, the better.'') AS Details FROM sys.server_triggers WHERE is_disabled = 0 AND is_ms_shipped = 0'
            EXECUTE(@StringToExecute)
        END ;


    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  12 AS CheckID ,
                    10 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Auto-Close Enabled' AS Finding ,
                    'http://www.BrentOzar.com/blitz/auto-close-enabled/' AS URL ,
                    ( 'Database [' + [name]
                      + '] has auto-close enabled.  This setting can dramatically decrease performance.' ) AS Details
            FROM    sys.databases
            WHERE   is_auto_close_on = 1 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  12 AS CheckID ,
                    10 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Auto-Shrink Enabled' AS Finding ,
                    'http://www.BrentOzar.com/blitz/auto-shrink-enabled/' AS URL ,
                    ( 'Database [' + [name]
                      + '] has auto-shrink enabled.  This setting can dramatically decrease performance.' ) AS Details
            FROM    sys.databases
            WHERE   is_auto_shrink_on = 1 ;


    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT TOP 1 13 AS CheckID, 110 AS Priority, ''Performance'' AS FindingsGroup, ''Plan Guides Enabled'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/query-plan-guides-enabled/'' AS URL,
    (''Query plan guides have been set up so that a query will always get a specific execution plan. If you are having trouble getting query performance to improve, it might be due to a frozen plan. Review the DMV sys.plan_guides to learn more about the plan guides in place on this server.'') AS Details FROM sys.plan_guides WHERE is_disabled = 0'
            EXECUTE(@StringToExecute)
        END ;

    IF @@version LIKE '%Microsoft SQL Server 2000%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT 14 AS CheckID, 50 AS Priority, ''Reliability'' AS FindingsGroup, ''Page Verification Not Optimal'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/page-verification/'' AS URL,
    (''Database ['' + [name] + ''] has '' + [page_verify_option_desc] + '' for page verification.  SQL Server may have a harder time recognizing and recovering from storage corruption.  Consider using CHECKSUM instead.'') AS Details FROM sys.databases WHERE page_verify_option < 1'
            EXECUTE(@StringToExecute)
        END ;

    IF @@version NOT LIKE '%Microsoft SQL Server 2000%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT 14 AS CheckID, 50 AS Priority, ''Reliability'' AS FindingsGroup, ''Page Verification Not Optimal'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/page-verification/'' AS URL,
    (''Database ['' + [name] + ''] has '' + [page_verify_option_desc] + '' for page verification.  SQL Server may have a harder time recognizing and recovering from storage corruption.  Consider using CHECKSUM instead.'') AS Details FROM sys.databases WHERE page_verify_option < 2'
            EXECUTE(@StringToExecute)
        END ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  15 AS CheckID ,
                    110 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Auto-Create Stats Disabled' AS Finding ,
                    'http://www.BrentOzar.com/blitz/auto-create-stats-disabled/' AS URL ,
                    ( 'Database [' + [name]
                      + '] has auto-create-stats disabled.  SQL Server uses statistics to build better execution plans, and without the ability to automatically create more, performance may suffer.' ) AS Details
            FROM    sys.databases
            WHERE   is_auto_create_stats_on = 0 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  16 AS CheckID ,
                    110 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Auto-Update Stats Disabled' AS Finding ,
                    'http://www.BrentOzar.com/blitz/auto-update-stats-disabled/' AS URL ,
                    ( 'Database [' + [name]
                      + '] has auto-update-stats disabled.  SQL Server uses statistics to build better execution plans, and without the ability to automatically update them, performance may suffer.' ) AS Details
            FROM    sys.databases
            WHERE   is_auto_update_stats_on = 0 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  17 AS CheckID ,
                    110 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Stats Updated Asynchronously' AS Finding ,
                    'http://www.BrentOzar.com/blitz/auto-update-stats-async-enabled/' AS URL ,
                    ( 'Database [' + [name]
                      + '] has auto-update-stats-async disabled.  When SQL Server gets a query for a table with out-of-date statistics, it will run the query with the stats it has - while updating stats to make later queries better. The initial run of the query may suffer, though.' ) AS Details
            FROM    sys.databases
            WHERE   is_auto_update_stats_async_on = 1 ;


    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  18 AS CheckID ,
                    110 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Forced Parameterization On' AS Finding ,
                    'http://www.BrentOzar.com/blitz/forced-parameterization/' AS URL ,
                    ( 'Database [' + [name]
                      + '] has forced parameterization enabled.  SQL Server will aggressively reuse query execution plans even if the applications do not parameterize their queries.  This can be a performance booster with some programming languages, or it may use universally bad execution plans when better alternatives are available for certain parameters.' ) AS Details
            FROM    sys.databases
            WHERE   is_parameterization_forced = 1 ;


    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  19 AS CheckID ,
                    200 AS Priority ,
                    'Informational' AS FindingsGroup ,
                    'Replication In Use' AS Finding ,
                    'http://www.BrentOzar.com/blitz/replication-in-use/' AS URL ,
                    ( 'Database [' + [name]
                      + '] is a replication publisher, subscriber, or distributor.' ) AS Details
            FROM    sys.databases
            WHERE   is_published = 1
                    OR is_subscribed = 1
                    OR is_merge_published = 1
                    OR is_distributor = 1 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  20 AS CheckID ,
                    110 AS Priority ,
                    'Informational' AS FindingsGroup ,
                    'Date Correlation On' AS Finding ,
                    'http://www.BrentOzar.com/blitz/date-correlation/' AS URL ,
                    ( 'Database [' + [name]
                      + '] has date correlation enabled.  This is not a default setting, and it has some performance overhead.  It tells SQL Server that date fields in two tables are related, and SQL Server maintains statistics showing that relation.' ) AS Details
            FROM    sys.databases
            WHERE   is_date_correlation_on = 1 ;

    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
SELECT 21 AS CheckID, 20 AS Priority, ''Encryption'' AS FindingsGroup, ''Database Encrypted'' AS Finding, 
    ''http://www.BrentOzar.com/blitz/transparent-data-encryption/'' AS URL,
    (''Database ['' + [name] + ''] has Transparent Data Encryption enabled.  Make absolutely sure you have backed up the certificate and private key, or else you will not be able to restore this database.'') AS Details FROM sys.databases WHERE is_encrypted = 1'
            EXECUTE(@StringToExecute)
        END ;

/* Compare sp_configure defaults */
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'Ad Hoc Distributed Queries', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'affinity I/O mask', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'affinity mask', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'Agent XPs', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'allow updates', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'awe enabled', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'blocked process threshold', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'c2 audit mode', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'clr enabled', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'cost threshold for parallelism', 5 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'cross db ownership chaining', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'cursor threshold', -1 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'Database Mail XPs', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'default full-text language', 1033 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'default language', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'default trace enabled', 1 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'disallow results from triggers', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'fill factor (%);', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'ft crawl bandwidth (max);', 100 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'ft crawl bandwidth (min);', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'ft notify bandwidth (max);', 100 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'ft notify bandwidth (min);', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'index create memory (KB);', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'in-doubt xact resolution', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'lightweight pooling', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'locks', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'max degree of parallelism', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'max full-text crawl range', 4 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'max server memory (MB);', 2147483647 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'max text repl size (B);', 65536 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'max worker threads', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'media retention', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'min memory per query (KB);', 1024 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'min server memory (MB);', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'nested triggers', 1 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'network packet size (B);', 4096 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'Ole Automation Procedures', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'open objects', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'PH timeout (s);', 60 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'precompute rank', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'priority boost', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'query governor cost limit', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'query wait (s);', -1 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'recovery interval (min);', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'remote access', 1 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'remote admin connections', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'remote login timeout (s);', 20 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'remote proc trans', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'remote query timeout (s);', 600 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'Replication XPs', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'RPC parameter data validation', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'scan for startup procs', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'server trigger recursion', 1 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'set working set size', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'show advanced options', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'SMO and DMO XPs', 1 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'SQL Mail XPs', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'transform noise words', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'two digit year cutoff', 2049 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'user connections', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'user options', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'Web Assistant Procedures', 0 ) ;
    INSERT  INTO #ConfigurationDefaults
    VALUES  ( 'xp_cmdshell', 0 ) ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  22 AS CheckID ,
                    200 AS Priority ,
                    'Non-Default Server Config' AS FindingsGroup ,
                    cd.name AS Finding ,
                    'http://www.BrentOzar.com/blitz/sp_configure/' AS URL ,
                    ( 'This sp_configure option has been changed.  Its default value is '
                      + CAST(cd.[DefaultValue] AS VARCHAR(100))
                      + ' and it has been set to '
                      + CAST(cr.value_in_use AS VARCHAR(100)) + '.' ) AS Details
            FROM    #ConfigurationDefaults cd
                    INNER JOIN sys.configurations cr ON cd.name = cr.name
            WHERE   cd.DefaultValue <> cr.value_in_use ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  23 AS CheckID ,
                    20 AS Priority ,
                    'Security' AS FindingsGroup ,
                    'Stored Procedure Runs Automatically' AS Finding ,
                    'http://www.BrentOzar.com/blitz/startup-stored-procedure/' AS URL ,
                    ( SPECIFIC_CATALOG + '.' + SPECIFIC_SCHEMA + '.'
                      + SPECIFIC_NAME
                      + ' is a stored procedure set to run automatically every time SQL Server starts up. Make sure you understand what it does.' ) AS Details
            FROM    master.INFORMATION_SCHEMA.ROUTINES
            WHERE   OBJECTPROPERTY(OBJECT_ID(ROUTINE_NAME), 'ExecIsStartup') = 1 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT DISTINCT
                    24 AS CheckID ,
                    20 AS Priority ,
                    'Reliability' AS FindingsGroup ,
                    'System Database on C Drive' AS Finding ,
                    'http://www.BrentOzar.com/blitz/system-databases-on-c-drive/' AS URL ,
                    ( 'The ' + DB_NAME(database_id)
                      + ' database has a file on the C drive.  Putting system databases on the C drive runs the risk of crashing the server when it runs out of space.' ) AS Details
            FROM    sys.master_files
            WHERE   UPPER(LEFT(physical_name, 1)) = 'C'
                    AND DB_NAME(database_id) IN ( 'master', 'model', 'msdb' ) ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT TOP 1
                    25 AS CheckID ,
                    100 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'TempDB on C Drive' AS Finding ,
                    'http://www.BrentOzar.com/blitz/system-databases-on-c-drive/' AS URL ,
                    ( 'The tempdb database has files on the C drive.  TempDB frequently grows unpredictably, putting your server at risk of running out of C drive space and crashing hard.  C is also often much slower than other drives, so performance may be suffering.' ) AS Details
            FROM    sys.master_files
            WHERE   UPPER(LEFT(physical_name, 1)) = 'C'
                    AND DB_NAME(database_id) = 'tempdb' ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT DISTINCT
                    26 AS CheckID ,
                    20 AS Priority ,
                    'Reliability' AS FindingsGroup ,
                    'User Databases on C Drive' AS Finding ,
                    'http://www.BrentOzar.com/blitz/user-databases-on-c-drive/' AS URL ,
                    ( 'The ' + DB_NAME(database_id)
                      + ' database has a file on the C drive.  Putting databases on the C drive runs the risk of crashing the server when it runs out of space.' ) AS Details
            FROM    sys.master_files
            WHERE   UPPER(LEFT(physical_name, 1)) = 'C'
                    AND DB_NAME(database_id) NOT IN ( 'master', 'model',
                                                      'msdb', 'tempdb' ) ;


    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  27 AS CheckID ,
                    200 AS Priority ,
                    'Informational' AS FindingsGroup ,
                    'Tables in the Master Database' AS Finding ,
                    'http://www.BrentOzar.com/blitz/tables-master-database/' AS URL ,
                    ( 'The ' + name
                      + ' table in the master database was created by end users on '
                      + CAST(create_date AS VARCHAR(20))
                      + '. Tables in the master database may not be restored in the event of a disaster.' ) AS Details
            FROM    master.sys.tables
            WHERE   is_ms_shipped = 0 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  28 AS CheckID ,
                    200 AS Priority ,
                    'Informational' AS FindingsGroup ,
                    'Tables in the MSDB Database' AS Finding ,
                    'http://www.BrentOzar.com/blitz/tables-msdb-database/' AS URL ,
                    ( 'The ' + name
                      + ' table in the msdb database was created by end users on '
                      + CAST(create_date AS VARCHAR(20))
                      + '. Tables in the msdb database may not be restored in the event of a disaster.' ) AS Details
            FROM    msdb.sys.tables
            WHERE   is_ms_shipped = 0 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  29 AS CheckID ,
                    200 AS Priority ,
                    'Informational' AS FindingsGroup ,
                    'Tables in the Model Database' AS Finding ,
                    'http://www.BrentOzar.com/blitz/tables-model-database/' AS URL ,
                    ( 'The ' + name
                      + ' table in the model database was created by end users on '
                      + CAST(create_date AS VARCHAR(20))
                      + '. Tables in the model database are automatically copied into all new databases.' ) AS Details
            FROM    model.sys.tables
            WHERE   is_ms_shipped = 0 ;

    IF NOT EXISTS ( SELECT  *
                    FROM    msdb.dbo.sysalerts ) 
        INSERT  INTO #BlitzResults
                ( CheckID ,
                  Priority ,
                  FindingsGroup ,
                  Finding ,
                  URL ,
                  Details
                )
                SELECT  30 AS CheckID ,
                        50 AS Priority ,
                        'Reliability' AS FindingsGroup ,
                        'No Alerts Configured' AS Finding ,
                        'http://www.BrentOzar.com/blitz/configure-sql-server-alerts/' AS URL ,
                        ( 'No SQL Server Agent alerts have been configured.  This is a free, easy way to get notified of corruption, job failures, or major outages even before monitoring systems pick it up.' ) AS Details ;

    IF NOT EXISTS ( SELECT  *
                    FROM    msdb.dbo.sysoperators
                    WHERE   enabled = 1 ) 
        INSERT  INTO #BlitzResults
                ( CheckID ,
                  Priority ,
                  FindingsGroup ,
                  Finding ,
                  URL ,
                  Details
                )
                SELECT  31 AS CheckID ,
                        50 AS Priority ,
                        'Reliability' AS FindingsGroup ,
                        'No Operators Configured/Enabled' AS Finding ,
                        'http://www.BrentOzar.com/blitz/configure-sql-server-operators/' AS URL ,
                        ( 'No SQL Server Agent operators (emails) have been configured.  This is a free, easy way to get notified of corruption, job failures, or major outages even before monitoring systems pick it up.' ) AS Details ;

    EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT DISTINCT 32, 110, ''Performance'', ''Triggers on Tables'', ''http://www.BrentOzar.com/blitz/table-triggers/'', (''The ? database has triggers on the '' + s.name + ''.'' + o.name + '' table.'') FROM [?].sys.triggers t INNER JOIN [?].sys.objects o ON t.parent_id = o.object_id INNER JOIN [?].sys.schemas s ON o.schema_id = s.schema_id WHERE t.is_ms_shipped = 0' ;

    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT DISTINCT 33, 200, ''Licensing'', ''Enterprise Edition Features In Use'', ''http://www.BrentOzar.com/blitz/enterprise-edition-features/'', (''The ? database is using '' + feature_name + ''.  If this database is restored onto a Standard Edition server, the restore will fail.'') FROM [?].sys.dm_db_persisted_sku_features' ;
        END ;


    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            SELECT TOP 1
                    34 AS CheckID ,
                    1 AS Priority ,
                    ''Corruption'' AS FindingsGroup ,
                    ''Database Corruption Detected'' AS Finding ,
                    ''http://www.BrentOzar.com/blitz/mirroring-automatic-page-repair-corruption/'' AS URL ,
                    ( ''Database mirroring has automatically repaired at least one corrupt page in the last 30 days. For more information, query the DMV sys.dm_db_mirroring_auto_page_repair.'' ) AS Details
            FROM    sys.dm_db_mirroring_auto_page_repair
            WHERE   modification_time >= DATEADD(dd, -30, GETDATE()) ;'
            EXECUTE(@StringToExecute)
        END ;

	IF @CheckProcedureCache = 1
	BEGIN
    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  35 AS CheckID ,
                    100 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Single-Use Plans in Procedure Cache' AS Finding ,
                    'http://www.BrentOzar.com/blitz/single-use-plans-procedure-cache/' AS URL ,
                    ( CAST(COUNT(*) AS VARCHAR(10))
                      + ' query plans are taking up '
                      + CAST(( SUM(cp.size_in_bytes * 1.0) / 1048576 ) AS VARCHAR(20))
                      + ' megabytes in the procedure cache. This may be wasted memory if we cache plans for queries that never get called again. This may be a good use case for SQL Server 2008''s Optimize for Ad Hoc or for Forced Parameterization.' ) AS Details
            FROM    sys.dm_exec_cached_plans AS cp
                    CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
            WHERE   cp.usecounts = 1
                    AND qp.query_plan IS NOT NULL
                    AND cp.objtype = 'Adhoc'
            HAVING  COUNT(*) > 1 ;
	END

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT DISTINCT
                    36 AS CheckID ,
                    100 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Slow Storage Reads on Drive '
                    + UPPER(LEFT(mf.physical_name, 1)) AS Finding ,
                    'http://www.BrentOzar.com/blitz/slow-storage-reads-writes/' AS URL ,
                    'Reads are averaging longer than 100ms for at least one database on this drive.  For specific database file speeds, run the query from the information link.' AS Details
            FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
                    INNER JOIN sys.master_files AS mf ON fs.database_id = mf.database_id
                                                         AND fs.[file_id] = mf.[file_id]
            WHERE   ( io_stall_read_ms / ( 1.0 + num_of_reads ) ) > 100 ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT DISTINCT
                    37 AS CheckID ,
                    100 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Slow Storage Writes on Drive '
                    + UPPER(LEFT(mf.physical_name, 1)) AS Finding ,
                    'http://www.BrentOzar.com/blitz/slow-storage-reads-writes/' AS URL ,
                    'Writes are averaging longer than 20ms for at least one database on this drive.  For specific database file speeds, run the query from the information link.' AS Details
            FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
                    INNER JOIN sys.master_files AS mf ON fs.database_id = mf.database_id
                                                         AND fs.[file_id] = mf.[file_id]
            WHERE   ( io_stall_write_ms / ( 1.0 + num_of_writes ) ) > 20 ;


    IF ( SELECT COUNT(*)
         FROM   tempdb.sys.database_files
         WHERE  type_desc = 'ROWS'
       ) = 1 
        BEGIN
            INSERT  INTO #BlitzResults
                    ( CheckID ,
                      Priority ,
                      FindingsGroup ,
                      Finding ,
                      URL ,
                      Details
                    )
            VALUES  ( 40 ,
                      100 ,
                      'Performance' ,
                      'TempDB Only Has 1 Data File' ,
                      'http://www.BrentOzar.com/blitz/tempdb-data-files/' ,
                      'TempDB is only configured with one data file.  More data files are usually required to alleviate SGAM contention.'
                    ) ;
        END ;

    EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT 41, 100, ''Performance'', ''Multiple Log Files on One Drive'', ''http://www.BrentOzar.com/blitz/multiple-log-files-same-drive/'', (''The ? database has multiple log files on the '' + LEFT(physical_name, 1) + '' drive. This is not a performance booster because log file access is sequential, not parallel.'') FROM [?].sys.database_files WHERE type_desc = ''LOG'' AND ''?'' <> ''[tempdb]'' GROUP BY LEFT(physical_name, 1) HAVING COUNT(*) > 1' ;

    EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT DISTINCT 42, 100, ''Performance'', ''Uneven File Growth Settings in One Filegroup'', ''http://www.BrentOzar.com/blitz/file-growth-settings/'', (''The ? database has multiple data files in one filegroup, but they are not all set up to grow in identical amounts.  This can lead to uneven file activity inside the filegroup.'') FROM [?].sys.database_files WHERE type_desc = ''ROWS'' GROUP BY data_space_id HAVING COUNT(DISTINCT growth) > 1 OR COUNT(DISTINCT is_percent_growth) > 1' ;

    IF EXISTS ( SELECT  *
                FROM    sys.traces
                WHERE   is_default = 0 ) 
        BEGIN
            INSERT  INTO #BlitzResults
                    ( CheckID ,
                      Priority ,
                      FindingsGroup ,
                      Finding ,
                      URL ,
                      Details
                    )
                    SELECT  44 AS CheckID ,
                            110 AS Priority ,
                            'Performance' AS FindingsGroup ,
                            'Queries Forcing Order Hints' AS Finding ,
                            'http://www.BrentOzar.com/blitz/query-hints-optimizer/' AS URL ,
                            CAST(occurrence AS VARCHAR(10))
                            + ' instances of order hinting have been recorded since restart.  This means queries are bossing the SQL Server optimizer around, and if they don''t know what they''re doing, this can cause more harm than good.  This can also explain why DBA tuning efforts aren''t working.' AS Details
                    FROM    sys.dm_exec_query_optimizer_info
                    WHERE   counter = 'order hint'
                            AND occurrence > 1
        END

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  45 AS CheckID ,
                    110 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Queries Forcing Join Hints' AS Finding ,
                    'http://www.BrentOzar.com/blitz/query-hints-optimizer/' AS URL ,
                    CAST(occurrence AS VARCHAR(10))
                    + ' instances of join hinting have been recorded since restart.  This means queries are bossing the SQL Server optimizer around, and if they don''t know what they''re doing, this can cause more harm than good.  This can also explain why DBA tuning efforts aren''t working.' AS Details
            FROM    sys.dm_exec_query_optimizer_info
            WHERE   counter = 'join hint'
                    AND occurrence > 1



    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  49 AS CheckID ,
                    200 AS Priority ,
                    'Informational' AS FindingsGroup ,
                    'Linked Server Configured' AS Finding ,
                    'http://www.BrentOzar.com/blitz/linked-servers/' AS URL ,
                    'The server [' + name
                    + '] is configured as a linked server. Check its security configuration to make sure it isn''t connecting with SA or some other bone-headed administrative login, because any user who queries it might get admin-level permissions.' AS Details
            FROM    sys.servers
            WHERE   is_linked = 1



    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            SELECT  50 AS CheckID ,
                    100 AS Priority ,
                    ''Performance'' AS FindingsGroup ,
                    ''Max Memory Set Too High'' AS Finding ,
                    ''http://www.BrentOzar.com/blitz/max-memory/'' AS URL ,
                    ''SQL Server max memory is set to ''
                    + CAST(c.value_in_use AS VARCHAR(20))
                    + '' megabytes, but the server only has ''
                    + CAST(( CAST(m.total_physical_memory_kb AS BIGINT) / 1024 ) AS VARCHAR(20))
                    + '' megabytes.  SQL Server may drain the system dry of memory, and under certain conditions, this can cause Windows to swap to disk.'' AS Details
            FROM    sys.dm_os_sys_memory m
                    INNER JOIN sys.configurations c ON c.name = ''max server memory (MB)''
            WHERE   CAST(m.total_physical_memory_kb AS BIGINT) < ( CAST(c.value_in_use AS BIGINT) * 1024 )'
            EXECUTE(@StringToExecute)
        END ;



    IF @@version NOT LIKE '%Microsoft SQL Server 2000%'
        AND @@version NOT LIKE '%Microsoft SQL Server 2005%' 
        BEGIN
            SET @StringToExecute = 'INSERT INTO #BlitzResults (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            SELECT  51 AS CheckID ,
                    1 AS Priority ,
                    ''Performance'' AS FindingsGroup ,
                    ''Memory Dangerously Low'' AS Finding ,
                    ''http://www.BrentOzar.com/blitz/max-memory/'' AS URL ,
                    ''Only ''
                    + CAST(( CAST(m.available_physical_memory_kb AS BIGINT)
                             / 1024 ) AS VARCHAR(20))
                    + '' megabytes, but the server only has ''
                    + CAST(( CAST(m.total_physical_memory_kb AS BIGINT) / 1024 ) AS VARCHAR(20))
                    + ''megabytes of memory are free.  As the server runs out of memory, there is danger of swapping to disk, which will kill performance.'' AS Details
            FROM    sys.dm_os_sys_memory m
            WHERE   CAST(m.available_physical_memory_kb AS BIGINT) < 262144'
            EXECUTE(@StringToExecute)
        END ;



/*
    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  52 AS CheckID ,
                    200 AS Priority ,
                    'Performance' AS FindingsGroup ,
                    'Virtual Server' AS Finding ,
                    'http://www.BrentOzar.com/go/virtual/' AS URL ,
                    'This is a virtual server running under a hypervisor. Nothing wrong with that - just letting you know.' AS Details
            FROM    sys.dm_os_sys_info
            WHERE   virtual_machine_type <> 0
*/

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT TOP 1
                    53 AS CheckID ,
                    200 AS Priority ,
                    'High Availability' AS FindingsGroup ,
                    'Cluster Node' AS Finding ,
                    'http://www.BrentOzar.com/blitz/clustering/' AS URL ,
                    'This is a node in a cluster.' AS Details
            FROM    sys.dm_os_cluster_nodes

/*
    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  54 AS CheckID ,
                    200 AS Priority ,
                    'Service Accounts' AS FindingsGroup ,
                    servicename AS Finding ,
                    'http://www.BrentOzar.com/blitz/service-account/' AS URL ,
                    'This service is running as [' + service_account
                    + '].  This affects the server''s ability to copy files to network locations, lock pages in memory, and perform Instant File Initialization.' AS Details
            FROM    sys.dm_server_services
*/

/* Thanks to Ali for this check! http://www.alirazeghi.com */
    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  55 AS CheckID ,
                    200 AS Priority ,
                    'Security' AS FindingsGroup ,
                    'Database Owner <> SA' AS Finding ,
                    'http://www.brentozar.com/blitz/database-owners/' AS URL ,
                    ( 'Database name: ' + name + '   ' + 'Owner name: '
                      + SUSER_SNAME(owner_sid) ) AS Details
            FROM    sys.databases
            WHERE   SUSER_SNAME(owner_sid) <> SUSER_SNAME(0x01) ;

    EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT 56, 100, ''Performance'', ''Check Constraint Not Trusted'', ''http://www.BrentOzar.com/blitz/foreign-key-trusted/'', (''The check constraint [?].['' + s.name + ''].['' + o.name + ''].['' + i.name + ''] is not trusted - meaning, it was disabled, data was changed, and then the constraint was enabled again.  Simply enabling the constraint is not enough for the optimizer to use this constraint - we have to alter the table using the WITH CHECK CHECK CONSTRAINT parameter.'') from [?].sys.check_constraints i INNER JOIN [?].sys.objects o ON i.parent_object_id = o.object_id INNER JOIN [?].sys.schemas s ON o.schema_id = s.schema_id WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0' ;

    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
            SELECT  57 AS CheckID ,
                    10 AS Priority ,
                    'Security' AS FindingsGroup ,
                    'SQL Agent Job Runs at Startup' AS Finding ,
                    'http://www.BrentOzar.com/blitz/startup-stored-procedures-master/' AS URL ,
                    ( 'Job ' + j.name
                      + '] runs automatically when SQL Server Agent starts up.  Make sure you know exactly what this job is doing, because it could pose a security risk.' ) AS Details
            FROM    msdb.dbo.sysschedules sched
                    JOIN msdb.dbo.sysjobschedules jsched ON sched.schedule_id = jsched.schedule_id
                    JOIN msdb.dbo.sysjobs j ON jsched.job_id = j.job_id
            WHERE   sched.freq_type = 64 ;

    IF @CheckUserDatabaseObjects = 1 
        BEGIN

            EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT DISTINCT 38, 110, ''Performance'', ''Active Tables Without Clustered Indexes'', ''http://www.BrentOzar.com/blitz/heaps-tables-without-primary-key-clustered-index/'', (''The ? database has heaps - tables without a clustered index - that are being actively queried.'') FROM [?].sys.indexes i INNER JOIN [?].sys.objects o ON i.object_id = o.object_id INNER JOIN [?].sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id INNER JOIN sys.databases sd ON sd.name = ''?'' LEFT OUTER JOIN [?].sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id AND ius.database_id = sd.database_id WHERE i.type_desc = ''HEAP'' AND COALESCE(ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates) IS NOT NULL AND sd.name <> ''tempdb''' ;

            EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT DISTINCT 39, 110, ''Performance'', ''Inactive Tables Without Clustered Indexes'', ''http://www.BrentOzar.com/blitz/heaps-tables-without-primary-key-clustered-index/'', (''The ? database has heaps - tables without a clustered index - that have not been queried since the last restart.  These may be backup tables carelessly left behind.'') FROM [?].sys.indexes i INNER JOIN [?].sys.objects o ON i.object_id = o.object_id INNER JOIN [?].sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id INNER JOIN sys.databases sd ON sd.name = ''?'' LEFT OUTER JOIN [?].sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id AND ius.database_id = sd.database_id WHERE i.type_desc = ''HEAP'' AND COALESCE(ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates) IS NULL AND sd.name <> ''tempdb''' ;



            EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT 46, 100, ''Performance'', ''Leftover Fake Indexes From Wizards'', ''http://www.BrentOzar.com/blitz/hypothetical-indexes-index-tuning-wizard/'', (''The index [?].['' + s.name + ''].['' + o.name + ''].['' + i.name + ''] is a leftover hypothetical index from the Index Tuning Wizard or Database Tuning Advisor.  This index is not actually helping performance and should be removed.'') from [?].sys.indexes i INNER JOIN [?].sys.objects o ON i.object_id = o.object_id INNER JOIN [?].sys.schemas s ON o.schema_id = s.schema_id WHERE i.is_hypothetical = 1' ;

            EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT 47, 100, ''Performance'', ''Indexes Disabled'', ''http://www.BrentOzar.com/blitz/indexes-disabled/'', (''The index [?].['' + s.name + ''].['' + o.name + ''].['' + i.name + ''] is disabled.  This index is not actually helping performance and should either be enabled or removed.'') from [?].sys.indexes i INNER JOIN [?].sys.objects o ON i.object_id = o.object_id INNER JOIN [?].sys.schemas s ON o.schema_id = s.schema_id WHERE i.is_disabled = 1' ;

            EXEC dbo.sp_MSforeachdb 'INSERT INTO #BlitzResults SELECT 48, 100, ''Performance'', ''Foreign Key Not Trusted'', ''http://www.BrentOzar.com/blitz/foreign-key-trusted/'', (''The foreign key [?].['' + s.name + ''].['' + o.name + ''].['' + i.name + ''] is not trusted - meaning, it was disabled, data was changed, and then the key was enabled again.  Simply enabling the key is not enough for the optimizer to use this key - we have to alter the table using the WITH CHECK CHECK CONSTRAINT parameter.'') from [?].sys.foreign_keys i INNER JOIN [?].sys.objects o ON i.parent_object_id = o.object_id INNER JOIN [?].sys.schemas s ON o.schema_id = s.schema_id WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0' ;

        END /* IF @CheckUserDatabaseObjects = 1 */




    INSERT  INTO #BlitzResults
            ( CheckID ,
              Priority ,
              FindingsGroup ,
              Finding ,
              URL ,
              Details
            )
    VALUES  ( -1 ,
              255 ,
              'Thanks!' ,
              'From Brent Ozar PLF, LLC' ,
              'http://www.BrentOzar.com/blitz/' ,
              'Thanks from the Brent Ozar PLF, LLC team.  We hope you found this tool useful, and if you need help relieving your SQL Server pains, email us at Help@BrentOzar.com.'
            ) ;

    SELECT  [Priority] ,
            [FindingsGroup] ,
            [Finding] ,
            ( [URL] + '?VersionNumber=' + @VersionNumber ) AS [URL] ,
            [Details] ,
            CheckID
    FROM    #BlitzResults
    ORDER BY Priority ,
            FindingsGroup ,
            Finding ,
            Details ;
  
  
    DROP TABLE #BlitzResults ;
    SET NOCOUNT OFF ;
GO
