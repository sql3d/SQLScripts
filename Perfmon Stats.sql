

CREATE TABLE #perf_counters_init 
	(
		Collection_Instance INT
		, Object_Name VARCHAR(200)
		, Counter_Name VARCHAR(200)
		, Instance_Name VARCHAR(200)		
		, CNTR_VALUE INT
		, CNTR_Type INT
		, CurrentTime DATETIME
	);
	
CREATE TABLE #perf_counters_second 
	(
		Collection_Instance INT
		, Object_Name VARCHAR(200)
		, Counter_Name VARCHAR(200)
		, Instance_Name VARCHAR(200)
		, CNTR_VALUE INT
		, CNTR_Type INT		
		, CurrentTime DATETIME
	);
		
DECLARE @ServerName NVARCHAR(100)
		,@SQL_Init NVARCHAR(4000)
		,@SQL_Second NVARCHAR(4000)


IF  CHARINDEX('\', @@SERVERNAME) > 1
	BEGIN 
		SELECT @ServerName = SUBSTRING(@@SERVERNAME, CHARINDEX('\', @@SERVERNAME) + 1, LEN(@@SERVERNAME) )
	END
ELSE 
	BEGIN
		SELECT @ServerName = 'SQLServer'
	END;
	
SET @SQL_Init = 'SELECT  CAST(1 AS INT) AS collection_instance ,
				OBJECT_NAME ,
				counter_name ,
				instance_name ,
				cntr_value ,
				cntr_type ,
				CURRENT_TIMESTAMP AS collection_time
			FROM    sys.dm_os_performance_counters
			WHERE   ( OBJECT_NAME = '''  + @ServerName + ':Access Methods''
					  AND counter_name = ''Full Scans/sec''
					)
					OR ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
						 AND counter_name = ''Index Searches/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
						 AND counter_name = ''Lazy Writes/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
						 AND counter_name =''Free list stalls/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
						 AND counter_name = ''Page life expectancy''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
						 AND counter_name = ''Processes Blocked''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
						 AND counter_name = ''User Connections''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
						 AND counter_name = ''Lock Waits/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
						 AND counter_name = ''Lock Wait Time (ms)''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
						 AND counter_name = ''SQL Re-Compilations/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':Memory Manager''
						 AND counter_name = ''Memory Grants Pending''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
						 AND counter_name = ''Batch Requests/sec''
					   )
					OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
						 AND counter_name = ''SQL Compilations/sec''
					   );
		';
		
SET @SQL_Second = 'SELECT  CAST(2 AS INT) AS collection_instance ,
        OBJECT_NAME ,
        counter_name ,
        instance_name ,
        cntr_value ,
        cntr_type ,
        CURRENT_TIMESTAMP AS collection_time
FROM    sys.dm_os_performance_counters
WHERE   ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
          AND counter_name = ''Full Scans/sec''
        )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Access Methods''
             AND counter_name = ''Index Searches/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
             AND counter_name = ''Lazy Writes/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
			 AND counter_name =''Free list stalls/sec''
		   )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Buffer Manager''
             AND counter_name = ''Page life expectancy''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
             AND counter_name = ''Processes Blocked''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':General Statistics''
             AND counter_name = ''User Connections''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
             AND counter_name = ''Lock Waits/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Locks''
             AND counter_name = ''Lock Wait Time (ms)''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
             AND counter_name = ''SQL Re-Compilations/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':Memory Manager''
             AND counter_name = ''Memory Grants Pending''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
             AND counter_name = ''Batch Requests/sec''
           )
        OR ( OBJECT_NAME = ''' + @ServerName + ':SQL Statistics''
             AND counter_name = ''SQL Compilations/sec''
           );
	';             
             
         
INSERT INTO #perf_counters_init
EXEC sp_executesql @sql_init
    
-- Wait on Second between data collection
WAITFOR DELAY '00:00:01'

INSERT INTO #perf_counters_second
EXEC sp_executesql @SQL_Second

print @sql_second

-- Calculate the cumulative counter values
SELECT  i.object_name ,
        i.counter_name ,
        i.instance_name ,
        CASE WHEN i.cntr_type = 272696576	THEN s.cntr_value - i.cntr_value
             WHEN i.cntr_type = 65792		THEN s.cntr_value
        END AS cntr_value
FROM    #perf_counters_init AS i
	INNER JOIN #perf_counters_second AS s ON i.collection_instance + 1 = s.collection_instance
		AND i.object_name = s.object_name
		AND i.counter_name = s.counter_name
		AND i.instance_name = s.instance_name
ORDER BY OBJECT_NAME;



-- Cleanup tables
DROP TABLE #perf_counters_init;
DROP TABLE #perf_counters_second;


SELECT ((CAST(value_in_use AS DEC(24,4))/1024)/4) * 300 MinimumPLE
FROM master.sys.configurations 
WHERE name = 'max server memory (MB)' ;
