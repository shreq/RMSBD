use geo
go

-- procedure #1: import_xml
if exists (select 1 from sysobjects where name='print_readable')
    drop procedure print_readable
go

create procedure print_readable (@id int = null) as
begin
    set nocount on
    if @id is null
        select id, park_name, coords.Lat as 'Latitude', coords.Long as 'Longitude' from geo..parks;
    else
        select id, park_name, coords.Lat as 'Latitude', coords.Long as 'Longitude' from geo..parks
        where @id = geo..parks.id;
    set nocount off
end
go
