
-- PREEMPTIVE WAITS from OS (only for 2008)

SELECT wait_type, waiting_tasks_count
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'PREEMPTIVE%'
ORDER BY waiting_tasks_count DESC