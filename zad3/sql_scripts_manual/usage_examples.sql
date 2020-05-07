-- procedure #1: load_from_file
select * from cookbook..files
go
exec cookbook..import_xml 'P:\xmls\categories.xml';
select * from cookbook..files
go

-- procedure #2:
EXEC xp_cmdshell 'whoami /all'
exec cookbook..export_xml 'cookbook..files', 'P:\xmls\sav.xml';


EXEC xp_cmdshell 'bcp "SELECT * FROM cookbook..files FOR XML AUTO, ELEMENTS" queryout "P:\xmls\sav.xml" -c -w -t -T -S DESKTOP-TAVGN6D\SQLEXPRESS'
