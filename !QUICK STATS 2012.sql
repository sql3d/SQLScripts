-- QUICK STATS
-- Will give you a listing of the following:
-- current sp_WhoIsActive results
-- current CPU utilization
-- Perfmon Counters for a 1 second interval
-- current Waits over a 1 second interval.
-- File Latency over a 1 second interval.  Only displays file latencies > 20MS for writes or > 100MS for Reads

SET NOCOUNT ON;

-- Server Last Start Date/Time
DECLARE @start DATETIME

SELECT @start = create_date 
FROM sys.databases
WHERE name = 'tempdb';


PRINT @@VERSION;
PRINT 'Server Last Restarted: ' + CAST(@start AS VARCHAR(20)) + CHAR(13);

-- Get processor ID of this particular Instance (if you need to compare multiple instances on a server in Task Manager/Resource Monitor
PRINT 'Process ID: ' + CAST(SERVERPROPERTY('processid') AS VARCHAR(20)) + CHAR(13) + CHAR(13);


-- Current server activity
SELECT 
    requests.DatabaseName
    ,requests.SPID
    ,requests.StartTime
    ,requests.RunningTimeSec
    ,requests.BlockedBySPID
    ,requests.BlockingSessionCount
    ,requests.IsRootBlocker
    ,requests.WaitType
    ,requests.WaitTimeMS
    ,requests.WaitResource + 
        ISNULL(STUFF(
	        (SELECT '; ' + resource_description + '('+ CONVERT(VARCHAR(10), dowt.wait_duration_ms) + 'ms)'
		        FROM sys.dm_os_waiting_tasks dowt WITH (READUNCOMMITTED)
		        WHERE dowt.session_id = requests.SPID
		        ORDER BY resource_description ASC
		        FOR XML PATH('')
	        ),1,1,''),'')
     AS WaitResource
    ,requests.LastWaitType
    ,requests.LoginName
    ,requests.HostName
    ,CASE
        WHEN j.name IS NOT NULL THEN 'SQL Agent Job - "' + j.name + '"'
        ELSE requests.[program_name]       
    END AS ProgramName
    ,requests.[status] AS Status
    ,requests.Command
    ,CONVERT(XML, 
        '<?query --' + CHAR(13) +
            SUBSTRING(dest.[text], requests.statement_start_offset / 2,
                    (CASE WHEN requests.statement_end_offset = -1 THEN LEN(CONVERT(NVARCHAR(MAX), dest.[text])) * 2
                        ELSE requests.statement_end_offset
                    END - requests.statement_start_offset) / 2) 
        + CHAR(13) + '--?>'
     )  AS QueryStatment
    ,requests.PctComplete
    ,requests.EstCompletionTime
    ,requests.TotalElapsedTimeMS
    ,requests.CPUTimeMS
    ,requests.Writes
    ,requests.LogicalReads
    ,requests.[RowCount]
    ,requests.MemoryUsage
    ,requests.GrantedQueryMem
    ,requests.TransactionIsolationLevel
    ,requests.OpenTranCount
    ,requests.IsCLR        
    ,deqp.query_plan AS QueryPlan
    ,CONVERT(XML, 
        '<?query --' + CHAR(13) +
            dest.[text] 
        + CHAR(13) + '--?>'
     )  AS QueryBatch     
    ,requests.LoginTime     
    ,SYSDATETIME() AS CollectionTime     
FROM 
    (
        SELECT DISTINCT
             DB_NAME(dess.database_id) AS DatabaseName
            ,dess.session_id AS SPID
            ,der.start_time AS StartTime
            ,DATEDIFF(SECOND, der.start_time, SYSDATETIME()) AS RunningTimeSec
            ,CASE
                WHEN der.blocking_session_id > 0 THEN der.blocking_session_id
                ELSE NULL
             END AS BlockedBySPID
            ,(
                SELECT COUNT(*) 
                FROM sys.dm_exec_requests bsc WITH (READUNCOMMITTED)
                WHERE bsc.blocking_session_id = dess.session_id
             ) AS BlockingSessionCount
            ,(
                SELECT  CASE  
                            WHEN COUNT(*) > 0 THEN 1
                            ELSE 0
                        END
                FROM sys.dm_exec_requests rbs WITH (READUNCOMMITTED)
                WHERE rbs.blocking_session_id = dess.session_id
                    AND rbs.blocking_session_id NOT IN
                        (
                            SELECT der2.session_id
                            FROM sys.dm_exec_requests der2 WITH (READUNCOMMITTED)
                            WHERE der2.blocking_session_id <> 0
                        )
             ) AS IsRootBlocker
            ,der.wait_type AS WaitType
            ,der.wait_time AS WaitTimeMS
            ,der.last_wait_type AS LastWaitType
            ,der.wait_resource AS WaitResource
            ,dess.login_name AS LoginName
            ,dess.[host_name] AS HostName
            ,dess.[program_name]
            ,dess.[Status]
            ,der.Command  
            ,der.percent_complete AS PctComplete
            ,der.estimated_completion_time AS EstCompletionTime    
            ,dess.total_elapsed_time AS TotalElapsedTimeMS
            ,dess.cpu_time AS CPUTimeMS
            ,dess.Writes
            ,dess.logical_reads AS LogicalReads
            ,dess.row_count AS [RowCount]
            ,dess.memory_usage AS MemoryUsage
            ,der.granted_query_memory AS GrantedQueryMem
            ,CASE der.transaction_isolation_level
                WHEN 2 THEN 'ReadCommitted'
                WHEN 1 THEN 'ReadUncommitted'
                WHEN 0 THEN 'Unspecified'
                WHEN 5 THEN 'Snapshot'
                WHEN 3 THEN 'Repeatable'
                WHEN 4 THEN 'Serializable'
             END AS TransactionIsolationLevel  
            ,dess.open_transaction_count AS OpenTranCount
            ,der.executing_managed_code AS IsCLR    
            ,dess.login_time AS LoginTime
            ,der.[sql_handle]
            ,der.plan_handle
            ,der.statement_start_offset
            ,der.statement_end_offset
        FROM sys.dm_exec_sessions dess WITH (READUNCOMMITTED)
            LEFT JOIN sys.dm_exec_requests der WITH (READUNCOMMITTED)
                ON der.session_id = dess.session_id   
        WHERE  dess.is_user_process = 1
            AND dess.session_id <> @@SPID
            AND (dess.open_transaction_count > 0
                OR der.session_id IS NOT null
                )                 
    ) AS requests
    LEFT JOIN msdb.dbo.sysjobs j 
        ON master.dbo.fn_varbintohexstr(CONVERT(varbinary(16), job_id)) COLLATE Latin1_General_CI_AI = SUBSTRING(REPLACE(requests.[program_name], 'SQLAgent - TSQL JobStep (Job ', ''), 1, 34)
    OUTER APPLY sys.dm_exec_sql_text(requests.sql_handle) dest
    OUTER APPLY sys.dm_exec_query_plan(requests.plan_handle) deqp
ORDER BY IsRootBlocker DESC, BlockingSessionCount DESC, RunningTimeSec DESC;



-- CPU Utilization
DECLARE @TSNow BIGINT;
SELECT @TSNow = cpu_ticks / CONVERT(FLOAT, cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info;

SELECT TOP 1
        DATEADD(ms, -1 * (@TSNow - [TIMESTAMP]), GETDATE()) AS EventTime, 
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
ORDER BY record_id DESC;
GO

-- Get Average Task Counts (run multiple times)  (Query 29) (Avg Task Counts)
SELECT AVG(current_tasks_count) AS [Avg Task Count], 
AVG(runnable_tasks_count) AS [Avg Runnable Task Count],
AVG(pending_disk_io_count) AS [Avg Pending DiskIO Count]
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255 OPTION (RECOMPILE);

--Get Max Memory (used to estimate min PLE)
DECLARE @maxMemory INT;

SELECT @maxMemory =
		CASE
			WHEN CEILING(physical_memory_kb / 1024) > maxmem.value_in_use
				THEN maxmem.value_in_use
			ELSE 	CEILING(physical_memory_kb / 1024)
		END
FROM sys.dm_os_sys_info			
	CROSS APPLY 
		(SELECT CAST(value_in_use AS INT) AS value_in_use
			FROM master.sys.configurations 
			WHERE name = 'max server memory (MB)') maxmem;

-- Temp Tables
-- Perfmon Temps
CREATE TABLE #PerfCountersFirst 
	(
		OBJECT_NAME VARCHAR(200)
		, Counter_Name VARCHAR(200)
		, Instance_Name VARCHAR(200)		
		, CNTR_VALUE BIGINT
		, CNTR_Type INT
		, CurrentTime DATETIME
	);
	
CREATE TABLE #PerfCountersSecond 
	(
		OBJECT_NAME VARCHAR(200)
		, Counter_Name VARCHAR(200)
		, Instance_Name VARCHAR(200)
		, CNTR_VALUE BIGINT
		, CNTR_Type INT		
		, CurrentTime DATETIME
	);
	
-- IO Temps
CREATE TABLE #FileStatsFirst
	(
		database_id INT
		,FILE_ID INT
		,num_of_reads BIGINT
		,num_of_writes BIGINT
		,io_stall_read_ms BIGINT
		,io_stall_write_ms BIGINT
	);
	
CREATE TABLE #FileStatsSecond
	(
		database_id INT
		,FILE_ID INT
		,num_of_reads BIGINT
		,num_of_writes BIGINT
		,io_stall_read_ms BIGINT
		,io_stall_write_ms BIGINT
	);
	
-- Wait Types Temps
CREATE TABLE #WaitTypesFirst
	(
		Wait_Type VARCHAR(200)
		,Waiting_Tasks_Count BIGINT
		,Wait_Time_MS BIGINT
		,Max_Wait_Time_MS BIGINT
		,Signal_Wait_Time_MS BIGINT
	);
	

CREATE TABLE #WaitTypesSecond
	(
		Wait_Type VARCHAR(200)
		,Waiting_Tasks_Count BIGINT
		,Wait_Time_MS BIGINT
		,Max_Wait_Time_MS BIGINT
		,Signal_Wait_Time_MS BIGINT
	);

		
DECLARE @ServerName NVARCHAR(100)
		,@SQLFirst NVARCHAR(4000)
		,@SQLSecond NVARCHAR(4000);


IF  CHARINDEX('\', @@SERVERNAME) > 1
	BEGIN 
		SELECT @ServerName = 'MSSQL$' + SUBSTRING(@@SERVERNAME, CHARINDEX('\', @@SERVERNAME) + 1, LEN(@@SERVERNAME) )
	END
ELSE 
	BEGIN
		SELECT @ServerName = 'SQLServer'
	END;
	
SET @SQLFirst = 'SELECT  
				OBJECT_NAME ,
				counter_name ,
				instance_name ,
				cntr_value ,
				cntr_type ,
				CURRENT_TIMESTAMP AS collection_time
			FROM    sys.dm_os_performance_counters
			WHERE   ( OBJECT_NAME = '''  + @ServerName + ':Access Methods''
					  AND counter_name = ''Full Scans/sec''
					)
					OR ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
						 AND counter_name = ''Index Searches/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
						 AND counter_name = ''Lazy Writes/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
						 AND counter_name =''Free list stalls/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
						 AND counter_name = ''Page life expectancy''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
						 AND counter_name = ''Processes Blocked''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
						 AND counter_name = ''User Connections''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
						 AND counter_name = ''Lock Waits/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
						 AND counter_name = ''Lock Wait Time (ms)''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
						 AND counter_name = ''SQL Re-Compilations/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Memory Manager''
						 AND counter_name = ''Memory Grants Pending''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
						 AND counter_name = ''Batch Requests/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
						 AND counter_name = ''SQL Compilations/sec''
					   )
				     OR ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
						  AND counter_name = ''Page Splits/sec''
					   );
		';
		
SET @SQLSecond = 'SELECT 
        OBJECT_NAME ,
        counter_name ,
        instance_name ,
        cntr_value ,
        cntr_type ,
        CURRENT_TIMESTAMP AS collection_time
FROM    sys.dm_os_performance_counters
WHERE   ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
          AND counter_name = ''Full Scans/sec''
        )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
             AND counter_name = ''Index Searches/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
             AND counter_name = ''Lazy Writes/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
			 AND counter_name =''Free list stalls/sec''
		   )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
             AND counter_name = ''Page life expectancy''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
             AND counter_name = ''Processes Blocked''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
             AND counter_name = ''User Connections''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
             AND counter_name = ''Lock Waits/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
             AND counter_name = ''Lock Wait Time (ms)''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
             AND counter_name = ''SQL Re-Compilations/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Memory Manager''
             AND counter_name = ''Memory Grants Pending''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
             AND counter_name = ''Batch Requests/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
             AND counter_name = ''SQL Compilations/sec''
           )  
	   OR ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
		   AND counter_name = ''Page Splits/sec''
		 );
	';             
             
       
-- RUN INITIAL DATA COLLECTORS  
-- File Stats
INSERT INTO #FileStatsFirst
SELECT database_id 
		,FILE_ID
		,num_of_reads 
		,num_of_writes 
		,io_stall_read_ms 
		,io_stall_write_ms
FROM sys.dm_io_virtual_file_stats(NULL,NULL);

-- Wait Types
INSERT INTO #WaitTypesFirst
SELECT wait_type
		,waiting_tasks_count
		,wait_time_ms
		,max_wait_time_ms
		,signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
        'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
        'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',
        'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BROKER_TO_FLUSH',
        'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE',
        'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'BROKER_EVENTHANDLER',
        'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
        'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE', 'DBMIRROR_EVENTS_QUEUE',
        'DBMIRRORING_CMD', 'BROKER_TRANSMITTER', 'SQLTRACE_WAIT_ENTRIES',
        'SLEEP_BPOOL_FLUSH', 'SQLTRACE_LOCK','SP_SERVER_DIAGNOSTICS_SLEEP',
	   'HADR_FILESTREAM_IOMGR_IOCOMPLETION','DIRTY_PAGE_POLL');

-- Perfmon Counters
INSERT INTO #PerfCountersFirst
EXEC sp_executesql @SQLFirst;
    

-- Wait on Second between data collection
WAITFOR DELAY '00:00:01'


-- RUN Second Perfmon Counters
INSERT INTO #PerfCountersSecond
EXEC sp_executesql @SQLSecond;

-- IO
INSERT INTO #FileStatsSecond
SELECT database_id 
		,FILE_ID
		,num_of_reads 
		,num_of_writes 
		,io_stall_read_ms 
		,io_stall_write_ms
FROM sys.dm_io_virtual_file_stats(NULL,NULL);

-- Wait Types
INSERT INTO #WaitTypesSecond
SELECT wait_type
		, waiting_tasks_count
		,wait_time_ms
		, max_wait_time_ms
		,signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
        'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
        'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',
        'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BROKER_TO_FLUSH',
        'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE',
        'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'BROKER_EVENTHANDLER',
        'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
        'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE', 'DBMIRROR_EVENTS_QUEUE',
        'DBMIRRORING_CMD', 'BROKER_TRANSMITTER', 'SQLTRACE_WAIT_ENTRIES',
        'SLEEP_BPOOL_FLUSH', 'SQLTRACE_LOCK','SP_SERVER_DIAGNOSTICS_SLEEP',
	   'HADR_FILESTREAM_IOMGR_IOCOMPLETION','DIRTY_PAGE_POLL');


-- Calculate the cumulative counter values
SELECT   ObjectName		= i.object_name 
        ,CounterName	= i.counter_name 
        ,InstanceName = 
			CASE	
				WHEN i.Counter_Name = 'Page life expectancy' THEN 
					CASE 
						WHEN ((@maxMemory /1024 /4 ) * 300) < 300 THEN 'Min = 300'
						ELSE 'Min = ' + CAST((CEILING(@maxMemory /1024) /4 ) * 300 AS VARCHAR(20))
					END									
				ELSE
					i.Instance_Name
			END
        ,CounterValue	= 
			CASE WHEN i.cntr_type = 272696576	THEN (s.cntr_value - i.cntr_value) --/ 5
				 WHEN i.cntr_type = 65792		THEN s.cntr_value
			END		
FROM #PerfCountersFirst AS i
	INNER JOIN #PerfCountersSecond AS s ON i.object_name = s.object_name
		AND i.counter_name = s.counter_name
		AND i.instance_name = s.instance_name
UNION ALL 
-- BUFFER POOL I/O RATE (~20)
SELECT ObjectName = @ServerName + ':Buffer Manager'
		,CounterName = 'Buffer Pool I/O Rate'
		,InstanceName = 'MB/sec'
		,CounterValue = 
			(1.0 * cntr_value / 128) / 
				(SELECT 1.0 * cntr_value
					FROM   sys.dm_os_performance_counters
					WHERE  OBJECT_NAME LIKE '%Buffer Manager%'
						AND counter_name = 'Page life expectancy')
FROM   sys.dm_os_performance_counters
WHERE  OBJECT_NAME LIKE '%Buffer Manager%'
   AND counter_name = 'total pages'
ORDER BY ObjectName;


-- WAIT TYpe	
SELECT	WaitType				= s.wait_type
		,WaitCount				= (s.Waiting_Tasks_Count - i.Waiting_Tasks_Count)
		,WaitTimeMS				= (s.wait_time_ms - i.wait_time_ms)
		,AvgWaitTimeMS			= (s.wait_time_ms - i.wait_time_ms) / ((s.Waiting_Tasks_Count - i.Waiting_Tasks_Count) * 1.0) 
FROM #WaitTypesFirst i
	INNER JOIN #WaitTypesSecond s ON i.wait_type = s.wait_type
WHERE s.wait_time_ms > i.wait_time_ms
ORDER BY WaitTimeMS DESC;


-- IO
SELECT	DatabaseName	= DB_NAME(i.database_id)
		,FilaName		= mf.name
		,FileType		= mf.type_desc
		,ReadLatencyMS	= s.io_stall_read_ms - i.io_stall_read_ms
		,WriteLatencyMS = s.io_stall_write_ms - i.io_stall_write_ms
FROM  #FileStatsFirst AS i
	INNER JOIN #FileStatsSecond AS s ON i.database_id = s.database_id
		AND i.file_id = s.file_id
	INNER JOIN sys.master_files AS mf ON i.database_id = mf.database_id
        AND i.file_id = mf.file_id	
WHERE (s.io_stall_read_ms - i.io_stall_read_ms >= 100)
	OR (s.io_stall_write_ms - i.io_stall_write_ms >= 20);
	

DROP TABLE #WaitTypesFirst;
DROP TABLE #WaitTypesSecond;	        
DROP TABLE #FileStatsFirst;
DROP TABLE #FileStatsSecond;
DROP TABLE #PerfCountersFirst;
DROP TABLE #PerfCountersSecond;
GO

-- TempDB File Allocation
SELECT 'TempDB File Usage'
      ,SUM(ddfsu.total_page_count) * 8 / 1024 AS TotalMB
      ,SUM(ddfsu.allocated_extent_page_count) * 8 / 1024 AS AllocatedMB
      ,((SUM(ddfsu.allocated_extent_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100 AS PCTAllocated
      ,SUM(ddfsu.unallocated_extent_page_count) * 8 / 1024 AS UnAllocatedMB
      ,((SUM(ddfsu.unallocated_extent_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTUnAllocated
      ,SUM(ddfsu.version_store_reserved_page_count) * 8 / 1024 AS VersionStoreMB
      ,((SUM(ddfsu.version_store_reserved_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTVersionStore
      ,SUM(ddfsu.user_object_reserved_page_count) * 8 / 1024 AS UserObjectsMB
      ,((SUM(ddfsu.user_object_reserved_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS  PCTUserObjects
      ,SUM(ddfsu.internal_object_reserved_page_count) * 8 / 1024 AS InternalObjectsMB
      ,((SUM(ddfsu.internal_object_reserved_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTInternalObjects
      ,SUM(ddfsu.mixed_extent_page_count) * 8 / 1024 AS MixedExtentsMB
      ,((SUM(ddfsu.mixed_extent_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTMixedExtents
FROM tempdb.sys.dm_db_file_space_usage ddfsu;


--backup log sizes
DBCC SQLPERF (LOGSPACE)

DECLARE
    @gc VARCHAR(MAX)
   ,@gi VARCHAR(MAX);

WITH    BR_Data
          AS (
              SELECT
                dm_os_ring_buffers.timestamp
               ,CONVERT(XML, dm_os_ring_buffers.record) AS record
              FROM
                sys.dm_os_ring_buffers
              WHERE
                dm_os_ring_buffers.ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
                AND record LIKE '%<SystemHealth>%'
             ),
        Extracted_XML
          AS (
              SELECT
                BR_Data.timestamp
               ,BR_Data.record.value('(./Record/@id)[1]', 'int') AS record_id
               ,BR_Data.record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'bigint') AS SystemIdle
               ,BR_Data.record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'bigint') AS SQLCPU
              FROM
                BR_Data
             ),
        CPU_Data
          AS (
              SELECT
                Extracted_XML.record_id
               ,ROW_NUMBER() OVER (ORDER BY Extracted_XML.record_id) AS rn
               ,DATEADD(ms, -1 * ((
                                   SELECT
                                    dm_os_sys_info.ms_ticks
                                   FROM
                                    sys.dm_os_sys_info
                                  ) - Extracted_XML.timestamp), GETDATE()) AS EventTime
               ,Extracted_XML.SQLCPU
               ,Extracted_XML.SystemIdle
               ,100 - Extracted_XML.SystemIdle - Extracted_XML.SQLCPU AS OtherCPU
              FROM
                Extracted_XML
             )
             --SELECT * FROM CPU_Data
    SELECT
        @gc = CAST((
                    SELECT
                        CAST(d1.rn AS VARCHAR) + ' ' + CAST(d1.SQLCPU AS VARCHAR) + ','
                    FROM
                        CPU_Data AS d1
                    ORDER BY
                        d1.rn
                   FOR
                    XML PATH('')
                   ) AS VARCHAR(MAX))
       ,@gi = CAST((
                    SELECT
                        CAST(d1.rn AS VARCHAR) + ' ' + CAST(d1.OtherCPU AS VARCHAR) + ','
                    FROM
                        CPU_Data AS d1
                    ORDER BY
                        d1.rn
                   FOR
                    XML PATH('')
                   ) AS VARCHAR(MAX))
OPTION
        (RECOMPILE);

SELECT
    CAST('LINESTRING(' + LEFT(@gc, LEN(@gc) - 1) + ')' AS GEOMETRY)
   ,'SQL CPU %' AS Measure
UNION ALL
SELECT
    CAST('LINESTRING(1 100,2 100)' AS GEOMETRY)
   ,''
UNION ALL
SELECT
    CAST('LINESTRING(' + LEFT(@gi, LEN(@gi) - 1) + ')' AS GEOMETRY)
   ,'Other CPU %'; 

GO
