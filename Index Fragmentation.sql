SELECT
      db.name AS databaseName
    , ps.OBJECT_ID AS objectID
    , ps.index_id AS indexID
    , ps.partition_number AS partitionNumber
    , ps.avg_fragmentation_in_percent AS fragmentation
    , ps.page_count
FROM sys.databases db
  INNER JOIN sys.dm_db_index_physical_stats (NULL, NULL, NULL , NULL, N'Limited') ps
      ON db.database_id = ps.database_id
WHERE ps.index_id > 0 
   AND ps.page_count > 100 
   AND ps.avg_fragmentation_in_percent > 30
	and db.state = 0
OPTION (MaxDop 1);

