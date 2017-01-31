

SET NOCOUNT ON

DECLARE @backup_set_id_Full INT
DECLARE @Full_Backup_Set_Date DATETIME
DECLARE @backup_set_id_Diff INT
DECLARE @backup_set_id_Tlog INT
DECLARE @backup_set_id_end INT
DECLARE @Last_Backup_Set_Date DATETIME
DECLARE @databaseName SYSNAME
DECLARE @LiteSpeed BIT

SET @databasename = 'dba'	-- database to restore
SET @LiteSpeed = 1			-- 0 - use native SQL Restore, 1 - use Quest LiteSpeed restore

-- Get the ID of the most recent full backup for the database
SELECT @backup_set_id_Full = Max(backup_set_id)
FROM   msdb.dbo.backupset
WHERE  database_name = @databaseName
   AND type = 'D'

-- Get the ID for the most recent DIFF backup is it exists
SELECT @backup_set_id_Diff = Max(backup_set_id)
FROM   msdb.dbo.backupset
WHERE  database_name = @databaseName
   AND type = 'I'
   AND backup_set_id > (@backup_set_id_Full)

-- If no DIFF backup exists, then set the DIFF ID to the full backup ID
IF @backup_set_id_Diff IS NULL
	BEGIN
		SET @backup_set_id_Diff = @backup_set_id_Full
	END
ELSE
	BEGIN
		-- Set the Last Backup Date to the most recent Differential
		SET @Last_Backup_Set_Date = @Full_Backup_Set_Date
	END

-- Set a maximum backup set ID to make sure this is at the bottom of the list
IF @backup_set_id_end IS NULL
	SET @backup_set_id_end = 999999999

IF @LiteSpeed = 0
	BEGIN
		-- UNION the Full backup with the Differential, with the trailing TLOG backups
		SELECT backup_set_id
			   ,'RESTORE DATABASE ' + @databaseName + ' FROM DISK = ''' + mf.physical_device_name + ''' WITH ' + 'FILE = ' + CONVERT(VARCHAR(10), b.position) + ', NORECOVERY;' AS CommandSet
		FROM   msdb.dbo.backupset b,
			   msdb.dbo.backupmediafamily mf
		WHERE  b.media_set_id = mf.media_set_id
		   AND b.database_name = @databaseName
		   AND b.backup_set_id = @backup_set_id_Full
		UNION
		SELECT backup_set_id
			   ,'RESTORE DATABASE ' + @databaseName + ' FROM DISK = ''' + mf.physical_device_name + ''' WITH ' + 'FILE = ' + CONVERT(VARCHAR(10), b.position) + ', NORECOVERY;'
		FROM   msdb.dbo.backupset b,
			   msdb.dbo.backupmediafamily mf
		WHERE  b.media_set_id = mf.media_set_id
		   AND b.database_name = @databaseName
		   AND b.backup_set_id = @backup_set_id_Diff
		UNION
		SELECT backup_set_id
			   ,'RESTORE LOG ' + @databaseName + ' FROM DISK = ''' + mf.physical_device_name + ''' WITH ' + 'FILE = ' + CONVERT(VARCHAR(10), b.position) + ', NORECOVERY;'
		FROM   msdb.dbo.backupset b,
			   msdb.dbo.backupmediafamily mf
		WHERE  b.media_set_id = mf.media_set_id
		   AND b.database_name = @databaseName
		   AND b.backup_set_id >= @backup_set_id_Diff
		   AND b.backup_set_id < @backup_set_id_end
		   AND b.type = 'L'
		UNION
		SELECT 999999999 AS backup_set_id
			   ,'RESTORE DATABASE ' + @databaseName + ' WITH RECOVERY;'
		ORDER  BY backup_set_id 
	END -- IF @LiteSpeed = 0
ELSE
	BEGIN
		-- UNION the Full backup with the Differential, with the trailing TLOG backups
		SELECT backup_set_id
			   ,'exec master.dbo.xp_restore_database @database = N''' + @databaseName + ''''
				+ ', @filename = N''' + mf.physical_device_name + ''''
				+ ', @filenumber = ''' + CONVERT(VARCHAR(10), b.position) + '''' 
				+ ', @with = N''STATS = 10'''
				+ ', @with = N''NORECOVERY'''
				+ ', @affinity = 0'
				+ ', @logging = 0'
		FROM   msdb.dbo.backupset b,
			   msdb.dbo.backupmediafamily mf
		WHERE  b.media_set_id = mf.media_set_id
		   AND b.database_name = @databaseName
		   AND b.backup_set_id = @backup_set_id_Full
		UNION
		SELECT backup_set_id
				,'exec master.dbo.xp_restore_database @database = N''' + @databaseName + ''''
				+ ', @filename = N''' + mf.physical_device_name + ''''
				+ ', @filenumber = ''' + CONVERT(VARCHAR(10), b.position) + '''' 
				+ ', @with = N''STATS = 10'''
				+ ', @with = N''NORECOVERY'''
				+ ', @affinity = 0'
				+ ', @logging = 0'
			  -- ,'RESTORE DATABASE ' + @databaseName + ' FROM DISK = ''' + mf.physical_device_name + ''' WITH ' + 'FILE = ' + CONVERT(VARCHAR(10), b.position) + ', NORECOVERY;'
		FROM   msdb.dbo.backupset b,
			   msdb.dbo.backupmediafamily mf
		WHERE  b.media_set_id = mf.media_set_id
		   AND b.database_name = @databaseName
		   AND b.backup_set_id = @backup_set_id_Diff
		UNION
		SELECT backup_set_id
			   ,'RESTORE LOG ' + @databaseName + ' FROM DISK = ''' + mf.physical_device_name + ''' WITH ' + 'FILE = ' + CONVERT(VARCHAR(10), b.position) + ', NORECOVERY;'
		FROM   msdb.dbo.backupset b,
			   msdb.dbo.backupmediafamily mf
		WHERE  b.media_set_id = mf.media_set_id
		   AND b.database_name = @databaseName
		   AND b.backup_set_id >= @backup_set_id_Diff
		   AND b.backup_set_id < @backup_set_id_end
		   AND b.type = 'L'
		UNION
		SELECT 999999999 AS backup_set_id
			   ,'RESTORE DATABASE ' + @databaseName + ' WITH RECOVERY;'
		ORDER  BY backup_set_id 
	END	-- IF @LiteSpeed = 1

