-- procedure #1: load_from_file
select * from cookbook..files
go
exec cookbook..import_xml 'C:\Users\Tomek\Repos\studia\RMSBD\zad3\xmls\full.xml';
select * from cookbook..files
go

-- procedure #2:
exec cookbook..export_xml 'cookbook..files', "C:\Users\Tomek\Repos\studia\RMSBD\zad3\xmls\sav.xml";

-- procedure #3: view_dishes <file_id>
exec cookbook..view_dishes 3

-- procedure #4: view_recipes <file_id>
exec cookbook..view_recipes 2

-- procedure #5: view_categories <file_id>
exec cookbook..view_categories 2


-- EXEC xp_cmdshell 'whoami /all'
-- EXEC xp_cmdshell 'bcp "SELECT * FROM cookbook..files FOR XML AUTO, ELEMENTS" queryout "P:\xmls\sav.xml" -c -w -t -T -S DESKTOP-TAVGN6D\SQLEXPRESS'
