USE DBA
GO

CREATE PROC dbo.usp_SuspectPages
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


