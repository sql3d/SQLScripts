USE coxDSS
GO

/*
{CALL [sp_MSdel_dboORG_WORDDPF] (333,37993167,'30001',1,'D',16150909)}
{CALL [sp_MSdel_dboORG_WORDMPF] (37993539)}
{CALL [sp_MSdel_dboORG_WORDMPF] (37993490)}
{CALL [sp_MSdel_dboORG_WORDMPF] (37993300)}
*/

DECLARE @WDNROV INT = 333
        ,@WDWO# INT = 37993490
        ,@WONUM INT = 37993300
        ,@WDSRC VARCHAR = '30001'
        ,@WDSYSN INT = 1
        ,@WDCEK6 VARCHAR = 'D'
        ,@WDCNBR INT = 16150909
        
SELECT TOP 1 * 
FROM dbo.org_wordmpf
WHERE wonum = @WONUM

BEGIN TRAN
    INSERT INTO dbo.org_wordmpf (wonrov, wonum)
    VALUES (@WDNROV,@WONUM)
   
    SELECT TOP 1 * 
    FROM dbo.org_wordmpf
    WHERE wonum = @WONUM;


 --     COMMIT
 --     rollback
