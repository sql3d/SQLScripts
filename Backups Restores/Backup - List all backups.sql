
select*
from msdb.dbo.backupset bs
	inner join msdb.dbo.backupfile bf on bs.backup_set_id = bf.backup_set_id
order by backup_finish_date desc