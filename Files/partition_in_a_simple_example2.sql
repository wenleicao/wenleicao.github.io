create schema Test
go
create schema TestStage
go

drop table if exists [Test].[Student]
drop table if exists [TestStage].[Student]

IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = 'ps_ETLId')
	DROP PARTITION SCHEME ps_ETLId ;

IF EXISTS (SELECT * FROM sys.partition_functions WHERE name = 'pf_ETLId')
	DROP PARTITION function pf_ETLId;


--create partition function
CREATE PARTITION FUNCTION [pf_ETLId](int) AS RANGE LEFT FOR VALUES (1, 2)

--create partition schema
CREATE PARTITION SCHEME [ps_ETLId] AS PARTITION [pf_ETLId] ALL TO ([Primary])



--create table  
CREATE TABLE [Test].[Student](
	[StudentID] int identity not null,
	StudentName  varchar(20) not null,
	EtlID  int not null
 CONSTRAINT [PK_Student] Primary Key 
(
	[StudentID] ASC,
	[EtlId] ASC
)ON [ps_ETLId] ([EtlId] )
) ON [ps_ETLId] ([EtlId]);
go

SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('Test.Student')
ORDER BY PartitionNumber;

CREATE NONCLUSTERED INDEX ix_Student_StudnetID ON Test.student ([StudentID] ASC) 
CREATE NONCLUSTERED INDEX ix_Student_StudnetName  ON Test.student ([StudentName] ASC) 
go

--let us say we already have some data in the 
insert into [Test].[Student]
select 'Lisa', 1
union
select 'Wenlei', 1


--let us say we do second incremental load, first need to load to stage
drop table if exists TestStage.Student
select * into TestStage.Student  from [Test].[Student] where 2=1   --create a table based  on Student but not include content


--add constraint to this table
--alter table TestStage.Student
--drop constraint  pk_stage_student

alter table TestStage.Student
--add constraint pk_stage_student primary key  ([StudentID],[EtlId])
add CONSTRAINT pk_stage_student Primary key ([StudentID],[EtlId]) on [ps_ETLId] ([EtlId])


--this is need if you need to do a switch
alter table TestStage.Student
add constraint chk_stage_student check (EtlID =2)


declare @id_begin int = (select max(Studentid) from [Test].[Student] ) +1
DBCC CHECKIDENT ('TestStage.Student', RESEED, @id_begin) WITH NO_INFOMSGS;

insert into TestStage.Student  --select * from
select  'Donald Trump', 2


SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('TestStage.Student')
ORDER BY PartitionNumber;

--if your table is big, it is good for performance purpose to drop index and recreate those after ETL complete.
drop index Test.student.ix_Student_StudnetID
drop index Test.student.ix_Student_StudnetName   

select * from Test.Student
ALTER TABLE TestStage.Student SWITCH PARTITION 2  TO Test.Student PARTITION 2;
select * from Test.Student

--add back the non clustered index
CREATE NONCLUSTERED INDEX ix_Student_StudnetID ON Test.student ([StudentID] ASC) 
CREATE NONCLUSTERED INDEX ix_Student_StudnetName  ON Test.student ([StudentName] ASC) 

drop table TestStage.Student

--can you remove PK as well, answer is no  for switch

--switch diable index  and enable index spc_EnableOrDisableNonClusteredIndexes

--what if out of boundry
	ALTER PARTITION SCHEME ps_ETLAggregateId
		NEXT USED [PRIMARY];
ALTER PARTITION FUNCTION pf_EtlID () SPLIT RANGE (3);

SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('Test.Student')
ORDER BY PartitionNumber;

drop table if exists TestStage.Student
select * into TestStage.Student  from [Test].[Student] where 2=1

alter table TestStage.Student
--add constraint pk_stage_student primary key  ([StudentID],[EtlId])
add CONSTRAINT pk_stage_student Primary key ([StudentID],[EtlId]) on [ps_ETLId] ([EtlId])

--alter table TestStage.Student
--drop constraint chk_stage_student 

alter table TestStage.Student
add constraint chk_stage_student check (EtlID =3)


SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('Teststage.Student')
ORDER BY PartitionNumber;


--now you are ready for next cycle


declare @id_begin2 int = (select max(Studentid) from [Test].[Student] ) +1
DBCC CHECKIDENT ('TestStage.Student', RESEED, @id_begin2) WITH NO_INFOMSGS;

insert into TestStage.Student
select  'Bill Clinton', 3
select * from TestStage.Student


drop index Test.student.ix_Student_StudnetID
drop index Test.student.ix_Student_StudnetName  

select * from Test.Student
ALTER TABLE TestStage.Student SWITCH PARTITION 3  TO Test.Student PARTITION 3;
select * from Test.Student

--add back the non clustered index
CREATE NONCLUSTERED INDEX ix_Student_StudnetID ON Test.student ([StudentID] ASC) 
CREATE NONCLUSTERED INDEX ix_Student_StudnetName  ON Test.student ([StudentName] ASC) 

truncate table TestStage.Student

--make this change dynamic
/*****************
pseudo code
1. maintain a ETL execution table, get next id from there. 
2. create dynamic sql from above hard coded script to handle etlID increment, different table,index created and drop
**************/


--for example to add one more partition

declare @etlid int  = (select max(etlid) +1  from yourETLtable),
@sql = 'ALTER PARTITION FUNCTION pf_EtlID () SPLIT RANGE (' + cast(@etlid as varchar(10)) +');'
exec (@sql)


/************************
--clean up
drop table if exists [Test].[Student]
drop table if exists [TestStage].[Student]
IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = 'ps_ETLId')
	DROP PARTITION SCHEME ps_ETLId ;

IF EXISTS (SELECT * FROM sys.partition_functions WHERE name = 'pf_ETLId')
	DROP PARTITION function pf_ETLId;
go
drop schema Test
go
drop schema TestStage
go
****************************/

