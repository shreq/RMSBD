use cookbook
go

exec sp_configure 'show advanced options', 1;
go
reconfigure;
go
exec sp_configure 'ole automation procedures', 1;
go
reconfigure;
go
exec sp_configure 'xp_cmdshell', 1;
go
reconfigure;
go
exec sp_configure 'external scripts enabled', 1;
go
reconfigure;
go

declare @IMG_PATH varchar
set @IMG_PATH = 'P:\zad2\images\'
