-- Find all indexes in a database

-- define database
use total_rewards
go

SELECT OBJECT_NAME ( si.id ) AS TableName ,
CASE indid WHEN 1 THEN 'Clustered'
ELSE 'NonClustered'
END TypeOfIndex,
si.[name] AS IndexName
FROM sysindexes si
JOIN sysobjects so ON si.id =so.id
WHERE xtype ='U'
AND indid < 255
ORDER BY TableName,indid