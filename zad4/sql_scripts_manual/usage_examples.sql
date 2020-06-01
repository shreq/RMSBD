-- procedure #1: print_readable
exec geo..print_readable 2;

-- procedure #2 add_point_of_interest
exec geo..add_point_of_interest 1, 44.60, -110.50, 'toilet'

-- procedure #3 add_route
exec geo..add_point_of_interest 1, 44.60, -110.50, 44.65, -110.45, 'shortest path'


-- function #5 create_polygon
declare @polygon geography
set @polygon = geo..create_polygon()

-- procedure #4 add_restricted_area
exec geo..add_restricted_area 1, @polygon, 'no flex zone'

-- procedure #6: print_distance
exec geo..print_distance 1, 2;
