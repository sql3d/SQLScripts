cls
Set-DbatoolsInsecureConnection -SessionOnly 

##$Servers = @('FE4SQL21.proflowers.com','FE4SQL22.proflowers.com','FE4SQL23.proflowers.com','BE4SQL23.proflowers.com','RPT3SQL25.proflowers.com')
$Servers = @('WMS4SQL31.proflowers.com')

foreach ($Server in $Servers){
    $FromServer = $Server
    $FromServer

    $AvailabilityGroups = Get-DbaAvailabilityGroup -SqlInstance $FromServer

    foreach ($AG in $AvailabilityGroups){
        if ($AG.ComputerName -eq $AG.PrimaryReplica){
            foreach($DB in $AG.AvailabilityDatabases){
                $DBName = $DB.name
                $DBName
                $DestDataPath = $ToDataPath + $DBName
                $DestLogPath = $ToLogPath + $DBName
                $Bak = $BackupDirectory + "$ClusterName" + '$' + $AG.AvailabilityGroup + '\' + $DBName + '\'

                $Query = ";WITH cteLatestFullBackup AS
        (
            SELECT bs.database_name AS DBName, MAX(bs.backup_set_id) AS backup_set_id
            FROM msdb.dbo.backupset bs
            WHERE bs.database_name = '$DBName'
	            AND bs.type = 'D' 
	            AND bs.is_copy_only = 0
            GROUP BY bs.database_name
        ),
        cteFilePaths AS 
        (
        SELECT 
            CASE 
                WHEN bf.file_type = 'D' THEN
                    ' MOVE N''' + bf.logical_name + ''' TO N''' + 'S:\DB_DATA\'  + lfb.DBName + '\' + FName.FName + ''''
                ELSE 
                    ' MOVE N''' + bf.logical_name + ''' TO N''' + 'S:\DB_LOGS\' + lfb.DBName + '\' + FName.FName + ''''
            END AS MoveCommand
        FROM msdb.dbo.backupfile bf
            INNER JOIN cteLatestFullBackup lfb 
                ON lfb.backup_set_id = bf.backup_set_id
            CROSS APPLY 
                (VALUES(SUBSTRING(bf.physical_name, LEN(bf.physical_name) - CHARINDEX('\',Reverse(bf.physical_name))+2, LEN(bf.physical_name)))) AS FName (FName)
        ),cteConcatFileMoves AS
        (
            SELECT STUFF(
                (SELECT ', ' +  cfp.MoveCommand 
                FROM cteFilePaths cfp
                FOR XML PATH('')
                ),1,1,'') AS MovePath
        ),cteBackupChain AS
        (
        
        SELECT 0 AS backup_set_id, ' EXECUTE AS LOGIN = ''sa'';' AS CommandSet
        UNION ALL
        SELECT b.backup_set_id
		        ,'RESTORE DATABASE ' + lfb.DBName + ' FROM ' +
		        STUFF(
			        (SELECT ', DISK = ''' + mf.physical_device_name + ''''
				        FROM msdb.dbo.backupmediafamily mf
				        WHERE mf.media_set_id = b.media_set_id
				        ORDER BY mf.family_sequence_number ASC
				        FOR XML PATH('')
			        ),1,1,'')			   
	        + ' WITH REPLACE, ' + 'FILE = ' + CONVERT(VARCHAR(10), b.position) + ', ' + cfm.MovePath + ', STATS=5, NORECOVERY;' AS CommandSet
        FROM   msdb.dbo.backupset b
            INNER JOIN msdb.dbo.backupmediafamily mf ON b.media_set_id = mf.media_set_id
            CROSS JOIN cteConcatFileMoves cfm
            INNER JOIN  cteLatestFullBackup lfb
                ON lfb.backup_set_id = b.backup_set_id
        UNION ALL
        SELECT b.backup_set_id
		        ,'RESTORE LOG ' + lfb.DBName + ' FROM ' +
			        STUFF(
				        (SELECT ', DISK = ''' + mf.physical_device_name + ''''
					        FROM msdb.dbo.backupmediafamily mf
					        WHERE mf.media_set_id = b.media_set_id
					        ORDER BY mf.family_sequence_number ASC
				            FOR XML PATH('')
				        ),1,1,'')			   
		        + ' WITH ' + 'FILE = ' + CONVERT(VARCHAR(10), b.position) + ', STATS=5,NORECOVERY;'
        FROM   msdb.dbo.backupset b
		        INNER JOIN  msdb.dbo.backupmediafamily mf ON b.media_set_id = mf.media_set_id
                CROSS JOIN cteLatestFullBackup lfb
        WHERE b.database_name = '$DBName'
	        AND b.backup_set_id >= lfb.backup_set_id
	        AND b.backup_set_id < 999999999
	        AND b.type = 'L'
        )
        SELECT bc.CommandSet
        FROM cteBackupChain bc
        ORDER  BY bc.backup_set_id;"

                ##$Query
                $RestoreCmds = Invoke-Sqlcmd -ServerInstance $FromServer -QueryTimeout 0 -Query $Query 
                $RestoreCmdsNoHdr = ($RestoreCmds | Format-Table -HideTableHeaders| Out-String -Width 5000).trim()
                $RestoreCmdsNoHdr | Out-File "S:\Install\$DBname.sql" -Encoding utf8 -Width 5000
            }
        }
    }
}