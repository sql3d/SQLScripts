USE [master];
GO

EXEC master.dbo.sp_addlinkedserver
    @server = N'PSTAGE'
  , @srvproduct = N'PSTAGE.WORLD'
  , @provider = N'OraOLEDB.Oracle'
  , @datasrc = N'PSTAGE.WORLD';

/* For security reasons the linked server remote logins password is changed with ######## */

EXEC master.dbo.sp_addlinkedsrvlogin
    @rmtsrvname = N'PSTAGE'
  , @useself = N'False'
  , @locallogin = NULL
  , @rmtuser = N'PHX_APPDEV_ETL'
  , @rmtpassword = '########';  -- UPDATE PASSWORD

GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'collation compatible'
  , @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'data access'
  , @optvalue = N'true';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'dist'
  , @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'pub'
  , @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'rpc'
  , @optvalue = N'true';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'rpc out'
  , @optvalue = N'true';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'sub'
  , @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'connect timeout'
  , @optvalue = N'0';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'collation name'
  , @optvalue = NULL;
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'lazy schema validation'
  , @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'query timeout'
  , @optvalue = N'0';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'use remote collation'
  , @optvalue = N'true';
GO

EXEC master.dbo.sp_serveroption
    @server = N'PSTAGE'
  , @optname = N'remote proc transaction promotion'
  , @optvalue = N'true';
GO