
SELECT 
      DISCOCOUNT
     ,geography::STPointFromText('POINT(' + CAST([Longitude] AS VARCHAR(10)) + ' ' + CAST([Latitude] AS VARCHAR(10)) + ')', 4326)
	  ,'POINT(' + CAST([Longitude] AS VARCHAR(10)) + ' ' + CAST([Latitude] AS VARCHAR(10)) + ')'
	  ,latitude
    ,longitude	 
      ,[MONTH]
      ,[YEAR]
FROM
OPENQUERY(DSAN,
'
SELECT 
     count(account_number) discoCount
    ,latitude
    ,longitude
    ,MONTH
    ,YEAR
FROM
    SALES_METRICS.SALES_DISCO_DOWN_WO
WHERE
    MONTH = 3
    AND YEAR = 2013
    AND DISCO_REASON_BUCKET_CHILD = ''CONTROLLABLE - Competitive''
    AND CHANGE_TYPE = ''Disconnect''
    and TRIM(latitude) is not null
GROUP BY
    latitude
    ,longitude
    ,MONTH
    ,YEAR
')
 