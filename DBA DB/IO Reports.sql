
use DBA
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*----------------------------------------------------
Calculating the percentage of I/O by Drive
----------------------------------------------------*/
create proc [sp_IO_per_Drive]

as
	set nocount on ;
		
	With g as
	(select db_name(mf.database_id) as database_name, mf.physical_name, 
			left(mf.physical_name, 1) as drive_letter, 
			vfs.num_of_writes, 
			vfs.num_of_bytes_written as BYTESWRITTEN, 
			vfs.io_stall_write_ms, 
			mf.type_desc, vfs.num_of_reads, vfs.num_of_bytes_read, vfs.io_stall_read_ms,
			vfs.io_stall, vfs.size_on_disk_bytes
		from sys.master_files mf
			join sys.dm_io_virtual_file_stats(NULL, NULL) vfs
				on mf.database_id=vfs.database_id and mf.file_id=vfs.file_id
		--order by vfs.num_of_bytes_written desc)
	)
	select database_name,drive_letter, 
			physical_name, 
			BYTESWRITTEN,
			Percentage = RTRIM(CONVERT(DECIMAL(5,2),
			BYTESWRITTEN*100.0/(SELECT SUM(BYTESWRITTEN) FROM g))) --where drive_letter='R')))
			+ '%'
		from g --where drive_letter='R'
		order by BYTESWRITTEN desc
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------
Calculating the Percentage of I/O for Each Database
---------------------------------------------------*/
create proc [sp_IO_per_Database]

as
	set nocount on;
		
	WITH Agg_IO_Stats
	AS
	(
	  SELECT
		DB_NAME(database_id) AS database_name,
		sum(num_of_bytes_read) as num_of_bytes_read,
		sum(num_of_bytes_written) as num_of_bytes_written,
		CAST(SUM(num_of_bytes_read + num_of_bytes_written) / 1048576.
			 AS DECIMAL(12, 2)) AS io_in_mb
	  FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS DM_IO_Stats
	  GROUP BY database_id
	)
	SELECT
	  ROW_NUMBER() OVER(ORDER BY io_in_mb DESC) AS row_num,
	  database_name,
	  io_in_mb,
	  CAST(io_in_mb / SUM(io_in_mb) OVER() * 100
		   AS DECIMAL(5, 2)) AS pct
	FROM Agg_IO_Stats
	ORDER BY row_num;
GO



