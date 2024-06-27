
cls




$output = @()

$stoppedInstances = Get-EC2Instance -Region us-east-1 | Where-Object { $_.Instances.State.Name -eq 'stopped'} ## -and $_.Instances.Tags.Value -eq 'db-prod' }

# Loop through stopped instances to find attached volumes
foreach ($instance in $stoppedInstances) {
    $instanceId = $instance.Instances.InstanceId
    ##$instanceId
    $instanceName = ($instance.Instances.Tags | Where-Object { $_.Key -eq 'Name' }).Value

    $volumes = Get-EC2Volume -Region us-east-1 | Where-Object { $_.Attachments.InstanceId -eq $instanceId }
    # Output information about each volume
    foreach ($volume in $volumes) {
        $volumeId = $volume.VolumeId
        $sizeGB = $volume.Size
        $state = $volume.State
        $type = $volume.VolumeType
        $attachment = $volume.Attachments | Where-Object { $_.InstanceId -eq $instanceId }
        $deleteOnTermination = $attachment.DeleteOnTermination

        $object = New-Object PSObject -Property @{
            "InstanceName" = $instanceName
            "InstanceId" = $instanceId
            "VolumeId" = $volumeId
            "Type" = $type
            "SizeGB" = $sizeGB
            "DeleteOnTermination" = $deleteOnTermination

        }

        $output += $object
    }
}

$output | Export-Csv -Path "C:\Temp\PC_Prod_EBS_Volumes_with_Instance.csv" -NoTypeInformation

Write-Output "CSV file 'EBS_Volumes_with_Instance.csv' has been exported."