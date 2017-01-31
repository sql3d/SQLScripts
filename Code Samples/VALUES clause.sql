
SELECT
    T.name AS                 [Table Name]
  , T.create_date AS          [Create Date]
  , T.modify_date AS          [Modified Date]
  , P.rows AS                 [Row Count]
  , IUS.last_system_update AS [Last User Write]
  , [Last User Read] =
		(
			SELECT TOP 1
				LastUserRead
			FROM
				(VALUES
					(
					IUS.last_user_scan
					),
					(
					IUS.last_user_lookup
					),
					(
					IUS.last_user_seek
					)) AS dt(LastUserRead)
			ORDER BY
				LastUserRead DESC
		)
FROM
    sys.tables AS T
    INNER JOIN sys.partitions AS P
        ON P.object_id = T.object_id
           AND P.index_id IN ( 0, 1 )
    LEFT JOIN sys.dm_db_index_usage_stats AS IUS
        ON IUS.object_id = T.object_id
           AND IUS.index_id IN ( 0, 1 )
WHERE OBJECTPROPERTYEX(T.object_id, 'isusertable') = 1
      AND ( T.name LIKE '%[_]bak%'
            OR T.Name LIKE '%[_][0-9]%' )
      AND T.modify_date < DATEADD(year, -1, GETDATE())
ORDER BY
    T.name;

/*
From: http://www.sqlsoldier.com/wp/sqlserver/return-max-or-min-value-of-a-group-of-columns-as-a-single-column
*/