/* Increase the length of text returned in queries from default 64k */
SET @sys.statement_truncate_len := 1024 ;

/* Current queries and connections */
SELECT * 
FROM INFORMATION_SCHEMA.PROCESSLIST 
-- where command <> 'Sleep'
ORDER BY TIME DESC;


-- CALL mysql.rds_kill(8675352);


/* MySQL version and Aurora version */
select @@version, @@aurora_version;

set transaction isolation level read uncommitted;

/* Blocked queries - similar to sp_whoisactive */
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
		ON it1.trx_mysql_thread_id = p1.id;


/* More information on the below queries can be found here: https://github.com/mysql/mysql-sys/tree/master/views/p_s  */

/* Sessions without system sessions */
SELECT * 
FROM sys.session 
ORDER BY time DESC;

/* Table locks */
SELECT * 
FROM sys.schema_table_lock_waits;  

/* Queries with Errors */
SELECT * 
FROM sys.statements_with_errors_or_warnings 
WHERE last_seen > '2024-02-01'
	and exec_count > 100
ORDER BY error_pct DESC LIMIT 10;

/* Slow queries */
SELECT * 
FROM sys.statements_with_runtimes_in_95th_percentile;

/* Execution times for types of statements/users */
SELECT * 
FROM sys.user_summary_by_statement_type;


/* Find tables with most table scans */
SELECT * 
FROM sys.schema_tables_with_full_table_scans 
LIMIT 10;

/* Wait Types - Average */
SELECT * 
FROM sys.wait_classes_global_by_avg_latency 
WHERE event_class != 'idle';

/* Wait Types - Global */
SELECT * 
FROM sys.wait_classes_global_by_latency;

/* Query Analyzer view - ordered by Total_Latency */
SELECT * 
FROM sys.statement_analysis 
LIMIT 10;

/* Indexes - Redundant Indexes */  
SELECT * 
FROM sys.schema_redundant_indexes;

/* Indexes - Unused Indexes */
SELECT * 
FROM sys.schema_unused_indexes;


/* Find text in Stored Procedures */
SELECT * 
FROM information_schema.routines 
WHERE routine_definition LIKE '%BOM_BATCH_CONTROL%'
LIMIT 10;