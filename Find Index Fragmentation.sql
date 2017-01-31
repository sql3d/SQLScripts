SELECT d.name, ps.database_id,
	t.name,	
	ps.index_id, 
	b.name,
	b.type_desc,
	ps.page_count,
	ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ps
	INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID
		AND ps.index_id = b.index_id
	INNER JOIN sys.databases d on d.database_id = ps.database_id
	INNER JOIN sys.tables t on t.object_id = ps.object_id
WHERE ps.database_id = DB_ID()
	and avg_fragmentation_in_percent >= 30
	AND ps.index_id > 0 -- ignore heaps
    AND ps.page_count > 8 
    AND ps.index_level = 0 -- leaf-level nodes only, 
ORDER BY t.name, b.name
OPTION (MAXDOP 2);

GO
