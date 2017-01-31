-- run these queries on the TARGET server (not the server that has the Linked Server setup)

SELECT
	trace_event_id AS Trace_Event_ID
	, e.name AS Event_Description
FROM ::fn_trace_geteventinfo(1) t
    JOIN sys.trace_events e ON t.eventID = e.trace_event_id
GROUP BY trace_event_id, e.name

DECLARE @filename VARCHAR(255)
SELECT @FileName = SUBSTRING(path, 0, LEN(path)-CHARINDEX('\' , REVERSE(path))+1) + '\Log.trc'
FROM sys.traces
WHERE is_default = 1;  

--Check for failed DBCC events
SELECT	gt.HostName
		, gt.ApplicationName
		, gt.ServerName
		, gt.TEXTData
		, gt.LoginName
		, gt.spid
		, gt.StartTime
		, gt.Success
		, gt.EventClass
		, te.Name
FROM [fn_trace_gettable](@filename, DEFAULT) gt
	JOIN sys.trace_events te ON gt.EventClass = te.trace_event_id
WHERE EventClass = 116 --'Audit DBCC'
	AND gt.Success = 0 --Check for failures
	AND gt.TextData LIKE 'dbcc show_statistics(@qtbl, @statname) with stat_header join density_vector%'
ORDER BY StartTime;
GO