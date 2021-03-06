USE [BeaconDM]
GO
/****** Object:  StoredProcedure [dbo].[USP_Build_String]    Script Date: 8/25/2017 7:45:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------
--Author: Wenlei Cao
--create date: Aug 22, 2017
--can use any linked database  
--sanwich column name with *, data type with # to let sp know where to modify, also replace ' with ` in your string 
--exec [dbo].[USP_Build_String] 'beacondm.tmp.edinewformat', '*plangroupsk* #int#,'
--exec [dbo].[USP_Build_String] 'tempdb..##tmpedinewformat', '*plangroupsk* #int#,'
--exec [dbo].[USP_Build_String] 'beacondm.tmp.edinewformat', '"*MemberSK* #int#," +"\n" +'
--exec [dbo].[USP_Build_String]  'beacondw.star.factclaimline', '`select `+ *plangrousk* +` from `'
--------------------------------

ALTER proc  [dbo].[USP_Build_String] (@TablePath  varchar (50), @StringSample varchar(max))

as

--declare @StringSample varchar(max), @TablePath  varchar (50)

--I need to define where columnname is and datatype is; *...* means columnname   #...# means datatype, single quotation use ` to replace
--select @StringSample = '*plangroupsk* #int#,', @TablePath = 'tempdb..#temp2'   

declare @DatabaseName varchar(50), @ColumnName varchar(50), @DataType varchar(20),
		 @TableName varchar(50),  @object_id int, @sql varchar(max)
--declare @destinationtable table (expression_wanted varchar(max)) 


set @databaseName = left (@TablePath , charindex ('.', @TablePath )-1)
set @tableName = right (@TablePath , charindex ('.', reverse(@TablePath )) -1)
set @ColumnName  = substring (@StringSample, charindex('*', @StringSample) , 
							charindex('*', @StringSample, charindex('*', @StringSample)+1) - charindex('*', @StringSample) +1)
set @DataType = substring (@StringSample, charindex('#', @StringSample) , 
					charindex('#', @StringSample, charindex('#', @StringSample)+1) - charindex('#', @StringSample) +1)


--select @databasename, @tablename, @columnName, @DataType

--regular table use information schema
if @databaseName <> 'tempdb'

begin
	/*****************************
	select 
	replace(replace(replace (@StringSample, @ColumnName, COLUMN_NAME), 
	@DataType,  case when DATA_TYPE in( 'varchar', 'Nvarchar', 'char') then Data_type + ' (' + cast(CHARACTER_MAXIMUM_LENGTH as varchar(5)) + ')' else DATA_TYPE end  ),
	 '`', '''')
	from INFORMATION_SCHEMA.columns  --need to change database name here
	where table_name = @TableName 
	*************************************/

	--need to use dynamic sql to pass @databasename value to query
	select @sql = 'select  ' +
	'replace(replace(replace (''' + @StringSample + ''', ''' + @ColumnName + ''', COLUMN_NAME), ''' +  @DataType  + ''',  case when DATA_TYPE in( ''varchar'', ''Nvarchar'', ''char'') then Data_type + '' ('' + cast(CHARACTER_MAXIMUM_LENGTH as varchar(5)) + '')'' else DATA_TYPE end  ), ''`'', '''''''')' + 
	--'replace(replace (' + '''' + @StringSample + ''', ' + '''' + @ColumnName + ''', COLUMN_NAME), ' + '''' + @DataType + ''',  ' + 'case when DATA_TYPE in( ''varchar'', ''Nvarchar'', ''char'') then Data_type + '' ('' + cast(CHARACTER_MAXIMUM_LENGTH as varchar(5)) + '')'' else DATA_TYPE end  )' +
	--'replace (' + ''''+ @StringSample + ''', ' + '''' + @ColumnName + ''', COLUMN_NAME)' +
	--'replace (' + ''''+ @StringSample + ''', ' + '''' + @ColumnName + ''', COLUMN_NAME)' +
	'from ' 	+ @DatabaseName + '.INFORMATION_SCHEMA.columns where table_name = ' + ''''+ @TableName + '''' 
		
	EXEC ( @Sql)

end

else 
begin
--temp table use the system table,  cannot use @tablepath in object_id, has to use dynamic sql

	set @tablepath = 'N''tempdb..' +@TableName + ''''
	set @object_id = OBJECT_ID('tempdb..' +@TableName )
--select @tablepath, @object_id

	SELECT 
	replace(replace(replace (@StringSample, @ColumnName, c.name),
	 @DataType,  case when t.name in( 'varchar', 'Nvarchar', 'char') then t.name + ' (' + cast(c.max_length as varchar(5)) + ')' else t.name end  )
	 , '`', '''')

	FROM tempdb.sys.columns c 
	join tempdb.sys.types t on c.system_type_id = t.system_type_id 
	WHERE [object_id] = @object_id

	
end


