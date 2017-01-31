select * from fn_trace_getinfo(0)


-- sp_trace_setstatus @traceid, @status
-- @status - 0 = Stop, 1 = Start, 2 = Closes trace and deletes definition from server
exec sp_trace_setstatus 2, 0
exec sp_trace_setstatus 2, 2


