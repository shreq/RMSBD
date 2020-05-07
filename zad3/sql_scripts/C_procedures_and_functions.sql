use cookbook
go

-- procedure #1: import_xml
if exists (select 1 from sysobjects where name='import_xml')
    drop procedure import_xml
go

create procedure import_xml (@path nvarchar(200)) as
begin
    declare @sql nvarchar(400);
    set nocount on
    set @sql = 'insert into files ' +
                'select * from openrowset(bulk N''' + @path + ''', single_blob) as doc;'
    exec(@sql)
    set nocount off
end
go

-- procedure #2: export_xml
if exists (select 1 from sysobjects where name='export_xml')
    drop procedure export_xml
go

create procedure export_xml (@table nvarchar(50), @path nvarchar(200)) as
begin
    declare @cmd nvarchar(400);
    set nocount on
    set @cmd = N'bcp "select * from ' + @table + N' for xml auto, elements" queryout "' + @path + N'" -c -T'
    exec xp_cmdshell @cmd
    set nocount off
end
go
