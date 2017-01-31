-- Metrics from Tom LaRock - http://thomaslarock.com/2012/05/are-you-using-the-right-sql-server-performance-metrics/

-- SQL COMPILATIONS PERCENTAGE (~10%)
SELECT (1.0 * cntr_value / (SELECT 1.0 * cntr_value
						   FROM   sys.dm_os_performance_counters
						   WHERE  counter_name = 'Batch Requests/sec')) * 100 AS [SQLCompilationPct]
FROM   sys.dm_os_performance_counters
WHERE  counter_name = 'SQL Compilations/sec';



-- SQL RE-COMPILATIONS PERCENTAGE  (~1%)
SELECT (1.0 * cntr_value / (SELECT 1.0 * cntr_value
						   FROM   sys.dm_os_performance_counters
						   WHERE  counter_name = 'Batch Requests/sec')) * 100 AS [SQLReCompilationPct]
FROM   sys.dm_os_performance_counters
WHERE  counter_name = 'SQL Re-Compilations/sec';



-- PAGE LOOKUPS PERCENTAGE (< 100)
SELECT (1.0 * cntr_value / 
	(SELECT 1.0 * cntr_value
	   FROM   sys.dm_os_performance_counters
	   WHERE  counter_name = 'Batch Requests/sec')) * 100 AS [PageLookupPct]
FROM   sys.dm_os_performance_counters
WHERE  counter_name = 'Page lookups/sec';



-- AVERAGE TASK COUNT (< 10)
-- High AVG TASK COUNT = blocking or resource contention
-- High AVG RUNNABLE TASK COUNT = CPU pressure
-- High AVG PENDING DISKIO COUNT = Disk pressure
SELECT Avg(current_tasks_count)    AS [Avg Task Count]
	   ,Avg(runnable_tasks_count)  AS [Avg Runnable Task Count]
	   ,Avg(pending_disk_io_count) AS [Avg Pending DiskIO Count]
FROM   sys.dm_os_schedulers WITH (NOLOCK)
WHERE  scheduler_id < 255
OPTION (RECOMPILE);



-- BUFFER POOL I/O RATE (~20)
SELECT (1.0 * cntr_value / 128) / 
	(SELECT 1.0 * cntr_value
		FROM   sys.dm_os_performance_counters
		WHERE  object_name LIKE '%Buffer Manager%'
			AND Lower(counter_name) = 'Page life expectancy') AS [BufferPoolRate]
FROM   sys.dm_os_performance_counters
WHERE  object_name LIKE '%Buffer Manager%'
   AND counter_name = 'total pages'; 


