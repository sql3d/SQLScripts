

/*
EXEC sys.sp_addextendedproperty 
    @name=N'MS_Description',   -- Property Name
    @value=N'Foreign key for Product' , -- Description to add
    @level0type=N'SCHEMA',  -- Leave as is
    @level0name=N'iTac',	   -- Name of Schema
    @level1type=N'TABLE',   -- Leave as is
    @level1name=N'AUD_trProblem',  -- Name of Table
    @level2type=N'COLUMN',  -- Leave as is 
    @level2name=N'ProductId' -- Name of column
GO
*/

-- TABLE LEVEL Description
SELECT s.name AS schemaName, o.name AS tableName
    ,CAST('EXEC sys.sp_addextendedproperty @name=N''MS_Description'', 
        @value=N''' + t.name + ''', 
        @level0type=N''SCHEMA'', 
        @level0name=N''' + s.name + ''', 
        @level1type=N''TABLE'', 
        @level1name=N''' + o.name + '''
      ' AS VARCHAR(MAX)) AS ExtendedProperty      
FROM sys.tables t
    INNER JOIN sys.objects AS o ON o.object_id = t.object_id
    INNER JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    LEFT JOIN sys.extended_properties ep ON t.object_id = ep.major_id
        AND ep.minor_id = 0
WHERE ep.value IS NULL
ORDER BY s.name, o.name;
GO

IF OBJECT_ID('Split_On_Upper_Case') IS NOT NULL
    DROP FUNCTION dbo.Split_On_Upper_Case;
GO

Create Function dbo.Split_On_Upper_Case(@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^ ][A-Z]%'
    While PatIndex(@KeepValues collate Latin1_General_Bin, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues collate Latin1_General_Bin, @Temp) + 1, 0, ' ')

    Return @Temp
END
GO
-- COLUMN LEVEL Description
SELECT s.name AS schemaName, o.name AS tableName, c.name AS columnName--, * 
    ,'EXEC sys.sp_addextendedproperty @name=N''Documentation'', 
    @value=N''' +
	   CASE
		  WHEN i.is_primary_key = 1 THEN 'Primary Key'
		  WHEN fk.parent_column_id IS NOT NULL THEN 'Foreign Key to ' + s2.name + '.' + o2.[name]  + '.' + c2.[name] 
		  WHEN c.name = 'IsActive' THEN 'Active if True'
		  ELSE dbo.Split_On_Upper_Case(c.name) 
	   END + ''',
    @level0type=N''SCHEMA'', 
    @level0name=N''' + s.name + ''', 
    @level1type=N''TABLE'', 
    @level1name=N''' + o.name + ''',  
    @level2type=N''COLUMN'', 
    @level2name=N''' + c.name + ''';' AS ExtendedProperty
    --,s2.name + '.' + o2.[name]  + '.' + c2.[name] 
FROM sys.columns AS c
    INNER JOIN sys.objects AS o ON o.object_id = c.object_id
    INNER JOIN sys.schemas AS s ON s.schema_id = o.schema_id
     LEFT JOIN sys.index_columns ic 
		  INNER JOIN sys.indexes i ON ic.object_id = i.object_id 
			 AND ic.index_id = i.index_id
			 AND i.is_primary_key = 1
	   ON c.object_id = ic.object_id 
		  AND c.column_id = ic.column_id
    LEFT JOIN sys.foreign_key_columns fk ON o.object_id = fk.parent_object_id
	   AND c.column_id = fk.parent_column_id 
    LEFT JOIN sys.objects AS o2 ON o2.object_id = fk.referenced_object_id
    LEFT JOIN sys.columns AS c2 ON c2.column_id = fk.referenced_column_id
	   AND c2.object_id = fk.referenced_object_id
    LEFT JOIN sys.schemas AS s2 ON s2.schema_id = o2.schema_id
    LEFT OUTER JOIN sys.extended_properties AS epc ON epc.major_id = c.object_id
		 AND epc.minor_id = c.column_id
WHERE o.type = 'U'
    AND epc.value IS NULL
    AND o.name IN 
        (
            'ApprovalQueue'
            ,'ApprovalQueueCriteria'
            ,'ApprovalQueueCriteriaValue'
            ,'ApprovalQueueSystemModuleGroup'
            ,'ComparisonOperators'
            ,'Criteria'
            ,'CriteriaComparisonOperator'
        )
ORDER BY s.name, o.name, c.name;
GO

DROP FUNCTION dbo.Split_On_Upper_Case;
GO