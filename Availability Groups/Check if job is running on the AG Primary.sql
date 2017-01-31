/*
Script by Denny Cherry
http://itknowledgeexchange.techtarget.com/sql-server/updating-all-jobs-to-check-for-ag-primary-replica/

*/
USE msdb;

CREATE TABLE #sysjobsteps
    (
        job_id UNIQUEIDENTIFIER NOT NULL
        ,step_id INT NOT NULL
        ,step_name sysname NOT NULL
        ,subsystem NVARCHAR(40) NOT NULL
        ,command NVARCHAR(MAX) NULL
        ,flags INT NOT NULL
        ,additional_parameters NVARCHAR(MAX) NULL
        ,cmdexec_success_code INT NOT NULL
        ,on_success_action TINYINT NOT NULL
        ,on_success_step_id INT NOT NULL
        ,on_fail_action TINYINT NOT NULL
        ,on_fail_step_id INT NOT NULL
        ,server sysname NULL
        ,database_name sysname NULL
        ,database_user_name sysname NULL
        ,retry_attempts INT NOT NULL
        ,retry_interval INT NOT NULL
        ,os_run_priority INT NOT NULL
        ,output_file_name NVARCHAR(200) NULL
        ,last_run_outcome INT NOT NULL
        ,last_run_duration INT NOT NULL
        ,last_run_retries INT NOT NULL
        ,last_run_date INT NOT NULL
        ,last_run_time INT NOT NULL
        ,proxy_id INT NULL
        ,step_uid UNIQUEIDENTIFIER NULL
    );

INSERT  INTO #sysjobsteps
SELECT  sysjobsteps.job_id
       ,sysjobsteps.step_id
       ,sysjobsteps.step_name
       ,sysjobsteps.subsystem
       ,sysjobsteps.command
       ,sysjobsteps.flags
       ,sysjobsteps.additional_parameters
       ,sysjobsteps.cmdexec_success_code
       ,sysjobsteps.on_success_action
       ,sysjobsteps.on_success_step_id
       ,sysjobsteps.on_fail_action
       ,sysjobsteps.on_fail_step_id
       ,sysjobsteps.server
       ,sysjobsteps.database_name
       ,sysjobsteps.database_user_name
       ,sysjobsteps.retry_attempts
       ,sysjobsteps.retry_interval
       ,sysjobsteps.os_run_priority
       ,sysjobsteps.output_file_name
       ,sysjobsteps.last_run_outcome
       ,sysjobsteps.last_run_duration
       ,sysjobsteps.last_run_retries
       ,sysjobsteps.last_run_date
       ,sysjobsteps.last_run_time
       ,sysjobsteps.proxy_id
       ,sysjobsteps.step_uid
FROM    msdb.dbo.sysjobsteps;

DECLARE @job_id UNIQUEIDENTIFIER
   ,@step_id INT
   ,@step_name sysname
   ,@subsystem NVARCHAR(40)
   ,@command NVARCHAR(MAX)
   ,@flags INT
   ,@additional_parameters NVARCHAR(MAX)
   ,@cmdexec_success_code INT
   ,@on_success_action TINYINT
   ,@on_success_step_id INT
   ,@on_fail_action TINYINT
   ,@on_fail_step_id INT
   ,@server sysname
   ,@database_name sysname
   ,@database_user_name sysname
   ,@retry_attempts INT
   ,@retry_interval INT
   ,@os_run_priority INT
   ,@output_file_name NVARCHAR(200)
   ,@last_run_outcome INT
   ,@last_run_duration INT
   ,@last_run_retries INT
   ,@last_run_date INT
   ,@last_run_time INT
   ,@proxy_id INT
   ,@step_uid UNIQUEIDENTIFIER;

DECLARE jobs CURSOR
FOR
    SELECT DISTINCT
            sysjobs.job_id
    FROM    msdb.dbo.sysjobs
    WHERE   NOT EXISTS ( SELECT *
                         FROM   msdb.dbo.sysjobsteps
                         WHERE  sysjobsteps.step_name = 'Check Is AG Primary'
                                AND sysjobs.job_id = sysjobsteps.job_id );
OPEN jobs;
FETCH NEXT FROM jobs INTO @job_id;
WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @database_name = (
                              SELECT    a.database_name
                              FROM      (
                                         SELECT TOP (1)
                                                #sysjobsteps.database_name
                                               ,COUNT(*) ct
                                         FROM   #sysjobsteps
                                         WHERE  #sysjobsteps.job_id = @job_id
                                         GROUP BY #sysjobsteps.database_name
                                         ORDER BY COUNT(*) DESC
                                        ) a
                             );

        IF @database_name NOT IN (SELECT    availability_databases_cluster.database_name
                                  FROM      sys.availability_databases_cluster)
            BEGIN
                GOTO SkipJob;
            END;

        SET @command = 'IF [master].sys.fn_hadr_is_primary_replica ('''
            + @database_name
            + ''') 1
RAISERROR(''Not the PRIMARY server for this job, exiting with SUCCESS'' ,11,1)';

        DECLARE steps CURSOR
        FOR
            SELECT  #sysjobsteps.step_id
            FROM    #sysjobsteps
            WHERE   #sysjobsteps.job_id = @job_id
            ORDER BY #sysjobsteps.step_id DESC;
        OPEN steps;
        FETCH NEXT FROM steps INTO @step_id;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC msdb.dbo.sp_delete_jobstep
                    @job_id = @job_id
                   ,@step_id = @step_id;

                FETCH NEXT FROM steps INTO @step_id;
            END;
        CLOSE steps;
        DEALLOCATE steps;

        EXEC msdb.dbo.sp_add_jobstep
            @job_id = @job_id
           ,@step_name = 'Check Is AG Primary'
           ,@step_id = 1
           ,@cmdexec_success_code = 0
           ,@on_success_action = 3
           ,@on_fail_action = 1
           ,@retry_attempts = 0
           ,@retry_interval = 0
           ,@os_run_priority = 0
           ,@subsystem = 'TSQL'
           ,@command = @command
           ,@database_name = 'master'
           ,@flags = 0;

        DECLARE steps CURSOR
        FOR
            SELECT  #sysjobsteps.step_id + 1
                   ,#sysjobsteps.step_name
                   ,#sysjobsteps.subsystem
                   ,#sysjobsteps.command
                   ,#sysjobsteps.flags
                   ,#sysjobsteps.additional_parameters
                   ,#sysjobsteps.cmdexec_success_code
                   ,#sysjobsteps.on_success_action
                   ,#sysjobsteps.on_success_step_id + 1
                   ,#sysjobsteps.on_fail_action
                   ,#sysjobsteps.on_fail_step_id + 1
                   ,#sysjobsteps.server
                   ,#sysjobsteps.database_name
                   ,#sysjobsteps.database_user_name
                   ,#sysjobsteps.retry_attempts
                   ,#sysjobsteps.retry_interval
                   ,#sysjobsteps.os_run_priority
                   ,#sysjobsteps.output_file_name
            FROM    #sysjobsteps
            WHERE   #sysjobsteps.job_id = @job_id
            ORDER BY #sysjobsteps.step_id;
        OPEN steps;
        FETCH NEXT FROM steps INTO @step_id, @step_name, @subsystem, @command,
            @flags, @additional_parameters, @cmdexec_success_code,
            @on_success_action, @on_success_step_id, @on_fail_action,
            @on_fail_step_id, @server, @database_name, @database_user_name,
            @retry_attempts, @retry_interval, @os_run_priority,
            @output_file_name;
        WHILE @@FETCH_STATUS = 0
            BEGIN

                EXEC msdb.dbo.sp_add_jobstep
                    @job_id = @job_id
                   ,@step_name = @step_name
                   ,@step_id = @step_id
                   ,@cmdexec_success_code = @cmdexec_success_code
                   ,@on_success_action = @on_success_action
                   ,@on_fail_action = @on_fail_action
                   ,@on_success_step_id = @on_success_step_id
                   ,@on_fail_step_id = @on_fail_step_id
                   ,@retry_attempts = @retry_attempts
                   ,@retry_interval = @retry_interval
                   ,@os_run_priority = @os_run_priority
                   ,@subsystem = @subsystem
                   ,@command = @command
                   ,@database_name = @database_name
                   ,@flags = @flags;

                FETCH NEXT FROM steps INTO @step_id, @step_name, @subsystem,
                    @command, @flags, @additional_parameters,
                    @cmdexec_success_code, @on_success_action,
                    @on_success_step_id, @on_fail_action, @on_fail_step_id,
                    @server, @database_name, @database_user_name,
                    @retry_attempts, @retry_interval, @os_run_priority,
                    @output_file_name;
            END;
        CLOSE steps;
        DEALLOCATE steps;

        EXEC msdb.dbo.sp_update_job
            @job_id = @job_id
           ,@start_step_id = 1;

        SkipJob:

        FETCH NEXT FROM jobs INTO @job_id;
    END;
CLOSE jobs;
DEALLOCATE jobs;

DROP TABLE #sysjobsteps;