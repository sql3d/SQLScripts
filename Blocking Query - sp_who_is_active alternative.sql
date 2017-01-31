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
    LEFT JOIN msdb.dbo.sysjobs j WITH (READUNCOMMITTED)
        ON master.dbo.fn_varbintohexstr(CONVERT(varbinary(16), job_id)) COLLATE Latin1_General_CI_AI = SUBSTRING(REPLACE(requests.[program_name], 'SQLAgent - TSQL JobStep (Job ', ''), 1, 34)
    OUTER APPLY sys.dm_exec_sql_text(requests.[sql_handle]) dest
    OUTER APPLY sys.dm_exec_query_plan(requests.plan_handle) deqp
ORDER BY IsRootBlocker DESC, BlockingSessionCount DESC, RunningTimeSec DESC;
