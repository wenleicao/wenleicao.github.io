declare 
@date varchar(30) = format (getdate(), 'MM-dd-yyyy'),
@delaydatetime datetime, 
@delayperiod  varchar(20),
@sql varchar(200)
set  @delaydatetime = convert (datetime, @date + ' 22:00:00',  101) 
select @delayperiod = convert(varchar,  DATEADD(ss,datediff(ss, getdate(), @delaydatetime),CAST('00:00:00' AS TIME)), 108)

select @sql = 'waitfor delay' + ' ''' +@delayperiod + ''''

select @date, @delaydatetime, @delayperiod, @sql
--select @sql


if getdate() >= @delaydatetime
waitfor delay '00:00:00'
else 
exec (@sql)
