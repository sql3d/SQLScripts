
-- This will find the most recently modified/created Stored Procs, Functions, and Views
SELECT top 100 * --name, type_desc, create_date, modify_date
FROM sys.objects
WHERE 1=1
	and type in ('P', 'FN', 'V', 'TF', 'T')
	and create_date > '5/9/2010'
--		or modify_date > '7/1/2010')
order by modify_date desc
GO




