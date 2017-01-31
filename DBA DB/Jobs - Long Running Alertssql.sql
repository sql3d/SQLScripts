USE DBA
GO


CREATE PROC dbo.LongRunningJobsAlert 
    @MinHistExecutions INT = 20
    ,@MinAvgSecsDuration INT = 5 
    ,@SendTo VARCHAR(500)
AS  
    /*********************************************************************************
	   Name:       dbo.LongRunningJobsAlert
     
	   Author:     Dan Denney
     
	   Purpose:	To email alerts about jobs that are running more the 2 standard 
				    deviations longer than the average run time. 
     
	   Notes:		Uses Thomas LaRock's code (see notes below).
     
	   Date        Initials    Description
	   ----------------------------------------------------------------------------
	   2013-23-09	DDD		  Initial Release 
	   ----------------------------------------------------------------------------
    *********************************************************************************
	    Usage: 		
		    EXEC dbo.LongRunningJobsAlert
				@MinHistExecutions = 20
				,@MinAvgSecsDuration = 5
				,@SendTo = 'dan.denney@cox.com'
    *********************************************************************************/

    /*=============================================
	 File: long_running_jobs.sql
 
	 Author: Thomas LaRock, http://thomaslarock.com/contact-me/
 
	 Summary: This script will check to see if any currently
			    running jobs are running long. 
 
	 Variables:
		  @MinHistExecutions - Minimum number of job runs we want to consider 
		  @MinAvgSecsDuration - Threshold for minimum duration we care to monitor
		  @HistoryStartDate - Start date for historical average
		  @HistoryEndDate - End date for historical average
 
		  These variables allow for us to control a couple of factors. First
		  we can focus on jobs that are running long enough on average for
		  us to be concerned with (say, 30 seconds or more). Second, we can
		  avoid being alerted by jobs that have run so few times that the
		  average and standard deviations are not quite stable yet. This script
		  leaves these variables at 1.0, but I would advise you alter them
		  upwards after testing.
 
	 Returns: One result set containing a list of jobs that
	    are currently running and are running longer than two standard deviations 
		  away from their historical average. The "Min Threshold" column
		  represents the average plus two standard deviations. 
 
	 Date: October 3rd, 2012
 
	 SQL Server Versions: SQL2005, SQL2008, SQL2008R2, SQL2012
 
	 You may alter this code for your own purposes. You may republish
	 altered code as long as you give due credit. 
 
	 THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
	 OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
	 LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR
	 FITNESS FOR A PARTICULAR PURPOSE.
 
    =============================================*/

 
    SET NOCOUNT ON;

    DECLARE @HistoryStartDate DATETIME 
	   ,@HistoryEndDate DATETIME  

    SET @HistoryStartDate = '19000101';
    SET @HistoryEndDate = GETDATE();
 
    DECLARE @currently_running_jobs TABLE (
	   job_id UNIQUEIDENTIFIER NOT NULL
	   ,last_run_date INT NOT NULL
	   ,last_run_time INT NOT NULL
	   ,next_run_date INT NOT NULL
	   ,next_run_time INT NOT NULL
	   ,next_run_schedule_id INT NOT NULL
	   ,requested_to_run INT NOT NULL
	   ,request_source INT NOT NULL
	   ,request_source_id SYSNAME NULL
	   ,running INT NOT NULL
	   ,current_step INT NOT NULL
	   ,current_retry_attempt INT NOT NULL
	   ,job_state INT NOT NULL
	   );

    -- Had to create global temp table to work within the sp_send_dbmail proc
    CREATE TABLE ##longRunningJobs (
		  JobID UNIQUEIDENTIFIER NOT NULL
		  ,SessionID INT NOT NULL
		  ,JobName VARCHAR(200) NOT NULL
		  ,ExecutionDate DATETIME NOT NULL
		  ,HistoricalAvgDuration DEC(12,2) NOT NULL
		  ,MinThreshold DEC(12,2) NOT NULL
	   );
 
    --capture details on jobs
    INSERT INTO @currently_running_jobs
    EXECUTE master.dbo.xp_sqlagent_enum_jobs 1,'';
     
    ;WITH JobHistData AS
    (
	 SELECT job_id
	    ,date_executed=msdb.dbo.agent_datetime(run_date, run_time)
	    ,secs_duration=run_duration/10000*3600
					 +run_duration%10000/100*60
					 +run_duration%100
	 FROM msdb.dbo.sysjobhistory
	 WHERE step_id = 0   --Job Outcome
	   AND run_status = 1  --Succeeded
    )
    ,JobHistStats AS
    (
	 SELECT job_id
		  ,AvgDuration = AVG(secs_duration*1.)
		  ,AvgPlus2StDev = AVG(secs_duration*1.) + 2*stdevp(secs_duration)
	 FROM JobHistData
	 WHERE date_executed >= DATEADD(day, DATEDIFF(day,'19000101',@HistoryStartDate),'19000101')
		AND date_executed < DATEADD(day, 1 + DATEDIFF(day,'19000101',@HistoryEndDate),'19000101')   GROUP BY job_id   HAVING COUNT(*) >= @MinHistExecutions
		AND AVG(secs_duration*1.) >= @MinAvgSecsDuration
    )
    INSERT INTO ##longRunningJobs (jobID, sessionID, JobName, ExecutionDate, HistoricalAvgDuration, MinThreshold)
    SELECT jd.job_id
	   ,es.session_id
	   ,j.name AS [JobName]	   
	   ,MAX(act.start_execution_date) AS [ExecutionDate]
	   ,AvgDuration AS [Historical Avg Duration (secs)]
	   ,AvgPlus2StDev AS [Min Threshhold (secs)]
    FROM JobHistData jd
	   JOIN JobHistStats jhs on jd.job_id = jhs.job_id
	   JOIN msdb..sysjobs j on jd.job_id = j.job_id
	   JOIN @currently_running_jobs crj ON crj.job_id = jd.job_id
	   JOIN msdb..sysjobactivity AS act ON act.job_id = jd.job_id
		  AND act.stop_execution_date IS NULL
		  AND act.start_execution_date IS NOT NULL
	   INNER JOIN sys.dm_exec_sessions AS es ON jd.job_id = cast(convert( binary(16), substring(es.program_name , 30, 34), 1) as uniqueidentifier)
    WHERE secs_duration > AvgPlus2StDev
	   AND DATEDIFF(SS, act.start_execution_date, GETDATE()) > AvgPlus2StDev
	   AND crj.job_state = 1
    GROUP BY jd.job_id, es.session_id, j.name, AvgDuration, AvgPlus2StDev;

    IF (SELECT COUNT(*) FROM ##longRunningJobs) > 0
	   BEGIN
		  EXEC msdb.dbo.sp_send_dbmail 
			 @recipients = @sendTo
			 ,@subject = 'Long Running Job Detected'
			 ,@body = 'The following job(s) are currently taking longer to execute than normal: '
			 ,@query = 'SELECT jobName, sessionID, ExecutionDate FROM ##longRunningJobs'
	   END;

    DROP TABLE ##longRunningJobs;
GO

USE [msdb]
GO

/****** Object:  Job [Long Running Jobs Alert]    Script Date: 9/23/2013 1:34:10 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 9/23/2013 1:34:10 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Long Running Jobs Alert', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'CCI SAN CCC - SQL Notification', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Long Running Jobs]    Script Date: 9/23/2013 1:34:10 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Long Running Jobs', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC DBA.dbo.LongRunningJobsAlert
	@MinHistExecutions = 20
	,@MinAvgSecsDuration = 5
	,@SendTo = ''ccisanccc-sqlnotification@cox.com''', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Hourly', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130923, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


