;
WITH	cte
    AS (
    --gets the RDL; note the double convert.
		  SELECT	[path], [name] AS Report_Name,
				    CONVERT(XML, CONVERT(VARBINARY(MAX), content)) AS rdl
		  FROM		reportserver.dbo.catalog
		  WHERE Type = 2
	   )
SELECT	
	   LEFT([Path], LEN([path]) - CHARINDEX('/',REVERSE([Path])) + 1) AS Report_Path
	   ,Report_Name
	   ,T1.N.value('@Name', 'nvarchar(128)') AS DataSetName
	   ,T2.N.value('(*:DataSourceName/text())[1]', 'nvarchar(128)') AS DataSourceName
	   ,ISNULL(T2.N.value('(*:CommandType/text())[1]', 'nvarchar(128)'), 'T-SQL') AS CommandType
	   ,T2.N.value('(*:CommandText/text())[1]', 'nvarchar(max)') AS CommandText
FROM	cte AS T
    CROSS APPLY T.rdl.nodes('/*:Report/*:DataSets/*:DataSet') AS T1 (N)
    CROSS APPLY T1.N.nodes('*:Query') AS T2 (N)
WHERE T2.N.value('(*:CommandText/text())[1]', 'nvarchar(max)') NOT LIKE '%COX_DATA_CLASSIFICATION_PKG%'
ORDER BY Report_Path, Report_Name, DataSetName, DataSourceName, CommandType, CommandText

