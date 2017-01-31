
USE [DBA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[udfCheckForPrimaryAGReplica] (@AGName sysname)
RETURNS BIT
AS
    BEGIN
        DECLARE @IsPrimary BIT;

        SELECT @IsPrimary = 
            CASE
                WHEN ars.role_desc = 'PRIMARY' THEN 1
                ELSE 0
            END 
        FROM sys.dm_hadr_availability_replica_states ars
            INNER JOIN sys.availability_groups ag
                ON ars.group_id = ag.group_id
        WHERE ag.name = @AGName
            AND ars.is_local = 1;

        RETURN @IsPrimary;
    END
GO




IF DBA.dbo.udfCheckForPrimaryAGReplica('BIDAvailabilityGroup') = 1
    PRINT 1
ELSE
    RAISERROR('This is not the primary replica - exiting with success.',0,0);

