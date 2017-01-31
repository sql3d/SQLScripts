
SELECT Schema_name(tbl.schema_id) AS [Table_Schema]
	   ,tbl.name                  AS [Table_Name]
	   ,p.value
FROM   sys.tables AS tbl
	   INNER JOIN sys.extended_properties AS p ON p.major_id = tbl.object_id
												  AND p.minor_id = 0
												  AND p.class = 1
WHERE  p.name LIKE 'Documentation'
ORDER  BY [Table_Schema] ASC;




SELECT Schema_name(tbl.schema_id)		AS [Table_Schema]
	   ,tbl.name					AS [Table_Name]
	   ,clmns.name					AS [Column_Name]
	   ,CAST(p.value AS SQL_VARIANT)	AS [Value]
FROM   sys.tables AS tbl
	   INNER JOIN sys.all_columns AS clmns ON clmns.object_id = tbl.object_id
	   INNER JOIN sys.extended_properties AS p ON p.major_id = clmns.object_id
												  AND p.minor_id = clmns.column_id
												  AND p.class = 1
WHERE  p.name LIKE 'Documentation'
ORDER  BY [Table_Schema] ASC,[Table_Name] ASC,[Column_ID] ASC, clmns.name ASC ;

