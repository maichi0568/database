--11
select (s.last_name||' '||s.first_name) as student_name,
		(DATE_PART('year', current_date) - DATE_PART('year', dob)) as age
from student s
where (DATE_PART('year', current_date) - DATE_PART('year', dob))>=25;
--12
select s.*
from student s
where date_part('year', dob)=1999
	and date_part('month', dob)=6;
--So mon hoc sinh vien co mssv 20160001 da hoc
select count(distinct e.subject_id)
from student s, enrollment e
where s.student_id=e.student_id
	and s.student_id='20160001';
--13
select name, count(*) as total 
from clazz 
group by (clazz_id) 
order by (total) desc, (name) asc;
--14
select min(midterm_score) as min, max(midterm_score) as max, avg(midterm_score),2 as avg
from enrollment e, subject s
where e.semester='20172'
	and e.subject_id=s.subject_id
	and s.name='CSDL'
--15
select lecturer_id, concat(last_name,' ',first_name) as name_lecturer, count(*)
from lecturer join teaching using (lecturer_id)
group by (lecturer_id)
order by (count) desc, (first_name) asc, (last_name) asc
--16
select subject_id, subject.name , count(*) as lecturers_in_charge
from subject join teaching using(subject_id)
group by (subject_id)
having count(*) >= 2
order by subject_id
--17
select s.subject_id, count(lecturer_id)
from subject s left join teaching t on s.subject_id=t.subject_id
group by s.subject_id
having count(lecturer_id)<2
--18
with tmp as (
select student_id, (en.midterm_score * (1 - s.percentage_final_exam / 100.0)) +
(en.final_score * s.percentage_final_exam / 100.0) as diem_hocphan
from enrollment en
inner join subject s on s.subject_id = en.subject_id
where s.subject_id = 'IT3080'
and semester = '20172'
)
select s.student_id, last_name || ' ' || first_name
from tmp t join student s
on (s.student_id = t.student_id)
where diem_hocphan = (select max(diem_hocphan) from tmp);