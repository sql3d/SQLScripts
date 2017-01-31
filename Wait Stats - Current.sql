SELECT [counter_name]
	   ,"Average wait time (ms)"
	   ,"Waits in progress"
	   ,"Waits started per second"
	   ,"Cumulative wait time (ms) per second"
FROM   
	(SELECT [counter_name]
			,[instance_name]
			,[cntr_value]
		FROM   sys.dm_os_performance_counters
		WHERE  OBJECT_NAME LIKE '%Wait Statistics%'
	) os_pc 
PIVOT (Avg([cntr_value]) FOR [instance_name] IN ("Average wait time (ms)", "Waits in progress", "Waits started per second", "Cumulative wait time (ms) per second")) AS Pvt
WHERE  "Average wait time (ms)" > 0; 
