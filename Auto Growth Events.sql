
SELECT te.name AS [trace_events_name] ,
t.DatabaseName ,
t.[FileName],
t.NTDomainName ,
t.ApplicationName ,
t.LoginName ,
t.Duration ,
t.StartTime ,
t.EndTime
FROM sys.fn_trace_gettable(CONVERT(VARCHAR(150), 
	   ( SELECT TOP 1 f.value 
		  FROM sys.fn_trace_getinfo(NULL) f 
		  WHERE f.property = 2 )
	   ), DEFAULT) T
    INNER JOIN sys.trace_events TE ON T.EventClass = TE.trace_event_id
WHERE te.trace_event_id IN (92,93)

/*
DECLARE @path NVARCHAR(260);

SELECT 
   @path = REVERSE(SUBSTRING(REVERSE([path]), 
   CHARINDEX('\', REVERSE([path])), 260)) + N'log.trc'
FROM    sys.traces
WHERE   is_default = 1;

SELECT 
   DatabaseName,
   [FileName],
   SPID,
   Duration,
   StartTime,
   EndTime,
   FileType = CASE EventClass 
       WHEN 92 THEN 'Data'
       WHEN 93 THEN 'Log'
   END
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE
   EventClass IN (92,93)
ORDER BY
   StartTime DESC;
*/

