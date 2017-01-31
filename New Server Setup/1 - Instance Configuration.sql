/*
Instance Configuration script

Please make sure to change values for max server memory (MB) and min server memory (MB) 
and then uncomment before running.

Developer: Dan Denney
Date: 2015-10-14
*/

EXEC sys.sp_configure 
    @configname = 'show advanced options'
   ,@configvalue = 1;
GO

RECONFIGURE;
GO

EXEC sys.sp_configure
    @configname = 'backup compression default'
   ,@configvalue = 1;
GO

EXEC sys.sp_configure
    @configname = 'backup checksum default'
   ,@configvalue = 1;
GO

EXEC sys.sp_configure 
    @configname = 'cost threshold for parallelism'
   ,@configvalue = 50;
GO

EXEC sys.sp_configure
    @configname = 'Database Mail XPs'
   ,@configvalue = 1;
GO

EXEC sys.sp_configure
    @configname = 'max degree of parallelism'
   ,@configvalue = 8;
GO

--EXEC sys.sp_configure
--    @configname = 'max server memory (MB)'
--   ,@configvalue = 250000;
--GO

--EXEC sys.sp_configure
--    @configname = 'min server memory (MB)'
--   ,@configvalue = 64000;
--GO

EXEC sys.sp_configure
    @configname = 'optimize for ad hoc workloads'
   ,@configvalue = 1;
GO


EXEC sys.sp_configure
    @configname = 'remote admin connections'
   ,@configvalue = 1;
GO

RECONFIGURE;
GO
