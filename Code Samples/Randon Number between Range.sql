DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT

SET @Lower = 1 ---- The lowest random number
SET @Upper = 999 ---- The highest random number
SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
SELECT @Random