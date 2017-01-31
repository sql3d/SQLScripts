

--select MIN(timestart) --*
--from ExecutionLogstorage


--select Path, name
--from Catalog
--where type = 2
--	and Path not in
--		(select distinct ReportPath
--			from ExecutionLog2)
			

--select * -- path, name
--from Catalog
--where TYPE = 2
--	and ItemID not in
--		(select ReportID
--			from ExecutionLogStorage)


--select distinct c.itemid, c.path
--from Catalog c
--	left join ExecutionLogStorage es on es.ReportID = c.ItemID
--where c.Type = 2
--	and TimeStart is null
--order by c.path


--F4FAC913-AB38-4D5F-8D80-D728D263B516

select *
from Catalog
where tYPE = 5
and Name = 'dsAdventureWorks'

select *
from Catalog where Name = 'Test_datasource'



select *
from DataSource ds
	inner join Catalog c on ds.ItemID = c.ItemID
where link = 'F899F607-65C9-4816-B04E-31CEE600FF80'
or ds.ItemID = 'FC479743-298B-4B3E-843C-C0F5FB503A4E'



-- THIS SCRIPT WILL REMOVE A SHARED DATASOURCE FROM A DEPLOYED REPORT
update DataSource
	set Link = null
where ItemID = 'FC479743-298B-4B3E-843C-C0F5FB503A4E'
