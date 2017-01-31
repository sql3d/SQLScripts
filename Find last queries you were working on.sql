

SELECT  dest.text
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
WHERE   deqs.last_execution_time > '5/19/2011 11:00'
        AND dest.text LIKE 'WITH%';