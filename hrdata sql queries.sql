
create table hrdata
(
	emp_no int PRIMARY KEY,
	gender varchar(50) NOT NULL,
	marital_status varchar(50),
	age_band varchar(50),
	age int,
	department varchar(50),
	education varchar(50),
	education_field varchar(50),
	job_role varchar(50),
	business_travel varchar(50),
	employee_count int,
	attrition varchar(50),
	attrition_label varchar(50),
	job_satisfaction int,
	active_employee int
)

--Viewing all the columns in the table

select * from hrdata;

--Inserted data through import process by matching the fields/columns of the source table with the table created above


--Employee Count

select sum(employee_count) employee_count 
from hrdata

--Employee Count based on a filter

select sum(employee_count) employee_count 
from hrdata
where education = 'High School';

--Employee Count - Department wise

select sum(employee_count) employee_count 
from hrdata
where department = 'Sales';

--Employee Count - Education Field wise

select sum(employee_count) employee_count 
from hrdata
where education_field = 'Medical';


--Attrition Count

select 
sum(case when attrition = 'yes' then 1 else 0 end) as attrition_count
from hrdata;

------------another method for attrition count

select count(attrition) as attrition_count
from hrdata
where attrition = 'yes';


--Attrition count based on education

select count(attrition) as attrition_count
from hrdata
where attrition = 'yes' and education = 'Doctoral Degree';


--Attrition count based on multiple filters

select count(attrition) as attrition_count
from hrdata
where attrition = 'yes' and department = 'R&D' and education_field = 'Medical';


--Attrition Rate

select round(((1.0*(select count(attrition) from hrdata where attrition = 'Yes')/Sum(employee_count))*100),2) as attrition_rate
from hrdata;


--Attrition Rate department wise

select round(((1.0*(select count(attrition) from hrdata where attrition = 'Yes' and department = 'Sales')/Sum(employee_count))*100),2) as attrition_rate
from hrdata 
where department = 'Sales';


--Active Employees

select Sum(employee_count) - (select count(attrition) from hrdata where attrition = 'Yes') as active_employees
from hrdata;

 
--Active Employees based on gender

select Sum(employee_count) - (select count(attrition) from hrdata where attrition = 'Yes' and gender = 'Male') as active_male_employees
from hrdata
where gender = 'Male';


--Avearge Age

select round(avg(cast(age as float)),0) as avg_age from hrdata;


--Attrition by gender

select gender, count(attrition)
from hrdata
where attrition = 'Yes'
group by gender;


--Department wise attrition

select department, count(attrition)
from hrdata
where attrition = 'Yes'
group by department
order by count(attrition) desc;

--Department wise attrition percentage

select department, count(attrition), round((cast (count(attrition) as numeric) / 
(select count(attrition) from hrdata where attrition= 'Yes')) * 100, 2) as pct from hrdata
where attrition='Yes'
group by department 
order by count(attrition) desc;

--Employees by age group 

select age, count(employee_count) as employee_count 
from hrdata
group by age
order by age;

--Education Field wise Attrition

select education_field, count(attrition) as attrition_count from hrdata
where attrition='Yes'
group by education_field
order by count(attrition) desc;

--Attrition  by Gender for different Age Group

select age_band, gender,  count(attrition) 
from hrdata 
where attrition = 'Yes'
group by age_band, gender
order by age_band, gender desc;


--Attrition Rate by Gender for different Age Group

select age_band, gender, count(attrition) as attrition, 
round((cast(count(attrition) as numeric) / (select count(attrition) from hrdata where attrition = 'Yes')) * 100,2) as pct
from hrdata
where attrition = 'Yes'
group by age_band, gender
order by age_band, gender desc;

--Job Satisfaction Rating

SELECT *
FROM (
    SELECT job_role, job_satisfaction, SUM(employee_count) as employee_count
    FROM hrdata
    GROUP BY job_role, job_satisfaction
) AS src
PIVOT (
    SUM(employee_count)
    FOR job_satisfaction in ([1], [2], [3], [4])
) AS pivoted
ORDER BY job_role;