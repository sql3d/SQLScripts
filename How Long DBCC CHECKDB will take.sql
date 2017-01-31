SELECT start_time, [status], command, DB_NAME(database_id) AS DBName,
	percent_complete, (estimated_completion_time / 1000) / 60 AS min_to_complete,
	DATEADD(ms, estimated_completion_time, GETDATE()) AS est_complete_time
FROM sys.dm_exec_requests
WHERE session_id = 52