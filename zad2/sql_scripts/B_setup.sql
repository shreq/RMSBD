use cookbook
go

-- db setup
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

	declare @IMG_PATH varchar
	set @IMG_PATH = 'C:\Users\Tomek\Repos\studia\RMSBD\zad2\images\'