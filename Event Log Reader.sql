DECLARE @Errorlog TABLE (LogDate datetime, ProcessorInfo VARCHAR (100),ErrorMSG VARCHAR(2000))

INSERT INTO @Errorlog

EXEC sp_executesql N'xp_readerrorlog'


select *
from @Errorlog
WHERE ErrorMSG NOT LIKE '%corp\a1orionapm%' 
    AND ErrorMSG NOT LIKE 'Error: 18456, Severity: 14, State: 6.'
ORDER BY LogDate DESC