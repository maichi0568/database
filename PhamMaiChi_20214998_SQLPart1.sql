--1
select subject_id from subject where credit>=5;
--2
select * from student full outer join clazz on student.clazz_id=clazz.clazz_id where clazz.name='CNTT1.01-K61'; 
--3
select student.* from student full outer join clazz on student.clazz_id=clazz.clazz_id where clazz.name like '%CNTT%'; 
--4
select student.* from student, enrollment, subject where student.student_id=enrollment.student_id and enrollment.subject_id=subject.subject_id and subject.name='CSDL'
intersect
select student.* from student, enrollment, subject where student.student_id=enrollment.student_id and enrollment.subject_id=subject.subject_id and subject.name='HM';
--5
select distinct * from student full outer join clazz on student.clazz_id=clazz.clazz_id where clazz.name='Java Programming'or clazz.name='Embedded Programming';
--6
select subject_id 
from subject 
except 
select subject.subject_id 
from enrollment, subject 
where enrollment.subject_id=subject.subject_id; 
--7
select sj.subject_id, sj.name
from student s, subject sj, enrollment e
where s.student_id=e.student_id 
	and e.subject_id=sj.subject_id
	and e.semester='20171'
	and s.first_name='Ngọc An'
	and s.last_name='Bùi'
--8
select s.student_id, (s.last_name||' '||s.first_name) as name, midterm_score, final_score, (midterm_score*(100-sj.percentage_final_exam)/100+final_score*sj.percentage_final_exam/100) as subjectscore
from student s, enrollment e, subject sj
where s.student_id=e.student_id and e.subject_id=sj.subject_id
		and sj.name='CSDL' and e.semester='20172';
--9
select distinct s.student_id
from student s, subject sj, enrollment e
where s.student_id=e.student_id and e.subject_id=sj.subject_id
		and sj.subject_id='IT1110' and e.semester='20171'
		and midterm_score <3 or final_score <3 
		or (midterm_score*(100-sj.percentage_final_exam)/100+final_score*sj.percentage_final_exam/100)<4;
--10
select s.*, c.name, c.monitor_id
from (student s left join clazz c on s.clazz_id=c.clazz_id)
	left join student m on c.monitor_id=m.student_id;
