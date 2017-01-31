

DECLARE @SPWHO TABLE
    (
     SPID INT
    ,[Status] VARCHAR(500)
    ,[Login] VARCHAR(500)
    ,Hostname VARCHAR(500)
    ,BlockedBy VARCHAR(500)
    ,DBName VARCHAR(128)
    ,Command VARCHAR(500)
    ,CPUTime INT
    ,DiskIO INT
    ,LastBatch VARCHAR(500)
    ,ProgramName VARCHAR(500)
    ,SPID1 INT
    ,Requestid INT
    );

INSERT INTO @SPWHO
    EXEC master.dbo.sp_who2;

SELECT *
FROM @SPWHO spwho
WHERE spwho.SPID > 49
   -- AND spwho.Hostname = ''
   -- AND spwho.Login = ''
    AND spwho.DBName = 'QEDataMax_PEN'
;