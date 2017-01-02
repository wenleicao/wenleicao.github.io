create table tmp.student
(
StudentID int identity ,
StudentName varchar(50)
constraint PK_studentID Primary Key (StudentID)
)


insert into tmp.student (StudentName)
values 
('John'), 
('Mary'),
('Lisa') 

--select * from tmp.student

create table tmp.class
(
ClassID char(1) ,
ClassName varchar(50), 
ClassFee money
constraint PK_ClassID Primary Key (ClassID)
)

insert into tmp.class (ClassID, ClassName, ClassFee)
values 
('A', 'English', 200), 
('B', 'Math', 300),
('C', 'Science', 400 ) 

--select * from tmp.class

create table tmp.mapStudentClass 
(StudentID int, 
ClassID  char(1), 
primary key  (StudentID, ClassID ), 
foreign key (StudentID) References tmp.student (StudentID), 
foreign key (ClassID) References tmp.class (ClassID)
 )

 insert into tmp.mapStudentClass 
 values 
 (1, 'A'),
 (1, 'B'),
 (2, 'B'),
 (2, 'C'),
 (3, 'A')

 select * from 
 tmp.student s 
 join tmp.mapStudentClass m on s.StudentID = m.StudentID
 join tmp.class c on m.ClassID =c.ClassID

 select studentname, sum(classFee)
 from 
 tmp.student s 
 join tmp.mapStudentClass m on s.StudentID = m.StudentID
 join tmp.class c on m.ClassID =c.ClassID
 group by studentname
 order by studentname