insert into cookbook..category (category_name) VALUES
    ('breakfast'),  -- 1
    ('lunch'),      -- 2
    ('dinner'),     -- 3
    ('drink'),      -- 4
    ('dessert');    -- 5
select * from cookbook..category;
go

insert into cookbook..picture (filepath, picture)
    select 'Z:\zad2\images\burger.jpg',
        * from OPENROWSET(BULK N'Z:\zad2\images\burger.jpg', SINGLE_BLOB) as image;
GO

-- insert into cookbook..picture (filepath, picture) VALUES
--     ('/images/burger.jpg', null),
--     ('/images/coffee.jpg', null),
--     ('/images/cornflakes.jpg', null),
--     ('/images/friedeggs.jpg', null),
--     ('/images/icecream.jpg', null),
--     ('/images/pancake.jpg', null),
--     ('/images/salmon.jpg', null),
--     ('/images/sandwich.jpg', null),
--     ('/images/steak.jpg', (select BulkColumn from openrowset(bulk N'/images/steak.jpg', single_blob) image));
select * from cookbook..picture;
go

insert into cookbook..dish (dish_name, category_id, picture_id) VALUES
    ('burger', 2, null),
    ('coffee', 4, null),
    ('corn flakes', 1, null),
    ('fried eggs', 1, null),
    ('ice cream', 5, null),
    ('pancakes', 5, null),
    ('salmon', 3, null),
    ('sandwich', 3, null),
    ('steak', 2, null);
select * from cookbook..dish;
go
