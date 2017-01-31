SELECT DISTINCT
       t.sp_name
     , t.TypeDesc
	 , SUM(t.lines_of_code) OVER (PARTITION BY t.sp_name, t.TypeDesc) AS LinesOfCode
	 , SUM(t.lines_of_code) OVER () AS TotalLinesOfCode
FROM
    (
        SELECT
               o.name AS sp_name
             , LEN(c.text) - LEN(REPLACE(c.text, CHAR(10), '')) AS lines_of_code
             , CASE
                   WHEN o.xtype = 'P'
                       THEN 'Stored Procedure'
                   WHEN o.xtype IN ( 'FN', 'IF', 'TF' )
                       THEN 'Function'
               END AS TypeDesc
        FROM
            sysobjects AS o
            INNER JOIN syscomments AS c
                ON c.id = o.id
        WHERE  o.xtype IN
            ( 'P', 'FN', 'IF', 'TF' )
               AND o.category = 0
               AND o.name NOT IN
            ( 'fn_diagramobjects', 'sp_alterdiagram', 'sp_creatediagram', 'sp_dropdiagram', 'sp_helpdiagramdefinition', 'sp_helpdiagrams',
				'sp_renamediagram', 'sp_upgraddiagrams', 'sysdiagrams' )
    ) AS t
ORDER BY 3 DESC;