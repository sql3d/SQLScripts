/**************************************************************************************************
**
**  author: Daniel Denney 
**  date:   4/23/2010
**  usage:  starts a SQL Agent Job and waits to complete before moving on
**
**		exec DBA.dbo.sp_start_job_wait_complete 'Backup - WSS_Content'
**
**************************************************************************************************/
CREATE PROC dbo.usp_start_job_wait_complete 
	@jobname NVARCHAR(100)
AS
	SET NOCOUNT ON
	
	DECLARE @status INT

	EXEC msdb.dbo.sp_start_job @jobname

	WHILE 1=1
	BEGIN
		WAITFOR delay '00:00:05'
		
		EXEC dba.dbo.usp_get_SQL_job_execution_status @jobname, 0, @execution_status = @status OUTPUT
		
		IF @status IN (4,5)
			BREAK
	END
GO