/**************************************************************************************************
**
**  author: http://www.siccolo.com/Articles/SQLScripts/how-to-create-sql-to-sql-job-execution-status.html
**  date:   4/23/2010
**  usage:  returns the current execution status of a particular job
**
**	exec DBA.dbo.sp_get_SQL_job_execution_status 'Backup - WSS_Content', 0, @execution_status = @output OUTPUT
**
**
**	Is the execution status for the jobs. 
**		Value Description 
**		0 Returns only those jobs that are not idle or suspended.  
**		1 Executing. 
**		2 Waiting for thread. 
**		3 Between retries. 
**		4 Idle. 
**		5 Suspended. 
**		7 Performing completion action
**
**************************************************************************************************/
CREATE PROCEDURE dbo.usp_get_SQL_job_execution_status
		@job_name sysname
		, @select_data INT =0
		, @execution_status INT = NULL OUTPUT	
AS
	SET NOCOUNT ON
	
	DECLARE	@job_id UNIQUEIDENTIFIER 
		, @is_sysadmin INT
		, @job_owner   sysname

	SELECT @job_id = job_id FROM msdb..sysjobs_view WHERE name = @job_name 
	SELECT @is_sysadmin = ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0)
	SELECT @job_owner = SUSER_SNAME()

	CREATE TABLE #xp_results (job_id                UNIQUEIDENTIFIER NOT NULL,
	                            last_run_date         INT              NOT NULL,
	                            last_run_time         INT              NOT NULL,
	                            next_run_date         INT              NOT NULL,
	                            next_run_time         INT              NOT NULL,
	                            next_run_schedule_id  INT              NOT NULL,
	                            requested_to_run      INT              NOT NULL, -- BOOL
	                            request_source        INT              NOT NULL,
	                            request_source_id     sysname          COLLATE database_default NULL,
	                            running               INT              NOT NULL, -- BOOL
	                            current_step          INT              NOT NULL,
	                            current_retry_attempt INT              NOT NULL,
	                            job_state             INT              NOT NULL)


	IF ((@@microsoftversion / 0x01000000) >= 8) -- SQL Server 8.0 or greater
		    INSERT INTO #xp_results
		    EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner, @job_id
  	ELSE
		    INSERT INTO #xp_results
		    EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner


	--declare @execution_status int
	SET @execution_status = (SELECT job_state FROM #xp_results)

	DROP TABLE #xp_results

	IF @select_data =1 
		SELECT @job_name AS 'job_name', @execution_status AS 'execution_status'
GO