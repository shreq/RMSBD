-- procedure #1: print_readable
exec geo..print_readable 2;

-- procedure #2 add_point_of_interest
exec geo..add_point_of_interest 1, 44.60, -110.50, 'toilet'

-- procedure #3 add_route
exec geo..add_point_of_interest 1, 44.60, -110.50, 44.65, -110.45, 'shortest path'

-- procedure #4 add_restricted_area
exec geo..add_point_of_interest 1, 44.60, -110.50, 'toilet'

select * from geo..locations