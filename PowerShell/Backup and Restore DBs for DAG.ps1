cls

$FromSQLlistener = 'AGXSQLOP1LS.ad.pquadnt.com'
$FromAvailabilityGroup = 'AGXSQLOP'
$backupPath = '\\ad.pquadnt.com\pc-sqlbackup\backups\Migration\'
$ToSQLListener = 'AGXEcommLS.ad.pquadnt.com'


$databases = Get-DbaAgDatabase -SqlInstance $FromSQLlistener -AvailabilityGroup $FromAvailabilityGroup

foreach ($db in $databases){
    $DBName = $db.Name
    $DBBackupPath = $backupPath + $DBName
    $DestinationDataDir = 'S:\DB_DATA\' + $DBName
    $DestinationLogDir = 'S:\DB_LOGS\' + $DBName

    $DBName

    if ($DBName -ne 'AG_TEST' -and $DBName -ne 'Archive'){
        Backup-DbaDatabase -SqlInstance $FromSQLlistener -Database $DBName -Path $DBBackupPath -Checksum -CompressBackup -BuildPath -FileCount 4 -BufferCount 20 -MaxTransferSize 1048576

        ##Backup-DbaDatabase -SqlInstance $FromSQLlistener -Database $DBName -Type Log -Path $DBBackupPath -Checksum -CompressBackup -BuildPath
    }

    if ($DBName -ne 'AG_TEST'){
        Backup-DbaDatabase -SqlInstance $FromSQLlistener -Database $DBName -Type Log -Path $DBBackupPath -Checksum -CompressBackup -BuildPath

        Restore-DbaDatabase -SqlInstance $ToSQLListener -DatabaseName $DBName -Path $DBBackupPath -DestinationDataDirectory $DestinationDataDir -DestinationLogDirectory $DestinationLogDir -WithReplace -NoRecovery -BufferCount 20 -MaxTransferSize 1048576

        Invoke-DbaQuery -SqlInstance $ToSQLListener -Query "ALTER DATABASE [$DBName] SET HADR AVAILABILITY GROUP = [AGXDistributed]"
    }
}