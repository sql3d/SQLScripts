SELECT
   t.name AS Table_Name
   ,i.name AS Index_Name
   ,i.type_desc AS Index_Type
   ,STATS_DATE(i.object_id,i.index_id) AS Date_Updated
FROM
   sys.indexes i JOIN
   sys.tables t ON t.object_id = i.object_id
WHERE
   i.type > 0
ORDER BY
   t.name ASC
   ,i.type_desc ASC
   ,i.name ASC

--In SQL Server 2000, a similar query can be run.

SELECT
   o.name AS Table_Name
   ,i.name AS Index_Name
   ,STATS_DATE(o.id,i.indid) AS Date_Updated
FROM
   sysobjects o JOIN
   sysindexes i ON i.id = o.id
WHERE
   xtype = 'U' AND
   i.name IS NOT NULL
ORDER BY
   o.name ASC
   ,i.name ASC