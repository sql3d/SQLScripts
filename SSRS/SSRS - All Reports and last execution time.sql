use calReportServer
go

SELECT c.Description 
	,c.[Path] AS ReportPath	 
	, c.Name AS ReportName
	,	CASE
			WHEN Type = 2 THEN 'Report'
			WHEN Type = 4 THEN 'Linked'
			when TYPE= 1 then 'Folder'
		END AS ReportType
	, MAX(el.TimeStart) AS LastExecuted
	, STUFF(
		(SELECT ',' + cds.Name	
			FROM [Catalog] cds
				INNER JOIN DataSource ds ON ds.Link = cds.ItemID
			WHERE ds.ItemID = c.ItemID
			ORDER BY cds.name
			FOR XML Path ('')
		), 1, 1, '') AS DataSources
	--,	CASE
	--		WHEN MAX(s.LastRunTime) IS NULL THEN 0
	--		ELSE 1
	--	END AS Subscription
	--, MAX(s.LastRunTime) as LastSubscriptionRun
	,(select username
		  from ExecutionLogStorage els2
		  where els2.LogEntryId = MAX(el.LogEntryId)) username
FROM [Catalog] c 
	LEFT JOIN ExecutionLogStorage el ON el.ReportID = c.ItemID
	LEFT JOIN Subscriptions s on s.Report_OID = c.ItemID
WHERE Type IN (2,4,1)
GROUP BY c.[path], c.name, c.ItemID, c.[Type], c.Description
ORDER BY c.[path];