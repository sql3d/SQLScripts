SELECT 
	s.name AS SchemaName
	,t.name AS TableName
	,c.name AS ColumnName
	,CASE
		WHEN st.name IN ('INT', 'TINYINT', 'SMALLINT', 'BIGINT', 'DATETIME', 'BIT', 'FLOAT', 'REAL', 'DATE', 
						'TIME', 'TIMESTAMP', 'SMALLDATETIME', 'UNIQUEIDENTIFIER', 'HIERARCHYID' ,'MONEY', 'SMALLMONEY') THEN UPPER(st.name)
		WHEN st.collationid IS NOT NULL THEN UPPER(st.name) + '(' + CAST(st.length AS VARCHAR(4)) + ')'
		WHEN st.name IN ('DATETIME2') THEN UPPER(st.name) + '(' + CAST(st.length AS VARCHAR(4)) + ')'
		ELSE UPPER(st.name) + '(' + CAST(st.xprec AS VARCHAR(4)) + ',' + CAST(st.xscale AS VARCHAR(4)) + ')'
	END AS DataType
	,CASE c.is_nullable 
		WHEN 0 THEN ''
		ELSE 'Yes'
	END AS IsNullable
	,COALESCE(dc.definition, '') AS DefaultValue
	,CASE
		WHEN ic.index_id IS NULL THEN ''
		ELSE 'Yes'
	END AS PrimaryKey
	,CASE
		WHEN fk.parent_object_id IS NULL THEN ''
		ELSE 'Yes'
	END AS ForeignKey
	,COALESCE(fks.name + '.' + ft.name, '') AS ForeignKeyTable
FROM sys.tables AS t
	INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
	INNER JOIN sys.columns AS c ON c.object_id = t.object_id
	INNER JOIN sys.systypes AS st ON  st.xtype = c.user_type_id
	LEFT JOIN sys.default_constraints AS dc ON dc.parent_column_id = c.column_id
		AND dc.parent_object_id = c.object_id
	LEFT JOIN sys.indexes AS i ON i.object_id = t.object_id
		AND i.is_primary_key = 1
	LEFT JOIN sys.index_columns AS ic ON i.index_id = ic.index_id
		AND i.object_id = ic.object_id
		AND c.column_id = ic.column_id
	LEFT JOIN sys.foreign_key_columns AS fk
	   ON fk.parent_object_id = c.object_id
		 AND fk.parent_column_id = c.column_id	
	LEFT OUTER JOIN sys.tables AS ft
	   ON fk.referenced_object_id = ft.object_id
	LEFT JOIN sys.schemas AS fks ON ft.schema_id = fks.schema_id	 
WHERE
    (t.name NOT IN ('sysdiagrams', 'DataDictionary'))
    AND (st.name NOT LIKE '%sysname%')
ORDER BY s.name, t.name, c.column_id
