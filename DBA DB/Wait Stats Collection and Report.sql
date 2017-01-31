

use dba
go


CREATE TABLE dbo.[WaitStatSnapshot](
    [CreateDate] [datetime] NOT NULL,
    [WaitType] [nvarchar](60) NOT NULL,
    [WaitingTasksCount] [bigint] NOT NULL,
    [WaitTimeMs] [bigint] NOT NULL,
    [MaxWaitTimeMs] [bigint] NOT NULL,
    [SignalWaitTimeMs] [bigint] NOT NULL,
    CONSTRAINT [PK_Monitor_WaitStatSnapshot_CreateDateWaitType]
        PRIMARY KEY CLUSTERED ([CreateDate] ASC, [WaitType] ASC)
) ON [primary]
GO


CREATE TABLE dbo.[WaitStatHistory](
    [CreateDate] [datetime] NOT NULL,
    [WaitType] [nvarchar](60) NOT NULL,
    [WaitingTasksCount] [bigint] NOT NULL,
    [WaitTimeMs] [bigint] NOT NULL,
    [MaxWaitTimeMs] [bigint] NOT NULL,
    [SignalWaitTimeMs] [bigint] NOT NULL,
    CONSTRAINT [PK_Monitor_WaitStatHistory_CreateDateWaitType]
        PRIMARY KEY CLUSTERED ([CreateDate] ASC, [WaitType] ASC)
) ON [primary]
go

USE dba
GO

/*============================================================
	Procedure: dbo.upLoad_TrackWaitStats
	Author: Jason Strate
	Date: October 26, 2009

	Synopsis:
	This procedure takes snapshots of wait stats and compares them with previous
	snapshots to determine a delta of changes over time. Raw snapshot information
	is deleted on a short time span, while the delta information in the history
	table is deleted over a longer time span.

	============================================================
	Revision History:
	Date: By Description
	------------------------------------------------------------

============================================================*/
CREATE PROCEDURE dbo.upLoad_TrackWaitStats
(
	@SnapshotDays tinyint = 1,
	@HistoryDays smallint = 90
)
AS
	set nocount on
		
	INSERT INTO dbo.WaitStatSnapshot
	SELECT GETDATE()
		, CASE wait_type 
				WHEN 'MISCELLANEOUS' THEN 'MISCELLANEOUS' 
				ELSE wait_type 
		  END
		, SUM(waiting_tasks_count)
		, SUM(wait_time_ms)
		, SUM(max_wait_time_ms)
		, SUM(signal_wait_time_ms)
	FROM sys.dm_os_wait_stats
	GROUP BY CASE wait_type WHEN 'MISCELLANEOUS' THEN 'MISCELLANEOUS' ELSE wait_type END

	;WITH WaitStatCTE
	AS (
	SELECT CreateDate
		, DENSE_RANK() OVER (ORDER BY CreateDate DESC) AS HistoryID
		, WaitType
		, WaitingTasksCount
		, WaitTimeMs
		, MaxWaitTimeMs
		, SignalWaitTimeMs
	FROM dbo.WaitStatSnapshot
	)
	INSERT INTO dbo.WaitStatHistory
	SELECT w1.CreateDate
		, w1.WaitType
		, w1.WaitingTasksCount - COALESCE(w2.WaitingTasksCount,0)
		, w1.WaitTimeMs - COALESCE(w2.WaitTimeMs,0)
		, w1.MaxWaitTimeMs - COALESCE(w2.MaxWaitTimeMs,0)
		, w1.SignalWaitTimeMs - COALESCE(w2.SignalWaitTimeMs,0)
	FROM WaitStatCTE w1
		LEFT OUTER JOIN WaitStatCTE w2 ON w1.WaitType = w2.WaitType
			AND w1.WaitingTasksCount >= COALESCE(w2.WaitingTasksCount,0)
			AND w2.HistoryID = 2
	WHERE w1.HistoryID = 1

	DELETE FROM dbo.WaitStatSnapshot
	WHERE CreateDate < DATEADD(d, -@SnapshotDays, GETDATE())

	DELETE FROM dbo.WaitStatHistory
	WHERE CreateDate < DATEADD(d, -@HistoryDays, GETDATE())
GO

USE dba
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitTypeCategory]') AND type in (N'U'))
    DROP TABLE dbo.[WaitTypeCategory]
GO

--IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Resources')
--    DROP SCHEMA [Resources]
--GO

--IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Resources')
--    EXEC sys.sp_executesql N'CREATE SCHEMA [Resources] AUTHORIZATION [dbo]'
--GO

CREATE TABLE dbo.[WaitTypeCategory](
	[WaitType] [nvarchar](60) NOT NULL,
	[Category] [varchar](50) NULL,
	[Resource] [varchar](50) NULL,
	[Version] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[Action] [varchar](max) NULL,
 CONSTRAINT [PK_WaitTypeCategory] PRIMARY KEY CLUSTERED 
    (
	[WaitType] ASC
    )
) 
GO

INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ABR', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ASSEMBLY_LOAD', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ASYNC_DISKPOOL_LOCK', N'I/O', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ASYNC_IO_COMPLETION', N'I/O', N'Resource', N'SQL 2005;SQL 2008', N'Used to indicate a worker is waiting on a asynchronous I/O operation to complete not associated with database pages', N'Since this is used for various reason you need to find out what query or task is associated with the wait. Two examples of where this wait type is used is to create files associated with a CREATE DATABASE and for "zeroing" out a transaction log file during log creation or growth.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ASYNC_NETWORK_IO', N'Network ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'AUDIT_GROUPCACHE_LOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'AUDIT_LOGINCACHE_LOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'AUDIT_ON_DEMAND_TARGET_LOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'AUDIT_XE_SESSION_MGR', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BACKUP', N'Backup ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BACKUP_CLIENTLOCK ', N'Backup ', N'Resource', N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BACKUP_OPERATOR', N'Backup ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BACKUPBUFFER', N'Backup ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BACKUPIO', N'Backup ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BACKUPTHREAD', N'Backup ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BAD_PAGE_PROCESS', N'Memory ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_CONNECTION_RECEIVE_TASK', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_ENDPOINT_STATE_MUTEX', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_EVENTHANDLER', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_INIT', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_MASTERSTART', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_RECEIVE_WAITFOR', N'Service Broker ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_REGISTERALLENDPOINTS', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_SERVICE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_SHUTDOWN', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_TASK_STOP', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_TO_FLUSH', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BROKER_TRANSMITTER', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'BUILTIN_HASHKEY_MUTEX', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CHECK_PRINT_RECORD', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CHECKPOINT_QUEUE', N'Buffer', N'Background', N'SQL 2005;SQL 2008', N'Used by background worker that waits on events on queue to process checkpoint requests. This is an "optional" wait type see Important Notes section in blog', N'You should be able to safely ignore this one as it is just indicates the checkpoint background worker is waiting for work to do. I suppose if you thought you had issues with checkpoints not working or log truncation you might see if this worker ever "wakes up". Expect higher wait times as this will only wake up when work to do')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CHKPT', N'Buffer', N'Background', N'SQL 2005;SQL 2008', N'Used to coordinate the checkpoint background worker thread with recovery of master so checkpoint won''t start accepting queue requests until master online', N'You should be able to safely ignore. You should see 1 wait of this type for the server unless the checkpoint worker crashed and had to be restarted.. If though this is technically a "sync" type of event I left its usage as Background')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLEAR_DB', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_AUTO_EVENT', N'Common Language Runtime (CLR) ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_CRST', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_JOIN', N'CLR', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_MANUAL_EVENT', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_MEMORY_SPY', N'CLR', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_MONITOR', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_RWLOCK_READER', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_RWLOCK_WRITER', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_SEMAPHORE', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLR_TASK_START', N'CLR ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CLRHOST_STATE_ACCESS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CMEMTHREAD', N'Memory ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'COMMIT_TABLE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CURSOR', N'Internal ', N'Background', N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CURSOR_ASYNC', N'Internal ', N'Background', N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CXPACKET', N'Query', N'Sync', N'SQL 2005;SQL 2008', N'Used to synchronize threads involved in a parallel query. This wait type only means a  parallel query is executing.', N'You may not need to take any action. If you see high wait times then it means you have a long running parallel query. I would first identify the query and determine if you need to tune it. Note sys.dm_exec_requests only shows the wait type of the request even if multiple tasks have different wait types. When you see CXPACKET here look at all tasks associated with the request. Find the task that doesn''t have this wait_type and see its status. It may be waiting on something else slowing down the query. wait_resource also has interesting details about the tasks and its parallel query operator')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'CXROWSET_SYNC', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DAC_INIT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DBMIRROR_DBM_EVENT ', N'Database Mirroring ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DBMIRROR_DBM_MUTEX ', N'Database Mirroring ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DBMIRROR_EVENTS_QUEUE', N'Database Mirroring ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DBMIRROR_SEND', N'Database Mirroring ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DBMIRROR_WORKER_QUEUE', N'Database Mirroring ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DBMIRRORING_CMD', N'Database Mirroring ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DBTABLE', N'Internal ', N'Background', N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DEADLOCK_ENUM_MUTEX', N'Lock ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DEADLOCK_TASK_SEARCH', N'Lock ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DEBUG', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DISABLE_VERSIONING', N'Row versioning ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DISKIO_SUSPEND', N'BACKUP', N'Sync', N'SQL 2005;SQL 2008', N'Used to indicate a worker is waiting to process I/O for a database or log file associated with a SNAPSHOT BACKUP', N'High wait times here indicate the SNAPSHOT BACKUP may be taking longer than expected. Typically the delay is within the VDI application perform the snapshot backup.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DISPATCHER_QUEUE_SEMAPHORE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DLL_LOADING_MUTEX', N'XML ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DROPTEMP', N'Temporary Objects ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DTC', N'Distributed Transaction Coordinator (DTC) ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DTC_ABORT_REQUEST', N'DTC ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DTC_RESOLVE', N'DTC ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DTC_STATE', N'DTC ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DTC_TMDOWN_REQUEST', N'DTC ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DTC_WAITFOR_OUTCOME', N'DTC ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DUMP_LOG_COORDINATOR', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DUMP_LOG_COORDINATOR_QUEUE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'DUMPTRIGGER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'EC', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'EE_PMOLOCK', N'Memory ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'EE_SPECPROC_MAP_INIT', N'Internal ', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ENABLE_VERSIONING', N'Row versioning ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ERROR_REPORTING_MANAGER', N'Internal ', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'EXCHANGE', N'Parallelism (processor) ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'EXECSYNC', N'Parallelism (processor) ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'EXECUTION_PIPE_EVENT_INTERNAL', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'Failpoint', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FCB_REPLICA_READ', N'Database snapshot ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FCB_REPLICA_WRITE', N'Database snapshot ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FS_FC_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FS_GARBAGE_COLLECTOR_SHUTDOWN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FS_HEADER_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FS_LOGTRUNC_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FSA_FORCE_OWN_XACT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FSAGENT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FSTR_CONFIG_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FSTR_CONFIG_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_COMPROWSET_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_IFTS_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'Full-Text', N'Background', N'SQL 2008', N'Used by a background task processing full-text search requests indicating it is “waiting for work to do:”', N'You should be able to safely ignore unless some unexplained FTS issue. High wait times are normal')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_IFTSHC_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_IFTSISM_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_MASTER_MERGE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_METADATA_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_RESTART_CRAWL', N'Full Text Search ', N'External', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FT_RESUME_CRAWL', N'Full Text Search ', N'External', N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'FULLTEXT GATHERER', N'Full Text Search ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'GUARDIAN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'HTTP_ENDPOINT_COLLCREATE', NULL, NULL, N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'HTTP_ENUMERATION', N'Service Broker ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'HTTP_START', N'Service Broker ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'IMP_IMPORT_MUTEX', NULL, NULL, N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'IMPPROV_IOWAIT', N'I/O', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'INDEX_USAGE_STATS_MUTEX', NULL, NULL, N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'INTERNAL_TESTING', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'IO_AUDIT_MUTEX', N'Profiler Trace ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'IO_COMPLETION', N'I/O', N'Resource', N'SQL 2005;SQL 2008', N'Used to indicate a wait for I/O for operation (typically synchronous)  like sorts and various situations where the engine needs to do a synchronous I/O', N'If wait times are high then you have a disk I/O bottleneck. The problem will be determining what type of operation and where the bottleneck exists. For sorts, it is on the storage system associated with tempdb. Note that database page I/O does not use this wait type. Instead look at PAGEIOLATCH waits.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'IO_RETRY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'IOAFF_RANGE_QUEUE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'KSOURCE_WAKEUP', N'Shutdown', N'Background', N'SQL 2005;SQL 2008', N'Used by the background worker "signal handler" which waits for a signal to shutdown SQL Server', N'You should able to safely ignore this wait. You should only see one instance of this wait but in SQL Server 2008 what will be unusual is the wait time will show up as 0 in sys.dm_os_wait_stats. Other DMVs like sys.dm_exec_requests will show the SIGNAL_HANDLER with a high wait time of this type.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'KTM_ENLISTMENT', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'KTM_RECOVERY_MANAGER', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'KTM_RECOVERY_RESOLUTION', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LATCH_DT', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LATCH_EX', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LATCH_KP', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LATCH_NL', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LATCH_SH', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LATCH_UP', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LAZYWRITER_SLEEP', N'Buffer', N'Background', N'SQL 2005;SQL 2008', N'Used by the Lazywriter background worker to indicate it is sleeping waiting to wake up and check for work to do', N'You should be able to safely ignore this one. The wait times will appear to "cycle" as LazyWriter is designed to sleep and wake-up every 1 second. Appears as LZW_SLEEP in Xevent')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_BU', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_IS', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_IU', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_IX', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RIn_NL', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RIn_S', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RIn_U', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RIn_X', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RS_S', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RS_U', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RX_S', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RX_U', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_RX_X', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_S', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_SCH_M', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_SCH_S', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_SIU', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_SIX', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_U', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_UIX', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LCK_M_X', N'Lock ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LOGBUFFER', N'Transaction Log', N'Resource', N'SQL 2005;SQL 2008', N'Used to indicate a worker thread is waiting for a log buffer to write log blocks for a transaction', N'This is typically a symptom of I/O bottlenecks because other workers waiting on WRITELOG will hold on to log blocks. Look for WRITERLOG waiters and if found the overall problem is I/O bottleneck on the storage system associated with the transaction log')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LOGGENERATION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LOGMGR', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LOGMGR_FLUSH', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LOGMGR_QUEUE', N'Transaction Log', N'Background', N'SQL 2005;SQL 2008', N'Used by the background worker "Log Writer" to wait on a queue for requests to flush log blocks to the transaction log. This is an "optional" wait type see Important Notes section in blog', N'You should be able to safely ignore this wait type unless you believe a problem exists in processing log blocks to flush to the transaction log. This wait type is not a wait indicating I/O bottlenecks. It is only for waiting for other workers to request log block flushes. Note that on SQL Server 2005 this wait type will not show up in sys.dm_exec_requests because the Log Writer task does not show up there.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LOGMGR_RESERVE_APPEND', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'LOWFAIL_MEMMGR_QUEUE', N'Memory ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'METADATA_LAZYCACHE_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MIRROR_SEND_MESSAGE', NULL, NULL, N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MISCELLANEOUS', N'Ignore', N'Ignore', N'SQL 2005;SQL 2008', N'This really should be called "Not Waiting".', N'This may have been used in SQL 2000 but for 2005/2008, it is not used for any valid wait. It is simply the default wait in a list and isn''t used to indicate any real waiting. This type shows up twice in sys.dm_os_wait_stats in SQL 2008 but the "other" instance is an older unused wait type in the code. We should be able to remove it.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MSQL_DQ', N'Distributed Query ', N'External', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MSQL_SYNC_PIPE', NULL, NULL, N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MSQL_XACT_MGR_MUTEX', N'Transaction ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MSQL_XACT_MUTEX', N'Transaction ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MSQL_XP', N'Extended Procedure ', N'External', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'MSSEARCH', N'Full-Text Search ', N'External', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'NET_WAITFOR_PACKET', N'Network ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'NODE_CACHE_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'OLEDB', N'OLEDB ', N'External', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'ONDEMAND_TASK_QUEUE', N'Internal ', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGEIOLATCH_DT', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGEIOLATCH_EX', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGEIOLATCH_KP', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGEIOLATCH_NL', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGEIOLATCH_SH', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGEIOLATCH_UP', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGELATCH_DT', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGELATCH_EX', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGELATCH_KP', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGELATCH_NL', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGELATCH_SH', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PAGELATCH_UP', N'Latch ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PARALLEL_BACKUP_QUEUE', N'Backup or Restore ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PERFORMANCE_COUNTERS_RWLOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_ABR', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_AUDIT_ACCESS_EVENTLOG', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_AUDIT_ACCESS_SECLOG', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_CLOSEBACKUPMEDIA', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_CLOSEBACKUPTAPE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_CLOSEBACKUPVDIDEVICE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_CLUSAPI_CLUSTERRESOURCECONTROL', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_COCREATEINSTANCE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_COGETCLASSOBJECT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_CREATEACCESSOR', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_DELETEROWS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_GETCOMMANDTEXT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_GETDATA', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_GETNEXTROWS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_GETRESULT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_GETROWSBYBOOKMARK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_LBFLUSH', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_LBLOCKREGION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_LBREADAT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_LBSETSIZE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_LBSTAT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_LBUNLOCKREGION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_LBWRITEAT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_QUERYINTERFACE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_RELEASE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_RELEASEACCESSOR', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_RELEASEROWS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_RELEASESESSION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_RESTARTPOSITION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_SEQSTRMREAD', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_SEQSTRMREADANDWRITE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_SETDATAFAILURE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_SETPARAMETERINFO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_SETPARAMETERPROPERTIES', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_STRMLOCKREGION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_STRMSEEKANDREAD', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_STRMSEEKANDWRITE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_STRMSETSIZE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_STRMSTAT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_COM_STRMUNLOCKREGION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_CONSOLEWRITE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_CREATEPARAM', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DEBUG', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSADDLINK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSLINKEXISTCHECK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSLINKHEALTHCHECK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSREMOVELINK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSREMOVEROOT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSROOTFOLDERCHECK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSROOTINIT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DFSROOTSHARECHECK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DTC_ABORT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DTC_ABORTREQUESTDONE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DTC_BEGINTRANSACTION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DTC_COMMITREQUESTDONE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DTC_ENLIST', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_DTC_PREPAREREQUESTDONE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_FILESIZEGET', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_FSAOLEDB_ABORTTRANSACTION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_FSAOLEDB_COMMITTRANSACTION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_FSAOLEDB_STARTTRANSACTION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_FSRECOVER_UNCONDITIONALUNDO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_GETRMINFO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_LOCKMONITOR', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_MSS_RELEASE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_ODBCOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLE_UNINIT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_ABORTORCOMMITTRAN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_ABORTTRAN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_GETDATASOURCE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_GETLITERALINFO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_GETPROPERTIES', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_GETPROPERTYINFO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_GETSCHEMALOCK', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_JOINTRANSACTION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_RELEASE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDB_SETPROPERTIES', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OLEDBOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_ACCEPTSECURITYCONTEXT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_ACQUIRECREDENTIALSHANDLE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_AUTHENTICATIONOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_AUTHORIZATIONOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_AUTHZGETINFORMATIONFROMCONTEXT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_AUTHZINITIALIZECONTEXTFROMSID', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_AUTHZINITIALIZERESOURCEMANAGER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_BACKUPREAD', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_CLOSEHANDLE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_CLUSTEROPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_COMOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_COMPLETEAUTHTOKEN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_COPYFILE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_CREATEDIRECTORY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_CREATEFILE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_CRYPTACQUIRECONTEXT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_CRYPTIMPORTKEY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_CRYPTOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DECRYPTMESSAGE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DELETEFILE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DELETESECURITYCONTEXT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DEVICEIOCONTROL', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DEVICEOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DIRSVC_NETWORKOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DISCONNECTNAMEDPIPE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DOMAINSERVICESOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DSGETDCNAME', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_DTCOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_ENCRYPTMESSAGE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_FILEOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_FINDFILE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_FLUSHFILEBUFFERS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_FORMATMESSAGE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_FREECREDENTIALSHANDLE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_FREELIBRARY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GENERICOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETADDRINFO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETCOMPRESSEDFILESIZE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETDISKFREESPACE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETFILEATTRIBUTES', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETFILESIZE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETLONGPATHNAME', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETPROCADDRESS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETVOLUMENAMEFORVOLUMEMOUNTPOINT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_GETVOLUMEPATHNAME', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_INITIALIZESECURITYCONTEXT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_LIBRARYOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_LOADLIBRARY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_LOGONUSER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_LOOKUPACCOUNTSID', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_MESSAGEQUEUEOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_MOVEFILE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_NETGROUPGETUSERS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_NETLOCALGROUPGETMEMBERS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_NETUSERGETGROUPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_NETUSERGETLOCALGROUPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_NETUSERMODALSGET', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_NETVALIDATEPASSWORDPOLICY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_NETVALIDATEPASSWORDPOLICYFREE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_OPENDIRECTORY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_PIPEOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_PROCESSOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_QUERYREGISTRY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_QUERYSECURITYCONTEXTTOKEN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_REMOVEDIRECTORY', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_REPORTEVENT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_REVERTTOSELF', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_RSFXDEVICEOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SECURITYOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SERVICEOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SETENDOFFILE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SETFILEPOINTER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SETFILEVALIDDATA', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SETNAMEDSECURITYINFO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SQLCLROPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_SQMLAUNCH', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_VERIFYSIGNATURE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_VSSOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_WAITFORSINGLEOBJECT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_WINSOCKOPS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_WRITEFILE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_WRITEFILEGATHER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_OS_WSASETLASTERROR', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_REENLIST', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_RESIZELOG', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_ROLLFORWARDREDO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_ROLLFORWARDUNDO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_SB_STOPENDPOINT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_SERVER_STARTUP', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_SETRMINFO', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_SHAREDMEM_GETDATA', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_SNIOPEN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_SOSHOST', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_SOSTESTING', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_STARTRM', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_STREAMFCB_CHECKPOINT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_STREAMFCB_RECOVER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_STRESSDRIVER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_TESTING', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_TRANSIMPORT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_UNMARSHALPROPAGATIONTOKEN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_VSS_CREATESNAPSHOT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_VSS_CREATEVOLUMESNAPSHOT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_CALLBACKEXECUTE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_DISPATCHER', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_ENGINEINIT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_GETTARGETSTATE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_SESSIONCOMMIT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_TARGETFINALIZE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_TARGETINIT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XE_TIMERRUN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XETESTING', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PREEMPTIVE_XXX', N'Varies', N'External', N'SQL 2008', N'Used to indicate a worker is running coded that is not under the SQLOS Scheduling Systems', N'I will specific PREEMPTIVE_XX wait types or groups of them in 2010. Be sure to read the Important Notes section for bug where this wait type is being over counted by the engine in some situations. Note also that when you see this wait_type in sys.dm_exec_requests the status of the request is RUNNING not SUSPENDED. This is because the engine doesn''t really know if the thread is waiting or running "external" code.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'PRINT_ROLLBACK_PROGRESS', N'Alter Database state ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QNMANAGER_ACQUIRE', NULL, NULL, N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QPJOB_KILL', N'Update of statistics ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QPJOB_WAITFOR_ABORT', N'Update of statistics ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QRY_MEM_GRANT_INFO_MUTEX', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_ERRHDL_SERVICE_DONE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_EXECUTION_INDEX_SORT_EVENT_OPEN', N'Building indexes ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_NOTIFICATION_MGR_MUTEX', N'Query Notification Manager ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_NOTIFICATION_SUBSCRIPTION_MUTEX', N'Query Notification Manager ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_NOTIFICATION_TABLE_MGR_MUTEX', N'Query Notification Manager ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_NOTIFICATION_UNITTEST_MUTEX', N'Query Notification Manager ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_OPTIMIZER_PRINT_MUTEX', N'Query Notification Manager ', N'Queue', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_TRACEOUT', N'Query Notification Manager ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'QUERY_WAIT_ERRHDL_SERVICE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RECOVER_CHANGEDB', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'REPL_CACHE_ACCESS', N'Replication ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'REPL_HISTORYCACHE_ACCESS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'REPL_SCHEMA_ACCESS', N'Replication ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'REPL_TRANHASHTABLE_ACCESS', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'REPLICA_WRITES', N'Database Snapshots ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'REQUEST_DISPENSER_PAUSE', N'Backup or Restore ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'REQUEST_FOR_DEADLOCK_SEARCH', N'Lock', N'Background', N'SQL 2008', N'Used by background worker "Lock Monitor" to search for deadlocks.  This is an "optional" wait type see Important Notes section in blog', N'You should be able to safely ignore this one as it is just and indication the lock monitor thread is temporarily sleeping before it wakes up to do work. This wait type should never exceed 5 seconds in one "wait" as this is the interval the lock monitor wakes up to check for deadlocks')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RESMGR_THROTTLED', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RESOURCE_QUERY_SEMAPHORE_COMPILE', N'Query', N'Resource', N'SQL 2005;SQL 2008', N'Used to indicate a worker is waiting to compile a query due to too many other concurrent query compilations that require "not small" amounts of memory.', N'This is a very complicated problem to explain. The problem is more than just concurrent compilations. It is the amount of memory required by the compilations. Typically this problem is not seen on 64bit systems. The biggest thing you can do is find out why you have so many compilations. Furthermore, a high amount of "query memory" can result in less memory available for compilations so check what other users are consuming high query memory. ')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RESOURCE_QUEUE', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RESOURCE_SEMAPHORE', N'Query', N'Resource', N'SQL 2005;SQL 2008', N'Used to indicate a worker is waiting to be allowed to perform an operation requiring "query memory" such as hashes and sorts', N'High wait times indicate too many queries are running concurrently that require query memory. Operations requiring query memory are hashes and sorts. Use DMVs such as dm_exec_query_resource_semaphores and dm_exec_query_memory_grants')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RESOURCE_SEMAPHORE_MUTEX', N'Memory ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RESOURCE_SEMAPHORE_QUERY_COMPILE', N'Memory ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RESOURCE_SEMAPHORE_SMALL_QUERY', N'Memory ', N'Resource', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'RG_RECONFIG', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SEC_DROP_TEMP_KEY', N'Security ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SECURITY_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SEQUENTIAL_GUID', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SERVER_IDLE_CHECK', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SHUTDOWN', N'Internal ', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SLEEP_BPOOL_FLUSH', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SLEEP_DBSTARTUP', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SLEEP_DCOMSTARTUP', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SLEEP_MSDBSTARTUP', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SLEEP_SYSTEMTASK', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SLEEP_TASK', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SLEEP_TEMPDBSTARTUP', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SNI_CRITICAL_SECTION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SNI_HTTP_ACCEPT', N'Internal ', N'Background', N'SQL 2005;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SNI_HTTP_WAITFOR_0_DISCON', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SNI_LISTENER_ACCESS', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SNI_TASK_COMPLETION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOAP_READ', N'SOAP ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOAP_WRITE', N'SOAP ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_CALLBACK_REMOVAL', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_DISPATCHER_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_LOCALALLOCATORLIST', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_MEMORY_USAGE_ADJUSTMENT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_OBJECT_STORE_DESTROY_MUTEX', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_PROCESS_AFFINITY_MUTEX', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_RESERVEDMEMBLOCKLIST', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_SCHEDULER_YIELD', N'SQLOS', N'Forced', N'SQL 2005;SQL 2008', N'Used to indicate a worker has yielded to let other workers run on a scheduler', N'This wait is simply an indication that a worker yielded for someone else to run. High wait counts with low wait times usually mean CPU bound queries. High wait times here could be non-yielding problems')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_SMALL_PAGE_ALLOC', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_STACKSTORE_INIT_MUTEX', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_SYNC_TASK_ENQUEUE_EVENT', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOS_VIRTUALMEMORY_LOW', N'Internal ', N'Background', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_EVENT', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_INTERNAL', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_MUTEX', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_ROWLOCK', N'CLR ', N'Queue', NULL, NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_RWLOCK', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_SEMAPHORE', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_SLEEP', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_TRACELOCK', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SOSHOST_WAITFORDONE', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLCLR_APPDOMAIN', N'CLR ', N'Queue', N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLCLR_ASSEMBLY', N'CLR', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLCLR_DEADLOCK_DETECTION', N'CLR', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLCLR_QUANTUM_PUNISHMENT', N'CLR', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLSORT_NORMMUTEX', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLSORT_SORTMUTEX', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLTRACE_BUFFER_FLUSH ', N'Trace', N'Background', N'SQL 2005;SQL 2008', N'Used by background worker', N'You should be able to safely ignore unless some unexplained problem with SQLTrace files not getting written to disk properly. ')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLTRACE_LOCK', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLTRACE_SHUTDOWN', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SQLTRACE_WAIT_ENTRIES', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'SRVPROC_SHUTDOWN', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TEMPOBJ', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'THREADPOOL', N'SQLOS', N'Resource', N'SQL 2005;SQL 2008', N'Indicates a wait for a  task to be assigned to a worker thread', N'Look for symptoms of high blocking or contention problems with many of the workers especially if the wait count and times are high. Don''t jump to increase max worker threads especially if you use default setting of 0. This wait type will not show up in sys.dm_exec_requests because it only occurs when the task is waiting on a worker thread. You must have a worker to become a request. Furthermore, you may not see this "live" since there may be no workers to process tasks for logins or for queries to look at DMVs.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TIMEPRIV_TIMEPERIOD', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRACE_EVTNOTIF', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRACEWRITE', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRAN_MARKLATCH_DT', N'TRAN_MARKLATCH', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRAN_MARKLATCH_EX', N'TRAN_MARKLATCH', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRAN_MARKLATCH_KP', N'TRAN_MARKLATCH', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRAN_MARKLATCH_NL', N'TRAN_MARKLATCH', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRAN_MARKLATCH_SH', N'TRAN_MARKLATCH', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRAN_MARKLATCH_UP', N'TRAN_MARKLATCH', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'TRANSACTION_MUTEX', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'UTIL_PAGE_ALLOC', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'VIA_ACCEPT', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'VIEW_DEFINITION_MUTEX', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WAIT_FOR_RESULTS', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WAITFOR', N'Background', NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WAITFOR_TASKSHUTDOWN', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WAITSTAT_MUTEX', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WCC', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WORKTBL_DROP', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WRITE_COMPLETION', NULL, NULL, N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'WRITELOG', N'I/O', N'Sync', N'SQL 2005;SQL 2008', N'Indicates a worker thread is waiting for LogWriter to flush log blocks. ', N'High waits and wait times indicate an I/O bottleneck on the storage system associated with the transaction log')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XACT_OWN_TRANSACTION', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XACT_RECLAIM_SESSION', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XACTLOCKINFO', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XACTWORKSPACE_MUTEX', NULL, NULL, N'SQL 2005;SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_BUFFERMGR_ALLPROCESSED_EVENT', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_BUFFERMGR_FREEBUF_EVENT', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_DISPATCHER_CONFIG_SESSION_LIST', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_DISPATCHER_JOIN', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_DISPATCHER_WAIT', N'XEvent', N'Background', N'SQL 2008', N'Used by a background worker to handle queue requests to write out buffers for async targets', N'You should be able to safely ignore this unless you believe a problem is occurring with processing of events for async targets. Since this works on a queue you can have bursts of high wait times especially when no XEvent sessions are active.')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_MODULEMGR_SYNC', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_OLS_LOCK', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_PACKAGE_LOCK_BACKOFF', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_SERVICES_EVENTMANUAL', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_SERVICES_MUTEX', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_SERVICES_RWLOCK', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_SESSION_CREATE_SYNC', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_SESSION_FLUSH', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_SESSION_SYNC', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_STM_CREATE', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_TIMER_EVENT', N'XEvent', N'Background', N'SQL 2008', N'Used to indicate a background task is waiting for "expired" timers for internal Xevent engine work', N'You should be able to safely ignore this one. Just used by the Xevent engine for internal processing of its work. If something was possibly wrong with Xevent processing you might see if this thread ever "wakes up"')
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_TIMER_MUTEX', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
INSERT dbo.[WaitTypeCategory] ([WaitType], [Category], [Resource], [Version], [Description], [Action]) VALUES (N'XE_TIMER_TASK_DONE', N'XEvent', N'Background', N'SQL 2008;', NULL, NULL)
go




USE dba
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upReport_WaitStatSnapshot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Report].[WaitStatSnapshot]
GO

/*============================================================
	Procedure:	dbo.upReport_WaitStatSnapshot
	Author:		Jason Strate
	Date:		April 1, 2010

	Synopsis:
	This procedure aggregates wait stats for the selected date range.  Data is
	joined with category information to provide description and action
	guidance if available.

	Parameters
	@StartDate  : Begin date for aggregating wait stats.  Begins from the start
	of the date.
	@EndDate    : End date for aggregating wait stats.  Includes all data for the
	end date.

	============================================================
	Revision History:
	Date:		By			Description
	------------------------------------------------------------

============================================================*/
CREATE PROCEDURE dbo.[upReport_WaitStatSnapshot]
(
	@StartDate datetime,
	@EndDate datetime
)
As
	set nocount on
	
	;WITH WaitStatCTE
	AS (
		SELECT COALESCE(wtc.Category, 'UNKNOWN') AS Category
			,COALESCE(wtc.Resource, 'UNKNOWN') AS Resource
			,wtc.Description
			,wtc.Action
			,wsh.WaitType
			,SUM(wsh.WaitingTasksCount) AS WaitingTasksCount
			,SUM(wsh.WaitTimeMs) AS WaitTimeMs
			,SUM(wsh.SignalWaitTimeMs) AS SignalWaitTimeMs
		FROM dbo.WaitStatHistory wsh
			INNER JOIN dbo.WaitTypeCategory wtc ON wsh.WaitType = wtc.WaitType
		WHERE wsh.WaitingTasksCount <> 0
			AND	wsh.CreateDate BETWEEN @StartDate AND DATEADD(ms, -3, DATEADD(d, 1, @EndDate))
		GROUP BY COALESCE(wtc.Category, 'UNKNOWN')
			,COALESCE(wtc.Resource, 'UNKNOWN')
			,wsh.WaitType
			,wtc.Description
			,wtc.Action
	)
	SELECT Category
		,Resource
		,[Description]
		,[Action]
		,WaitType
		,WaitTimeMs
		,WaitingTasksCount
		,SUM(WaitTimeMs) OVER() AS TotalWaitTimeMS
		,SignalWaitTimeMs
		,CAST((1.*WaitTimeMs)/SUM(WaitTimeMs) OVER() AS decimal(8,6)) AS PercentWaitTimeMS
	FROM WaitStatCTE
	ORDER BY WaitTimeMs DESC
GO

USE [msdb]
GO

/****** Object:  Job [Collect Wait Stats]    Script Date: 04/15/2011 09:17:18 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 04/15/2011 09:17:18 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Collect Wait Stats', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CORP\dandenne', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [upLoad_TrackWaitStats]    Script Date: 04/15/2011 09:17:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'upLoad_TrackWaitStats', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dba.dbo.[upLoad_TrackWaitStats]', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every 15 minutes', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20110415, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959--, 
		--@schedule_uid=N'b651e72d-9d9f-4e03-8245-25548608010a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

