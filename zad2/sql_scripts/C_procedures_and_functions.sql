use cookbook
go

    --if exists (select 1 from sys.server_principals where name='user_')
    --    drop login [user_]
    --go
    --create login [user_] with password = 'user_'
    --go
    --alter server role [bulkadmin] add member [windws_user]
    --go

-- procedure #1: load_from_file
	if exists (select 1 from sysobjects where name='load_from_file')
		drop procedure load_from_file
	go

	create procedure load_from_file (@path nvarchar(200)) as
	begin
        declare @sql nvarchar(400);
		set nocount on
		set @sql = 'insert into cookbook..picture (picture) ' +
                   'select * from openrowset(bulk N''' + @path + ''', single_blob) as image;'
        exec(@sql)
        set nocount off
	end
	go

-- procedure #2: save_to_file
	if exists (select 1 from sysobjects where name='save_to_file')
		drop procedure save_to_file
	go

    create procedure save_to_file (@id int, @path nvarchar(200)) as
    begin
        declare @picture varbinary(max);
        declare @object int
        set nocount on
        select @picture = (
            select picture from cookbook..picture where picture_id = @id
        )
        begin try
            exec sp_oacreate 'adodb.stream', @object output;
            exec sp_oasetproperty @object, 'type', 1;
            exec sp_oamethod @object, 'open';
            exec sp_oamethod @object, 'write', null, @picture;
            exec sp_oamethod @object, 'savetofile', null, @path, 2;
            exec sp_oamethod @object, 'close';
            exec sp_oadestroy @object;
        end try
        begin catch
			print 'en error occured'
            exec sp_oadestroy @object;
        end catch
        set nocount off
    end
    go

-- procedure #3: load_from_folder
	if exists (select 1 from sysobjects where name='load_from_folder')
		drop procedure load_from_folder
	go

    create procedure load_from_folder (@path nvarchar(200)) as
    begin
        set @path = replace(@path, '''', '''''')
        declare @files table (file_ varchar(max));
        declare @cmd nvarchar(400) = N'exec xp_cmdshell ''dir ' + @path + '*.jpg /b''';
        declare @sql nvarchar(max) = '';
        set nocount on
        insert @files exec(@cmd);

        with asd as (
            select file_ = @path from @files where file_ is not null
        )
        select @sql = @sql + N'insert picture (picture) values ' +
                              '((select * from openrowset(bulk ''' + file_ + ''', single_blob) as image));'
        from asd;
        exec(@sql);
        set nocount off
    end
    go

-- procedure #4: scale_image
	if exists (select 1 from sysobjects where name='scale_image')
		drop procedure scale_image
	go

-- procedure #5: change_format
if exists (select 1 from sysobjects where name='change_format')
	drop procedure change_format
go

create procedure change_format (@id int, @format nvarchar(200)) as
begin
	declare @ret varbinary(max)
	declare @sql nvarchar(1000)
	set @sql = N'SELECT picture FROM picture where picture_id = ' + str(@id)
    set nocount on
	begin try
		exec sp_execute_external_script @language = N'Python'
		, @script = N'
from PIL import Image
import io

im = Image.open(io.BytesIO(InputDataSet.iloc[0].picture))
with io.BytesIO() as f:
	im.save(f, format=file_format)
	ret = f.getvalue()
'
		, @input_data_1 = @sql
		, @params = N'@file_format nvarchar(100), @ret varbinary(max) output'
		, @file_format = @format
		, @ret = @ret output

		update picture
		set picture = @ret
		where picture_id = @id
	end try
	begin catch
        print 'there was an error'
    end catch
    set nocount off
end
go

--
