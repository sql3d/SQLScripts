/**************************************************************************************
*
*  BigTables.sql
*  Bill Graziano (SQLTeam.com)
*  graz@sqlteam.com
*  v1.1
*
**************************************************************************************/


--DBCC UPDATEUSAGE('aspectsqlserver') 

declare @id	int			
declare @type	character(2) 		
declare	@pages	int			
declare @dbname sysname
declare @dbsize dec(15,0)
declare @bytesperpage	dec(15,0)
declare @pagesperMB		dec(15,0)

create table #spt_space
(
	objid		int null,
	rows		int null,
	reserved	dec(15) null,
	data		dec(15) null,
	indexp		dec(15) null,
	unused		dec(15) null
)

set nocount on

-- Create a cursor to loop through the user tables
declare c_tables cursor for
	select	id
		from	sysobjects
		where	xtype = 'U'

open c_tables

fetch next from c_tables
into @id

while @@fetch_status = 0
begin

	/* Code from sp_spaceused */
	insert into #spt_space (objid, reserved)
		select objid = @id, sum(reserved)
			from sysindexes
				where indid in (0, 1, 255)
					and id = @id

	select @pages = sum(dpages)
			from sysindexes
				where indid < 2
					and id = @id

	select @pages = @pages + isnull(sum(used), 0)
		from sysindexes
			where indid = 255
				and id = @id

	update #spt_space
		set data = @pages
		where objid = @id


	/* index: sum(used) where indid in (0, 1, 255) - data */
	update #spt_space
		set indexp = (select sum(used)
				from sysindexes
				where indid in (0, 1, 255)
					and id = @id)
			    - data
		where objid = @id

	/* unused: sum(reserved) - sum(used) where indid in (0, 1, 255) */
	update #spt_space
		set unused = reserved
				- (select sum(used)
					from sysindexes
						where indid in (0, 1, 255)
						and id = @id)
		where objid = @id

	update #spt_space
		set rows = i.rows
			from sysindexes i
				where i.indid < 2
				and i.id = @id
				and objid = @id

	fetch next from c_tables
	into @id
end


select top 25
		Table_Name = (select left(name,25) from sysobjects where id = objid),
		rows = convert(char(11), rows),
		reserved_KB = ltrim(str(reserved * d.low / 1024.,15,0) + ' ' + 'KB'),
		data_KB = ltrim(str(data * d.low / 1024.,15,0) + ' ' + 'KB'),
		index_size_KB = ltrim(str(indexp * d.low / 1024.,15,0) + ' ' + 'KB'),
		case data
			when 0 then '100%'
			else ltrim(str(indexp*100 /data) + '%')
		end as idx_data_ratio,
		case reserved
			when 0 then '100%'
			else ltrim(str(unused * 100 /reserved) + '%')
		end as unused_pct
	from 	#spt_space, master.dbo.spt_values d
	where 	d.number = 1
		and 	d.type = 'E'
	order by reserved desc

drop table #spt_space
close c_tables
deallocate c_tables