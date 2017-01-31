select
       db_name ( resource_database_id ) as [Database Name] ,
       count (*) as [Sessions] FROM sys . dm_tran_locks
where resource_type = 'DATABASE'
and db_name ( resource_database_id ) = 'YourDatabaseName'
group by db_name ( resource_database_id )
order by db_name ( resource_database_id )