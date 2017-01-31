select 
	   --c.usecounts
	   --,c.cacheobjtype
	   --,c.objtype
	   --,t.text
	   c.*
	   ,t.*
	   , a.*
from sys.dm_exec_cached_plans c
    cross apply sys.dm_exec_sql_text(c.plan_handle) t
    cross apply sys.dm_exec_plan_Attributes(c.plan_handle) a
where t.dbid = 44
   -- and t.text like '%up_GetServiceItemByServiceID%'
    and t.objectid = 1731797527 -- object_id('dbo.up_GetServiceItemByServiceID')
order by a.attribute

/*
-- FIND PLAN ATTRIBUTES SET CONDITIONS HERE

declare @set_options int = 251
if ((1 & @set_options) = 1) print 'ANSI_PADDING'
if ((4 & @set_options) = 4) print 'FORCEPLAN'
if ((8 & @set_options) = 8) print 'CONCAT_NULL_YIELDS_NULL'
if ((16 & @set_options) = 16) print 'ANSI_WARNINGS'
if ((32 & @set_options) = 32) print 'ANSI_NULLS'
if ((64 & @set_options) = 64) print 'QUOTED_IDENTIFIER'
if ((128 & @set_options) = 128) print 'ANSI_NULL_DFLT_ON'
if ((256 & @set_options) = 256) print 'ANSI_NULL_DFLT_OFF'
if ((512 & @set_options) = 512) print 'NoBrowseTable'
if ((4096 & @set_options) = 4096) print 'ARITH_ABORT'
if ((8192 & @set_options) = 8192) print 'NUMERIC_ROUNDABORT'
if ((16384 & @set_options) = 16384) print 'DATEFIRST'
if ((32768 & @set_options) = 32768) print 'DATEFORMAT'
if ((65536 & @set_options) = 65536) print 'LanguageID'
*/



select 
    SUBSTRING(b.text, (a.statement_start_offset/2) + 1, 
		((	CASE statement_end_offset           
				WHEN -1 THEN DATALENGTH(b.text)          
				ELSE a.statement_end_offset 
			END               - a.statement_start_offset)/2) + 1) AS statement_text
    ,c.query_plan
    --,b.text
    ,a.execution_count
    ,a.total_elapsed_time
    ,a.max_elapsed_time
    ,CAST(((a.total_elapsed_time * 1.0) / a.execution_count) as INT) as Avg_Elapesed_Time
    ,a.*
from sys.dm_exec_query_stats a
    cross apply sys.dm_exec_sql_text(a.plan_handle) b
    CROSS APPLY sys.dm_exec_query_plan (a.plan_handle) AS c  
where b.text like '%up_GetServiceItemByServiceID%'
    and b.dbid = 44
  -- and a.plan_handle = CAST('0x05002C001722396740C314DB030000000000000000000000' as VARBINARY)
order by Avg_Elapesed_Time

