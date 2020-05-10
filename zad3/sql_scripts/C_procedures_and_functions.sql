use cookbook
go

-- procedure #1: import_xml
if exists (select 1 from sysobjects where name='import_xml')
    drop procedure import_xml
go

create procedure import_xml (@path nvarchar(200)) as
begin
    declare @sql nvarchar(400);
    set nocount on
    set @sql = 'insert into files ' +
                'select * from openrowset(bulk N''' + @path + ''', single_blob) as doc;'
    exec(@sql)
    set nocount off
end
go

-- procedure #2: export_xml
if exists (select 1 from sysobjects where name='export_xml')
    drop procedure export_xml
go

create procedure export_xml (@table nvarchar(50), @path nvarchar(200), @instance_name nvarchar(100)) as
begin
    declare @cmd nvarchar(400);
    set nocount on
    set @cmd = N'bcp "select * from ' + @table + N' for xml auto, elements" queryout "' + @path + N'" -w -t; -T -S ' + @instance_name
    exec xp_cmdshell @cmd
    set nocount off
end
go

-- procedure #3: view_dishes
if exists (select 1 from sysobjects where name='view_dishes')
    drop procedure view_dishes
go

create procedure view_dishes (@file_id int) as
begin
    declare @xml as xml
    declare @doc as int

    select @xml = document from files where id = @file_id

    exec sp_xml_preparedocument @doc output, @xml

    select * from openxml(@doc, 'cookbook/dishes/dish', 2)
    with (dish_id varchar(10) '@did',
          recipie_id varchar(10) '@rid',
          category_id varchar(10) '@cid',
          name text 'name')

    exec sp_xml_removedocument @doc
end
go

-- procedure #4: view_recipes
if exists (select 1 from sysobjects where name='view_recipes')
    drop procedure view_recipes
go

create procedure view_recipes (@file_id int) as
begin
    declare @xml as xml
    declare @doc as int

    select @xml = document from files where id = @file_id

    exec sp_xml_preparedocument @doc output, @xml

    select * from openxml(@doc, 'cookbook/recipes/recipe', 2)
    with (recipe_id varchar(10) '@rid',
          content text '.')

    exec sp_xml_removedocument @doc
end
go

-- procedure #5: view_categories
if exists (select 1 from sysobjects where name='view_categories')
    drop procedure view_categories
go

create procedure view_categories (@file_id int) as
begin
    declare @xml as xml
    declare @doc as int

    select @xml = document from files where id = @file_id

    exec sp_xml_preparedocument @doc output, @xml

    select * from openxml(@doc, 'cookbook/categories/category', 2)
    with (category_id varchar(10) '@cid',
          name text '.')

    exec sp_xml_removedocument @doc
end
go
