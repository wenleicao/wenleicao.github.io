 drop table if exists #UnPivotMe
 CREATE TABLE #UnPivotMe (
    FirstName varchar(255) NOT NULL, 
    LastName varchar(255) NOT NULL,
    Question1 varchar(1000) Not  NULL,
    Answer1 varchar(1000)  NULL,
    Question2 varchar(1000) Not NULL,
    Answer2 varchar(1000)  NULL,
    Question3 varchar(1000) NOT NULL,
    Answer3 varchar(1000) NULL,
    Question4 varchar(1000) NOT NULL,
    Answer4 varchar(1000) NULL,
    Question5 varchar(1000) NOT NULL,
    Answer5 varchar(1000)  NULL
    )

	INSERT INTO #UnPivotMe VALUES
   ('Kenneth','Fisher','What is your first name?','Kenneth','What is your favorite color?','green','What do you do for a living?','Not much',
           'What is 2x3','6','Why?','Because'),
   ('Bob','Smith','What is your first name?','Robert','What is your favorite color?','blue','What is 4x7?','238',
           'What is 7x6','Life the Universe and Everything','Why?','Why not'),
   ('Jane','Doe','What is your first name?','John','What is your favorite color?','plaid','What do you do for a living?','Door to door salesman',
           'What is 3/4','.75','Why?','yes'),
   ('Prince','Charming','What is your first name?','George','What is your favorite color?','Orange','What do you do for a living?','Not much',
           'What is 1235x523','Yea right','Why?','no'),
	('Test','Null','What is your first name?',null,'What is your favorite color?',null,'What do you do for a living?',null,
           'What is 1235x523',null,'Why?',null),
	('Test2','not Null','What is your first name?',null,'What is your favorite color?',null,'What do you do for a living?','IT',
           'What is 1235x523',null,'Why?',null)


select * from #UnPivotMe --where Coalesce(answer1, answer2, answer3, answer4, answer5, null) is not null

SELECT #UnPivotMe.FirstName, #UnPivotMe.LastName, 
        CrossApplied.Question, CrossApplied.Answer
FROM #UnPivotMe
CROSS APPLY (VALUES (Question1, Answer1),
                    (Question2, Answer2),
                    (Question3, Answer3),
                    (Question4, Answer4),
                    (Question5, Answer5)) 
            CrossApplied (Question, Answer)

--use unpivot instead to do similar thing
-- Create the table and insert values as portrayed in the previous example.  


select * from #UnPivotMe

--get question only
select 
FirstName,
LastName,
QN,
Question
from 
(SELECT 
    FirstName,
	LastName,
	Question1,
	Question2,
	Question3,
	Question4,
	Question5
	FROM #UnPivotMe
  ) d
unpivot (

Question for QN in  (
	Question1,
	Question2,
	Question3,
	Question4,
	Question5

)
) as unpvt

--get answer only
select 
FirstName,
LastName,
AN,
answer
from 
(SELECT 
    FirstName,
	LastName,
	--Question1,
	Answer1,
	--Question2,
	Answer2,
	--Question3,
	Answer3,
	--Question4,
	Answer4,
	--Question5
	Answer5
  FROM #UnPivotMe
  ) d
unpivot (

answer for AN in  (
	--Question1,
	Answer1,
	--Question2,
	Answer2,
	--Question3,
	Answer3,
	--Question4,
	Answer4,
	--Question5
	Answer5
)
) as unpvt


--you can combine both into one http://sqlbanana.blogspot.com/2014/11/sql-unpivot-on-multiple-columns.html

select 
FirstName,
LastName,
QN,
Question,
AN,
answer
from 
(SELECT 
    FirstName,
	LastName,
	Question1,
	Answer1,
	Question2,
	Answer2,
	Question3,
	Answer3,
	Question4,
	Answer4,
	Question5,
	Answer5
  FROM #UnPivotMe
  ) d
unpivot (
Question for QN in  (
	Question1,
	Question2,
	Question3,
	Question4,
	Question5
)
) as unpvt1
unpivot (

answer for AN in  (
	Answer1,
	Answer2,
	Answer3,
	Answer4,
	Answer5
)
) as unpvt2
where right(QN,1) = right(AN,1)




