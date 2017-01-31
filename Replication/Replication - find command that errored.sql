USE distribution;
GO

--EXEC sp_browsereplcmds 
--	@command_id = 721
--	,@publisher_database_id = 15
--	,@xact_seqno_start = 0x0058AC3000000864009D00000000
--	,@xact_seqno_end = 0x0058AC3000000864009D00000000



SELECT TOP 5 *
FROM dbo.MSrepl_errors AS mse WITH (NOLOCK)
WHERE mse.source_type_id = 1
ORDER BY id DESC;

DECLARE
    @PublisherDB sysname
   ,@PublisherDBID INT
   ,@SeqNo NCHAR(22)
   ,@CommandID INT;

	-- Set publisher database name and values from Replication Monitor
SET @PublisherDB = N'stage_pstage';
SET @SeqNo = N'0x007AD6F50000062800AF00000000';
SET @CommandID = 17;
 
-- Find the publisher database ID
SELECT @PublisherDBID = id
FROM dbo.MSpublisher_databases WITH (NOLOCK)
WHERE publisher_db = @PublisherDB;
 
-- Get the command
EXEC sp_browsereplcmds
    @xact_seqno_start = @SeqNo
   ,@xact_seqno_end = @SeqNo
   ,@command_id = @CommandID
   ,@publisher_database_id = @PublisherDBID;


    