--
-- open transactions
--
select count(*) as [Trans]
from sys.dm_tran_session_transactions tst
	join sys.dm_tran_active_transactions tat on tat.transaction_id = tst.transaction_id
	join sys.dm_tran_database_transactions tdt on tst.transaction_id = tdt.transaction_id
	join sys.dm_exec_sessions dess on dess.session_id = tst.session_id
where tst.session_id > 50;