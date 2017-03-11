
--drop table test_cdc_1
--drop table test_cdc_2

-- alter table test_cdc_1 modify (CustomerAddress varchar(20))
-- commit

-- customer Jonh, Lisa, Mary is in the table 

create table test_cdc_1 as
select 1 as Customernumber , 'John' as CustomerName, 'NewTon' as CustomerAddress from dual
union all
select 2, 'Kevin', 'Boston' from dual
union all
select 3, 'Lisa', 'Natik' from dual

--select * from test_cdc_1
/************************************************
we want to see change   insert, update and  delete 
we create another table test_cdc_2
***********************************************/

create table test_cdc_2 as
select 1 as Customernumber , 'John' as CustomerName, 'NewTon' as CustomerAddress from dual   --this record no change
union all
select 2, 'Kevin', 'Cambridge' from dual   --Kevin move to cambridge, this is update
union all
select 4, 'Mary', 'Shrewsbury' from dual  --this insert

-- lisa did not show in second table, this record is deleted
--select * from test_cdc_2
--commit


--restore test_cdc_1  by drop and recreate
/************************************************
what if the income data record shows more than once
let us recreate test_cdc_2 to see what happen
***********************************************/

drop table test_cdc_2
create table test_cdc_2 as
select 1 as Customernumber , 'John' as CustomerName, 'NewTon' as CustomerAddress from dual   --this record no change
union all
select 2, 'Kevin', 'Cambridge' from dual   --Kevin move to cambridge, this is update
union all
select 2, 'Kevin', 'Chelsa' from dual   --Kevin moved again, this is update
union all
select 4, 'Mary', 'Shrewsbury' from dual  --this insert
union all
select 4, 'Mary', 'Northboro' from dual   --Mary moved again


--change duplicate

--what if the existing has duplication

create table test_cdc_1 as
select 1 as Customernumber , 'John' as CustomerName, 'NewTon' as CustomerAddress from dual
union all
select 2, 'Kevin', 'Boston' from dual
union all
select 2, 'Kevin', 'Lexinton' from dual
union all
select 3, 'Lisa', 'Natik' from dual

create table test_cdc_2 as
select 1 as Customernumber , 'John' as CustomerName, 'NewTon' as CustomerAddress from dual   --this record no change
union all
select 2, 'Kevin', 'Cambridge' from dual   --Kevin move to cambridge, this is update
union all
select 4, 'Mary', 'Shrewsbury' from dual

