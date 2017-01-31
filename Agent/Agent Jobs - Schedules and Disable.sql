DECLARE @weekDay TABLE (
      mask      INT
    , maskValue VARCHAR(32)
);
 
INSERT INTO @weekDay
SELECT 1, 'Sunday'  UNION All
SELECT 2, 'Monday'  UNION All
SELECT 4, 'Tuesday'  UNION All
SELECT 8, 'Wednesday'  UNION All
SELECT 16, 'Thursday'  UNION All
SELECT 32, 'Friday'  UNION All
SELECT 64, 'Saturday';
 
WITH myCTE
AS(
    SELECT sched.name AS 'scheduleName'
        , sched.schedule_id
        , jobsched.job_id
        , CASE WHEN sched.freq_type = 1 THEN 'Once' 
            WHEN sched.freq_type = 4 
                And sched.freq_interval = 1 
                    THEN 'Daily'
            WHEN sched.freq_type = 4 
                THEN 'Every ' + CAST(sched.freq_interval AS VARCHAR(5)) + ' days'
            WHEN sched.freq_type = 8 THEN 
                REPLACE( REPLACE( REPLACE(( 
                    SELECT maskValue 
                    FROM @weekDay AS x 
                    WHERE sched.freq_interval & x.mask <> 0 
                    ORDER BY mask FOR XML Raw)
                , '"/><row maskValue="', ', '), '<row maskValue="', ''), '"/>', '') 
                + CASE WHEN sched.freq_recurrence_factor <> 0 
                        And sched.freq_recurrence_factor = 1 
                            THEN '; weekly' 
                    WHEN sched.freq_recurrence_factor <> 0 THEN '; every ' 
                + CAST(sched.freq_recurrence_factor AS VARCHAR(10)) + ' weeks' END
            WHEN sched.freq_type = 16 THEN 'On day ' 
                + CAST(sched.freq_interval AS VARCHAR(10)) + ' of every '
                + CAST(sched.freq_recurrence_factor AS VARCHAR(10)) + ' months' 
            WHEN sched.freq_type = 32 THEN 
                CASE WHEN sched.freq_relative_interval = 1 THEN 'First'
                    WHEN sched.freq_relative_interval = 2 THEN 'Second'
                    WHEN sched.freq_relative_interval = 4 THEN 'Third'
                    WHEN sched.freq_relative_interval = 8 THEN 'Fourth'
                    WHEN sched.freq_relative_interval = 16 THEN 'Last'
                END + 
                CASE WHEN sched.freq_interval = 1 THEN ' Sunday'
                    WHEN sched.freq_interval = 2 THEN ' Monday'
                    WHEN sched.freq_interval = 3 THEN ' Tuesday'
                    WHEN sched.freq_interval = 4 THEN ' Wednesday'
                    WHEN sched.freq_interval = 5 THEN ' Thursday'
                    WHEN sched.freq_interval = 6 THEN ' Friday'
                    WHEN sched.freq_interval = 7 THEN ' Saturday'
                    WHEN sched.freq_interval = 8 THEN ' Day'
                    WHEN sched.freq_interval = 9 THEN ' Weekday'
                    WHEN sched.freq_interval = 10 THEN ' Weekend'
                END
                + CASE WHEN sched.freq_recurrence_factor <> 0 
                        And sched.freq_recurrence_factor = 1 THEN '; monthly'
                    WHEN sched.freq_recurrence_factor <> 0 THEN '; every ' 
                + CAST(sched.freq_recurrence_factor AS VARCHAR(10)) + ' months' END
            WHEN sched.freq_type = 64 THEN 'StartUp'
            WHEN sched.freq_type = 128 THEN 'Idle'
          END AS 'frequency'
        , IsNull('Every ' + CAST(sched.freq_subday_interval AS VARCHAR(10)) + 
            CASE WHEN sched.freq_subday_type = 2 THEN ' seconds'
                WHEN sched.freq_subday_type = 4 THEN ' minutes'
                WHEN sched.freq_subday_type = 8 THEN ' hours'
            END, 'Once') AS 'subFrequency'
        , REPLICATE('0', 6 - LEN(sched.active_start_time)) 
            + CAST(sched.active_start_time AS VARCHAR(6)) AS 'startTime'
        , REPLICATE('0', 6 - LEN(sched.active_end_time)) 
            + CAST(sched.active_end_time AS VARCHAR(6)) AS 'endTime'
        , REPLICATE('0', 6 - LEN(jobsched.next_run_time)) 
            + CAST(jobsched.next_run_time AS VARCHAR(6)) AS 'nextRunTime'
        , CAST(jobsched.next_run_date AS CHAR(8)) AS 'nextRunDate'
    FROM msdb.dbo.sysschedules AS sched
    Join msdb.dbo.sysjobschedules AS jobsched
        ON sched.schedule_id = jobsched.schedule_id
    WHERE sched.enabled = 1
)
 
SELECT job.name AS 'jobName'
    , sched.scheduleName
    , sched.frequency
    , sched.subFrequency
    , SUBSTRING(sched.startTime, 1, 2) + ':' 
        + SUBSTRING(sched.startTime, 3, 2) + ' - ' 
        + SUBSTRING(sched.endTime, 1, 2) + ':' 
        + SUBSTRING(sched.endTime, 3, 2) 
        AS 'scheduleTime' -- HH:MM
    , SUBSTRING(sched.nextRunDate, 1, 4) + '/' 
        + SUBSTRING(sched.nextRunDate, 5, 2) + '/' 
        + SUBSTRING(sched.nextRunDate, 7, 2) + ' ' 
        + SUBSTRING(sched.nextRunTime, 1, 2) + ':' 
        + SUBSTRING(sched.nextRunTime, 3, 2) AS 'nextRunDate'
      /* Note: the sysjobschedules table refreshes every 20 min, 
        so nextRunDate may be out of date */
    , 'Execute msdb.dbo.sp_update_job @job_id = ''' 
        + CAST(job.job_id AS CHAR(36)) + ''', @enabled = 0;' AS 'disableScript'
FROM msdb.dbo.sysjobs AS job
Join myCTE AS sched
    ON job.job_id = sched.job_id
WHERE job.enabled = 1 -- do not display disabled jobs
ORDER BY nextRunDate;