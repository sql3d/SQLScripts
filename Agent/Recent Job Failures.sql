SELECT	A.Name as 'JobName', Sub5.MaxRunDate, Sub5.MaxRunTime, Sub5.MostRecentJobStatus
FROM	msdb.dbo.sysJobs A LEFT OUTER JOIN
		(SELECT	A.Job_ID, Sub4.MaxRunDate, Sub4.MaxRunTime,
				CASE	A.run_status
						WHEN 0 THEN 'Failed'
						WHEN 1 THEN 'Successful'
						WHEN 2 THEN 'Retry'
						WHEN 3 THEN 'Cancelled'
						WHEN 4 THEN 'In Progress'
				END as 'MostRecentJobStatus'
		FROM	msdb.dbo.sysJobHistory A INNER JOIN
				(	SELECT	A.Job_ID, Sub3.MaxRunDate, Sub3.MaxRunTime, Sub3.MaxStepID, MAX(A.Instance_ID) as 'MaxInstanceID'
					FROM msdb.dbo.sysJobHistory A INNER JOIN
						(	SELECT	A.Job_ID, Sub2.MaxRunDate, Sub2.MaxRunTime, MAX(A.Step_ID) as 'MaxStepID'
							FROM msdb.dbo.sysJobHistory A INNER JOIN
								(	SELECT	A.Job_ID, Sub1.MaxRunDate, MAX(A.run_time) as 'MaxRunTime'
									FROM	msdb.dbo.sysJobHistory A INNER JOIN
									(	SELECT	A.Job_ID, MAX(A.run_date) as 'MaxRunDate'
										FROM	msdb.dbo.sysJobHistory A
										GROUP BY A.Job_ID) Sub1 ON
											A.Job_ID = Sub1.Job_ID AND
											A.run_date = Sub1.MaxRunDate
									GROUP BY A.Job_ID, Sub1.MaxRunDate) Sub2 ON
										A.Job_ID = Sub2.Job_ID AND
										A.run_date = Sub2.MaxRunDate AND
										A.run_time = Sub2.MaxRunTime
							GROUP BY A.Job_ID, Sub2.MaxRunDate, Sub2.MaxRunTime) Sub3 ON
									A.Job_ID = Sub3.Job_ID AND
									A.run_date = Sub3.MaxRunDate AND
									A.run_time = Sub3.MaxRunTime AND
									A.Step_ID = Sub3.MaxStepID
						GROUP BY A.Job_ID, Sub3.MaxRunDate, Sub3.MaxRunTime, Sub3.MaxStepID) Sub4 ON
							A.Job_ID = Sub4.Job_ID AND
							A.run_date = Sub4.MaxRunDate AND
							A.run_time = Sub4.MaxRunTime AND
							A.Step_ID = Sub4.MaxStepID AND
							A.Instance_ID = Sub4.MaxInstanceID) Sub5 ON
		A.Job_ID = Sub5.Job_ID
WHERE	A.[Enabled] = 1
	and Sub5.MostRecentJobStatus = 'Failed'
ORDER BY A.Name