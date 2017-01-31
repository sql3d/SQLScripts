
USE DBA 
GO

IF EXISTS (SELECT * FROM sys.objects WHERE [OBJECT_ID] = OBJECT_ID(N'[dbo].[gather_file_stats]') AND OBJECTPROPERTY([OBJECT_ID], N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[gather_file_stats] ;
GO

IF OBJECT_ID(N'[dbo].[file_stats]',N'U') IS NULL
    CREATE TABLE [dbo].[file_stats](
	    [database_id] [SMALLINT] NOT NULL,
	    [FILE_ID] [SMALLINT] NOT NULL,
	    [num_of_reads] [BIGINT] NOT NULL,
	    [num_of_bytes_read] [BIGINT] NOT NULL,
	    [io_stall_read_ms] [BIGINT] NOT NULL,
	    [num_of_writes] [BIGINT] NOT NULL,
	    [num_of_bytes_written] [BIGINT] NOT NULL,
	    [io_stall_write_ms] [BIGINT] NOT NULL,
	    [io_stall] [BIGINT] NOT NULL,
	    [size_on_disk_bytes] [BIGINT] NOT NULL,
        [capture_time] [DATETIME] NOT NULL
        ) ;
GO        


CREATE PROCEDURE [dbo].[gather_file_stats] 
	@Clear INT = 0
AS
	SET NOCOUNT ON ;

	DECLARE @DT DATETIME ;
	
	SET @DT = GETDATE() ;

	--  If 1 the clear out the table
	IF @Clear = 1
	BEGIN
		TRUNCATE TABLE [dbo].[file_stats] ;
	END

	INSERT INTO [dbo].[file_stats]
		  ([database_id]
		  ,[FILE_ID]
		  ,[num_of_reads]
		  ,[num_of_bytes_read]
		  ,[io_stall_read_ms]
		  ,[num_of_writes]
		  ,[num_of_bytes_written]
		  ,[io_stall_write_ms]
		  ,[io_stall]
		  ,[size_on_disk_bytes]
		  ,[capture_time])
	SELECT [database_id]
		  ,[FILE_ID]
		  ,[num_of_reads]
		  ,[num_of_bytes_read]
		  ,[io_stall_read_ms]
		  ,[num_of_writes]
		  ,[num_of_bytes_written]
		  ,[io_stall_write_ms]
		  ,[io_stall]
		  ,[size_on_disk_bytes]
		  ,@DT
	FROM [sys].dm_io_virtual_file_stats(NULL,NULL) ;

GO

IF EXISTS (SELECT * FROM sys.objects WHERE [OBJECT_ID] = OBJECT_ID(N'[dbo].[report_file_stats]') AND OBJECTPROPERTY([OBJECT_ID], N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[report_file_stats] ;
GO

CREATE PROCEDURE [dbo].[report_file_stats] 
	@EndTime DATETIME = NULL,
	@BeginTime DATETIME = NULL 
	--  Date & time of the last sample to use
AS
	SET NOCOUNT ON ;

	IF OBJECT_ID( N'[dbo].[file_stats]',N'U') IS NULL
	BEGIN
			RAISERROR('Error [dbo].[file_stats] table does not exist', 16, 1) WITH NOWAIT ;
			RETURN ;
	END

	DECLARE @file_stats TABLE (
			[database_id] [SMALLINT] NOT NULL,
			[FILE_ID] [SMALLINT] NOT NULL,
			[num_of_reads] [BIGINT] NOT NULL,
			[num_of_bytes_read] [BIGINT] NOT NULL,
			[io_stall_read_ms] [BIGINT] NOT NULL,
			[num_of_writes] [BIGINT] NOT NULL,
			[num_of_bytes_written] [BIGINT] NOT NULL,
			[io_stall_write_ms] [BIGINT] NOT NULL,
			[io_stall] [BIGINT] NOT NULL,
			[size_on_disk_bytes] [BIGINT] NOT NULL,
			[capture_time] [DATETIME] NOT NULL
			)  ;

	--  If no time was specified then use the latest sample minus the first sample
	IF @BeginTime IS NULL
		SET @BeginTime = (SELECT MIN([capture_time]) FROM [dbo].[file_stats]) ;
	ELSE
	BEGIN
		--  If the time was not specified exactly find the closest one
		IF NOT EXISTS(SELECT * FROM [dbo].[file_stats] WHERE [capture_time] = @BeginTime)
		BEGIN
			DECLARE @BT DATETIME ;
			SET @BT = @BeginTime ;

			SET @BeginTime = (SELECT MIN([capture_time]) FROM [dbo].[file_stats] WHERE [capture_time] >= @BT) ;
			IF @BeginTime IS NULL
				SET @BeginTime = (SELECT MAX([capture_time]) FROM [dbo].[file_stats] WHERE [capture_time] <= @BT) ;
		END
	END

	IF @EndTime IS NULL
		SET @EndTime = (SELECT MAX([capture_time]) FROM [dbo].[file_stats]) ;
	ELSE
	BEGIN
		--  If the time was not specified exactly find the closest one
		IF NOT EXISTS(SELECT * FROM [dbo].[file_stats] WHERE [capture_time] = @EndTime)
		BEGIN
			DECLARE @ET DATETIME ;
			SET @ET = @EndTime ;

			SET @EndTime = (SELECT MIN([capture_time]) FROM [dbo].[file_stats] WHERE [capture_time] >= @ET) ;
			IF @EndTime IS NULL
				SET @EndTime = (SELECT MAX([capture_time]) FROM [dbo].[file_stats] WHERE [capture_time] <= @ET) ;
		END
	END

	INSERT INTO @file_stats
		  ([database_id],[FILE_ID],[num_of_reads],[num_of_bytes_read],[io_stall_read_ms]
		  ,[num_of_writes],[num_of_bytes_written],[io_stall_write_ms]
		  ,[io_stall],[size_on_disk_bytes],[capture_time])
	SELECT [database_id],[FILE_ID],[num_of_reads],[num_of_bytes_read],[io_stall_read_ms]
		  ,[num_of_writes],[num_of_bytes_written],[io_stall_write_ms]
		  ,[io_stall],[size_on_disk_bytes],[capture_time]
	FROM [dbo].[file_stats] 
		WHERE [capture_time] = @EndTime ;

	IF @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Error, there are no waits for the specified DateTime', 16, 1) WITH NOWAIT ;
		RETURN ;
	END

	--  Subtract the starting numbers from the end ones to find the difference for that time period
	UPDATE fs
			SET fs.[num_of_reads] = (fs.[num_of_reads] - a.[num_of_reads])
		   , fs.[num_of_bytes_read] = (fs.[num_of_bytes_read] - a.[num_of_bytes_read])
		   , fs.[io_stall_read_ms] = (fs.[io_stall_read_ms] - a.[io_stall_read_ms])
		   , fs.[num_of_writes] = (fs.[num_of_writes] - a.[num_of_writes])
		   , fs.[num_of_bytes_written] = (fs.[num_of_bytes_written] - a.[num_of_bytes_written])
		   , fs.[io_stall_write_ms] = (fs.[io_stall_write_ms] - a.[io_stall_write_ms])
		   , fs.[io_stall] = (fs.[io_stall] - a.[io_stall])
	FROM @file_stats AS fs INNER JOIN (SELECT b.[database_id],b.[file_id],b.[num_of_reads],b.[num_of_bytes_read],b.[io_stall_read_ms]
											,b.[num_of_writes],b.[num_of_bytes_written],b.[io_stall_write_ms],b.[io_stall]
										FROM [dbo].[file_stats] AS b
											WHERE b.[capture_time] = @BeginTime) AS a
						ON (fs.[database_id] = a.[database_id] AND fs.[file_id] = a.[file_id]) ;


	SELECT CONVERT(VARCHAR(50),@BeginTime,120) AS [START TIME], CONVERT(VARCHAR(50),@EndTime,120) AS [END TIME]
		,CONVERT(VARCHAR(50),@EndTime - @BeginTime,108) AS [Duration (hh:mm:ss)] ;


	SELECT fs.[database_id] AS [DATABASE ID], fs.[file_id] AS [FILE ID], fs.[num_of_reads] AS [NumberReads],
		 CONVERT(VARCHAR(20),CAST((fs.[num_of_bytes_read] / 1048576.0) AS MONEY),1) AS [MBs READ]
		,fs.[io_stall_read_ms] AS [IoStallReadMS]
		,fs.[num_of_writes] AS [NumberWrites]
		,CONVERT(VARCHAR(20),CAST((fs.[num_of_bytes_written] / 1048576.0) AS MONEY),1) AS [MBs Written]
		,fs.[io_stall_write_ms] AS [IoStallWriteMS]
		,fs.[io_stall] AS [IoStallMS]
		,CONVERT(VARCHAR(20),CAST((fs.[size_on_disk_bytes] / 1048576.0) AS MONEY),1) AS [MBsOnDisk]
		,(SELECT c.[name] FROM [master].[sys].[databases] AS c WHERE c.[database_id] = fs.[database_id]) AS [DB name]
		,(SELECT RIGHT(d.[physical_name],CHARINDEX('\',REVERSE(d.[physical_name]))-1) 
				FROM [master].[sys].[master_files] AS d 
					WHERE d.[file_id] = fs.[file_id] AND d.[database_id] = fs.[database_id]) AS [FILE name]
		,fs.[capture_time] AS [LAST Sample]
	FROM @file_stats AS fs
		ORDER BY fs.[database_id], fs.[file_id] ;

GO


USE [msdb]
GO

/****** Object:  Job [File Stats]    Script Date: 06/29/2010 10:43:35 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 06/29/2010 10:43:36 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'File Stats', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'CORP\dandenne', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [file_stats]    Script Date: 06/29/2010 10:43:36 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'file_stats', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dba.dbo.file_stats', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every hour', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20100629, 
		@active_end_date=99991231, 
		@active_start_time=2300, 
		@active_end_time=232259, 
		@schedule_uid=N'8d5d0698-400a-4350-a9db-ce6791db5dd0'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO