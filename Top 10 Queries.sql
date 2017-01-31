
-- Most Frequently Used proc/function
SELECT TOP 20 
    DB_NAME(b.dbid) AS DatabaseName,
    b.text AS 'SP Name',         
	a.execution_count AS 'Execution Count',        
	a.execution_count/DATEDIFF(SECOND, a.creation_time, GETDATE()) AS 'Calls/Second',      
	a.total_worker_time/a.execution_count AS 'AvgCPUTime',      
	a.total_worker_time AS 'TotalCPUTime',      
	a.total_elapsed_time/a.execution_count AS 'AvgElapsedTime',      
	a.max_logical_reads,         
	a.max_logical_writes,         
	a.total_physical_reads,       
	DATEDIFF(MINUTE, a.creation_time, GETDATE()) AS 'Age in Cache'  ,
	c.query_plan
FROM sys.dm_exec_query_stats a        
	CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) b  
	CROSS APPLY sys.dm_exec_query_plan (a.plan_handle) AS c  
WHERE b.dbid IS NOT null	
ORDER BY a.execution_count DESC;


-- Logest running queries
SELECT TOP 10 
    DB_NAME(b.dbid) AS DatabaseName,
    b.text AS 'SP Name',         
	a.execution_count AS 'Execution Count',        
	a.execution_count/DATEDIFF(SECOND, a.creation_time, GETDATE()) AS 'Calls/Second',      
	a.total_worker_time/a.execution_count AS 'AvgCPUTime',      
	a.total_worker_time AS 'TotalCPUTime',      
	a.total_elapsed_time/a.execution_count AS 'AvgElapsedTime',      
	a.max_logical_reads,         
	a.max_logical_writes,         
	a.total_physical_reads,    
	DATEDIFF(MINUTE, a.creation_time, GETDATE()) AS 'Age in Cache'  ,
	c.query_plan
FROM sys.dm_exec_query_stats a        
	CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) b  
	CROSS APPLY sys.dm_exec_query_plan (a.plan_handle) AS c  
--WHERE b.dbid = 
--	(SELECT dbid
--		FROM sys.sysdatabases
--		WHERE name = 'BIDOC')
ORDER BY 'AvgElapsedTime' DESC;


-- Most IO intensive queries
SELECT TOP 10  
    DB_NAME(b.dbid) AS DatabaseName,
    total_logical_reads,         
	total_logical_writes,          
	execution_count,         
	total_logical_reads + total_logical_writes AS [IO_total],    
	(total_logical_reads + total_logical_writes) / execution_count as [avg_io],     
	b.text AS query_text,         
	db_name(b.dbid) AS database_name,         
	b.objectid AS object_id,
	c.query_plan
FROM sys.dm_exec_query_stats  a  
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) b  
	CROSS APPLY sys.dm_exec_query_plan (a.plan_handle) AS c  
WHERE total_logical_reads + total_logical_writes > 0   
--	and b.dbid = 
--		(SELECT dbid
--		FROM sys.sysdatabases
--		WHERE name = 'bidoc')
ORDER BY [IO_total] DESC;


-- Most frequently recompiled
SELECT TOP 10 
    DB_NAME(b.dbid) AS DatabaseName,
    b.text AS query_text,        
	plan_generation_num,        
	execution_count,        
	DB_NAME(b.dbid) AS database_name,        
	OBJECT_NAME(b.objectid) AS [object name] ,
	c.query_plan
FROM sys.dm_exec_query_stats a   
	CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS b  
	CROSS APPLY sys.dm_exec_query_plan (a.plan_handle) AS c  
WHERE plan_generation_num > 1  
	--and b.dbid = 
	--	(SELECT dbid
	--	FROM sys.sysdatabases
	--	WHERE name = 'emt')
ORDER BY plan_generation_num DESC;


-- Most CPU intensive
SELECT TOP 10 
    DB_NAME(b.dbid) AS DatabaseName,
    SUBSTRING(b.text, (a.statement_start_offset/2) + 1, 
		((	CASE statement_end_offset           
				WHEN -1 THEN DATALENGTH(b.text)          
				ELSE a.statement_end_offset 
			END               - a.statement_start_offset)/2) + 1) AS statement_text,   
	b.text,      
	c.query_plan,         
	total_worker_time as CPU_time,
	execution_count,
	total_worker_time / execution_count as avg_cpu_time
FROM sys.dm_exec_query_stats a  
	CROSS APPLY sys.dm_exec_sql_text (a.sql_handle) AS b  
	CROSS APPLY sys.dm_exec_query_plan (a.plan_handle) AS c  
--where b.dbid = 
--		(SELECT dbid
--		FROM sys.sysdatabases
--		WHERE name = 'emt')
ORDER BY total_worker_time DESC

/*  Column Explaination

Column Name					Explanation
Sql_handle					Binary pointer to the batch or stored procedure that contains the current SQL statement. To obtain the actual statement, you can pass the value in this column to sys.dm_exec_sql_text and retrieve the string between statement_start_offset and statement_end_offset.
Statement_start_offset		Starting position of the current SQL statement within the batch or stored procedure it is part of. If the batch consists of a single statement, the value will be 0.
Statement_end_offset		Ending position of the current SQL statement within the batch or stored procedure it is part of. If the batch consists of a single statement the value will be -1.
Plan_generation_num			Sequence number for generation of the execution plan. You can examine this column to determine whether current plan is a result of an initial compilation or a recompile.
Plan_handle					Binary pointer to the execution plan for the current query. To obtain the query plan, you can pass this value to sys.dm_exec_query_plan DMF.
Creation_time				Date and time when the current plan was created.
Last_execution_time			Last time when the current plan was executed.
Execution_count	Total		number of times the plan was executed since it was compiled.
Total_worker_time			Total CPU time in microseconds used for all executions of the plan.
Last_worker_time			CPU time in microseconds used for last execution of the plan.
Min_worker_time				Minimum CPU time in microseconds used for any execution of the plan.
Max_worker_time	Maximum		CPU time in microseconds used for any execution of the plan.
Total_physical_reads		Total physical reads for all executions of the current plan.
Last_physical_reads			Number of physical reads during last execution of the plan.
Min_physical_reads			Minimum number of physical reads for any execution of the plan.
Max_physical_reads			Maximum number of physical reads for any execution of the plan.
Total_logical_writes		Total logical writes for all executions of the current plan.
Last_logical_writes			Number of logical writes during last execution of the current plan.
Min_logical_writes			Minimum number of logical writes for any execution of the plan.
Max_logical_writes			Maximum number of logical writes for any execution of the plan.
Total_logical_reads			Total logical reads for all executions of the current plan.
Last_logical_reads			Number of logical reads during last execution of the plan.
Min_logical_reads			Minimum number of logical reads for any execution of the plan.
Max_logical_reads			Maximum number of logical reads for any execution of the plan.
Total_clr_time				Total number of microseconds spent executing common language runtime (CLR) objects by all executions of the plan.
Last_clr_time				Number of microseconds spent executing common language runtime (CLR) objects by last execution of the plan.
Min_clr_time				Minimum number of microseconds spent executing common language runtime (CLR) objects by any execution of the plan.
Max_clr_time				Maximum number of microseconds spent executing common language runtime (CLR) objects by any execution of the plan.
Total_elapsed_time			Total number of microseconds used for all executions of the plan.
Last_elapsed_time			Number of microseconds used for the last execution of the plan.
Min_elapsed_time			Minimum number of microseconds used for any execution of the plan.
Max_elapsed_time			Maximum number of microseconds used for any execution of the plan.
*/
