SELECT 
	owt.session_id
	,owt.exec_context_id
	,owt.wait_duration_ms
	,owt.wait_type
	,owt.blocking_session_id
	,owt.resource_description
	,es.[program_name]
	,est.[text]
	,est.[dbid]
	,eqp.query_plan
	,es.cpu_time
	,es.memory_usage
FROM sys.dm_os_waiting_tasks owt
	INNER JOIN sys.dm_exec_sessions es ON owt.session_id = es.session_id
	INNER JOIN sys.dm_exec_requests er ON es.session_id = er.session_id
	OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) est
	OUTER APPLY sys.dm_exec_query_plan (er.plan_handle) eqp
WHERE es.is_user_process = 1
ORDER BY owt.session_id, owt.exec_context_id

--wait_type NOT IN (
--        'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
--        'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',
--        'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BROKER_TO_FLUSH',
--        'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE',
--        'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'BROKER_EVENTHANDLER',
--        'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
--        'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE', 'DBMIRROR_EVENTS_QUEUE',
--        'DBMIRRORING_CMD', 'BROKER_TRANSMITTER', 'SQLTRACE_WAIT_ENTRIES',
--        'SLEEP_BPOOL_FLUSH', 'SQLTRACE_LOCK')