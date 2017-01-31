
-- SERVER PROPERTIES
SELECT 
          SERVERPROPERTY('MachineName') as Host,
          SERVERPROPERTY('InstanceName') as Instance,
          SERVERPROPERTY('Edition') as Edition, /*shows 32 bit or 64 bit*/
          SERVERPROPERTY('ProductLevel') as ProductLevel, /* RTM or SP1 etc*/
          Case SERVERPROPERTY('IsClustered') when 1 then 'CLUSTERED' else
      'STANDALONE' end as ServerType,
          @@VERSION as VersionNumber

-- SERVER CONFIGURATION          
SELECT * from sys.configurations order by NAME


-- LOGINS WITH SA PERMISSIONS          
SELECT l.name, l.denylogin, l.isntname, l.isntgroup, l.isntuser
  FROM master.dbo.syslogins l
WHERE l.sysadmin = 1 OR l.securityadmin = 1          


--TRACE FLAGS ON 
DBCC TRACESTATUS(-1);


-- DATABASE LIST
SELECT name,compatibility_level,recovery_model_desc,state_desc  FROM sys.databases


-- DATABASE FILE LOCATIONS
SELECT db_name(database_id) as DatabaseName,name,type_desc,physical_name FROM sys.master_files


-- SHOW MULTIPLE FILE GROUPS
EXEC master.dbo.sp_MSforeachdb @command1 = 'USE [?] SELECT * FROM sys.filegroups'


-- LAST GOOD BACKUP
SELECT db.name, 
case when MAX(b.backup_finish_date) is NULL then 'No Backup' else convert(varchar(100), 
	MAX(b.backup_finish_date)) end AS last_backup_finish_date
FROM sys.databases db
LEFT OUTER JOIN msdb.dbo.backupset b ON db.name = b.database_name AND b.type = 'D'
	WHERE db.database_id NOT IN (2) 
GROUP BY db.name
ORDER BY 2 DESC


-- BACKUP LOCATIONS
SELECT Distinct physical_device_name FROM msdb.dbo.backupmediafamily