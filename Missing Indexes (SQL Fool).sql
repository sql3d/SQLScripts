SELECT t.name AS 'affected_table'
    , 'Create NonClustered Index IX_' + t.name + '_missing_' 
        + CAST(ddmid.index_handle AS VARCHAR(10))
        + ' On ' + ddmid.STATEMENT 
        + ' (' + IsNull(ddmid.equality_columns,'') 
        + CASE WHEN ddmid.equality_columns IS Not Null 
            And ddmid.inequality_columns IS Not Null THEN ',' 
                ELSE '' END 
        + IsNull(ddmid.inequality_columns, '')
        + ')' 
        + IsNull(' Include (' + ddmid.included_columns + ');', ';'
        ) AS sql_statement
    , ddmigs.user_seeks
    , ddmigs.user_scans
    , CAST((ddmigs.user_seeks + ddmigs.user_scans) 
        * ddmigs.avg_user_impact AS BIGINT) AS 'est_impact'
    , ddmigs.last_user_seek
FROM sys.dm_db_missing_index_groups AS ddmig
INNER Join sys.dm_db_missing_index_group_stats AS ddmigs
    ON ddmigs.group_handle = ddmig.index_group_handle
INNER Join sys.dm_db_missing_index_details AS ddmid 
    ON ddmig.index_handle = ddmid.index_handle
INNER Join sys.tables AS t
    ON ddmid.OBJECT_ID = t.OBJECT_ID
WHERE ddmid.database_id = DB_ID()
    And CAST((ddmigs.user_seeks + ddmigs.user_scans) 
        * ddmigs.avg_user_impact AS BIGINT) > 100
ORDER BY CAST((ddmigs.user_seeks + ddmigs.user_scans) 
    * ddmigs.avg_user_impact AS BIGINT) DESC;
    
    
