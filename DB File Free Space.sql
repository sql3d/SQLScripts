
create table #tmp (dbName varchar(100), filesize dec(18,2), spaceused dec(18,2), freespace dec(18,2));

EXEC sp_MSForEachdb 
	@command1 = 'use [?];
	
insert into #tmp
select 
      name
    --, filename
    , convert(decimal(12,2),round(a.size/128.000,2)) as FileSizeMB
    , convert(decimal(12,2),round(fileproperty(a.name,''SpaceUsed'')/128.000,2)) as SpaceUsedMB
    , convert(decimal(12,2),round((a.size-fileproperty(a.name,''SpaceUsed''))/128.000,2)) as FreeSpaceMB
from dbo.sysfiles a
where groupid = 1'

--drop table #tmp
SELECT *, ROUND(CAST(freespace / FileSize AS DEC(12,8)),2) AS FreePCT
FROM #tmp AS t
ORDER BY t.dbName


