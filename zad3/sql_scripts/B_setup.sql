use cookbook
go

exec sp_configure 'show advanced options', 1;
go
reconfigure;
go
exec sp_configure 'xp_cmdshell', 1;
go
reconfigure;
go
