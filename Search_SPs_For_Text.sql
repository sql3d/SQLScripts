-- This will search all stored procedures in a database
-- for an specific text


SELECT SPECIFIC_NAME,*
FROM INFORMATION_SCHEMA.ROUTINES
WHERE 1=1
--and ROUTINE_TYPE ='PROCEDURE'
AND ROUTINE_DEFINITION LIKE '%*=%'  --ESCAPE '!' --change text to look for here


SELECT [name]
FROM [dbo].[sysobjects] obj
INNER JOIN [dbo].[syscomments] cmt
ON obj.[id] = cmt.[id]
where cmt.[text] like '%*=%'