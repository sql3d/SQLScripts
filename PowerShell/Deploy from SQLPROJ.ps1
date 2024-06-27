cls

## These are connection variables to SQL Server installed on my laptop, but can be any SQL Server instance
$TargetConnection = "Data Source=localhost;Integrated Security=True"
$TargetDB = "AdventureWorks2017"

## Local Repo path
$RepoPath = "C:\Working\GitHub\POC-DB-CICD\POC-DB-CICD\POC-DB-CICD.sqlproj"

## Path to place the DACPAC file
$OutPath = 'C:\Working\GitHub\'
  

## This part build a DACPAC, comparing the .sqlproj to the destination server in the TargetConnection and TargetDB variables
$msbuild = "C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe"
$collectionOfArgs = @("$RepoPath", '/target:Build', "/p:TargetConnectionString=""$TargetConnection""", "/p:TargetDatabase=$TargetDB", "/p:OutDir=$OutPath")
& $msbuild $collectionOfArgs


## This publishes the changes in the dacpac to the server 
Publish-DbaDacPackage -SqlInstance localhost -Database AdventureWorks2017 -Path C:\Working\GitHub\POC-DB-CICD.dacpac -OutputPath $OutPath