IF DB_ID('DeadlockDemo') IS NOT NULL DROP DATABASE DeadlockDemo
GO
CREATE DATABASE DeadlockDemo
GO
USE DeadlockDemo
GO
SET NOCOUNT ON
GO
IF OBJECT_ID ('BookmarkLookupDeadlock') IS NOT NULL DROP TABLE BookmarkLookupDeadlock
IF OBJECT_ID ('BookmarkLookupSelect') IS NOT NULL DROP PROC BookmarkLookupSelect
IF OBJECT_ID ('BookmarkLookupUpdate') IS NOT NULL DROP PROC BookmarkLookupUpdate
GO
CREATE TABLE BookmarkLookupDeadlock (col1 int, col2 int, col3 int, col4 char(100))
GO
DECLARE @int int
SET @int = 1
WHILE (@int <= 1000) BEGIN
    INSERT INTO BookmarkLookupDeadlock VALUES (@int*2, @int*2, @int*2, @int*2)
    SET @int = @int + 1
END
GO
CREATE CLUSTERED INDEX cidx_BookmarkLookupDeadlock ON BookmarkLookupDeadlock (col1)
CREATE NONCLUSTERED INDEX idx_BookmarkLookupDeadlock_col2 ON BookmarkLookupDeadlock (col2)
GO
CREATE PROC BookmarkLookupSelect @col2 int AS 
BEGIN
    SELECT col2, col3 FROM BookmarkLookupDeadlock WHERE col2 BETWEEN @col2 AND @col2+1
END
GO
CREATE PROC BookmarkLookupUpdate @col2 int 
AS
BEGIN
    UPDATE BookmarkLookupDeadlock SET col2 = col2+1 WHERE col1 = @col2
    UPDATE BookmarkLookupDeadlock SET col2 = col2-1 WHERE col1 = @col2
END
GO
