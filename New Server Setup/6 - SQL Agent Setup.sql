/*
This modifies the SQL Agent to add the DBA group distro as an operator.
Changes the Job History to allow 250,000 records and 1,000 records per job.
Use the AdminProfile databaes mail profile
Set the DBA group distro as the failsafe operator

Developer: Dan Denney
Date: 2015-10-14
*/
USE [msdb]
GO

EXEC msdb.dbo.sp_add_operator @name=N'FSD AppDev DBAs', 
		@enabled=1, 
		@email_address=N'CCIATL-FieldSolutionDeliveryAppsDatabaseSolutions@cox.com', 
		@category_name=N'[Uncategorized]'
GO

EXEC msdb.dbo.sp_set_sqlagent_properties 
    @email_save_in_sent_folder=1, 
    @databasemail_profile=N'AdminProfile', 
    @use_databasemail=1,
    @jobhistory_max_rows=250000, 
    @jobhistory_max_rows_per_job=1000;
GO

EXEC master.dbo.sp_MSsetalertinfo 
    @failsafeoperator=N'FSD AppDev DBAs', 
	@notificationmethod=1;
GO