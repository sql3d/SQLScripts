cls




$output = @()
$volumes = Get-EC2Volume -Region us-east-1 -Filter @{'Name'='status'; 'Values'='available'}

 foreach ($volume in $volumes) {
    $volumeId = $volume.VolumeId
    $sizeGB = $volume.Size
    $state = $volume.State
    $type = $volume.VolumeType

    $object = New-Object PSObject -Property @{
        "VolumeId" = $volumeId
        "Type" = $type
        "SizeGB" = $sizeGB

    }

    $output += $object

}

$output | Export-Csv -Path "C:\Temp\PC_Prod_EBS_Unattached_Volumes.csv" -NoTypeInformation

Write-Output "CSV file 'PC_Prod_EBS_Unattached_Volumes.csv' has been exported."