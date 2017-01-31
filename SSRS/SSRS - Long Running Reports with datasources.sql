USE coxReports
go


SELECT c.Path
    ,c.Name
    --,ExecutionLog.UserName
    ,COUNT(*) NumberOfTimesRun
    ,MAX(DATEDIFF(mi,TimeStart,TimeEnd)) MAXRunMinutes
    ,AVG(DATEDIFF(mi,TimeStart,TimeEnd)) AVGRunMinutes
    --,MAX(ExecutionLog.Parameters) Params
    ,MAX(el.TimeStart) LastStart
    ,MAX(el.TimeEnd) LastEnd
    ,MAX(el.TimeDataRetrieval) RetrievalMax
    ,MAX(el.TimeProcessing) ProcessingMax
    ,MAX(el.TimeRendering) MaxRendering
    ,MAX(el.Status) Status
    ,MAX(el.ByteCount) ByteCount
    ,MAX(el.[RowCount]) MaxRows
    ,el.RequestType
    ,STUFF((
		  SELECT ', ' + dsc.PATH
		  FROM dbo.DataSource ds
			 INNER JOIN dbo.Catalog dsc ON ds.link = dsc.ItemID
		  WHERE ds.ItemID = c.itemid
		  FOR XML PATH('')
	   ),1,1,'') AS DataSource
FROM dbo.ExecutionLog as el
    INNER JOIN dbo.Catalog AS  c  ON el.ReportID = c.ItemID
--WHERE c.ItemID IN
--    (SELECT ds.ItemID
--	   FROM dbo.DataSource AS ds
--		  INNER JOIN dbo.Catalog AS dsc ON ds.link = dsc.ItemID   
--	   WHERE dsc.path LIKE '%PSTAGE%')
GROUP BY c.Path
    ,c.Name
    ,c.ItemID
    --,ExecutionLog.UserName
    ,el.RequestType
HAVING MAX(DATEDIFF(mi,TimeStart,TimeEnd)) > 3     
ORDER BY MAX(TimeDataRetrieval) + MAX(TimeProcessing) DESC
