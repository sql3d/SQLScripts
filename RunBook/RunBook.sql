    
use Sys_Admin
go


CREATE SCHEMA RunBook AUTHORIZATION dbo;
GO

create table RunBook.ServerCheckDates
(
    CheckDateTime DATETIME2 NOT NULL
    ,CONSTRAINT PK_ServerCheckDates_CheckDateTime PRIMARY KEY CLUSTERED
        (CheckDateTime)
);

create table RunBook.DatabaseInstances
(
    InstanceName varchar(254) NOT NULL
    ,Environment varchar(5) NOT NULL
    ,ServerUse varchar(20) NOT NULL
    ,LastRestarted DATETIME2 NOT NULL
    ,LastCheckDateTime DATETIME2 NOT NULL
    ,IsActive BIT NOT NULL CONSTRAINT DF_DatabaseInstances_IsActive DEFAULT (1)
    ,Comments varchar(254)  NULL
    ,SQLEdition varchar(100) NULL
    ,SQLVersion varchar(20) NULL
    ,IsCurrentPrimary BIT NULL 
    ,CONSTRAINT PK_DatabaseInstances_InstanceName PRIMARY KEY CLUSTERED
        (InstanceName)
);

INSERT INTO RunBook.DatabaseInstances (InstanceName, Environment, ServerUse, LastRestarted, LastCheckDateTime, 
                                        IsActive, SQLEdition, SQLVersion, Comments, IsCurrentPrimary)
VALUES  ('CHDC-CAR-PHSQL4\DataMartProd','Prod','DataMart','2019-01-01','2019-01-01',1,NULL,NULL,NULL,1)
        ,('CHDC-CAR-PHSQL5\DataMartProd','Prod','DataMart','2019-01-01','2019-01-01',1,NULL,NULL,NULL,0)
        ,('CHDC-CAR-THSQL2\DataMartDev','Dev','DataMart','2019-01-01','2019-01-01',1,NULL,NULL,NULL,NULL)
        ,('CHDC-CAR-THSQL2\DataMartTest','Test','DataMart','2019-01-01','2019-01-01',1,NULL,NULL,NULL,NULL)
        ,('CHDC-CLS-PHSQL9\Prod','Prod','SQL9','2019-01-01','2019-01-01',1,NULL,NULL,NULL,NULL)
        ,('CHDC-CLS-DHSQL9\Dev','Dev','SQL9','2019-01-01','2019-01-01',1,NULL,NULL,NULL,NULL)
        ,('CHDC-S13-PCSQL1\S13','Prod','SharePoint','2019-01-01','2019-01-01',1,NULL,NULL,NULL,1)
        ,('CHDC-S13-PCSQL2\S13','Prod','SharePoint','2019-01-01','2019-01-01',1,NULL,NULL,NULL,0)
        ,('CHDC-SQL-DVCH1C\I1','Dev','Apps','2019-01-01','2019-01-01',1,NULL,NULL,NULL,NULL)
        ,('CHDC-SQL-PCCH2A\I1','Prod','Apps','2019-01-01','2019-01-01',1,NULL,NULL,NULL,1)
        ,('CHDC-SQL-PCCH2B\I1','Prod','Apps','2019-01-01','2019-01-01',1,NULL,NULL,NULL,0)
        ,('CHDC-SQL-UCCH2A\I1','Test','Apps','2019-01-01','2019-01-01',1,NULL,NULL,NULL,1)
        ,('CHDC-SQL-UCCH2B\I1','Test','Apps','2019-01-01','2019-01-01',1,NULL,NULL,NULL,0)
        ;

create table RunBook.UnhealthyDatabases
(
    UnhealthyDatabaseId INT NOT NULL IDENTITY(1,1)
    ,InstanceName varchar(254) NOT NULL
    ,DatabaseName sysname NOT NULL
    ,DatabaseState varchar(60) NOT NULL
    ,CheckDateTime DATETIME2 NOT NULL
    ,CONSTRAINT PK_UnhealthyDatabases_InstanceNameCheckDateTimeUnhealthyDatabaseId PRIMARY KEY CLUSTERED
        (InstanceName, CheckDateTime, UnhealthyDatabaseId)
);

create table RunBook.FailedBackups
(
    FailedBackupId INT NOT NULL IDENTITY(1,1)
    ,InstanceName varchar(254) NOT NULL
    ,DatabaseName varchar(254) NOT NULL
    ,LastFullBackup DATETIME2 NULL
    ,LastDiffBackup DATETIME2 NULL
    ,CheckDateTime DATETIME2 NOT NULL
    ,CONSTRAINT PK_FailedBackups_InstanceNameCheckDateTimeFailedBackupId PRIMARY KEY CLUSTERED
        (InstanceName, CheckDateTime, FailedBackupId)
);

create table RunBook.Alerts
(
    AlertId INT NOT NULL IDENTITY(1,1)
    ,InstanceName varchar(254) NOT NULL
    ,AlertName sysname NOT NULL
    ,MessageId INT NOT NULL
    ,Severity INT NOT NULL
    ,AlertDateTime DATETIME2 NOT NULL
    ,CheckDateTime DATETIME2 NOT NULL
    ,CONSTRAINT PK_Alerts_InstanceNameCheckDateTimeAlertId PRIMARY KEY CLUSTERED
        (InstanceName, CheckDateTime, AlertId)
);

create table RunBook.FailedJobs
(
    FailedJobId INT NOT NULL IDENTITY(1,1)
    ,InstanceName varchar(254) NOT NULL
    ,JobName sysname NOT NULL
    ,RunDateTime DATETIME2 NOT NULL
    ,RanSuccessfulAfter BIT NOT NULL CONSTRAINT DF_FailedJobs_RanSuccessfulAfter DEFAULT 0
    ,CheckDateTime DATETIME2 NOT NULL
    ,CONSTRAINT PK_FailedJobs_InstanceNameCheckDateTimeFailedJobId PRIMARY KEY CLUSTERED
        (InstanceName, CheckDateTime, FailedJobId)
);


/*
/* Queries */
-- Last Run:
SELECT create_date AS LastRestarted FROM sys.databases WHERE name = 'tempdb';

-- Database Health:
SELECT name AS DatabaseName, state_desc AS DatabaseState FROM sys.databases WHERE state <> 0

-- Failed Backup:
;WITH cteBackups AS
(
    SELECT  
        DB_ID(bus.database_name) AS DatabaseId
        ,MAX(CASE WHEN bus.type = 'D' THEN bus.Backup_Finish_Date END) AS LastFullBackup
        ,MAX(CASE WHEN bus.Type <> 'D' THEN bus.Backup_Finish_Date END) AS LastDiffBackup
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
    OR (b.LastDiffBackup < DATEADD(HOUR, -24, SYSDATETIME())
        AND b.LastFullBackup < DATEADD(HOUR, -24, SYSDATETIME())
        );

-- Alerts
;WITH cteAlerts AS
(
    SELECT a.name AS AlertName
        ,a.message_id AS MessageId
        ,a.severity
        ,msdb.dbo.agent_datetime(a.last_occurrence_date, a.last_occurrence_time) AS AlertDateTime
    FROM msdb.dbo.sysalerts a
    WHERE a.last_occurrence_date > 0
)
SELECT *
FROM cteAlerts ca
WHERE ca.AlertDateTime > DATEADD(HOUR, -24, SYSDATETIME());

-- Failed Jobs
;WITH cteFailedJobs AS 
(
    SELECT sjh.job_id
        ,MAX(msdb.dbo.agent_datetime(sjh.run_date, sjh.run_time)) AS RunDateTime
    FROM msdb.dbo.sysjobhistory sjh
    WHERE sjh.run_status NOT IN (1,4) -- Succeed, In Progress
        AND sjh.step_id <> 0
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
    WHERE msdb.dbo.agent_datetime(sjh.run_date, sjh.run_time) > cfj.RunDateTime
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
WHERE RunDateTime > DATEADD(HOUR, -24, SYSDATETIME())


*/