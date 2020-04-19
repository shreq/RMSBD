-- procedure #1: load_from_file
    select * from cookbook..picture
    go
    exec cookbook..load_from_file 'p:\zad2\images\pancake.jpg';
    select * from cookbook..picture
    go

-- procedure #2: save_to_file
    exec cookbook..save_to_file 1, 'p:\zad2\save.jpg';
    go

-- procedure #3: load_from_folder
    exec cookbook..load_from_folder 'p:\zad2';
    go

-- procedure #5: change_format
	-- the procedure takes as a format JPEG or PNG
	exec cookbook..change_format 1, 'PNG'
	go