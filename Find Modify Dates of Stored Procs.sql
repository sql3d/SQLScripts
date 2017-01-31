


SELECT name, create_date, modify_date
FROM sys.objects
WHERE 1=1
and type in ('P','FN')
and modify_date > '10/1/2012'
order by modify_date desc




