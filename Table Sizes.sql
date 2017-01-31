exec sp_spaceused 'qa_workorders'


create table #tmp_Size (table_name varchar(100), rows int, reserved varchar(100), data varchar(100), 
	index_size varchar(100), unused varchar(100))

insert #tmp_Size
exec sp_MSforeachtable @command1="exec sp_spaceused '?'"


select *
from #tmp_size
order by cast(left(data, len(data) - 2) as int) desc