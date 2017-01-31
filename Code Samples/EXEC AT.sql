USE master
GO

SELECT *
FROM OPENQUERY(PSTAGE,
'SELECT *
FROM san_work_order_master
WHERE site_id = 541
    AND work_order_number = 76331822'
) oq





DECLARE @pSiteId INT = 541
        ,@pWorkOrderNumber INT = 76331822;

DECLARE @sql NVARCHAR(4000) 

SET @sql = 'SELECT * FROM san_work_order_master WHERE site_id = ? AND work_order_number = ?';

EXEC (@sql, @pSiteId, @pWorkOrderNumber) AT PSTAGE;