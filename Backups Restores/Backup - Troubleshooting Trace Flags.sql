-- BACKUP Troubleshooting
/*
http://blogs.sqlsentry.com/aaronbertrand/t-sql-tuesday-66-babysitting-a-slow-backup-or-restore/
https://dba.stackexchange.com/questions/102617/long-running-backups-on-small-databases
*/

DBCC TRACEON(3604);     -- send info to message window
DBCC TRACEON(3605);     -- send info to SQL log file

DBCC TRACEON(3213);     -- Show detailed backup info to the message window
DBCC TRACEON(3014);     -- Show additional backup diagnostic information