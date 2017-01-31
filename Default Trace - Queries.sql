/*  THIS SECTION READS THE ENTIRE DEFAULT TRACE FILE */
DECLARE   @filename nvarchar(1000);
 
-- Get the name of the current default trace
SELECT   @filename = cast(value as nvarchar(1000))
FROM   ::fn_trace_getinfo(default)
WHERE   traceid = 1 and   property = 2;
 
-- view current trace file
SELECT   *
FROM   ::fn_trace_gettable(@filename, default) AS ftg 
    INNER   JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id  
WHERE starttime > '2015-03-24'
    AND ftg.TextData LIKE '%RESTORE%'
ORDER BY   ftg.StartTime
  
  
  
  
/*  THIS SECTION GETS SCHEMA CHANGES */
DECLARE   @filename nvarchar(1000);
 
-- Get the name of the current default trace
SELECT   @filename = cast(value as nvarchar(1000))
FROM   ::fn_trace_getinfo(default)
WHERE   traceid = 1 and   property = 2;
 
-- view current trace file
SELECT   *
FROM   ::fn_trace_gettable(@filename, default) AS ftg 
INNER   JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id  
WHERE (ftg.EventClass = 46 or ftg.EventClass = 47)
and   DatabaseName <> 'tempdb' 
and   EventSubClass = 0
ORDER   BY ftg.StartTime;  




/*  THIS SECTION GETS AUTOGROWTH EVENTS  */
DECLARE   @filename nvarchar(1000);
 
-- Get the name of the current default trace
SELECT   @filename = cast(value as nvarchar(1000))
FROM   ::fn_trace_getinfo(default)
WHERE   traceid = 1 and   property = 2;
 
-- Find auto growth events in the current trace file
SELECT
    ftg.StartTime
 ,te.name as EventName
 ,DB_NAME(ftg.databaseid) AS DatabaseName  
 ,ftg.Filename
 ,(ftg.IntegerData*8)/1024.0 AS GrowthMB 
 ,(ftg.duration/1000)as DurMS
FROM   ::fn_trace_gettable(@filename, default) AS ftg 
INNER   JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id  
WHERE (ftg.EventClass = 92  -- Date File Auto-grow
      OR ftg.EventClass   = 93) -- Log File Auto-grow
ORDER BY   ftg.StartTime





/* THIS SECTION GETS SECURITY CHANGES */
DECLARE   @filename nvarchar(1000);
 
-- Get the name of the current default trace
SELECT   @filename = cast(value as nvarchar(1000))
FROM   ::fn_trace_getinfo(default)
WHERE   traceid = 1 and   property = 2;
 
-- process all trace files
SELECT   *  
FROM   ::fn_trace_gettable(@filename, default) AS ftg 
INNER   JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id  
WHERE   ftg.EventClass 
      in (102,103,104,105,106,108,109,110,111)
  ORDER BY   ftg.StartTime