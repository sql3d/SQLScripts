-- This will search all tables in a database and search for all instance of a column name

-- Define database
USE total_rewards
GO

SELECT c.TABLE_NAME,
TABLE_TYPE,
COLUMN_NAME,
ORDINAL_POSITION,
IS_NULLABLE,
DATA_TYPE,
NUMERIC_PRECISION
FROM INFORMATION_SCHEMA.COLUMNS c
JOIN INFORMATION_SCHEMA.TABLES t ON c.TABLE_NAME = t.TABLE_NAME
WHERE COLUMN_NAME ='orderid'  					-- Define column to look for here
ORDER BY TABLE_TYPE ,c.TABLE_NAME