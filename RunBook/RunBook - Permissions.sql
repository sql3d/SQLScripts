/*
Permissions needed for RunBook.
Use the SQL Agent service account the Runbook job will run under.
*/

USE [master]
GO
CREATE LOGIN [UBOC-AD\svc_car_dm_sqlagnt_d] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO

CREATE USER [UBOC-AD\svc_car_dm_sqlagnt_d] FOR LOGIN [UBOC-AD\svc_car_dm_sqlagnt_d]
GO

ALTER ROLE [db_datareader] ADD MEMBER [UBOC-AD\svc_car_dm_sqlagnt_d]
GO

GRANT VIEW SERVER STATE TO [UBOC-AD\svc_car_dm_sqlagnt_d]
GO


USE [msdb]
GO
CREATE USER [UBOC-AD\svc_car_dm_sqlagnt_d] FOR LOGIN [UBOC-AD\svc_car_dm_sqlagnt_d]
GO

ALTER ROLE [db_datareader] ADD MEMBER [UBOC-AD\svc_car_dm_sqlagnt_d]
GO

GRANT EXECUTE ON [dbo].[agent_datetime] TO [UBOC-AD\svc_car_dm_sqlagnt_d]
GO
