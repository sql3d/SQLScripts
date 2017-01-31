
--!!! MOST EFFICIENT
print DATEADD(DAY, DATEDIFF(DAY, 0, getdate()), 0)

-- Less Efficient
print CAST(FLOOR(CAST(getdate() AS FLOAT)) AS DATETIME) 
print CONVERT(VARCHAR(10), getdate(), 101)
 

