SELECT p1.id waiting_thread,
    p1.user waiting_user,
    p1.host waiting_host,
    it1.trx_query waiting_query,
    ilw.requesting_engine_transaction_id waiting_transaction,
    ilw.blocking_engine_lock_id blocking_lock,
    il.lock_mode blocking_mode,
    il.lock_type blocking_type,
    ilw.blocking_engine_transaction_id blocking_transaction,
    CASE it.trx_state
        WHEN 'LOCK WAIT'
        THEN it.trx_state
        ELSE p.state end blocker_state,
    concat(il.object_schema,'.', il.object_name) as locked_table,
    it.trx_mysql_thread_id blocker_thread,
    p.user blocker_user,
    p.host blocker_host,
    p.info blocker_query
FROM performance_schema.data_lock_waits ilw
	JOIN performance_schema.data_locks il
		ON ilw.blocking_engine_lock_id = il.engine_lock_id
			AND ilw.blocking_engine_transaction_id = il.engine_transaction_id
	JOIN information_schema.innodb_trx it
		ON ilw.blocking_engine_transaction_id = it.trx_id 
	join information_schema.processlist p
		ON it.trx_mysql_thread_id = p.id 
	join information_schema.innodb_trx it1
		ON ilw.requesting_engine_transaction_id = it1.trx_id 
	join information_schema.processlist p1
		ON it1.trx_mysql_thread_id = p1.id