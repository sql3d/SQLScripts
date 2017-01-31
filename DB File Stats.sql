/*
DATABASE FILE STATS
Parameters:

database_id – key of the database, retrieved from sys.databases
file_id - key of a file in a database. Can be retrieved from sys.database_files if you are working in the context of a database, or sys.master_files will give you all files in all databases
Columns:

database_id, file_id – same as the parameter descriptions
sample_ms – the number of milliseconds that have passed since the values for sys.dm_io_virtual_file_stats were reset the only way to reset the values is to restart the server.
num_of_reads – number of individual read operations that were issued to the file. Note that this is physical reads, not logical reads. Logical reads would not be registered.
num_of_bytes_read – the number of bytes that were read, as opposed to the number of reads. The size of a read is not a constant value that can be calculated by the number of reads.
Io_stall_read_ms – total time user processes waited for IO. Note that this number can be much greater than the sample_ms. If 10 processes are trying to use the file simultaneously, but the disk is only able to server 1, then you might get 9 seconds waiting over a 10 second time period.
num_of_writes , num_of_bytes_written, io_stall_write_ms - the same as the read values, except for writes.
io_stall – sum of io_stall_write_ms and io_stall_read_ms
size_on_disk_bytes – the size of the file in bytes
file_handle – the Windows file handle of the file (Books Online)
*/

declare @start datetime, @end datetime

SELECT @start = create_date 
FROM sys.databases
WHERE name = 'tempdb'; 

set @end = getdate();

print @start

select db_name(mf.database_id) as databaseName, 
	case
		when mf.physical_name like '%MDF' then 'Data'
		when mf.physical_name like '%NDF' then 'Data'
		else 'Log'
	end as FileType, 
	num_of_reads, num_of_bytes_read, 
	num_of_reads / datediff(hh, @start, @end) as avg_reads_per_Hour,
	(num_of_bytes_read) / num_of_reads as avg_bytes_per_read,
	io_stall_read_ms, 
	num_of_writes, num_of_bytes_written, 
	num_of_writes / datediff(hh, @start, @end) as avg_writes_per_Hour,	
	CASE
	   WHEN num_of_writes = 0 THEN 0
	   ELSE num_of_bytes_written / num_of_writes
     END as avg_bytes_per_write,
	io_stall_write_ms, io_stall, size_on_disk_bytes,
	mf.physical_name
from sys.dm_io_virtual_file_stats(null,null) as divfs
         join sys.master_files as mf
              on mf.database_id = divfs.database_id
                 and mf.file_id = divfs.file_id
where 1=1
    --and mf.[type] = 1
    --and db_name(mf.database_id) Like '%orion%'
order by db_name(mf.database_id), FileType, mf.physical_name--num_of_reads desc
--order by avg_reads_per_hour desc
--order by size_on_disk_bytes desc

/*
-- Find Write Stalls over 20ms
select db_name(mf.database_id) as databaseName, mf.physical_name, 
	io_stall_write_ms / num_of_writes io_stall
from sys.dm_io_virtual_file_stats(null,null) as divfs
         join sys.master_files as mf
              on mf.database_id = divfs.database_id
                 and mf.file_id = divfs.file_id
where 1=1
	--and mf.[type] = 0   
	and num_of_writes > 0
	and ( io_stall_write_ms / ( 1.0 + num_of_writes ) ) > 20 
order by io_stall desc;

*/
	
/*	
-- Find Read Stalls over 100ms
select db_name(mf.database_id) as databaseName, mf.physical_name, 
	io_stall_read_ms / num_of_reads
from sys.dm_io_virtual_file_stats(null,null) as divfs
         join sys.master_files as mf
              on mf.database_id = divfs.database_id
                 and mf.file_id = divfs.file_id
where 1=1
	--and mf.[type] = 0   
	and  ( io_stall_read_ms / ( 1.0 + num_of_reads ) ) > 100 ;

*/	


