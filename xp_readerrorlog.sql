-- param 1 - file #, 0 is the latest file on down
-- param 2 - 1 = SQL Server Log, 2 = SQL Agent Log
-- param 3 - filter 1
-- param 4 - filter 2

xp_readerrorlog 0, 1, 'traceon'
