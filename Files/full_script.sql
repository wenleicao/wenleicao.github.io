--create some fake record
drop table if exists #tmp_fakeMedicalRecord
create table #tmp_fakeMedicalRecord
(RecordID char(9),
PatientID char(12), 
[adm_dt] smalldatetime,
[disch_dt] smalldatetime, 
readmissionflag bit)

insert into #tmp_fakeMedicalRecord
values
('000000001', '0001111111', '2015-02-11', '2015-02-15', 0),
('000000002', '0001111111', '2015-03-16', '2015-03-19', 1),
('000000003', '0001111111', '2015-03-26', '2015-03-30', 0),
('000000004', '0001111111', '2015-04-01', '2015-04-09', 1),
('000000005', '0001111111', '2015-04-14', '2015-04-17', 1),
('000000006', '0001111111', '2015-04-29', '2015-05-05', 1),
('000000007', '0001111111', '2015-06-01', '2015-06-17', 0),
('000000008', '0001111111', '2015-07-15', '2015-07-23', 1),
('000000009', '0001111111', '2015-10-01', '2015-10-02', 0),
('000000010', '0001111111', '2015-10-08', '2015-10-12', 1),
('000000011', '0001111111', '2015-12-31', '2016-01-29', 0),
('000000012', '0001111111', '2016-02-02', '2016-03-17', 1)
--select * from #tmp_fakeMedicalRecord


drop table if exists #tmp_readmission_rank
select 
*,
row_number () over (partition by patientid order by PatientID, disch_dt, adm_dt, recordid) as [rank]
into #tmp_readmission_rank
from  #tmp_fakeMedicalRecord
select * from #tmp_readmission_rank

--compare next record in the same PatientID to see what interval between
drop table if exists #tmp_readmission_interval
select 
*,
lag (disch_dt) over (partition by PatientID order by rank) as prevdisch,
datediff(d, lag(disch_dt) over (partition by PatientID order by rank), adm_dt ) as interval
into  #tmp_readmission_interval
from #tmp_readmission_rank
--select * from #tmp_readmission_interval

drop table if exists #tmp_readmission_block
select 
*,
case when interval < 31 then 1 else 0 end as block

--datediff (d, first_value(disch_dt) over (partition by PatientID order by disch_dt),  adm_dt) as totaldayfromfirst
into #tmp_readmission_block
from #tmp_readmission_interval
--select * from #tmp_readmission_block


drop table if exists #tmp_readmission_segment
select 
* ,
sum(iif(block=0, 1, 0)) over (partition by PatientID order by rank) as segment   --using running total to create segment
into #tmp_readmission_segment
from #tmp_readmission_block
--select * from #tmp_readmission_segment

drop table if exists #tmp_readmission_datediffinsegment1
select 
*,
datediff (d, first_value(disch_dt) over (partition by PatientID,segment order by rank),  adm_dt) as totaldayfromfirst  --count from the first record
into #tmp_readmission_datediffinsegment1
from #tmp_readmission_segment

--select * from  #tmp_readmission_datediffinsegment1

--add previous row to the same row to compare
drop table if exists #tmp_readmission_datediffinsegment1a
select 
*,
lag(totaldayfromfirst) over (partition by PatientID, segment order by rank) as prevtotaldayfromfirst
into #tmp_readmission_datediffinsegment1a
from #tmp_readmission_datediffinsegment1
--select *from #tmp_readmission_datediffinsegment1a


update #tmp_readmission_datediffinsegment1a
set block =0
where totaldayfromfirst >30 and prevtotaldayfromfirst<=30
select *from #tmp_readmission_datediffinsegment1a

			 



