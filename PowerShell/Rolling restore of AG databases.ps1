cls
## Variables to Change
$FromServer = 'db-ecomm-fe01.prod.pquadnt.com'
$ToServer = 'ecomm-fe1sql.ad.pquadnt.com'


## Static variables that don't change
$ToDataPath = 'S:\DB_DATA\' 
$ToLogPath = 'S:\DB_LOGS\'
$BackupDirectory = '\\ad.pquadnt.com\pc-sqlbackup\backups\'

$AvailabilityGroups = Get-DbaAvailabilityGroup -SqlInstance $FromServer
$Cluster = Get-DbaWsfcCluster -ComputerName $FromServer 
$ClusterName = $Cluster.Name

foreach ($AG in $AvailabilityGroups){
    
    foreach($DB in $AG.AvailabilityDatabases){
        $DBName = $DB.name
        $DestDataPath = $ToDataPath + $DBName
        $DestLogPath = $ToLogPath + $DBName
        $Bak = $BackupDirectory + "$ClusterName" + '$' + $AG.AvailabilityGroup + '\' + $DBName + '\'

        Restore-DbaDatabase -SqlInstance $ToServer -DatabaseName $DBName -Path $Bak -DestinationDataDirectory $DestDataPath -DestinationLogDirectory $DestLogPath -MaintenanceSolutionBackup -WithReplace -NoRecovery -WhatIf
    }
}