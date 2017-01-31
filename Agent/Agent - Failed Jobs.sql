USE [msdb] 
GO
 /* This code selects the top 10 most recent SQLAgent jobs that failed to 
complete successfully and where the email notification failed too. 
Jonathan Allen Jul 2012 */
DECLARE @Date DATETIME 
SELECT  @Date = DATEADD(d, DATEDIFF(d, '19000101', GETDATE()) - 1, '19000101') 
SELECT TOP 10
        [s].[name] ,
        [sjh].[step_name] ,
        [sjh].[sql_message_id] ,
        [sjh].[sql_severity] ,
        [sjh].[message] ,
        [sjh].[run_date] ,
        [sjh].[run_time] ,
        [sjh].[run_duration] ,
        [sjh].[operator_id_emailed] ,
        [sjh].[operator_id_netsent] ,
        [sjh].[operator_id_paged] ,
        [sjh].[retries_attempted]
FROM    [dbo].[sysjobhistory] AS sjh
INNER JOIN [dbo].[sysjobs] AS s
        ON [sjh].[job_id] = [s].[job_id]
WHERE   EXISTS ( SELECT *
                 FROM   [dbo].[sysjobs] AS s
                 INNER JOIN [dbo].[sysjobhistory] AS s2
                        ON [s].[job_id] = [s2].[job_id]
                 WHERE  [sjh].[job_id] = [s2].[job_id]
                        AND [s2].[message] LIKE '%failed to notify%'
                        AND CONVERT(DATETIME, CONVERT(VARCHAR(15), [s2].[run_date])) >= @date
                        AND [s2].[run_status] = 0 )
        AND sjh.[run_status] = 0
        AND sjh.[step_id] != 0
        AND CONVERT(DATETIME, CONVERT(VARCHAR(15), [run_date])) >= @date
ORDER BY [sjh].[run_date] DESC ,
        [sjh].[run_time] DESC 
go

USE [msdb] 
go 
/* This code summarises details of SQLAgent jobs that failed to complete successfully 
and where the email notification failed too. 
Jonathan Allen Jul 2012 */
DECLARE @Date DATETIME
SELECT  @Date = DATEADD(d, DATEDIFF(d, '19000101', GETDATE()) - 1, '19000101')
SELECT  [s].name ,
        [s2].[step_id] ,
        CONVERT(DATETIME, CONVERT(VARCHAR(15), [s2].[run_date])) AS [rundate] ,
        COUNT(*) AS [execution count]
FROM    [dbo].[sysjobs] AS s
INNER JOIN [dbo].[sysjobhistory] AS s2
        ON [s].[job_id] = [s2].[job_id]
WHERE   [s2].[message] LIKE '%failed to notify%'
        AND CONVERT(DATETIME, CONVERT(VARCHAR(15), [s2].[run_date])) >= @date
        AND [s2].[run_status] = 0
GROUP BY name ,
        [s2].[step_id] ,
        [s2].[run_date]
ORDER BY [s2].run_date DESC