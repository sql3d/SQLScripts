SELECT scheduler_id, current_tasks_count, runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255




SELECT Round(((CONVERT(FLOAT, ws.wait_time_ms) / ws.waiting_tasks_count) / (CONVERT(FLOAT, si.os_quantum) / si.cpu_ticks_in_ms) * cpu_count), 2)                        AS Additional_CPUs_Necessary
	   ,Round((((CONVERT(FLOAT, ws.wait_time_ms) / ws.waiting_tasks_count) / (CONVERT(FLOAT, si.os_quantum) / si.cpu_ticks_in_ms) * cpu_count) / hyperthread_ratio), 2) AS Additional_Sockets_Necessary
FROM   sys.dm_os_wait_stats ws
	   CROSS apply sys.dm_os_sys_info si
WHERE  ws.wait_type = 'SOS_SCHEDULER_YIELD' --example provided by
