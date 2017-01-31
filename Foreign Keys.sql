SELECT  SCHEMA_NAME(fk.schema_id) AS FKSchema ,
        fk.name AS FK ,
        SCHEMA_NAME(p.schema_id) AS ReferrerSchema ,
        p.name AS Referrer ,
        STUFF(CAST(( SELECT ',' + c.name
                     FROM   sys.foreign_key_columns fkc
                            JOIN sys.columns c ON fkc.parent_object_id = c.object_id
                                                  AND fkc.parent_column_id = c.column_id
                     WHERE  fkc.constraint_object_id = fk.object_id
                     ORDER BY fkc.constraint_column_id ASC
                   FOR
                     XML PATH('') ,
                         TYPE
                   ) AS NVARCHAR(MAX)), 1, 1, '') AS ReferrerColumns ,
        SCHEMA_NAME(r.schema_id) AS ReferencedSchema ,
        r.name AS Referenced ,
        STUFF(CAST(( SELECT ',' + c.name
                     FROM   sys.foreign_key_columns fkc
                            JOIN sys.columns c ON fkc.referenced_object_id = c.object_id
                                                  AND fkc.referenced_column_id = c.column_id
                     WHERE  fkc.constraint_object_id = fk.object_id
                     ORDER BY fkc.constraint_column_id ASC
                   FOR
                     XML PATH('') ,
                         TYPE
                   ) AS NVARCHAR(MAX)), 1, 1, '') AS ReferencedColumns ,
        fk.delete_referential_action_desc AS deleteAction ,
        fk.update_referential_action_desc AS updateAction ,
        fk.object_id AS FKId ,
        p.object_id AS ReferrerId ,
        r.object_id AS ReferencedId
FROM    sys.foreign_keys fk
        JOIN sys.tables p ON p.object_id = fk.parent_object_id
        JOIN sys.tables r ON r.object_id = fk.referenced_object_id
        
        
SELECT  SCHEMA_NAME(fk.schema_id) AS FKSchema ,
        fk.name AS FK ,
        SCHEMA_NAME(p.schema_id) AS ReferrerSchema ,
        p.name AS Referrer ,
        pc.name AS ReferrerColumn ,
        SCHEMA_NAME(r.schema_id) AS ReferencedSchema ,
        r.name AS Referenced,
        rc.name AS ReferencedColumn ,
        fk.object_id AS FKId ,
        fkc.constraint_column_id AS FKColumnId ,
        p.object_id AS ReferrerId ,
        r.object_id AS ReferencedId
FROM    sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
        JOIN sys.tables p ON p.object_id = fk.parent_object_id
        JOIN sys.columns pc ON fkc.parent_object_id = pc.object_id
                               AND fkc.parent_column_id = pc.column_id
        JOIN sys.tables r ON r.object_id = fk.referenced_object_id
        JOIN sys.columns rc ON fkc.referenced_object_id = rc.object_id
                               AND fkc.referenced_column_id = rc.column_id        