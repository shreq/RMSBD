insert into geo..parks (coords, park_name) values
    (geography::Point(44.60, -110.50, 4326), 'Yellowstone'),
    (geography::Point(36.43, -118.68, 4326), 'Sequoia'),
    (geography::Point(37.83, -119.50, 4326), 'Yosemite'),
    (geography::Point(40.40, -105.58, 4326), 'Rocky Mountain'),
    (geography::Point(36.06, -112.14, 4326), 'Grand Canyon'),
    (geography::Point(35.68,  -83.53, 4326), 'Great Smoky Mountains');
select * from geo..parks;
go
