cls
$Env:AWS_ACCESS_KEY_ID="ASIA2BOH4UWYXZUF4ADE"
$Env:AWS_SECRET_ACCESS_KEY="otiBTpZmm/ihsgDER75wOw2C/NKtanON+FT0dYZ7"
$Env:AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEKb//////////wEaCXVzLWVhc3QtMSJHMEUCIAHAtkIUA4aC/SdDm04Kq5HWjrW+JJVvj44ndtiePf13AiEApVF/e5wEmEbAQtxVmpzhtdiljOkIHN6vk6UgCLJPVA0qnQMIrv//////////ARAEGgw2OTAyOTgzMzI1OTMiDD3Y9uc5bkU2UuexrSrxAi/xWNRb6NFFNG9CdyX1CXriuUZhMqqX6vIe2kphAYTrVUd0eRm2DpD/owKSt1TMqOgMI+9O/7XqGk3tvIseC2nG2LBVU1VWW/FiEv3wvvVKiIypZKzLq9uUO16fTRAoTLsvuKIpSfxqUI/JK9Ivsbd37B4rPxL1wl/72/XWlKT/qUWmb1n7ThCmQr9x1NxNYX+jaTHCyIsvJo7vk+2186fqNNwZ/CuvcrE0i6kFVf/cgzg9oGnd2jVjxiu0+oYN3cNs/cJOOUPf/h6NO0+9Yc2Ux3dbPW3Q1LpQDuivI33EsBbSJQPH60tDKOQs+iatL186+mZk+5ByE4HfVVnDaYOUQMsJD+jMk+Bqf7/ofFxYRF7MaUU/HqogsyYW684tJXt1LLXek859O/SsL/zVTkfdBrb8dZThru12SnBF8ODzXiQo3EMe5BJm3Au/aOPvaWUnnvsUSWT6RxgOrE7rwDMJIrvyCNHaGJvB88yME0fqnDCC2cCiBjqmAcwIY4YUUJiBHGB5sEbAPgZgUztkts16g4spGohvQKm0MvOtBnWyNMYSqX3tAkK52kqxYaS0mivsWc3i46567OU3pX5+Z936iy7tOrBsHY3SA+rM/7DGOQ6gM+rnt9TZZMkOxJVx0fHWN1WonTS67RYpObVsxQKQm8Cn+XwBFiEkkqHju9JNnhw+aR+xUs/OomHMYC3Kn/FOMRIdaoTfs/4sN/J5IRc="

$DBConnection = "dev2sqlop01.ad.pquadnt.com"

$dsCNAMES = Invoke-Sqlcmd -Query "SELECT [Dev3 Server] AS DevServer, [Dev3 CName] AS DevCName FROM DAN_TEST.dbo.PC_CNames WHERE [Dev3 Server] <> ''" -ServerInstance $DBConnection 

foreach ($rowCName in $dsCNAMES){
    $ServerName = $rowCName.DevServer
    $CName = $rowCName.DevCName


    $change1 = New-Object Amazon.Route53.Model.Change
    $change1.Action = "CREATE"
    $change1.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
    $change1.ResourceRecordSet.Type = "CNAME"
    $change1.ResourceRecordSet.TTL = 300
    $change1.ResourceRecordSet.Name = "$CName"    
    $change1.ResourceRecordSet.ResourceRecords.Add(@{Value="$ServerName"})
    
    $params = @{
        HostedZoneId="Z1HE808MTGE48M"
	    ChangeBatch_Change=$change1
    }

    Edit-R53ResourceRecordSet @params
}
