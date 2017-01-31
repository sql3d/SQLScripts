

;WITH Latches AS
	(
		SELECT 
			latch_class
			,wait_time_ms / 1000.0 as WaitS
			,waiting_requests_count as WaitCount
			,100.0 * wait_time_ms / SUM(wait_time_ms) OVER() AS Percentage
			,ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS RowNum
		FROM sys.dm_os_latch_stats
		WHERE latch_class NOT IN ('BUFFER')
	)
SELECT w1.latch_class as LatchClass
	,CAST(W1.Waits AS DEC(14,2)) AS Wait_S
	,W1.WaitCount AS WaitCount
	,CAST(W1.Percentage AS DECIMAL(14,2)) as Percentage
	,CAST((W1.WaitS / W1.WaitCount) AS Decimal (14,4)) AS AvgWait_S
FROM Latches as W1
	INNER JOIN Latches as W2 ON W2.RowNum <= W1.RowNum
GROUP BY W1.RowNum, W1.latch_class, w1.WaitS, w1.WaitCount, w1.Percentage
HAVING
	SUM(W2.Percentage) - W1.Percentage < 95;
go