drop DATABASE hospita_managementl; 
 select * from hospital_data;

-- creating a alternate table to save the raw data
create table hospital_data2
like hospital_data;

-- copying data from old table to the new table 
insert hospital_data2
select * from hospital_data;

select * from hospital_data2;

-- as we can see hospital name has some weird letters and symbols and also we have spacing in the name of the colums in the table both will be problematic while running future querries, 
-- therefore we are going to remove space from the column names.

alter table hospital_data2
change `ï»¿Hospital Name` hospital_name varchar(250);

alter table hospital_data2
change `doctors count` doctors_count int(250);

alter table hospital_data2
change `Patients Count` patients_count int(250);

alter table hospital_data2
change `admission_date` admission_date text(250);

alter table hospital_data2
change `Discharge Date` discharge_date text(250);

alter table hospital_data2
change `Medical Expenses` medical_expenses int(250);


-- changing addmition_date and discharge_date from text to date.
update hospital_data2
set admission_date = str_to_date(admission_date, "%d-%m-%Y");
ALTER TABLE hospital_data2
modify admission_date date;

update hospital_data2
set discharge_date = str_to_date(discharge_date, "%d-%m-%Y");
alter table hospital_data2
modify discharge_date date;



-- 1. total number of patients in all hospitals
 select sum(patients_count) as total_patients
 from hospital_data2;
 
 
 -- 2. Average Number of Doctors per Hospital
select hospital_name, round(avg(doctors_count),1) as avg_doctor_per_hospital
from hospital_data2
group by hospital_name;


-- 3. Top 3 Departments with the Highest Number of Patients
SELECT department, sum(patients_count) AS total_patients
FROM hospital_data2
GROUP BY department
ORDER BY total_patients DESC
LIMIT 3;


-- 4. Hospital with the Maximum Medical Expenses
SELECT hospital_name, sum(medical_expenses) AS total_expense
FROM hospital_data2
GROUP BY hospital_name
ORDER BY total_expense DESC
LIMIT 3;


-- 5. Daily Average Medical Expenses
select hospital_name, round(sum(medical_expenses)/ sum(datediff(discharge_date, admission_date) + 1),2) as daily_avg_expenses
from hospital_data2
where discharge_date is not null 
and admission_date is not null 
and medical_expenses is not null 
and datediff(discharge_date, admission_date) >= 0
group by hospital_name;


-- 6. Longest Hospital Stay
-- unable to write a querry bec there is no way to diffrentiate an individul patients who satyed the longest, all the patients are in group.


-- 7. Total Patients Treated Per City
select location, sum(patients_count) as patients_treated_per_city
from hospital_data2
group by location
order by patients_treated_per_city desc;


-- 8. Average Length of Stay Per Department
select department, round(avg(datediff(discharge_date, admission_date)+ 1), 1) as avg_stay_per_dept
from hospital_data2
group by Department;


-- 9. Identify the Department with the Lowest Number of Patients
select department, sum(patients_count) as dept_lowest_patients
from hospital_data2
group by department
order by dept_lowest_patients asc
limit 3;


-- 10. Monthly Medical Expenses Report
select date_format(discharge_date, '%Y-%m') as month, sum(medical_expenses) as total_expense
from hospital_data2
where discharge_date is not null and medical_expenses is not null
group by date_format(discharge_date, '%Y-%m')
order by month;

-- the end



