
/**************************************************************************************************
**
**  author: Daniel Denney (based on Richard Ding's previous work)
**  date:   4/15/2010
**  usage:  deletes SQL BAK files older than a certain date
**
**		exec DBA.dbo.sp_Delete_BAK_Files 'C:\Test', 4
**
**************************************************************************************************/
CREATE PROC dbo.usp_Delete_BAK_Files
	@bak_path NVARCHAR(500),
	@delete_days INT			-- # of days back to delete bak files
AS
	SET NOCOUNT ON
	
	DECLARE @delete_date NVARCHAR(19)
	DECLARE @sql NVARCHAR(1000)
	
	SET @delete_date = CONVERT(VARCHAR(19), (GETDATE() - @delete_days), 126)
	
	SET @sql = 'EXECUTE master.dbo.xp_delete_file 0, N''' + @bak_path + ''',N''BAK'',N''' + @delete_date + ''' '
	
	EXEC sp_executesql @sql
		
GO