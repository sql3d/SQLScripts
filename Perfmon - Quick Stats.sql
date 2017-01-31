

declare @tmpStats table (counter_name varchar(100), value int);

insert into @tmpStats (counter_name, value)
select counter_name, cntr_value
from sys.dm_os_performance_counters
where 1=1
	and  object_name IN ('SQLServer:SQL Statistics'
						,'SQLServer:Buffer Manager'
						,'SQLServer:General Statistics'
						,'SQLServer:Databases')
	and counter_name IN ('Batch Requests/sec',
						'SQL Compilations/sec',
						'SQL Re-Compilations/sec'
						,'Page Life Expectancy'
						,'User Connections');
						
waitfor	delay '00:00:01';

select dmv.counter_name
	,value = 
		case 
			WHEN dmv.CNTR_Type = 65792 THEN dmv.cntr_value
			ELSE dmv.cntr_value - tmp.value
		End	
	--,origValue = tmp.value
	--,newValue = dmv.cntr_value
from sys.dm_os_performance_counters	dmv
	inner join @tmpStats tmp on dmv.counter_name = tmp.counter_name	
where 1=1
	and dmv.object_name IN ('SQLServer:SQL Statistics'
						,'SQLServer:Buffer Manager'
						,'SQLServer:General Statistics'
						,'SQLServer:Databases')
	and dmv.counter_name IN ('Batch Requests/sec',
						'SQL Compilations/sec',
						'SQL Re-Compilations/sec'
						,'Page Life Expectancy'
						,'User Connections');	
                     
                     
/*
select *
from sys.dm_os_performance_Counters
where object_name IN ('SQLServer:SQL Statistics'
						,'SQLServer:Buffer Manager')
*/