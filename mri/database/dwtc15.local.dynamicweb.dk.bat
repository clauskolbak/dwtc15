@echo off

set generator=c:\Projects\SQLGenerator\SQLGenerator\bin\Release\SQLGenerator.exe

set dbHost=localhost\MSSQLSERVER2014
set dbName=dwtc15.local.dynamicweb.dk
set tableNames=Area Page Paragraph ItemType_Dwtc15_*
rem set tableNames=ItemType_Dwtc15_Paragraph
set outputFileName=%dbName%.sql

echo WARNING: Running this script will delete all data in the database > %outputFileName%
echo WARNING: Remove these lines to be able to run the script >> %outputFileName%
echo. >> %outputFileName%

echo drop %dbHost% %dbName% %tableNames%
%generator% drop %dbHost% %dbName% %tableNames% >> %outputFileName%
echo.

echo schema %dbHost% %dbName% %tableNames%
%generator% schema %dbHost% %dbName% %tableNames% >> %outputFileName%
echo.

echo data %dbHost% %dbName% %tableNames%
%generator% data %dbHost% %dbName% %tableNames% >> %outputFileName%
echo.

setlocal EnableDelayedExpansion

set sql=/* Update item type ids */^

declare @c as cursor^

set @c = cursor for select replace(name, 'ItemType_', '') from sys.tables where name like 'ItemType_Dwtc15_%'^

declare @itemType as nvarchar(max)^

^

open @c^

fetch next from @c into @itemType^

while @@FETCH_STATUS = 0^

begin^

	declare @count as int^

	declare @sql as nvarchar(max) = 'select @count = max(Id) from ItemType_'+@itemType^

	exec sp_executesql @sql, N'@count int output', @count = @count output^

	if @count is not null^

	begin^

		if exists(select * from ItemTypeId where ItemType = @itemType)^

		  update ItemTypeId set [Current] = @count where ItemType = @itemType^

		else^

		  insert ItemTypeId([ItemType], [Current], [Seed]) values (@itemType, @count, 1)^

	  end^

	fetch next from @c into @itemType^

end^

close @c^


echo !sql! >> %outputFileName%

echo Sql script written to %outputFileName%
