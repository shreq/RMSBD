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

    constraint c_pk_park primary key clustered (
        id  asc
    )
);
go

create spatial index idx_sth on geo..parks(coords);
go

create table geo..locations (
	id			int identity(1, 1),
	park_id		int not null,
	coords		geography,
	description	varchar(100),
	type		varchar(50),

	constraint c_pk_locations primary key clustered (
        id  asc
    ),
	constraint c_fk_park_id foreign key (park_id) references geo..parks (id)
);
go
