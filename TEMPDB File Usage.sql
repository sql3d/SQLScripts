USE master
GO

SELECT 'TempDB File Usage'
      ,SUM(ddfsu.total_page_count) * 8 / 1024 AS TotalMB
      ,SUM(ddfsu.allocated_extent_page_count) * 8 / 1024 AS AllocatedMB
      ,((SUM(ddfsu.allocated_extent_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100 AS PCTAllocated
      ,SUM(ddfsu.unallocated_extent_page_count) * 8 / 1024 AS UnAllocatedMB
      ,((SUM(ddfsu.unallocated_extent_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTUnAllocated
      ,SUM(ddfsu.version_store_reserved_page_count) * 8 / 1024 AS VersionStoreMB
      ,((SUM(ddfsu.version_store_reserved_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTVersionStore
      ,SUM(ddfsu.user_object_reserved_page_count) * 8 / 1024 AS UserObjectsMB
      ,((SUM(ddfsu.user_object_reserved_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS  PCTUserObjects
      ,SUM(ddfsu.internal_object_reserved_page_count) * 8 / 1024 AS InternalObjectsMB
      ,((SUM(ddfsu.internal_object_reserved_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTInternalObjects
      ,SUM(ddfsu.mixed_extent_page_count) * 8 / 1024 AS MixedExtentsMB
      ,((SUM(ddfsu.mixed_extent_page_count) * 1.0) / SUM(ddfsu.total_page_count)) * 100  AS PCTMixedExtents
FROM tempdb.sys.dm_db_file_space_usage ddfsu;
