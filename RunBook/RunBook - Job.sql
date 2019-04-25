USE [msdb]
GO

/****** Object:  Job [Run Book]    Script Date: 4/25/2019 11:55:06 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 4/25/2019 11:55:06 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Run Book', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PS - Query Servers]    Script Date: 4/25/2019 11:55:07 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PS - Query Servers', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'PowerShell', 
		@command=N'$RunBookInstance = "CHDC-CAR-THSQL2\DataMartDev"

$ServersQuery = "SELECT InstanceName FROM Sys_Admin.RunBook.DatabaseInstances WHERE IsActive = 1"
$LastCheckQuery = "SELECT TOP (1) CheckDateTime FROM Sys_Admin.RunBook.ServerCheckDates ORDER BY CheckDateTime DESC"
$Servers = Invoke-Sqlcmd -Query $ServersQuery -ServerInstance $RunBookInstance 
$LastCheck = Invoke-Sqlcmd -Query $LastCheckQuery -ServerInstance $RunBookInstance
[datetime]$LastCheckDate = Get-Date -Date $LastCheck.CheckDateTime -Format ''yyyy-MM-dd hh:mm:ss.fff''
[datetime]$CurrentCheckDate = Get-Date -Format ''yyyy-MM-dd HH:mm:ss.fff''

$RestartQuery = "SELECT create_date AS LastRestarted
    ,LEFT(@@VERSION, CHARINDEX(''('', @@VERSION) - 1) + CAST(SERVERPROPERTY (''edition'') AS varchar(50)) AS SQLEdition
    ,SERVERPROPERTY(''productversion'') AS SQLVersion
FROM sys.databases WHERE name = ''tempdb''"

$PrimaryReplicaQuery = "DECLARE @PrimaryReplica NVARCHAR(254)
    ,@Version NUMERIC(18,10) 
SET @Version = CAST(LEFT(CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max)),CHARINDEX(''.'',CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max))) - 1) + ''.'' + REPLACE(RIGHT(CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max))) - CHARINDEX(''.'',CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max)))),''.'','''') AS numeric(18,10))
    
IF @Version < 11  -- Below 2012;
    BEGIN
        SET @PrimaryReplica = NULL;
    END
ELSE
    BEGIN

        SELECT @PrimaryReplica = Primary_Replica
        FROM sys.dm_hadr_availability_group_states;

        IF @PrimaryReplica IS NOT NULL AND @PrimaryReplica = @@SERVERNAME
            SET @PrimaryReplica = 1;
        ELSE IF @PrimaryReplica IS NOT NULL AND @PrimaryReplica <> @@SERVERNAME
            SET @PrimaryReplica = 0;
        ELSE
         
            SET @PrimaryReplica = NULL;
    END
SELECT @PrimaryReplica AS PrimaryReplica;
"

$DatabaseHealthQuery = "SELECT name AS DatabaseName, state_desc AS DatabaseState FROM sys.databases WHERE state <> 0"

$FailedBackupsQuery = ";WITH cteBackups AS
(
    SELECT  
        DB_ID(bus.database_name) AS DatabaseId
        ,MAX(CASE WHEN bus.type = ''D'' THEN bus.Backup_Finish_Date END) AS LastFullBackup
        ,MAX(CASE WHEN bus.Type <> ''D'' THEN bus.Backup_Finish_Date END) AS LastDiffBackup
    FROM  msdb.dbo.backupset bus
    GROUP BY bus.Database_Name
)
SELECT d.name AS DatabaseName
        ,b.LastFullBackup
        ,b.LastDiffBackup
FROM sys.Databases d
    LEFT JOIN cteBackups b 
        ON d.database_id = b.DatabaseId
WHERE b.DatabaseId IS NULL
    AND d.database_id NOT IN (2,3)
    AND d.State = 0
    AND d.name NOT LIKE ''AdventureWorks%''
    AND d.name NOT LIKE ''x^_%'' ESCAPE ''^''
    OR (b.LastDiffBackup < ''$LastCheckDate''
        AND b.LastFullBackup < ''$LastCheckDate''
        );"

$AlertsQuery = ";WITH cteAlerts AS
(
    SELECT a.name AS AlertName
        ,a.message_id AS MessageId
        ,a.severity
        ,msdb.dbo.agent_datetime(a.last_occurrence_date, a.last_occurrence_time) AS AlertDateTime
    FROM msdb.dbo.sysalerts a
    WHERE a.last_occurrence_date > 0
	AND (a.Severity > 20
		OR a.Severity = 0)
)
SELECT ca.AlertName
        ,ca.MessageId
        ,ca.Severity
        ,ca.AlertDateTime
FROM cteAlerts ca
WHERE ca.AlertDateTime > ''$LastCheckDate'';"

$FailedJobsQuery = ";WITH cteFailedJobs AS 
(
    SELECT sjh.job_id
        ,MAX(msdb.dbo.agent_datetime(sjh.run_date, sjh.run_time)) AS RunDateTime
    FROM msdb.dbo.sysjobhistory sjh
    WHERE sjh.run_status NOT IN (1,4) -- Succeed, In Progress
        AND sjh.step_id <> 0
        AND sql_message_id <> 50000
    group by sjh.job_id   
),
cteSuccessAfter AS
(
    SELECT cfj.job_id
            ,cfj.RunDateTime
            ,COUNT(sjh.job_id) AS Success
    FROM cteFailedJobs cfj
        LEFT JOIN msdb.dbo.sysjobhistory sjh
            ON sjh.job_id = cfj.job_id
                AND msdb.dbo.agent_datetime(sjh.run_date, sjh.run_time) > cfj.RunDateTime
                AND sjh.run_status = 1 -- Succeed
                AND sjh.step_id = 0 
    GROUP BY cfj.job_id, cfj.RunDateTime
)
SELECT sj.name AS JobName
        ,csa.RunDateTime
        ,CASE 
            WHEN csa.Success > 0 THEN 1
            ELSE 0
        END AS RanSuccessfulAfter
FROM cteSuccessAfter csa
    inner join msdb.dbo.sysjobs sj
        ON sj.job_id = csa.job_id
WHERE RunDateTime > ''$LastCheckDate''"

$MemoryDumpQuery = "SELECT creation_time
FROM sys.dm_server_memory_dumps 
WHERE creation_time > ''$LastCheckDate''"


Foreach ($Server in $Servers) {
    $InstanceName = $Server.InstanceName
    $RestartTime  = Invoke-Sqlcmd -ServerInstance $InstanceName -Query $RestartQuery          
    [datetime]$rs = get-date -date $RestartTime.LastRestarted -Format ''yyyy-MM-dd HH:mm:ss.fff''
    $SQLEdition = $RestartTime.SQLEdition
    $SQLVersion = $RestartTime.SQLVersion
    $InstanceUpdate = "UPDATE Sys_Admin.RunBook.DatabaseInstances
        SET LastRestarted = ''$rs''
            ,LastCheckDateTime = ''$CurrentCheckDate''
            ,SQLEdition = ''$SQLEdition''
            ,SQLVersion = ''$SQLVersion''
    WHERE InstanceName = ''$InstanceName'';"
    Invoke-Sqlcmd -Query $InstanceUpdate -ServerInstance $RunBookInstance
    
    $PrimaryReplicas = Invoke-SqlCmd -ServerInstance $InstanceName -Query $PrimaryReplicaQuery
    $PrimaryReplica = $PrimaryReplicas.PrimaryReplica
    if ($PrimaryReplica -ne [System.DBNULL]::Value){
        $ReplicaUpdate = "UPDATE Sys_Admin.RunBook.DatabaseInstances
            SET IsCurrentPrimary = $PrimaryReplica
            WHERE InstanceName = ''$InstanceName'';"
        Invoke-SqlCmd -Query $ReplicaUpdate -ServerInstance $RunBookInstance
    }

    $DatabasesHealth = Invoke-Sqlcmd -ServerInstance $InstanceName -Query $DatabaseHealthQuery
    if ($DatabasesHealth.count -gt 0) {
        foreach ($DatabaseHealth in $DatabasesHealth) {
            $DBName = $DatabaseHealth.DatabaseName
            $DBState = $DatabaseHealth.DatabaseState
            $UnhealthyDatabaseInsert = "INSERT INTO Sys_Admin.RunBook.UnhealthyDatabases (InstanceName, DatabaseName, DatabaseState, CheckDateTime)
                VALUES (''$InstanceName'', ''$DBName'', ''$DBState'', ''$CurrentCheckDate'');"
            Invoke-Sqlcmd -Query $UnhealthyDatabaseInsert -ServerInstance $RunBookInstance                   
        }
    }

$FailedBackupsQuery = "DECLARE @SQL NVARCHAR(4000)
            ,@Version NUMERIC(18,10) 
    SET @Version = CAST(LEFT(CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max)),CHARINDEX(''.'',CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max))) - 1) + ''.'' + REPLACE(RIGHT(CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max))) - CHARINDEX(''.'',CAST(SERVERPROPERTY(''ProductVersion'') AS nvarchar(max)))),''.'','''') AS numeric(18,10))
    
    IF @Version < 11  -- Below 2012
        BEGIN
            SET @SQL = 
                ''WITH cteBackups AS
                (
                    SELECT  
                        DB_ID(bus.database_name) AS DatabaseId
                        ,MAX(CASE WHEN bus.type = ''''D'''' THEN bus.Backup_Finish_Date END) AS LastFullBackup
                        ,MAX(CASE WHEN bus.Type <> ''''D'''' THEN bus.Backup_Finish_Date END) AS LastDiffBackup
                    FROM  msdb.dbo.backupset bus
                    GROUP BY bus.Database_Name
                )
                SELECT d.name AS DatabaseName
                        ,b.LastFullBackup
                        ,b.LastDiffBackup
                FROM sys.Databases d
                    LEFT JOIN cteBackups b 
                        ON d.database_id = b.DatabaseId
                WHERE d.database_id NOT IN (2,3)
                    AND d.name NOT LIKE ''''AdventureWorks%''''
                    AND d.name NOT LIKE ''''x^_%'''' ESCAPE ''''^''''
                    AND (b.DatabaseId IS NULL
                        OR (b.LastDiffBackup < ''''$LastCheckDate''''
                            AND b.LastFullBackup < ''''$LastCheckDate''''
                            )
                        );''
        END
    ELSE    
        BEGIN
            SET @SQL = 
                ''WITH cteBackups AS
                    (
                        SELECT  
                            DB_ID(bus.database_name) AS DatabaseId
                            ,MAX(CASE WHEN bus.type = ''''D'''' THEN bus.Backup_Finish_Date END) AS LastFullBackup
                            ,MAX(CASE WHEN bus.Type <> ''''D'''' THEN bus.Backup_Finish_Date END) AS LastDiffBackup
                        FROM  msdb.dbo.backupset bus
                        GROUP BY bus.Database_Name
                    )
                    SELECT d.name AS DatabaseName
                            ,b.LastFullBackup
                            ,b.LastDiffBackup
                    FROM sys.Databases d
                        LEFT JOIN cteBackups b 
                            ON d.database_id = b.DatabaseId
                    WHERE d.database_id NOT IN (2,3)
                        AND d.name NOT LIKE ''''AdventureWorks%''''
                        AND d.name NOT LIKE ''''x^_%'''' ESCAPE ''''^''''
                        AND (d.group_database_id IS NULL
                                OR EXISTS
                                    (
                                        SELECT 1
                                        FROM sys.dm_hadr_availability_group_states States
                                            INNER JOIN master.sys.availability_groups Groups ON States.group_id = Groups.group_id
                                            INNER JOIN sys.availability_databases_cluster AGDatabases ON Groups.group_id = AGDatabases.group_id
                                        WHERE primary_replica = @@Servername
                                            AND d.group_database_id = AGDatabases.group_database_id
                                    )
                            )
                        AND (b.DatabaseId IS NULL
                            OR (b.LastDiffBackup < ''''$LastCheckDate''''
                                AND b.LastFullBackup < ''''$LastCheckDate''''
                                )
                            );''
        END;"

    $FailedBackups = Invoke-Sqlcmd -ServerInstance $InstanceName -Query $FailedBackupsQuery
    foreach ($FailedBackup in $FailedBackups) {
        $DBName = $FailedBackup.DatabaseName       

        if (-not [String]::IsNullOrEmpty($DBName)){
            $FailedBackupInsert = "INSERT INTO Sys_Admin.RunBook.FailedBackups (InstanceName, DatabaseName, CheckDateTime"
            $FailedBackupValues = " VALUES (''$InstanceName'', ''$DBName'', ''$CurrentCheckDate''"
            if ($FailedBackup.LastFullBackup  -isnot [DBNull]){
                $LastFull = $FailedBackup.LastFullBackup
                $FailedBackupInsert = $FailedBackupInsert + ", LastFullBackup"
                $FailedBackupValues = $FailedBackupValues + ", ''$LastFull''"
            }
            if ($FailedBackup.LastDiffBackup  -isnot [DBNull]){
                $LastDiff = $FailedBackup.LastDiffBackup 
                $FailedBackupInsert = $FailedBackupInsert + ", LastDiffBackup"
                $FailedBackupValues = $FailedBackupValues + ", ''$LastDiff ''"
            }
            $FailedBackupInsert = $FailedBackupInsert + ")"
            $FailedBackupValues = $FailedBackupValues + ")"

            $FailedBackupInsertValues = $FailedBackupInsert + $FailedBackupValues 
            Invoke-Sqlcmd -Query $FailedBackupInsertValues -ServerInstance $RunBookInstance
        }
    }

    $Alerts = Invoke-Sqlcmd -ServerInstance $InstanceName -Query $AlertsQuery
    foreach ($Alert in $Alerts) {
        $AlertName = $Alert.AlertName
        $AlertMessageId = $Alert.MessageId
        $AlertSeverity = $Alert.severity
        $AlertDateTime = $Alert.AlertDateTime
        $InsertAlert = "INSERT INTO Sys_Admin.RunBook.Alerts (InstanceName, AlertName, MessageId, Severity, AlertDateTime, CheckDateTime)
            VALUES (''$InstanceName'', ''$AlertName'', $AlertMessageId, $AlertSeverity, ''$AlertDateTime'', ''$CurrentCheckDate'')"
        Invoke-Sqlcmd -Query $InsertAlert -ServerInstance $RunBookInstance      
    }   

    $FailedJobs = Invoke-Sqlcmd -ServerInstance $InstanceName -Query $FailedJobsQuery
    foreach ($FailedJob in $FailedJobs) {
        $JobName = $FailedJob.JobName
        $JobDate = $FailedJob.RunDateTime
        $JobSuccess = $FailedJob.RanSuccessfulAfter
        if (-not [String]::IsNullOrEmpty($JobName)) {
            $InsertJob = "INSERT INTO Sys_Admin.RunBook.FailedJobs (InstanceName, JobName, RunDateTime, RanSuccessfulAfter, CheckDateTime)
                    VALUES (''$InstanceName'', ''$JobName'', ''$JobDate'', $JobSuccess, ''$CurrentCheckDate'')"
    $InsertJob
            Invoke-Sqlcmd -Query $InsertJob -ServerInstance $RunBookInstance        
        }
    }

    $MemoryDumps = Invoke-Sqlcmd -ServerInstance $InstanceName -Query $MemoryDumpQuery
    foreach ($MemoryDump in $MemoryDumps) {
        $MemoryDumpDate = $MemoryDump.Creation_time
        if (-not [String]::IsNullOrEmpty($MemoryDumpDate)) {
            $InsertMemoryDump = "INSERT INTO Sys_Admin.RunBook.MemoryDumps (InstanceName, MemoryDumpDateTime, CheckDateTime)
                VALUES (''$InstanceName'',''$MemoryDumpDate'',''$CurrentCheckDate'')"        
            Invoke-Sqlcmd -Query $InsertMemoryDump -ServerInstance $RunBookInstance
        }
    }
}

$ServerCheckDateInsert = "INSERT INTO Sys_Admin.RunBook.ServerCheckDates (CheckDateTime) VALUES (''$CurrentCheckDate'')"
Invoke-Sqlcmd -Query $ServerCheckDateInsert -ServerInstance $RunBookInstance', 
		@database_name=N'master', 
		@output_file_name=N'\\chdc-car-thsql2\d$\SQLAgent_Output\DATAMARTDEV\RunBook\Step01.txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily - 7 AM', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190222, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'745f4a10-2bc2-42ea-b333-a7e25daafcb1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


