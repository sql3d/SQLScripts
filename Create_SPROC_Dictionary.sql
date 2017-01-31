USE QA
GO

select rt.specific_name, ISNULL(parameter_name,''),
	CASE 
		WHEN par.DATA_TYPE IS NULL THEN ''
		WHEN par.DATA_TYPE = 'decimal' then 'DEC'
		WHEN par.DATA_TYPE = 'nvarchar' then 'NVC'
		WHEN par.DATA_TYPE = 'float' then 'FLT'
		WHEN par.DATA_TYPE = 'int' then 'INT'
		WHEN par.DATA_TYPE = 'smallint' then 'SINT'
		WHEN par.DATA_TYPE = 'datetime' then 'DT'
		WHEN par.DATA_TYPE = 'varchar' then 'VC'
		WHEN par.DATA_TYPE = 'smalldatetime' then 'SDT'
		WHEN par.DATA_TYPE = 'char' then 'CHR'
		WHEN par.DATA_TYPE = 'bit' then 'BIT'
		WHEN par.DATA_TYPE = 'tinyint' then 'TINT'
		WHEN par.DATA_TYPE = 'text' then 'TXT'
		ELSE par.DATA_TYPE
	END +
	CASE 
		WHEN par.CHARACTER_MAXIMUM_LENGTH IS NULL THEN ''
		ELSE ' (' + CAST(par.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10)) + ')'
	END AS [TYPE],
	CASE 
		WHEN PARAMETER_MODE IS NULL THEN ''
		WHEN PARAMETER_MODE = 'IN' THEN 'INPUT'
		WHEN PARAMETER_MODE = 'OUT' THEN 'OUTPUT'
		ELSE 'IN/OUT'
	END AS PARAMETER_TYPE
FROM INFORMATION_SCHEMA.routines as rt
	left join INFORMATION_SCHEMA.parameters as par on par.specific_name = rt.specific_name
where left(rt.specific_name,2) <> 'dt'
order by rt.specific_name, ordinal_position

