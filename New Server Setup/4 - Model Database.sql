/*
Alters default properties of the Model database, so that future databases created will inherit 
these properties

Developer: Dan Denney
Date: 2015-10-14
*/

USE [master];
GO
ALTER DATABASE [model] SET RECOVERY SIMPLE WITH NO_WAIT;
GO
ALTER DATABASE [model] MODIFY FILE ( NAME = N'modeldev', FILEGROWTH = 262144KB );
GO
ALTER DATABASE [model] MODIFY FILE ( NAME = N'modellog', FILEGROWTH = 262144KB );
GO

USE Model
GO

CREATE ROLE db_executor;
GO
GRANT EXECUTE TO db_executor;
GO

CREATE USER [CORP\CATL0FieldAppDevEngineerDev] FOR LOGIN [CORP\CATL0FieldAppDevEngineerDev]
GO

ALTER ROLE [db_datareader] ADD MEMBER [CORP\CATL0FieldAppDevEngineerDev]
GO
