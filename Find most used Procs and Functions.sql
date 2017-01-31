-- Most frequently executed queries
SELECT TOP 10 
	db_name(qt.dbid) as DB,
	qt.TEXT AS 'SP Name',
	qs.execution_count AS 'Execution Count',
	qs.total_worker_time/qs.execution_count AS 'AvgWorkerTime',
	qs.total_worker_time AS 'TotalWorkerTime',
	qs.total_physical_reads AS 'PhysicalReads',
	qs.creation_time 'CreationTime',
	qs.execution_count/DATEDIFF(Second, qs.creation_time, GETDATE()) AS 'Calls/Second'
FROM sys.dm_exec_query_stats AS qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
--WHERE qt.dbid = 
--	(SELECT dbid
--		FROM sys.sysdatabases
--		WHERE name = 'BID2007')
ORDER BY qs.execution_count DESC

-- Most Frequently Used procs
SELECT TOP 10 
	db_name(b.dbid) as DB,
	b.text AS 'SP Name',         
	a.execution_count AS 'Execution Count',        
	a.execution_count/DATEDIFF(SECOND, a.creation_time, GETDATE()) AS 'Calls/Second',      
	a.total_worker_time/a.execution_count AS 'AvgCPUTime',      
	a.total_worker_time AS 'TotalCPUTime',      
	a.total_elapsed_time/a.execution_count AS 'AvgElapsedTime',      
	a.max_logical_reads,         
	a.max_logical_writes,         
	a.total_physical_reads,       
	DATEDIFF(MINUTE, a.creation_time, GETDATE()) AS 'Age in Cache'  
FROM sys.dm_exec_query_stats a        
	CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) b  
--WHERE b.dbid = 
	--(SELECT dbid
	--	FROM sys.sysdatabases
	--	WHERE name = 'BID2007')
ORDER BY a.execution_count DESC


-- Most IO intensive queries
SELECT TOP 10  
	db_name(b.dbid) as DB,
	total_logical_reads,         
	total_logical_writes,          
	execution_count,         
	total_logical_reads+total_logical_writes AS [IO_total],         
	b.text AS query_text,         
	db_name(b.dbid) AS database_name,         
	b.objectid AS object_id  
FROM sys.dm_exec_query_stats  a  
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) b  
WHERE total_logical_reads+total_logical_writes > 0   
ORDER BY [IO_total] DESC