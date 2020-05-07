insert into cookbook..category (category_name) values
    ('breakfast'),  -- 1
    ('lunch'),      -- 2
    ('dinner'),     -- 3
    ('drink'),      -- 4
    ('dessert');    -- 5
select * from cookbook..category;
go

declare @path varchar(100)

insert into cookbook..recipe (content) values
    ('take a bum and slam some cheese and ham'),	-- 1
    ('meat from oven');	-- 9
select * from cookbook..recipe;
go

insert into cookbook..dish (recipe_id, category_id, dish_name) values
    (1, 2, 'burger'),
    (9, 2, 'steak');
select * from cookbook..dish;
go
