
USE [DBA]
GO
CREATE SCHEMA [TestRestore] AUTHORIZATION [dbo]
GO


-- list of databases to test restore on 
CREATE TABLE TestRestore.RestoreDatabases
(
    ServerName VARCHAR(50) NOT NULL,
    DatabaseName VARCHAR(500) NOT NULL
);

ALTER TABLE TestRestore.RestoreDatabases WITH CHECK ADD CONSTRAINT PK_RestoreDatabases_ServerNameDatabaseName PRIMARY KEY CLUSTERED
    (ServerName, DatabaseName);


-- temporary holding table for list of restore commands for a database - populated by PowerShell script
CREATE TABLE TestRestore.TempRestoreList
(
    ServerName VARCHAR(50) NOT NULL,
    DatabaseName VARCHAR(500) NOT NULL,
    BackupSetID INT NOT NULL,
    RestoreCommand VARCHAR(2000) NOT NULL
);



-- results of test restores and dbcc checkdb 
CREATE TABLE TestRestore.RestoreResults
(
    RestoreResultsID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_RestoreResults_RestoreResultsID PRIMARY KEY CLUSTERED,
    ServerName VARCHAR(50) NOT NULL,
    DatabaseName VARCHAR(500) NOT NULL,
    Command VARCHAR(2000) NOT NULL,
    StartTime DATETIME2 NOT NULL, 
    EndTime DATETIME2 NULL,
    ErrorNumber INT NULL,
    ErrorMessage VARCHAR(Max) NULL
);

INSERT INTO TestRestore.RestoreDatabases
	   (ServerName, DatabaseName)
VALUES  ('csan1db01', -- ServerName - varchar(50)
	    'QA'  -- DatabaseName - varchar(500)
	    ),
	   ('csan1db01'
	   ,'Total_Rewards')
	   ,('ccal0db123'
	   ,'EMT');
GO


ALTER PROC TestRestore.RestoreDatabase

AS 
     /*********************************************************************************
	   Name:       dbo.RestoreDatabase
     
	   Author:     Dan Denney
     
	   Purpose:    This procedure will, in a loop, restore the database, run a checkDB, 
				then drop the database then move to the next database in the 
				TempRestoreList table.    			 
     
	   Notes:		Called from a Powershell script within a SQL Agent job.							
     
	   Date        Initials    Description
	   ----------------------------------------------------------------------------
	   2013-22-4	DDD		  Initial Release 
	   ----------------------------------------------------------------------------
    *********************************************************************************
	    Usage: 		
		    EXEC dbo.RestoreDatabase
    *********************************************************************************/
    SET NOCOUNT ON

    DECLARE @BackupCommand	  NVARCHAR(2000)
		  ,@ServerName		  VARCHAR(50)
		  ,@DatabaseName	  VARCHAR(500)
		  ,@BackupSetID	  INT
		  ,@DBCCCommand	  NVARCHAR(2000)
		  ,@CheckDBCommand	  NVARCHAR(2000)
		  ,@DropCommand	  NVARCHAR(2000)
		  ,@Error			  INT
		  ,@StartTime		  DATETIME2
		  ,@RestoreResultsID  INT;

    DECLARE curRestore CURSOR LOCAL READ_ONLY FAST_FORWARD FOR 
	   SELECT ServerName, DatabaseName, BackupSetID, RestoreCommand
	   FROM TestRestore.TempRestoreList AS trl
	   ORDER BY ServerName ASC, DatabaseName ASC, BackupSetID ASC
    
    OPEN curRestore;

    FETCH NEXT FROM curRestore INTO @ServerName, @DatabaseName, @BackupSetID, @BackupCommand
    WHILE @@FETCH_STATUS = 0 
	   BEGIN
		  --Initial Log Info
		  SET @StartTime = SYSDATETIME();

		  INSERT INTO TestRestore.RestoreResults
				(ServerName, DatabaseName, Command, StartTime, EndTime, ErrorNumber,ErrorMessage)	   
		  VALUES  (@ServerName, @DatabaseName, @BackupCommand, @StartTime, NULL, NULL, NULL);
		  
		  SET @RestoreResultsID = SCOPE_IDENTITY();
		  -- 

		  EXEC sp_executesql @BackupCommand;
		  SET @Error = @@ERROR;

		  --Log completion info
		  UPDATE TestRestore.RestoreResults
			 SET EndTime = SYSDATETIME(),
				ErrorNumber = @Error
			 WHERE RestoreResultsID = @RestoreResultsID;
		  -- 

		  IF @BackupSetID =   999999999
		  BEGIN
			 -- CHECKDB
			 SET @CheckDBCommand = 'DBCC CHECKDB (' + @DatabaseName + '_Restore) WITH NO_INFOMSGS, PHYSICAL_ONLY;';
			 
			 --Initial Log Info
			 SET @StartTime = SYSDATETIME();

			 INSERT INTO TestRestore.RestoreResults
				    (ServerName, DatabaseName, Command, StartTime, EndTime, ErrorNumber,ErrorMessage)	   
			 VALUES  (@ServerName, @DatabaseName, @CheckDBCommand, @StartTime, NULL, NULL, NULL);
		  
			 SET @RestoreResultsID = SCOPE_IDENTITY();
			 -- 
			
			 EXEC (@CheckDBCommand);	
			 SET @Error = @@ERROR;

			  --Log completion info
			 UPDATE TestRestore.RestoreResults
				SET EndTime = SYSDATETIME(),
				    ErrorNumber = @Error
				WHERE RestoreResultsID = @RestoreResultsID;
			 -- 
			 
			 -- DROP DATABASE
			 SET @DropCommand = 'DROP DATABASE ' + @DatabaseName + '_Restore';

			 EXEC (@DropCommand);
		  END

		  FETCH NEXT FROM curRestore INTO @ServerName, @DatabaseName, @BackupSetID, @BackupCommand	 
	   END    

    CLOSE curRestore;
    DEALLOCATE curRestore;

    -- Remove RestoreResults older than 120 days
    DELETE FROM TestRestore.RestoreResults 
    WHERE StartTime < DATEADD(dd, -120, SYSDATETIME())

    TRUNCATE TABLE TestRestore.TempRestoreList;
GO
