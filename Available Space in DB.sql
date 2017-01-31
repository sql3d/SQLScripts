SELECT DB_NAME(database_id) AS DatabaseName, 
	CAST([Name] AS varchar(20)) AS NameofFile,
	CAST(physical_name AS varchar(100)) AS PhysicalFile,
	type_desc AS FileType,
	((size * 8)/1024) AS FileSize,
	MaxFileSize = 
		CASE 
			WHEN max_size = -1 OR max_size = 268435456 THEN 'UNLIMITED'
			WHEN max_size = 0 THEN 'NO_GROWTH' 
			WHEN max_size <> -1 OR max_size <> 0 THEN CAST(((max_size * 8) / 1024) AS varchar(15))
			ELSE 'Unknown'
		END,
	SpaceRemainingMB = 
		CASE 
			WHEN max_size = -1 OR max_size = 268435456 THEN 'UNLIMITED'
			WHEN max_size <> -1 OR max_size = 268435456 THEN CAST((((max_size - size) * 8) / 1024) AS varchar(10))
			ELSE 'Unknown'
		END,
	Growth = 
		CASE 
			WHEN growth = 0 THEN 'FIXED_SIZE'
			WHEN growth > 0 THEN ((growth * 8)/1024)
			ELSE 'Unknown'
		END,
	GrowthType = 
		CASE 
			WHEN is_percent_growth = 1 THEN 'PERCENTAGE'
			WHEN is_percent_growth = 0 THEN 'MBs'
			ELSE 'Unknown'
		END,
	size
FROM master.sys.master_files
WHERE state = 0
AND type_desc IN ('LOG', 'ROWS')
ORDER BY database_id, file_id



select *
FROM master.sys.master_files


SELECT name AS 'File Name' , physical_name AS 'Physical Name', size/128 AS 'Total Size in MB',
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS 'Available Space In MB', *
FROM sys.database_files;


select SIZE, CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)
FROM sys.database_files;

declare @pct_avail dec(12,4)

select @pct_avail = CAST(FILEPROPERTY(name, 'SpaceUsed') AS int) / (size * 1.0)
from sys.database_files;

print @pct_avail



declare @pct_avail dec(12,4)

select CAST(FILEPROPERTY(name, 'SpaceUsed') AS int) / (size * 1.0)
from sys.database_files;

DBCC SQLPERF(logspace)
                
	                                                 
SELECT TOP 0 * INTO #DatabaseFiles
     FROM sys.database_files   

alter table #DatabaseFiles
	ADD SpaceUsed INT
	
EXECUTE sp_msforeachdb 'INSERT INTO #DatabaseFiles SELECT *, size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS int)/128.0 AS SpaceUsed FROM [?].sys.database_files'	       

select *
	from #DatabaseFiles
	
drop table #DatabaseFiles                                    
                    