-- procedure #1: load_from_file
select * from cookbook..picture
go
exec cookbook..load_from_file 'P:\zad2\images\pancake.jpg';
select * from cookbook..picture
go

-- procedure #2: save_to_file
exec cookbook..save_to_file 1, 'P:\zad2\test.jpg';
go

-- procedure #3: load_from_folder
select * from cookbook..picture
go
exec cookbook..load_from_folder 'P:\zad2\images\';
go
select * from cookbook..picture
go

-- procedure #4: resize
exec cookbook..resize 1, 400, 200;
go

-- procedure #5: change_format
-- the procedure takes as a format JPEG or PNG
exec cookbook..change_format 1, 'PNG'
go

-- result procedures #4 & #5
exec cookbook..save_to_file 1, 'P:\zad2\auc.png';
go
