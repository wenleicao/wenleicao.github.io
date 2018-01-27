

create table tmpTest as
select 'Alexis' as name, 'Finance' as dept, 1000 as salary from dual
union all 
select 'Brian', 'IT', 2000 from dual
union all
select 'Cathie', 'Finance', 3000 from dual
union all
select 'David', 'IT', 4000 from dual
union all
select 'Elaine', 'IT', 5000 from dual

select * from tmpTest

--group by department, order by salary ascending
select 
name,
dept,
salary,
lag (salary) over (partition by dept order by SALARY ) as  prevSalary,  --get previous lower salary in the same dept 
lead (salary) over (partition by dept order by SALARY ) as nextSalary,  --get next higher salary in the same dept
sum(salary) over (partition by dept order by SALARY ) as accumSalary    --accumulate salary in the same dept
from tmpTest
order by DEPT










