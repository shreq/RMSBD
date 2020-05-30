if exists (select 1 from master.dbo.sysdatabases where name='geo')
begin
    use master
    alter database geo set single_user with rollback immediate
    drop database geo
end
go

create database geo
go

create table geo..parks (
    id          int identity(1, 1),
    park_name   varchar(100),
    coords      geography,
    constraint const primary key clustered (
        id  asc
    ) --with (
    --    pad_index = off,
    --    statistics_norecompute = off,
    --    ignore_dup_key = off
    --)
);
go

create spatial index idx_sth on geo..parks(coords);
