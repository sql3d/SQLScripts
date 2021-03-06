/****************************************************/
/* Created by: Dan Denney				            */
/* Date: 01/07/2009  01:57:26 PM					*/
/****************************************************/


-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 100 

declare @stopTime datetime
set @stopTime = '1/9/2009 14:00' 

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

exec @rc = sp_trace_create @TraceID output, 0, N'c:\Trace\MyTrace', @maxfilesize, @stopTime
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1

exec sp_trace_setevent @TraceID, 10, 1, @on
exec sp_trace_setevent @TraceID, 10, 3, @on
--exec sp_trace_setevent @TraceID, 10, 11, @on		--!!REMOVES LOGINNAME column
exec sp_trace_setevent @TraceID, 10, 35, @on
exec sp_trace_setevent @TraceID, 10, 12, @on
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 45, 1, @on
exec sp_trace_setevent @TraceID, 45, 3, @on
--exec sp_trace_setevent @TraceID, 45, 11, @on		--!!REMOVES LOGINNAME column
exec sp_trace_setevent @TraceID, 45, 35, @on
exec sp_trace_setevent @TraceID, 45, 12, @on
exec sp_trace_setevent @TraceID, 45, 28, @on
exec sp_trace_setevent @TraceID, 45, 13, @on
exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 3, @on
--exec sp_trace_setevent @TraceID, 12, 11, @on		--!!REMOVES LOGINNAME column
exec sp_trace_setevent @TraceID, 12, 35, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on


-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
go

