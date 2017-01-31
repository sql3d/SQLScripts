

select
iv.table_name,
i.name as index_name,
iv.seeks + iv.scans + iv.lookups as total_accesses,
iv.seeks,
iv.scans,
iv.lookups
from
(select
i.object_id,
object_name(i.object_id) as table_name,
i.index_id,
sum(i.user_seeks) as seeks,
sum(i.user_scans) as scans,
sum(i.user_lookups) as lookups
from
sys.tables t
inner join sys.dm_db_index_usage_stats i
on t.object_id = i.object_id
group by
i.object_id,
i.index_id) as iv
inner join sys.indexes i
on iv.object_id = i.object_id
and iv.index_id = i.index_id
order by total_accesses desc

