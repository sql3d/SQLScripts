--This will script out all the replication procedures, so that you can re-run on the subscriber, should they disapear.


USE Flash_SD  -- Database experiencing problem
GO
EXEC sp_scriptpublicationcustomprocs @publication='FlashSD Reporting Tables' -- Publication name experiencing problem
