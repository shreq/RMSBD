if exists (select 1 from master.dbo.sysdatabases where name='cookbook')
begin
    use master
    alter database cookbook set single_user with rollback immediate
    drop database cookbook
end
go

create database cookbook
go

create table cookbook..picture (
    picture_id  int identity(1, 1),
    picture     varbinary(max) not null
);
go

create table cookbook..category (
    category_id     int identity(1, 1),
    category_name   varchar(30) not null
);
go

create table cookbook..recipe (
	recipe_id	int identity(1, 1),
	content		varchar(500) not null
);
go

create table cookbook..dish (
    dish_id     int identity(1, 1),
    dish_name   varchar(50) not null,
    category_id int not null,
    picture_id  int not null,
	recipe_id	int not null
);
go
