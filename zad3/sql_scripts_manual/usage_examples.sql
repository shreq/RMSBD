-- procedure #1: load_from_file
select * from cookbook..files
go
exec cookbook..import_xml 'P:\xmls\full.xml';
select * from cookbook..files
go

-- procedure #2:
exec cookbook..export_xml 'cookbook..files', 'P:\xmls\sav.xml', 'DESKTOP-TAVGN6D\SQLEXPRESS';

-- procedure #3: view_dishes <file_id>
exec cookbook..view_dishes 1;

-- procedure #4: view_recipes <file_id>
exec cookbook..view_recipes 1;

-- procedure #5: view_categories <file_id>
exec cookbook..view_categories 1;
