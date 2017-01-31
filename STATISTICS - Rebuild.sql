USE DBA
go

EXECUTE [dbo].[IndexOptimize]
    @Databases = 'USER_DATABASES' ,
    @FragmentationLow = NULL ,
    @FragmentationMedium = NULL ,
    @FragmentationHigh = NULL ,
    @UpdateStatistics = 'INDEX' ,
    @OnlyModifiedStatistics = N'Y' ,
    @StatisticsSample = 100,
    @LogToTable = N'Y';