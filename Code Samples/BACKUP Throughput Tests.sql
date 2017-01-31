-- RUN ON CCAL2DB903\D_DW

USE Master
GO


DBCC TRACEON (3604, 3213)

BACKUP DATABASE coxDSS TO 
    --DISK = 'nul' 
    --,DISK = 'nul'
    --,DISK = 'nul'
    --,DISK = 'nul'
    --,DISK = 'nul'
    --,DISK = 'nul'
    --,DISK = 'nul'
    --,DISK = 'nul' 
    DISK =N'\\10.46.80.130\rsm_sql\coxDSS1.bak'
    ,DISK = N'\\10.46.80.130\rsm_sql\coxDSS2.bak'
    ,DISK = N'\\10.46.80.130\rsm_sql\coxDSS3.bak'
    ,DISK = N'\\10.46.80.130\rsm_sql\coxDSS4.bak'
    ,DISK =N'\\10.46.80.130\rsm_sql\coxDSS5.bak'
    ,DISK = N'\\10.46.80.130\rsm_sql\coxDSS6.bak'
    ,DISK = N'\\10.46.80.130\rsm_sql\coxDSS7.bak'
    ,DISK = N'\\10.46.80.130\rsm_sql\coxDSS8.bak'
    WITH  COPY_ONLY, NOFORMAT, INIT, COMPRESSION,
    NAME = N'ReportingSandbox-Full Database Backup', 
    SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
    ,BUFFERCOUNT = 500;
GO

-- coxDSS - 8 files 'nul', 500 buffers, 3 sets of buffers, 1024KB maxtransfersize, 1.5GB total buffer space,
--      compressed, 982.529 MB/sec throughput, 593.861 seconds total time
-- coxDSS - 8 files exagrid, 500 buffers, 3 sets of buffers, 1024KB maxtransfersize, 1.5GB total buffer space,
--      compressed, 656.639 MB/sec throughput, 888.595 seconds total time (14:50)
-- coxDSS - default backup  - 136.951 MB/sec throughput, 4245 seconds total time (70:45)

/*
Exagrid Test
ReportingSandbox - Default with 1 disk
BufferCount: 7
MaxTransferSize: 1024
Set of Buffers: 1
Compression: ON
Throughput: 99.499
Time: 82.571
Size: 8.4GB

ReportingSandbox - Default with 1 disk
BufferCount: 7
MaxTransferSize: 1024
Set of Buffers: 3
Compression: Off
Trhoughput: 145.123
Time: 56.612
Size: 1.417GB

ReportingSandbox - 4 disks
BufferCount: 500
MaxTransferSize: 1024
Set of Buffers: 3
Compression: ON
Trhoughput: 548.594
Time: 14.976

ReportingSandbox - 8 disks
BufferCount: 500
MaxTransferSize: 1024
Set of Buffers: 3
Compression: ON
Trhoughput: 594.913
Time: 13.810
*/

/*
BACKUP TO NUL
1 Disk
BufferCount 7
MaxTransferSize 1024KB
Throughput 172.230 MB/sec
Time: 47.702 sec

4 disks
BufferCount 22
MaxTransferSize 1024KB
Throughput 544.053 MB/sec
Time: 15.101 sec

8 Disks
BufferCount 42
MaxTransferSize 1024KB
Throughput 804.992 MB/sec
Time: 10.206 sec

1 Disk
BufferCount 100
MaxTransferSize 1024KB
Throughput 1000.335 MB/sec
Time: 8.213 sec

4 disks
BufferCount 100
MaxTransferSize 1024KB
Throughput 947.934 MB/sec
Time: 8.667 sec

8 Disks
BufferCount 100
MaxTransferSize 1024KB
Throughput 994.402 MB/sec
Time: 8.262 sec

1 Disk
BufferCount 500
MaxTransferSize 1024KB
Throughput 1071.712 MB/sec
Time: 7.666 sec

4 disks
BufferCount 500
MaxTransferSize 1024KB
Throughput 1081.731 MB/sec
Time: 7.595 sec

8 Disks
BufferCount 500
MaxTransferSize 1024KB
Throughput 1074.938 MB/sec
Time: 7.643 sec
*/