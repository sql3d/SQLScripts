
-- Author: Kristina Chiara
-- Reporting Services production meta data is located on CORG0DB11
-- Script queries for specific keywords within embedded RDL SQL

WITH XMLNAMESPACES
(
'http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition' AS REP
)

SELECT
	c.Path,
	c.Name,
	DataSetXML.value('@Name','varchar(MAX)') DataSourceName,
	DataSetXML.value('REP:Query[1]/REP:CommandText[1]','varchar(MAX)') CommandText
FROM
	(SELECT
		ItemID,
		CAST(CAST(Content AS varbinary(max)) AS xml) ReportXML
	 FROM
		reportserver.dbo.Catalog
	 WHERE
		Type = 2
	) ReportXML
CROSS APPLY ReportXML.nodes('//REP:DataSet') DataSetXML (DataSetXML)
INNER JOIN ReportServer.dbo.Catalog c
ON ReportXML.ItemID = c.ItemID

WHERE (DataSetXML.value('REP:Query[1]/REP:CommandText[1]','varchar(MAX)')) LIKE '%spDisco_SRO_QA_Errors%' -- Change this to search for specific keyword



