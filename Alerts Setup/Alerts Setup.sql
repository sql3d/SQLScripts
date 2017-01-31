USE [msdb]
GO

--/****** Object:  Operator [!CCI SAN - IT BI On Call]   ******/
--EXEC msdb.dbo.sp_add_operator @name=N'!CCI SAN - IT BI On Call', 
--		@enabled=1, 
--		@weekday_pager_start_time=90000, 
--		@weekday_pager_end_time=180000, 
--		@saturday_pager_start_time=90000, 
--		@saturday_pager_end_time=180000, 
--		@sunday_pager_start_time=90000, 
--		@sunday_pager_end_time=180000, 
--		@pager_days=0, 
--		@email_address=N'ccisan-itbioncall@cox.com', 
--		@category_name=N'[Uncategorized]'
--GO

--/****** Object:  Operator [CCI SAN CCC - SQL Notification]   ******/
--EXEC msdb.dbo.sp_add_operator @name=N'CCI SAN CCC - SQL Notification', 
--		@enabled=1, 
--		@weekday_pager_start_time=90000, 
--		@weekday_pager_end_time=180000, 
--		@saturday_pager_start_time=90000, 
--		@saturday_pager_end_time=180000, 
--		@sunday_pager_start_time=90000, 
--		@sunday_pager_end_time=180000, 
--		@pager_days=0, 
--		@email_address=N'ccisanccc-sqlnotification@cox.com', 
--		@category_name=N'[Uncategorized]'
--GO


/****** Object:  Alert [Deadlocks]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Deadlocks', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Locks|Number of Deadlocks/sec|_Total|>|5', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Deadlocks', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


/****** Object:  Alert [Disk Space Full]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Disk Space Full', 
		@message_id=1101, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Disk Space Full', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


/****** Object:  Alert [Fatal Error]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Fatal Error', 
		@message_id=0, 
		@severity=25, 
		@enabled=1, 
		@delay_between_responses=120, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO



/****** Object:  Alert [Fatal Error in Current Process]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Fatal Error in Current Process', 
		@message_id=0, 
		@severity=20, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO


/****** Object:  Alert [Fatal Error In Database Processes]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Fatal Error In Database Processes', 
		@message_id=0, 
		@severity=21, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO


/****** Object:  Alert [Fatal Error In Resources]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Fatal Error In Resources', 
		@message_id=0, 
		@severity=19, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO



/****** Object:  Alert [Fatal Error: Database Integrity Suspect]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Fatal Error: Database Integrity Suspect', 
		@message_id=0, 
		@severity=23, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Fatal Error: Database Integrity Suspect', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


/****** Object:  Alert [Fatal Error: Hardware Error]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Fatal Error: Hardware Error', 
		@message_id=0, 
		@severity=24, 
		@enabled=1, 
		@delay_between_responses=60, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Fatal Error: Hardware Error', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


/****** Object:  Alert [Fatal Error: Table Integrity Suspect]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Fatal Error: Table Integrity Suspect', 
		@message_id=0, 
		@severity=22, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Fatal Error: Table Integrity Suspect', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


/****** Object:  Alert [Full MSDB Log]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Full Transaction Log', 
		@message_id=9002, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Full MSDB Log', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


--/****** Object:  Alert [Full TEMPDB Log]    ******/
--EXEC msdb.dbo.sp_add_alert @name=N'Full TEMPDB Log', 
--		@message_id=9002, 
--		@severity=0, 
--		@enabled=1, 
--		@delay_between_responses=600, 
--		@include_event_description_in=1, 
--		@database_name=N'tempdb', 
--		@category_name=N'[Uncategorized]', 
--		@job_id=N'00000000-0000-0000-0000-000000000000'
--GO
--EXEC msdb.dbo.sp_add_notification @alert_name=N'Full TEMPDB Log', 
--	@operator_name=N'!CCI SAN - IT BI On Call', @notification_method =1
--go


/****** Object:  Alert [Insufficient Resources]    ******/
EXEC msdb.dbo.sp_add_alert @name=N'Insufficient Resources', 
		@message_id=0, 
		@severity=17, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'Insufficient Resources', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


/****** Object:  Alert [823 - Hard I/O Error]    Script Date: 07/08/2011 12:07:08 ******/
EXEC msdb.dbo.sp_add_alert @name=N'823 - Hard I/O Error', 
		@message_id=823, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'823 - Hard I/O Error', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go

/****** Object:  Alert [824 - Soft I/O Error]    Script Date: 07/08/2011 12:07:08 ******/
EXEC msdb.dbo.sp_add_alert @name=N'824 - Soft I/O Error', 
		@message_id=824, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=600, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'824 - Soft I/O Error', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go


/****** Object:  Alert [825 - Read-Retry Error]    Script Date: 07/08/2011 12:07:08 ******/
EXEC msdb.dbo.sp_add_alert @name=N'825 - Read-Retry Error', 
		@message_id=825, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=300, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'825 - Read-Retry Error', 
	@operator_name=N'Database Solutions DBAs', @notification_method =1
go