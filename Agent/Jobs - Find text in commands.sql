select DISTINCT sj.name as [Job Name], command
from msdb.dbo.sysjobsteps sjs
	inner join msdb.dbo.sysjobs sj on sjs.job_id = sj.job_id
where command like '%up_ReportMasterMetricsload%'