--SELECT          physical_device_name,
--                backup_start_date,
--                backup_finish_date,
--                backup_size/1024.0 AS BackupSizeKB
--FROM msdb.dbo.backupset b
--JOIN msdb.dbo.backupmediafamily m ON b.media_set_id = m.media_set_id
----WHERE database_name = 'YourDB'
--ORDER BY backup_finish_date DESC



SELECT  b.database_name,     
	   m.physical_device_name,
	   b.type,
	   device_type,
	   backup_start_date,
	   backup_finish_date,
	   backup_size/(1024.0*1024.0) AS BackupSizeMB
FROM msdb.dbo.backupset b
    INNER JOIN msdb.dbo.backupmediafamily m ON b.media_set_id = m.media_set_id
    INNER JOIN	 
	    (
		  SELECT  bm.database_name, MAX(bm.backup_finish_date) AS LastBackupDate
		  FROM msdb.dbo.backupset AS bm	
			 INNER JOIN msdb.dbo.backupmediafamily m2 ON bm.media_set_id = m2.media_set_id
		  WHERE backup_finish_date > (GETDATE() - 10)	
			 AND type = 'D'	
			-- AND m2.device_type IN (2,7)
		  GROUP BY bm.database_name
	   ) lb ON b.database_name = lb.database_name
		  AND b.backup_finish_date = lb.LastBackupDate
WHERE b.database_name NOT IN ('Master', 'Model', 'MSDB')   
ORDER BY backup_finish_date DESC

SELECT device_type, type, * 
    FROM msdb.dbo.backupset AS b
	   INNER JOIN msdb.dbo.backupmediafamily AS b2 ON b.media_set_id = b2.media_set_id

WHERE database_name = 'bidsd'
--AND type ='d'


SELECT *
FROM msdb.dbo.backupset
     INNER JOIN msdb.dbo.backupmediafamily AS b2 ON b.media_set_id = b2.media_set_id
