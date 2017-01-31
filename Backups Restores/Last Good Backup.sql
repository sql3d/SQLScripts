SELECT  sd.name,
        bs.TYPE,
        bs.database_name,
        max(bs.backup_start_date) as last_backup
FROM    master..sysdatabases sd
        Left outer join msdb..backupset bs on rtrim(bs.database_name) = rtrim(sd.name)
        left outer JOIN msdb..backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
Group by sd.name,
        bs.TYPE,
        bs.database_name
Order by sd.name,last_backup
