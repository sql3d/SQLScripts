/*
You will need to heavily modify this file depending on what currently exists
and where the files live!

Developer: Dan Denney
Date: 2015-10-14
*/

USE [master]
GO

/*Alter existing data files*/
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev2', SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev3', SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev4', SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO

/*Add new data files*/
ALTER DATABASE [tempdb] 
    ADD FILE ( NAME = N'tempdev5', FILENAME = N'M:\MP_DB205_Data1\DATA\tempdb5.ndf' , 
    SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] 
    ADD FILE ( NAME = N'tempdev6', FILENAME = N'M:\MP_DB205_Data1\DATA\tempdb6.ndf' , 
    SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev7', 
    FILENAME = N'M:\MP_DB205_Data1\DATA\tempdb7.ndf' , 
    SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev8', 
    FILENAME = N'M:\MP_DB205_Data1\DATA\tempdb8.ndf' , 
    SIZE = 4194304KB , FILEGROWTH = 524288KB )
GO

/*Alter existing log file*/
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', 
    SIZE = 1048576KB , FILEGROWTH = 262144KB )
GO