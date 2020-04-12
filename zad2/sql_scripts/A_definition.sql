if exists (select 1 from master.dbo.sysdatabases where name='cookbook')
BEGIN
    use master
    alter database cookbook set single_user with rollback IMMEDIATE
    drop database cookbook
END
go

create database cookbook
GO

create table cookbook..picture (
    picture_id  int identity(1, 1),
    filepath    varchar(100) not null,
    picture     varbinary(MAX) -- not null
);
GO

create table cookbook..category (
    category_id     int identity(1, 1),
    category_name   varchar(30) not null
)
GO

create table cookbook..dish (
    dish_id     int identity(1, 1),
    dish_name   varchar(50) not null,
    category_id int not null,
    picture_id  int -- not null
);
GO
