insert into cookbook..category (category_name) values
    ('breakfast'),  -- 1
    ('lunch'),      -- 2
    ('dinner'),     -- 3
    ('drink'),      -- 4
    ('dessert');    -- 5
select * from cookbook..category;
go

insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\burger.jpg', single_blob) as image;		-- 1
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\coffee.jpg', single_blob) as image;		-- 2
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\cornflakes.jpg', single_blob) as image;	-- 3
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\friedeggs.jpg', single_blob) as image;	-- 4
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\icecream.jpg', single_blob) as image;	-- 5
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\pancake.jpg', single_blob) as image;		-- 6
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\salmon.jpg', single_blob) as image;		-- 7
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\sandwich.jpg', single_blob) as image;	-- 8
insert into cookbook..picture (picture)
    select * from openrowset(bulk N'p:\zad2\images\steak.jpg', single_blob) as image;		-- 9
select * from cookbook..picture;
go

insert into cookbook..recipe (content) values
	('take a bum and slam some cheese and ham'),	-- 1
	('take a couple spoons of coffee and pour some water'),	-- 2
	('first the corn flakes, then add milk'),	-- 3
	('eggs go skrrt'),	-- 4
	('frozen mousse'),	-- 5
	('eggs with flour, pour some syroup'),	-- 6
	('smoked salmon, put it on bread and sprinkle with lemon'),	-- 7
	('bread with ham, eggs, pickle and tomato'),	-- 8
	('meat from oven');	-- 9
select * from cookbook..recipe;
go

insert into cookbook..dish (picture_id, recipe_id, category_id, dish_name) values
    (1, 1, 2, 'burger'),
    (2, 2, 4, 'coffee'),
    (3, 3, 1, 'corn flakes'),
    (4, 4, 1, 'fried eggs'),
    (5, 5, 5, 'ice cream'),
    (6, 6, 5, 'pancakes'),
    (7, 7, 3, 'salmon'),
    (8, 8, 3, 'sandwich'),
    (9, 9, 2, 'steak');
select * from cookbook..dish;
go
