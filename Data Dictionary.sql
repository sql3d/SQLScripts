SELECT DISTINCT
    schemas.name AS Schema_Nme
    ,t.name AS Table_Nme
   ,ept.value AS Table_Desc
   ,c.name AS Column_Nme
   ,st.name + '(' + CASE	WHEN c.max_length = -1 THEN 'max'
					ELSE CAST(c.max_length AS VARCHAR(100))
				END + ')' AS Column_Data_Type
   ,CASE WHEN c.is_nullable = 0 THEN 'False'
	    ELSE 'True'
    END AS Null_Allowed_Ind
   ,epc.value AS Column_Desc
   ,CASE WHEN dc.definition LIKE '(getdate())'
	    THEN 'Current Date'
	    ELSE dc.definition
    END AS Column_Default_Value
   ,CASE WHEN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PK.NAME,
								    'PK_', ''),
								    'PK2_', ''),
								    'PK3_', ''),
							   'PK4_', ''), 'PK5_',
						''), 'PK1_', '') = c.name
	    THEN 'Yes'
	    ELSE ''
    END AS Primary_Key_Ind
   ,CASE WHEN t.object_id = fk.parent_object_id
		    AND c.column_id = fk.parent_column_id
	    THEN 'Yes'
	    ELSE ''
    END AS Foriegn_Key_Ind
   ,CASE WHEN c.is_identity = 1 THEN 'Yes'
	    ELSE ''
    END AS Identity_Column_Ind
   ,ft.name AS Foreign_Table
   ,c.column_id
FROM
    sys.columns AS c
    INNER JOIN sys.systypes AS st
	   ON st.xtype = c.user_type_id
    LEFT OUTER JOIN sys.extended_properties AS epc
	   ON epc.major_id = c.object_id
		 AND epc.minor_id = c.column_id
    LEFT OUTER JOIN sys.default_constraints AS dc
	   ON dc.parent_column_id = c.column_id
		 AND dc.parent_object_id = c.object_id
    INNER JOIN sys.tables AS t
	   ON c.object_id = t.object_id
    LEFT OUTER JOIN sys.extended_properties AS ept
	   ON ept.major_id = t.object_id
		 AND ept.minor_id = t.parent_object_id
    LEFT OUTER JOIN sys.key_constraints AS pk
	   ON t.object_id = pk.parent_object_id
    LEFT OUTER JOIN sys.foreign_key_columns AS fk
	   ON fk.parent_object_id = c.object_id
		 AND fk.parent_column_id = c.column_id
    LEFT OUTER JOIN sys.tables AS ft
	   ON fk.referenced_object_id = ft.object_id
    LEFT OUTER JOIN sys.schemas AS schemas ON t.schema_id = schemas.schema_id
WHERE
    (t.name NOT IN ('sysdiagrams', 'DataDictionary'))
    AND (st.name NOT LIKE '%sysname%')
ORDER BY
    Schema_Nme
   ,Table_Nme
   ,c.column_id

