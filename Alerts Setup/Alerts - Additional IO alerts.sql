USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'825 - Read-Retry Error', 
		@message_id=825, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1
GO

EXEC msdb.dbo.sp_add_notification @alert_name=N'825 - Read-Retry Error', 
	@operator_name=N'!CCI SAN - IT BI On Call', 
	@notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'823 - Hard I/O Error', 
		@message_id=823, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'823 - Hard I/O Error', 
	@operator_name=N'!CCI SAN - IT BI On Call', 
	@notification_method = 1
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'824 - Soft I/O Error', 
		@message_id=824, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'824 - Soft I/O Error', 
	@operator_name=N'!CCI SAN - IT BI On Call', 
	@notification_method = 1
GO
