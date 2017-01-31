/**************************************************************************************************
**
**  author: Daniel Denney 
**  date:   4/16/2010
**  usage:  code to backup databases
**
**	exec dbo.sp_Backup_Database 'DBA', '\\csan0as93\RemoteBackup\csan0db070', 1, 0
**   
**************************************************************************************************/
CREATE PROC dbo.usp_Backup_Database
	@database NVARCHAR(100),
	@backup_path NVARCHAR(500),
	@backup_type TINYINT = 1,	-- 1 Full, 2 Differential, 3 Log
	@verify_backup BIT = 0		-- 0 No, 1 Yes

AS
	SET NOCOUNT ON
		
	DECLARE	@Backup_Name NVARCHAR(200)
	DECLARE @Backup_File NVARCHAR(600)
	DECLARE @sql NVARCHAR(1000)
	DECLARE @backup_date NVARCHAR(20)
	
	IF CHARINDEX('\', REVERSE(@BACKUP_PATH)) = 1	-- Removes Trailing '\'
		SET @backup_path = LEFT(@BACKUP_PATH, LEN(@BACKUP_PATH)-1)
				
	SET @backup_date = CONVERT(NVARCHAR(8),GETDATE(),112) + '_' + REPLACE(CONVERT(NVARCHAR(8),GETDATE(),108),':','')
		
	IF @backup_type = 1			-- FULL DATABASE BACKUP
		BEGIN
			SET @Backup_Name = @database + '-Full Database Backup'
			
			SET @Backup_File = @backup_path + '\' + @database + '_Full_' + @backup_date + '.BAK'
			
			SET @sql = 'BACKUP DATABASE [' + @database + '] TO DISK = N''' + @Backup_File +
						''' WITH NOFORMAT, INIT, NAME = N''' + @Backup_Name + ''', SKIP, NOREWIND, NOUNLOAD'
		END	
		
	ELSE IF @backup_type = 2	-- DIFFERENTIAL DATABASE BACKUP
		BEGIN
			SET @Backup_Name = @database + '-Differential Database Backup'		
				
			SET @Backup_File = @backup_path + '\' + @database + '_Differential_' + @backup_date + '.BAK'
			
			SET @sql = 'BACKUP DATABASE [' + @database + '] TO DISK = N''' + @Backup_File +
						''' WITH DIFFERENTIAL, NOFORMAT, INIT, NAME = N''' + @Backup_Name + ''', SKIP, NOREWIND, NOUNLOAD'
		END
		
	ELSE IF @backup_type = 3	-- TRANSACTION LOG BACKUP
		BEGIN
			SET @Backup_Name = @database + '-Transaction Log backup'
			
			SET @Backup_File = @backup_path + '\' + @database + '_Log_' + @backup_date + '.BAK'
			
			SET @sql = 'BACKUP LOG [' + @database + '] TO DISK = N''' + @Backup_File +
						''' WITH NOFORMAT, INIT, NAME = N''' + @Backup_Name + ''', SKIP, NOREWIND, NOUNLOAD'
		END
		
	--	print @sql
	EXEC sp_executesql @sql
	
	IF @verify_backup = 1
		BEGIN
			DECLARE @backupSetId AS NVARCHAR(100)
			DECLARE @verify_sql NVARCHAR(1000)
			
			SELECT @backupSetId = POSITION 
				FROM msdb..backupset 
				WHERE database_name= @database
					AND backup_set_id=
						(SELECT MAX(backup_set_id) 
							FROM msdb..backupset 
							WHERE database_name=@database)
				
			IF @backupSetId IS NULL 
				RAISERROR(N'Verify failed. Backup information for database ''DBA'' not found.', 16, 1) 
			
			SET @verify_sql = 'RESTORE VERIFYONLY FROM  DISK = N''' + @Backup_File + ''' WITH  FILE = ' + @backupSetId + ',  NOUNLOAD,  NOREWIND'			
			
			EXEC sp_executesql @verify_sql
		END
GO