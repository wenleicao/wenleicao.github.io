create table tmp.sales_raw
(
Saleid int identity primary key,
Customer varchar(30), 
SaleAmount money,
SaleDate  date
)

insert into tmp.sales_raw
values 
('Mike', 10, '2020-01-01'),
('Susan', 20, '2020-01-01'),
(null, 50, '2020-01-02'),
('Jennifer', 30, '2020-01-05'),
('Bob', 5, '2020-01-01'),
(null, 7, '2020-01-03'),
(null, 2, '2020-01-06')

--truncate table tmp.sales_raw
select * from  tmp.sales_raw

select 
o.Saleid, 
o.Customer, 
backfilledCustomer = case when o.Customer is not null then o.Customer
						else (select top 1 i.customer from tmp.sales_raw i 
						where i.Saleid < o.Saleid and i.Customer is not null 
						order by i.Saleid desc )  
						end ,
o.SaleAmount,
o.SaleDate
from 
tmp.sales_raw o


