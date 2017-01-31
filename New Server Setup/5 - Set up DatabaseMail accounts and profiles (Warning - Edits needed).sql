/*
Creates an AdminMail and PublicMail account and an AdminProfile and PublicProfile profile.

!!!REPLACE ALL "<ServerName>" WITH THE ACTUAL SERVER NAME!!!


Developer: Dan Denney (used the SQL Server Template to generate the initial scripts)
Date:  2015-10-14
*/

DECLARE @profile_name sysname,
        @account_name sysname,
        @SMTP_servername sysname,
        @email_address NVARCHAR(128),
	    @display_name NVARCHAR(128);

-- Profile name. Replace with the name for your profile
        SET @profile_name = 'AdminProfile';

-- Account information. Replace with the information for your account.

		SET @account_name = 'AdminAccount';
		SET @SMTP_servername = 'smtpmail.cox.com';
		SET @email_address = '<ServerName>-DoNotReply@cox.com';
        SET @display_name = '<ServerName>';


-- Verify the specified account and profile do not already exist.
IF EXISTS (SELECT * FROM msdb.dbo.sysmail_profile WHERE name = @profile_name)
BEGIN
  RAISERROR('The specified Database Mail profile AdminProfile already exists.', 16, 1);
  GOTO done;
END;

IF EXISTS (SELECT * FROM msdb.dbo.sysmail_account WHERE name = @account_name )
BEGIN
 RAISERROR('The specified Database Mail account AdminAccount already exists.', 16, 1) ;
 GOTO done;
END;

-- Start a transaction before adding the account and the profile
BEGIN TRANSACTION ;

    DECLARE @rv INT;

    -- Add the account
    EXECUTE @rv=msdb.dbo.sysmail_add_account_sp
        @account_name = @account_name,
        @email_address = @email_address,
        @display_name = @display_name,
        @mailserver_name = @SMTP_servername;

    IF @rv<>0
    BEGIN
        RAISERROR('Failed to create the specified Database Mail account AdminAccount.', 16, 1) ;
        GOTO done;
    END

    -- Add the profile
    EXECUTE @rv=msdb.dbo.sysmail_add_profile_sp
        @profile_name = @profile_name ;

    IF @rv<>0
    BEGIN
        RAISERROR('Failed to create the specified Database Mail profile AdminProfile.', 16, 1);
	    ROLLBACK TRANSACTION;
        GOTO done;
    END;

    -- Associate the account with the profile.
    EXECUTE @rv=msdb.dbo.sysmail_add_profileaccount_sp
        @profile_name = @profile_name,
        @account_name = @account_name,
        @sequence_number = 1 ;

    IF @rv<>0
    BEGIN
        RAISERROR('Failed to associate the speficied profile with the specified account AdminAccount.', 16, 1) ;
	    ROLLBACK TRANSACTION;
        GOTO done;
    END;

COMMIT TRANSACTION;
GO


DECLARE @profile_name sysname,
        @account_name sysname,
        @SMTP_servername sysname,
        @email_address NVARCHAR(128),
	    @display_name NVARCHAR(128);

-- Profile name. Replace with the name for your profile
SET @profile_name = 'PublicProfile';

-- Account information. Replace with the information for your account.

SET @account_name = 'PublicAccount';
SET @SMTP_servername = 'smtpmail.cox.com';
SET @email_address = 'DoNotReply@cox.com';
SET @display_name = 'DoNotReply';


-- Verify the specified account and profile do not already exist.
IF EXISTS (SELECT * FROM msdb.dbo.sysmail_profile WHERE name = @profile_name)
BEGIN
  RAISERROR('The specified Database Mail profile PublicProfile already exists.', 16, 1);
  GOTO done;
END;

IF EXISTS (SELECT * FROM msdb.dbo.sysmail_account WHERE name = @account_name )
BEGIN
 RAISERROR('The specified Database Mail account PublicAccount already exists.', 16, 1) ;
 GOTO done;
END;

-- Start a transaction before adding the account and the profile
BEGIN TRANSACTION ;

    DECLARE @rv INT;

    -- Add the account
    EXECUTE @rv=msdb.dbo.sysmail_add_account_sp
        @account_name = @account_name,
        @email_address = @email_address,
        @display_name = @display_name,
        @mailserver_name = @SMTP_servername;

    IF @rv<>0
    BEGIN
        RAISERROR('Failed to create the specified Database Mail account PublicAccount.', 16, 1) ;
        GOTO done;
    END

    -- Add the profile
    EXECUTE @rv=msdb.dbo.sysmail_add_profile_sp
        @profile_name = @profile_name ;

    IF @rv<>0
    BEGIN
        RAISERROR('Failed to create the specified Database Mail profile PublicProfile.', 16, 1);
	    ROLLBACK TRANSACTION;
        GOTO done;
    END;

    -- Associate the account with the profile.
    EXECUTE @rv=msdb.dbo.sysmail_add_profileaccount_sp
        @profile_name = @profile_name,
        @account_name = @account_name,
        @sequence_number = 1 ;

    IF @rv<>0
    BEGIN
        RAISERROR('Failed to associate the speficied profile with the specified account PublicAccount.', 16, 1) ;
	    ROLLBACK TRANSACTION;
        GOTO done;
    END;

COMMIT TRANSACTION;
GO