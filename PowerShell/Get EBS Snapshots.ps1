cls





$output = @()
# Get all snapshots
$snapshots = Get-EC2Snapshot -Region us-east-1 ##| Where-Object { $_.Instances.Tags.Value -eq 'db-prod' }

foreach ($snapshot in $snapshots){
    $snapshotId = $snapshot.snapshotId
    $snapshotName = ($snapshot.Tags | Where-Object { $_.Key -eq 'Name' }).Value
    $snapshotSizeGB = $snapshot.VolumeSize
    $snapshotDate = $snapshot.StartTime
    $snapshotDesc = $snapshot.Description

    ##$snapshot
    $object = New-Object PSObject -Property @{
            "snapshotId" = $snapshotId
            "snapshotName" = $snapshotName
            "snapshotSizeGB" = $snapshotSizeGB
            "snapshotDate" = $snapshotDate
            "snapshotDesc" = $snapshotDesc

        }

        $output += $object
}


$output | Export-Csv -Path "C:\Temp\PC_Prod_EBS_Snapshots2.csv" -NoTypeInformation

Write-Output "CSV file 'PC_Prod_EBS_Snapshots.csv' has been exported."