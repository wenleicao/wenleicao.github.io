database dl_A036898cw;  --database you are using

CREATE VOLATILE TABLE Variables
(
TargetYear  int,
TargetYearBegin date,
TargetYearEnd date,
Prior2YearBegin date,
Prior4YearBegin date
) NO Primary index 
ON COMMIT PRESERVE ROWS;

INSERT INTO Variables --(VariableValue)
VALUES (
2018,
to_date(cast(2018 as char(4)) || '-01-01'),
to_date(cast(2018 as char(4)) || '-12-31'),
to_date(cast(2018-2 as char(4)) || '-01-01'),
to_date(cast(2018-4 as char(4)) || '-01-01')
);

select * from Variables ;


--create dummy student to test variables
--https://stackoverflow.com/questions/49901803/what-is-teradatas-equivalent-for-oracles-dual
CREATE VOLATILE TABLE students as (
select 'wenlei' as StudentName, '2015-09-01' as EnrollmentDate FROM (SELECT 1 AS "DUMMY") AS "DUAL"
union
select 'Joe', '2017-01-01'  FROM (SELECT 1 AS "DUMMY") AS "DUAL"
union 
select 'Donald', '2018-09-01' FROM (SELECT 1 AS "DUMMY") AS "DUAL"
union
select 'Hillary', '2014-09-01' FROM (SELECT 1 AS "DUMMY") AS "DUAL"
)
with data 
NO Primary index 
ON COMMIT PRESERVE ROWS;

--select * from students

-- look back 2 year

select 
a.studentname,
a.enrollmentdate
from students a
cross join Variables b
where a.enrollmentdate between b.Prior2YearBegin and b.TargetYearEnd;

--look back 4 year

select 
a.studentname,
a.enrollmentdate
from students a
cross join Variables b
where a.enrollmentdate between b.Prior4YearBegin and b.TargetYearEnd;



--since each year, the base year will shift, to do it dynamically, I create a sp and pass the variable year in

replace procedure  getLastFourYearStudent (IN year_var int)
   begin

   BEGIN
      -- simply try dropping the table and ignore the "table doesn't exist error"
      DECLARE exit HANDLER FOR SQLEXCEPTION
      BEGIN  -- 3807 = table doesn't exist
         IF SQLCODE <> 3807 THEN RESIGNAL; END IF;
      END;
      DROP TABLE Variables;
      DROP TABLE students;
      DROP TABLE LastFourYearStudent;
   END;
   
  CREATE VOLATILE TABLE Variables
(
TargetYear  int,
TargetYearBegin date,
TargetYearEnd date,
Prior2YearBegin date,
Prior4YearBegin date

) NO Primary index 
ON COMMIT PRESERVE ROWS;

INSERT INTO Variables --(VariableValue)
VALUES (
:year_var,
to_date(cast(:year_var as char(4)) || '-01-01'),
to_date(cast(:year_var as char(4)) || '-12-31'),
to_date(cast(:year_var-2 as char(4)) || '-01-01'),
to_date(cast(:year_var-4 as char(4)) || '-01-01')
);
 
--create dummy student to test variables

CREATE VOLATILE TABLE students as (
select 'wenlei' as StudentName, '2015-09-01' as EnrollmentDate FROM (SELECT 1 AS "DUMMY") AS "DUAL"
union
select 'Joe', '2017-01-01'  FROM (SELECT 1 AS "DUMMY") AS "DUAL"
union 
select 'Donald', '2018-09-01' FROM (SELECT 1 AS "DUMMY") AS "DUAL"
union
select 'Hillary', '2014-09-01' FROM (SELECT 1 AS "DUMMY") AS "DUAL"
)
with data 
NO Primary index 
ON COMMIT PRESERVE ROWS;

create table LastFourYearStudent as (
select 
a.studentname,
a.enrollmentdate
from students a
cross join Variables b
where a.enrollmentdate between b.Prior4YearBegin and b.TargetYearEnd
)
with data;

end;

--test
call dl_A036898CW.getLastFourYearStudent (2018);
select * from LastFourYearStudent;

call getLastFourYearStudent (2019);
select * from LastFourYearStudent;