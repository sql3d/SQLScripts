DECLARE @pg_size INT, @Instancename varchar(50)

SELECT @pg_size = low from master..spt_values where number = 1 and type = 'E'

SELECT @Instancename = LEFT([object_name], (CHARINDEX(':',[object_name]))) FROM sys.dm_os_performance_counters WHERE counter_name = 'Buffer cache hit ratio'

PRINT '----------------------------------------------------------------------------------------------------'

PRINT 'Memory usage details for SQL Server instance ' + @@SERVERNAME  + ' (' + CAST(SERVERPROPERTY('productversion') AS VARCHAR) + ' - ' +  SUBSTRING(@@VERSION, CHARINDEX('X',@@VERSION),4)  + ' - ' + CAST(SERVERPROPERTY('edition') AS VARCHAR) + ')'

PRINT '----------------------------------------------------------------------------------------------------'

SELECT 'Memory Configuration on the Server visible to Operating System'

SELECT physical_memory_in_bytes/1048576.0 as [Physical Memory_MB], physical_memory_in_bytes/1073741824.0 as [Physical Memory_GB], virtual_memory_in_bytes/1048576.0 as [Virtual Memory MB] FROM sys.dm_os_sys_info

SELECT 'Buffer Pool Usage at the Moment'

SELECT (bpool_committed*8)/1024.0 as BPool_Committed_MB, (bpool_commit_target*8)/1024.0 as BPool_Commit_Tgt_MB,(bpool_visible*8)/1024.0 as BPool_Visible_MB  FROM sys.dm_os_sys_info

SELECT 'Total Memory used by SQL Server instance from Perf Mon '

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'Total Server Memory (KB)'

SELECT 'Memory needed as per current Workload for SQL Server instance'

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'Target Server Memory (KB)'

SELECT 'Total amount of dynamic memory the server is using for maintaining connections'

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'Connection Memory (KB)'

SELECT 'Total amount of dynamic memory the server is using for locks'

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'Lock Memory (KB)'

SELECT 'Total amount of dynamic memory the server is using for the dynamic SQL cache'

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'SQL Cache Memory (KB)'

SELECT 'Total amount of dynamic memory the server is using for query optimization'

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'Optimizer Memory (KB) '

SELECT 'Total amount of dynamic memory used for hash, sort and create index operations.'

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'Granted Workspace Memory (KB) '

SELECT 'Total Amount of memory consumed by cursors'

SELECT cntr_value as Mem_KB, cntr_value/1024.0 as Mem_MB, (cntr_value/1048576.0) as Mem_GB FROM sys.dm_os_performance_counters WHERE counter_name = 'Cursor memory usage' and instance_name = '_Total'

SELECT 'Number of pages in the buffer pool (includes database, free, and stolen).'

SELECT cntr_value as [8KB_Pages], (cntr_value*@pg_size)/1024.0 as Pages_in_KB, (cntr_value*@pg_size)/1048576.0 as Pages_in_MB FROM sys.dm_os_performance_counters WHERE object_name= @Instancename+'Buffer Manager' and counter_name = 'Total pages' 

SELECT 'Number of Data pages in the buffer pool'

SELECT cntr_value as [8KB_Pages], (cntr_value*@pg_size)/1024.0 as Pages_in_KB, (cntr_value*@pg_size)/1048576.0 as Pages_in_MB FROM sys.dm_os_performance_counters WHERE object_name=@Instancename+'Buffer Manager' and counter_name = 'Database pages' 

SELECT 'Number of Free pages in the buffer pool'

SELECT cntr_value as [8KB_Pages], (cntr_value*@pg_size)/1024.0 as Pages_in_KB, (cntr_value*@pg_size)/1048576.0 as Pages_in_MB FROM sys.dm_os_performance_counters WHERE object_name=@Instancename+'Buffer Manager' and counter_name = 'Free pages'

SELECT 'Number of Reserved pages in the buffer pool'

SELECT cntr_value as [8KB_Pages], (cntr_value*@pg_size)/1024.0 as Pages_in_KB, (cntr_value*@pg_size)/1048576.0 as Pages_in_MB FROM sys.dm_os_performance_counters WHERE object_name=@Instancename+'Buffer Manager' and counter_name = 'Reserved pages'

SELECT 'Number of Stolen pages in the buffer pool'

SELECT cntr_value as [8KB_Pages], (cntr_value*@pg_size)/1024.0 as Pages_in_KB, (cntr_value*@pg_size)/1048576.0 as Pages_in_MB FROM sys.dm_os_performance_counters WHERE object_name=@Instancename+'Buffer Manager' and counter_name = 'Stolen pages'

SELECT 'Number of Plan Cache pages in the buffer pool'

SELECT cntr_value as [8KB_Pages], (cntr_value*@pg_size)/1024.0 as Pages_in_KB, (cntr_value*@pg_size)/1048576.0 as Pages_in_MB FROM sys.dm_os_performance_counters WHERE object_name=@Instancename+'Plan Cache' and counter_name = 'Cache Pages'  and instance_name = '_Total'