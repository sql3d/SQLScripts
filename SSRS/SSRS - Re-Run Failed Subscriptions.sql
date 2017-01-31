
use msdb
go


select c.[path], j.name, lastruntime, laststatus, 'exec sp_start_job @job_name = ''' + cast(j.name as varchar(40)) + '''' --, s.*
from msdb.dbo.sysjobs j  
	join  msdb.dbo.sysjobsteps js on js.job_id = j.job_id 
	join  reportserver.[dbo].[Subscriptions] s  on js.command like '%' + cast(s.subscriptionid as varchar(40)) + '%' 
	join reportserver.dbo.[Catalog] c on c.ItemID = s.Report_OID
where s.LastStatus  like 'Failure%'
order by LastRunTime desc



SELECT TOP 10 * 
FROM CalDevReportServer.dbo.ExecutionLog2 AS el
WHERE TimeStart BETWEEN '5/9/2014 04:00' AND '5/9/2014 04:15'