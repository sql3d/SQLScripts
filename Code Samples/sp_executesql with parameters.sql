

declare @sql nvarchar(1000)
declare @paramDef nvarchar(500)

declare @paramdt datetime 

set @paramdt = '10/1/2012'

set @sql = 'select * from foo where fooDT = @dt2 or fooDT > @dt2'

set @paramDef = '@dt2 datetime'

exec sp_executesql @sql, @paramDef, @dt2 = @paramdt
