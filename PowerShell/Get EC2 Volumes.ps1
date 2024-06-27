
cls

$Env:AWS_ACCESS_KEY_ID="ASIAQAL2WJXBJBPAVXHD"
$Env:AWS_SECRET_ACCESS_KEY="9UljNhxUDp48/G04YnSgmSDiWzSEOt4bk/j5lXPb"
$Env:AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEC8aCXVzLWVhc3QtMSJGMEQCIE91x2E4N0GFt4xJ8vprD9ju+Yj3w9SQp9so0OP1qB6ZAiBawuVcfJyvXenKtDiokj6Or6C7lFFbvHaZxTf88NoAXSqcAwjX//////////8BEAQaDDAwMDc5NDE4NTE1NCIMQYRlQGLpkiure5CvKvACpImWXV/dHIt396bgbDtwNDTPal+lXusijukiVc0yX2mVOzc3WamxFJRsiqAoCEpsNkQEZGvpVcW2ccBRTf4ORALY88ypuxnqfWK2gq1emiPC7i1CbMPFX5z4WAmbyI/O6LwAg1glGADgV+NjsFUA6vmDzsRp8bhWFWQzD0gxhGDnPltwq37XUIM2cG53V+fVGRugJzuMGtscm7FkYplUuyncwALz+WH5WcEP84KNdoCkce2/WyDomlsSKkPIBGz6U2Va6zz0E0cXZgqeImYlfBdV+QESj3So98w3UAiq970dPX19Ft+34MAs/NcBUJHjmiYhY9U9OxW+Cr3kR5GdV3CDmANldxSJBCxGFiTgO6sei6ka5XHlBAgV5MsJBi2hUqgxIrPsWPg97SB1XjSTVeZkrASpJr2WBIPavxiI23IUA6hFDKe5RZZFS0PsUzMx4drIJ0h2n6dYJgOnIHw+uX3WLZ9Pe+TaiC2H3T9IaO8w58TwswY6qAEZ/kq2Eui5PQvPtxqEUwFdNE7IUCV0Un83gPoshqwd+VARrOzDrpezjGH87G8j1D1LwiPcRzNQcsgFJ2dFwUUJG3irFNTvzGVhUQVW/cM3G7s5IgzgkDAhuLvj7Sizd9zAQBu0AdAkhLCQwOj0lwP2s4PG/S+A3bCQJ9G/pfe+uIdvQTjZdIlk7kTAWyRlCOU3Cgw4U+Rr1sGSob76QZ0hBrW+GuNqTCI="


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