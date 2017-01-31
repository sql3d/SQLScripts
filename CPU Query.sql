
SELECT scheduler_id, current_tasks_count, runnable_tasks_count, work_queue_count, pending_disk_io_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255

DECLARE @ts_now BIGINT
SELECT @ts_now = cpu_ticks / CONVERT(FLOAT, cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info

SELECT --record_id,
        DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS EventTime, 
        SQLProcessUtilization,
        SystemIdle,
        100 - SystemIdle - SQLProcessUtilization AS OtherProcessUtilization
FROM (
        SELECT 
                record.value('(./Record/@id)[1]', 'bigint') AS record_id,
                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'bigint') AS SystemIdle,
                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'bigint') AS SQLProcessUtilization,
                TIMESTAMP
        FROM (
                SELECT TIMESTAMP, CONVERT(XML, record) AS record 
                FROM sys.dm_os_ring_buffers 
                WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
                AND record LIKE '% %') AS x
        ) AS y 
ORDER BY record_id DESC

