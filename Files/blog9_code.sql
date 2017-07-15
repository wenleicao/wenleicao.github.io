create table tmp_customer_info1
(
customerId int,
name varchar(20), 

city varchar(20)
);

insert into tmp_customer_info1
select 1, 'Tom', 'boston' from DUAL
union all
select 2, 'Jenny', 'New York City' from Dual
union all
select 3, 'Alex', 'Philly' from dual
union all
select 4, 'Mike', 'Washington D.C.' from dual

select * from tmp_customer_info1

create table tmp_customer_info2
(
customerId int,
name varchar(20), 

city varchar(20)
);

insert into tmp_customer_info2
select 1, 'Tom', 'boston' from DUAL
union all
select 2, 'Jennifer', 'New York City' from Dual
union all
select 3, 'Alex', 'Seattle' from dual
union all
select 4, 'Michael', 'Huston' from dual

select * from tmp_customer_info2
commit