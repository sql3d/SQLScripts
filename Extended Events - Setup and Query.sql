-- set up XE

CREATE EVENT SESSION long_duration_statements
ON SERVER

ADD EVENT sqlserver.sql_statement_completed
(	ACTION
	(
		sqlserver.tsql_stack,
		sqlserver.sql_text
	)
	WHERE
	(
		sqlserver.session_id > 50
		AND duration > 5000000
	)
)

ADD TARGET package0.ring_buffer
	( SET MAX_MEMORY = 1024 )
	
WITH (MAX_DISPATCH_LATENCY = 15 SECONDS)

ALTER EVENT SESSION [long_duration_statements]
ON SERVER 
STATE = START


ALTER EVENT SESSION [long_duration_statements]
on server
add target package0.asynchronous_file_target
(	set filename = 'C:\long_duration_statements.xel',
		metadatafile = 'C:\long_duration_statements.mta' )
		
		
alter event session [long_duration_statements]
on server 
state = stop	

alter event session [long_duration_statements]
on server
with (max_dispatch_Latency = 5 seconds)

alter event session [long_duration_statements]
on server
state = start


-- Query Ring_Buffer
SELECT event_data.value('(@timestamp)[1]', 'DATETIME')           AS event_timestamp
	   ,event_data.value('(data[1]/value)[1]', 'VARCHAR(100)')   AS database_id
	   ,event_data.value('(data[2]/value)[1]', 'VARCHAR(100)')   AS object_id
	   ,event_data.value('(data[3]/value)[1]', 'VARCHAR(100)')   AS object_type
	   ,event_data.value('(data[4]/value)[1]', 'VARCHAR(100)')   AS cpu
	   ,event_data.value('(data[5]/value)[1]', 'VARCHAR(100)')   AS duration
	   ,event_data.value('(data[6]/value)[1]', 'VARCHAR(100)')   AS reads
	   ,event_data.value('(action[1]/value)[1]', 'VARCHAR(100)') AS tsql_stack
	   ,event_data.value('(action[2]/value)[1]', 'VARCHAR(100)') AS sql_text
FROM   (SELECT Cast(target_data AS XML) AS target_data
		FROM   sys.dm_xe_sessions AS s
			   JOIN sys.dm_xe_session_targets AS t ON s.address = t.event_session_address
		WHERE  s.name = 'long_duration_statements'
		   AND t.target_name = 'ring_buffer') AS tab
	   CROSS APPLY target_data.nodes('//RingBufferTarget/event') AS tgtNodes(event_data) 
	   
	   


-- QUERY Asynchronous_File_Target
-- sys.fn_xe_file_target_read_file (path, metadatapath, initial_filename, initial_offset)
DECLARE @filename VARCHAR(128) = 'C:\long_duration_statements*.xel'
DECLARE @metafilename VARCHAR(128) = 'C:\long_duration_statements*.mta'

IF Object_id('tempdb..#File_Data') IS NOT NULL
DROP TABLE #File_Data

SELECT CONVERT(XML, event_data) AS event_data
INTO   #File_Data
FROM   sys.Fn_xe_file_target_read_file(@filename, @metafilename, NULL, NULL)

SELECT event_data.value('(/event/@timestamp)[1]', 'DATETIME')           AS event_timestamp
   ,event_data.value('(/event/data[1]/value)[1]', 'VARCHAR(100)')   AS database_id
   ,event_data.value('(/event/data[2]/value)[1]', 'VARCHAR(100)')   AS object_id
   ,event_data.value('(/event/data[3]/value)[1]', 'VARCHAR(100)')   AS object_type
   ,event_data.value('(/event/data[4]/value)[1]', 'VARCHAR(100)')   AS cpu
   ,event_data.value('(/event/data[5]/value)[1]', 'VARCHAR(100)')   AS duration
   ,event_data.value('(/event/data[6]/value)[1]', 'VARCHAR(100)')   AS reads
   ,event_data.value('(/event/action[1]/value)[1]', 'VARCHAR(100)') AS tsql_stack
   ,event_data.value('(/event/action[2]/value)[1]', 'VARCHAR(100)') AS sql_text
FROM   #File_Data 



drop event session [long_duration_statements]
on server