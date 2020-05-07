if exists (select 1 from master.dbo.sysdatabases where name='cookbook')
begin
    use master
    alter database cookbook set single_user with rollback immediate
    drop database cookbook
end
go

create database cookbook
go

create table cookbook..files (
    id          int identity(1, 1),
    document    xml not null
);
go
