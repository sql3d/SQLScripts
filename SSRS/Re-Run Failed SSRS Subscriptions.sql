
use msdb
go


select 'exec sp_start_job @job_name = ''' + cast(j.name as varchar(40)) + '''', s.*
from msdb.dbo.sysjobs j  
	join  msdb.dbo.sysjobsteps js on js.job_id = j.job_id 
	join  [ReportServer].[dbo].[Subscriptions] s  on js.command like '%' + cast(s.subscriptionid as varchar(40)) + '%' 
where s.LastStatus like 'Failure sending mail%';
