use geo
go

-- procedure #1: print_readable
if exists (select 1 from sysobjects where name='print_readable')
    drop procedure print_readable
go

create procedure print_readable (@park_id int = null) as
begin
    set nocount on
    if @park_id is null
        select id, park_name, coords.Lat as 'Latitude', coords.Long as 'Longitude' from geo..parks;
    else
        select id, park_name, coords.Lat as 'Latitude', coords.Long as 'Longitude' from geo..parks
        where @park_id = geo..parks.id;
    set nocount off
end
go

-- procedure #2: add_point_of_interest
if exists (select 1 from sysobjects where name='add_point_of_interest')
    drop procedure add_point_of_interest
go

create procedure add_point_of_interest (@park_id int, @x_cord float, @y_cord float, @description varchar(100)) as
begin
    set nocount on
    insert into geo..locations values (@park_id, geography::Point(@x_cord, @y_cord, 4326), @description, 'POI')
    set nocount off
end
go

-- procedure #3: add_route
if exists (select 1 from sysobjects where name='add_route')
    drop procedure add_route
go

create procedure add_route (@park_id int, @x_start float, @y_start float, @x_stop float, @y_stop float, @description varchar(100)) as
begin
    set nocount on
    insert into geo..locations values (@park_id, geography::STLineFromText('LINESTRING(' + str(@y_start) + ' ' + str(@x_start) + ', ' + str(@y_stop) + ' ' + str(@x_stop) + ' )', 4326), @description, 'ROUTE')
    set nocount off
end
go

-- procedure #4: add_restricted_area
if exists (select 1 from sysobjects where name='add_restricted_area')
    drop procedure add_restricted_area
go

create procedure add_restricted_area (@park_id int, @restricted_polygon geography, @description varchar(100)) as
begin
    set nocount on
    insert into geo..locations values (@park_id, @restricted_area, @description, 'RESTRICTED')
    set nocount off
end
go

-- procedure #6: print_distance
if exists (select 1 from sysobjects where name='print_distance')
	drop procedure print_distance
go

create procedure print_distance (@idA int, @idB int) as
begin
	set nocount on
	declare @distance float = round((
		select coords from geo..parks where geo..parks.id = @idA
	).STDistance((
		select coords from geo..parks where geo..parks.id = @idB
	)), 2)
	set nocount off

	print cast(@distance as decimal(10, 2))
end
go
