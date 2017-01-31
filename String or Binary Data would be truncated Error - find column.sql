
/* SELECT query into #tmp Table first*/




-- Then run the following query:
;WITH CTE_Dev AS (
SELECT C.column_id ,
        ColumnName= C.name ,
        C.max_length ,
        C.user_type_id ,
        C.precision ,
        C.scale ,
        DataTypeName = T.name
FROM sys.columns C
    INNER JOIN sys.types T ON T.user_type_id=C.user_type_id
WHERE OBJECT_ID = OBJECT_ID('YourTableNameGoesHere')    ---- !!!! Change this to the table you are trying to INSERT INTO
),
CTE_Temp AS (
SELECT C.column_id ,
        ColumnName= C.name ,
        C.max_length ,
        C.user_type_id ,
        C.precision ,
        C.scale ,
        DataTypeName = T.name
FROM tempdb.sys.columns C
    INNER JOIN tempdb.sys.types T ON T.user_type_id=C.user_type_id
    INNER JOIN tempdb.sys.objects O ON o.object_id=c.object_id
WHERE O.name = '#tmp'
)
SELECT * 
FROM CTE_Dev D
    FULL OUTER JOIN CTE_Temp T ON D.ColumnName= T.ColumnName
WHERE ISNULL(D.max_length,0) < ISNULL(T.max_length,999);