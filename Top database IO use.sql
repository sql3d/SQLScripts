SELECT TOP 5 DB_NAME(database_id) AS [Database Name]
	,SUM(num_of_reads + num_of_writes) AS [Total I/Os]
FROM sys.dm_io_virtual_file_stats (NULL,NULL)
GROUP BY database_id
ORDER BY SUM(num_of_reads + num_of_writes) DESC